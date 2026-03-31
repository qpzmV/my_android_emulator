#----------------------------------------------------------------
# Generated CMake target import file for configuration "RelWithDebInfo".
#----------------------------------------------------------------

# Commands may need to know the format version.
set(CMAKE_IMPORT_FILE_VERSION 1)

# Import target "Qt6::QmlXmlListModel" for configuration "RelWithDebInfo"
set_property(TARGET Qt6::QmlXmlListModel APPEND PROPERTY IMPORTED_CONFIGURATIONS RELWITHDEBINFO)
set_target_properties(Qt6::QmlXmlListModel PROPERTIES
  IMPORTED_LOCATION_RELWITHDEBINFO "${_IMPORT_PREFIX}/lib/libQt6QmlXmlListModelAndroidEmu.6.5.3.dylib"
  IMPORTED_SONAME_RELWITHDEBINFO "@rpath/libQt6QmlXmlListModelAndroidEmu.6.dylib"
  )

list(APPEND _IMPORT_CHECK_TARGETS Qt6::QmlXmlListModel )
list(APPEND _IMPORT_CHECK_FILES_FOR_Qt6::QmlXmlListModel "${_IMPORT_PREFIX}/lib/libQt6QmlXmlListModelAndroidEmu.6.5.3.dylib" )

# Commands beyond this point should not need to know the version.
set(CMAKE_IMPORT_FILE_VERSION)
