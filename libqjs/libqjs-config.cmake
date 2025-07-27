#include("${CMAKE_CURRENT_LIST_DIR}/_libqjs-config.cmake")

#message("===PACKAGE_FIND_VERSION ${PACKAGE_FIND_VERSION}")



include("${CMAKE_CURRENT_LIST_DIR}/libqjs.cmake")
#set(libqjs_source_version "2023-12-09")

#message("=2=libqjs_source_version ${libqjs_source_version}")

set(QJS_DIR ${CMAKE_CURRENT_LIST_DIR}/..)

get_filename_component(QJS_DIR ${QJS_DIR} ABSOLUTE)


#set(qjs_inc ${QJS_DIR}/quickjs-${libqjs_source_version})


#message("=3= QJS_DIR ${QJS_DIR}")

set(QJS_LIB_DIR ${QJS_DIR}/libqjs/dist/${libqjs_source_version}/lib)
set(qjs_inc ${QJS_DIR}/libqjs/dist/${libqjs_source_version}/include)
#add_custom_target(copy_qjs_dll_
#    COMMAND ${CMAKE_COMMAND}  -E copy ${QJS_DIR}/libqjs/lib/${libqjs_source_version}/${qjs_dll_name} ${CMAKE_CURRENT_BINARY_DIR}/${CMAKE_CFG_INTDIR}/${qjs_dll_name} 
#    VERBATIM
#)

add_library(qjs_dll SHARED IMPORTED)

#message("==qjs_inc== ${qjs_inc}")

if(MSVC)
  set(_qjs_link_options /SAFESEH:NO )
endif()

set_target_properties(qjs_dll PROPERTIES
#  INTERFACE_COMPILE_DEFINITIONS $<$<CONFIG:RELEASE>:NDEBUG>
  INTERFACE_INCLUDE_DIRECTORIES "${qjs_inc}"
#  INTERFACE_LINK_LIBRARIES ""
  INTERFACE_LINK_OPTIONS "${_qjs_link_options}"
)


set_property(TARGET qjs_dll APPEND PROPERTY IMPORTED_CONFIGURATIONS DEBUG)
set_target_properties(qjs_dll PROPERTIES
  IMPORTED_IMPLIB_DEBUG "${QJS_LIB_DIR}/${qjs_debug_lib_name}"
  IMPORTED_LOCATION_DEBUG "${QJS_LIB_DIR}/${qjs_debug_dll_name}"
)

#message("==implib " "${QJS_DIR}/libqjs/lib/${qjs_lib_name}" )

set_property(TARGET qjs_dll APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(qjs_dll PROPERTIES
  IMPORTED_IMPLIB_RELEASE "${QJS_LIB_DIR}/${qjs_lib_name}"
  IMPORTED_LOCATION_RELEASE "${QJS_LIB_DIR}/${qjs_dll_name}"
)


macro(copy_qjs_dll _target)
   add_custom_command(
    TARGET ${_target}
    POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy_if_different $<TARGET_FILE:qjs_dll>
            $<TARGET_FILE_DIR:${_target}>)
endmacro(copy_qjs_dll)


