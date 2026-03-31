#----------------------------------------------------------------
# Generated CMake target import file for configuration "RelWithDebInfo".
#----------------------------------------------------------------

# Commands may need to know the format version.
set(CMAKE_IMPORT_FILE_VERSION 1)

# Import target "Qt6::QDarwinLocationPermissionPlugin" for configuration "RelWithDebInfo"
set_property(TARGET Qt6::QDarwinLocationPermissionPlugin APPEND PROPERTY IMPORTED_CONFIGURATIONS RELWITHDEBINFO)
set_target_properties(Qt6::QDarwinLocationPermissionPlugin PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_RELWITHDEBINFO "CXX;OBJCXX"
  IMPORTED_LOCATION_RELWITHDEBINFO "${_IMPORT_PREFIX}/./plugins/permissions/libqdarwinlocationpermissionAndroidEmu.a"
  )

list(APPEND _IMPORT_CHECK_TARGETS Qt6::QDarwinLocationPermissionPlugin )
list(APPEND _IMPORT_CHECK_FILES_FOR_Qt6::QDarwinLocationPermissionPlugin "${_IMPORT_PREFIX}/./plugins/permissions/libqdarwinlocationpermissionAndroidEmu.a" )

# Import target "Qt6::QDarwinLocationPermissionPlugin_init" for configuration "RelWithDebInfo"
set_property(TARGET Qt6::QDarwinLocationPermissionPlugin_init APPEND PROPERTY IMPORTED_CONFIGURATIONS RELWITHDEBINFO)
set_target_properties(Qt6::QDarwinLocationPermissionPlugin_init PROPERTIES
  IMPORTED_COMMON_LANGUAGE_RUNTIME_RELWITHDEBINFO ""
  IMPORTED_OBJECTS_RELWITHDEBINFO "${_IMPORT_PREFIX}/./plugins/permissions/objects-RelWithDebInfo/QDarwinLocationPermissionPlugin_init/QDarwinLocationPermissionPlugin_init.cpp.o"
  )

list(APPEND _IMPORT_CHECK_TARGETS Qt6::QDarwinLocationPermissionPlugin_init )
list(APPEND _IMPORT_CHECK_FILES_FOR_Qt6::QDarwinLocationPermissionPlugin_init "${_IMPORT_PREFIX}/./plugins/permissions/objects-RelWithDebInfo/QDarwinLocationPermissionPlugin_init/QDarwinLocationPermissionPlugin_init.cpp.o" )

# Commands beyond this point should not need to know the version.
set(CMAKE_IMPORT_FILE_VERSION)
