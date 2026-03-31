#----------------------------------------------------------------
# Generated CMake target import file for configuration "RelWithDebInfo".
#----------------------------------------------------------------

# Commands may need to know the format version.
set(CMAKE_IMPORT_FILE_VERSION 1)

# Import target "Qt6::WebEngineQuickDelegatesQml" for configuration "RelWithDebInfo"
set_property(TARGET Qt6::WebEngineQuickDelegatesQml APPEND PROPERTY IMPORTED_CONFIGURATIONS RELWITHDEBINFO)
set_target_properties(Qt6::WebEngineQuickDelegatesQml PROPERTIES
  IMPORTED_LINK_DEPENDENT_LIBRARIES_RELWITHDEBINFO "Qt6::Qml;Qt6::Core"
  IMPORTED_LOCATION_RELWITHDEBINFO "${_IMPORT_PREFIX}/lib/libQt6WebEngineQuickDelegatesQmlAndroidEmu.6.5.3.dylib"
  IMPORTED_SONAME_RELWITHDEBINFO "@rpath/libQt6WebEngineQuickDelegatesQmlAndroidEmu.6.dylib"
  )

list(APPEND _IMPORT_CHECK_TARGETS Qt6::WebEngineQuickDelegatesQml )
list(APPEND _IMPORT_CHECK_FILES_FOR_Qt6::WebEngineQuickDelegatesQml "${_IMPORT_PREFIX}/lib/libQt6WebEngineQuickDelegatesQmlAndroidEmu.6.5.3.dylib" )

# Commands beyond this point should not need to know the version.
set(CMAKE_IMPORT_FILE_VERSION)
