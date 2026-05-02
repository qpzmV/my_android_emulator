/* -*- Mode: C; indent-tabs-mode:nil -*- */
/*
 * darwin backend for libusb 1.0
 * Copyright © 2008-2020 Nathan Hjelm <hjelmn@cs.unm.edu>
 * Copyright © 2019-2020 Google LLC. All rights reserved.
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
 */

/* new mac api */
#import <Foundation/Foundation.h>
#import <IOUSBHost/IOUSBHost.h>
#import <IOKit/IOMessage.h>

#import "darwin_usb.h"


NS_ASSUME_NONNULL_BEGIN

/// Identifies a USB device by its vendor/product pair.
@interface DarwinUsbDeviceIdentifier : NSObject
@property(nonatomic, nonnull, strong) NSNumber *vendorID;
@property(nonatomic, nonnull, strong) NSNumber *productID;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithVendorID:(NSNumber *)vendorID productID:(NSNumber *)productID;
@end


/// Acquires exclusive access to the the device specified by the device ID.
@interface DarwinUsbDeviceExclusiveAccessAssertion : NSObject
@property (nonatomic, nonnull, strong) DarwinUsbDeviceIdentifier *deviceID;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithDeviceID:(DarwinUsbDeviceIdentifier *)deviceID;
@end


/// Parses the command line to extract all specified USB devices.
@interface DarwinUSBDeviceCommandLineProcessor : NSObject

/// Fetch the array of devices that were specified at the command line.
///
/// Multiple devices can be specified at the command line. For each such device, specify the `-device` switch followed by the
/// device's specification prefixed by `usb-host` and including the required vendor and product ids along with any other optional
/// properties. Properties are comma delimitted and specified as key/value pair assignments with the `=` delimitter. For example:
/// `-device usb-host,bus=ehci.0,vendorid=0x0b05,productid=0x17cb`
///
/// - Returns: The array of scanned USB devices.
- (NSArray<DarwinUsbDeviceIdentifier *> *)fetchDevices;
@end

NS_ASSUME_NONNULL_END


/// Array of assertions for exclusive USB access.
static NSMutableArray<DarwinUsbDeviceExclusiveAccessAssertion *> *usbDeviceExlusiveAccessAssertions;

/// Acquire exclusive USB access for the desired devices.
void DarwinGetExclusiveAccessForDevices(void) {
  // Only need to execute this once.
  static BOOL hasRun = NO;
  if (hasRun) { return; }
  hasRun = YES;

  usbDeviceExlusiveAccessAssertions = [[NSMutableArray alloc] init];

  // Parse the command line to fetch every device.
  DarwinUSBDeviceCommandLineProcessor *processor = [[DarwinUSBDeviceCommandLineProcessor alloc] init];
  NSArray<DarwinUsbDeviceIdentifier *> *deviceIDs = [processor fetchDevices];
  NSLog(@"Command line USB devices: %@", deviceIDs);

  // For device found, acquire an assertion for exclusive access.
  for (DarwinUsbDeviceIdentifier *deviceID in deviceIDs) {
    DarwinUsbDeviceExclusiveAccessAssertion *assertion =
      [[DarwinUsbDeviceExclusiveAccessAssertion alloc] initWithDeviceID:deviceID];
    if (assertion != nil) {
      [usbDeviceExlusiveAccessAssertions addObject:assertion];
    }
  }
}


@implementation DarwinUsbDeviceExclusiveAccessAssertion {
  dispatch_queue_t _queue;
  io_service_t _service;
  IOUSBHostDevice *_device;
}

- (instancetype)initWithDeviceID:(DarwinUsbDeviceIdentifier *)deviceID {
  self = [super init];
  if (self) {
    NSLog(@"Acquiring USB Exclusive access for device: <%@>", deviceID);
    _queue = dispatch_queue_create("usb-exclusive-access", DISPATCH_QUEUE_SERIAL);

    _deviceID = deviceID;

    CFMutableDictionaryRef query = [IOUSBHostDevice
                createMatchingDictionaryWithVendorID:deviceID.vendorID
                 productID:deviceID.productID
                 bcdDevice:nil
               deviceClass:nil
            deviceSubclass:nil
            deviceProtocol:nil
                     speed:nil
            productIDArray:nil];

    _service = IOServiceGetMatchingService(kIOMasterPortDefault, query);

    if (_service == 0) {
      NSLog(@"No service match found for product/vendor query.");
      return nil;
    }

    kern_return_t authorized = IOServiceAuthorize(_service, 0);
    if (authorized != kIOReturnSuccess) {
      NSLog(@"Service authorization failed with error with return code: %d", authorized);
    }

    NSError* error = nil;

    _device = [[IOUSBHostDevice alloc] initWithIOService:_service
      options:IOUSBHostObjectInitOptionsDeviceCapture
      queue:_queue
      error:&error
      interestHandler:nil
    ];

    if (error != nil) {
      NSLog(@"Error creating device: %@", [error localizedDescription]);
    }
  }

  return self;
}

