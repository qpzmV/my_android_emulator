This contains the android-sdk for the various platforms

Note that this is a minimal SDK that is to be used for testing the andriod emulator.
As such it does not include the emulator.

The system images can be found under the generic/system-images directory.

Note that most of the images are in the .gz format and need to be uncompressed before they
can be used by the emulator. This is significantly faster than obtaining the image through sdkmanager
(6 mins vs, 26 secs).

See go/ab/8512546
