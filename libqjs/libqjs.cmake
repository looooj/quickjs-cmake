set(name_arch "32" )
if(CMAKE_SIZEOF_VOID_P EQUAL 8)
set(name_arch "64")
endif()

set(qjs_name  "qjs${name_arch}" )
set(qjs_dll_name  "lib${qjs_name}${CMAKE_DEBUG_POSTFIX}.dll" )
set(qjs_def_name  "lib${qjs_name}${CMAKE_DEBUG_POSTFIX}.def" )
set(qjs_lib_name  "lib${qjs_name}${CMAKE_DEBUG_POSTFIX}.lib" )

set(qjs_debug_dll_name  "lib${qjs_name}d.dll" )
set(qjs_debug_def_name  "lib${qjs_name}d.def" )
set(qjs_debug_lib_name  "lib${qjs_name}d.lib" )