- (void)dealloc {
  NSLog(@"dealloc DarwinUsbDeviceExclusiveAccessAssertion...");
  NSError *error = nil;
  BOOL success = [_device resetWithError:&error];
  NSLog(@"Reset device: %@ with result: %u", _deviceID, success);
  IOObjectRelease(_service);
}

@end


/// As the command line is parsed, the mode tracks the state.
typedef enum DarwinCommandLineUsbDeviceParseMode {
  DarwinCommandLineUsbDeviceParseModeScanning,          // Scanning for the next device.
  DarwinCommandLineUsbDeviceParseModeProcessingDevice   // Processing the current device.
} DarwinCommandLineUsbDeviceParseMode;


@implementation DarwinUSBDeviceCommandLineProcessor {
  DarwinCommandLineUsbDeviceParseMode mode;
}

- (NSArray<DarwinUsbDeviceIdentifier *> *)fetchDevices {
  mode = DarwinCommandLineUsbDeviceParseModeScanning;
  NSMutableArray<DarwinUsbDeviceIdentifier *> *deviceIdentifiers = [[NSMutableArray alloc] init];

  NSArray<NSString *> *arguments = [[NSProcessInfo processInfo] arguments];
  for (NSString *argument in arguments) {
    switch(mode) {
      case DarwinCommandLineUsbDeviceParseModeProcessingDevice:
      {
        DarwinUsbDeviceIdentifier *deviceIdentifier = [self processDeviceArgument:argument];
        if (deviceIdentifier != nil) {
          [deviceIdentifiers addObject:deviceIdentifier];
        }
      }
        break;
      case DarwinCommandLineUsbDeviceParseModeScanning:
        [self processSearchingArgument:argument];
        break;
    }
  }

  return [deviceIdentifiers copy];
}

- (void)processSearchingArgument:(NSString *)argument {
  if ([argument isEqualToString:@"-device"]) {
    mode = DarwinCommandLineUsbDeviceParseModeProcessingDevice;
  }
}

- (DarwinUsbDeviceIdentifier *)processDeviceArgument:(NSString *)deviceArgument {
  // Continue searching for more devices after processing this argument.
  mode = DarwinCommandLineUsbDeviceParseModeScanning;

  NSString * _Nonnull const vendorIDKey = @"vendorid";
  NSString * _Nonnull const productIDKey = @"productid";
  NSString *vendorIDText = nil;
  NSString *productIDText = nil;
  if ([deviceArgument hasPrefix:@"usb-host"]) {
    NSArray<NSString *> *deviceComponents = [deviceArgument componentsSeparatedByString:@","];
    NSMutableDictionary<NSString *, NSString *> *assignments = [[NSMutableDictionary alloc] init];
    for (NSString *deviceComponent in deviceComponents) {
      NSArray<NSString *> *pair = [deviceComponent componentsSeparatedByString:@"="];
      if ([pair count] == 2) {
        NSString *key = pair[0];
        NSString *value = pair[1];
        assignments[key] = value;
      }
    }
    vendorIDText = assignments[vendorIDKey];
    productIDText = assignments[productIDKey];

    BOOL success = NO;
    unsigned int vendorID = 0;
    NSScanner *vendorScanner = [[NSScanner alloc] initWithString:vendorIDText];
    success = [vendorScanner scanHexInt:&vendorID];
    if (!success) return nil;

    unsigned int productID = 0;
    NSScanner *productScanner = [[NSScanner alloc] initWithString:productIDText];
    success = [productScanner scanHexInt:&productID];
    if (!success) return nil;

    if (vendorIDText != nil && productIDText != nil) {
      NSLog(@"vendorID: %@ (%u), productID: %@ (%u)", vendorIDText, vendorID, productIDText, productID);
    }

    DarwinUsbDeviceIdentifier *device = [[DarwinUsbDeviceIdentifier alloc] initWithVendorID:[NSNumber numberWithUnsignedInt:vendorID] productID:[NSNumber numberWithUnsignedInt:productID]];

    return device;
  }

  return nil;
}

- (void)parseDevice:(NSString *)device {

}

@end


@implementation DarwinUsbDeviceIdentifier

- (instancetype)initWithVendorID:(NSNumber *)vendorID productID:(NSNumber *)productID {
  self = [super init];
  if (self) {
    self.vendorID = vendorID;
    self.productID = productID;
  }
  return self;
}

- (NSString *)description {
  return [NSString stringWithFormat:@"vendorID: 0x%x, productID: 0x%x", [_vendorID unsignedIntValue], [_productID unsignedIntValue]];
}

@end
