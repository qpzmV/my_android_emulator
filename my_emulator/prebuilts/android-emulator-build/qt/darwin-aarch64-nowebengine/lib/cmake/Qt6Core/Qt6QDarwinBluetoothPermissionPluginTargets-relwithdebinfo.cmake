#----------------------------------------------------------------
# Generated CMake target import file for configuration "RelWithDebInfo".
#----------------------------------------------------------------

# Commands may need to know the format version.
set(CMAKE_IMPORT_FILE_VERSION 1)

# Import target "Qt6::QDarwinBluetoothPermissionPlugin" for configuration "RelWithDebInfo"
set_property(TARGET Qt6::QDarwinBluetoothPermissionPlugin APPEND PROPERTY IMPORTED_CONFIGURATIONS RELWITHDEBINFO)
set_target_properties(Qt6::QDarwinBluetoothPermissionPlugin PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_RELWITHDEBINFO "CXX;OBJCXX"
  IMPORTED_LOCATION_RELWITHDEBINFO "${_IMPORT_PREFIX}/./plugins/permissions/libqdarwinbluetoothpermissionAndroidEmu.a"
  )

list(APPEND _IMPORT_CHECK_TARGETS Qt6::QDarwinBluetoothPermissionPlugin )
list(APPEND _IMPORT_CHECK_FILES_FOR_Qt6::QDarwinBluetoothPermissionPlugin "${_IMPORT_PREFIX}/./plugins/permissions/libqdarwinbluetoothpermissionAndroidEmu.a" )

# Import target "Qt6::QDarwinBluetoothPermissionPlugin_init" for configuration "RelWithDebInfo"
set_property(TARGET Qt6::QDarwinBluetoothPermissionPlugin_init APPEND PROPERTY IMPORTED_CONFIGURATIONS RELWITHDEBINFO)
set_target_properties(Qt6::QDarwinBluetoothPermissionPlugin_init PROPERTIES
  IMPORTED_COMMON_LANGUAGE_RUNTIME_RELWITHDEBINFO ""
  IMPORTED_OBJECTS_RELWITHDEBINFO "${_IMPORT_PREFIX}/./plugins/permissions/objects-RelWithDebInfo/QDarwinBluetoothPermissionPlugin_init/QDarwinBluetoothPermissionPlugin_init.cpp.o"
  )

list(APPEND _IMPORT_CHECK_TARGETS Qt6::QDarwinBluetoothPermissionPlugin_init )
list(APPEND _IMPORT_CHECK_FILES_FOR_Qt6::QDarwinBluetoothPermissionPlugin_init "${_IMPORT_PREFIX}/./plugins/permissions/objects-RelWithDebInfo/QDarwinBluetoothPermissionPlugin_init/QDarwinBluetoothPermissionPlugin_init.cpp.o" )

# Commands beyond this point should not need to know the version.
set(CMAKE_IMPORT_FILE_VERSION)
