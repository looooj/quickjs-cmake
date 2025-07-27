cmake_minimum_required(VERSION 3.10)
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_SOURCE_DIR}/cmake"
                      ${CMAKE_SOURCE_DIR})


message("===CMAKE_FIND_ROOT_PATH   ${CMAKE_FIND_ROOT_PATH}")
set(CMAKE_PREFIX_PATH ${CMAKE_PREFIX_PATH};${CMAKE_FIND_ROOT_PATH})

set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(CMAKE_C_STANDARD 99)
set(CMAKE_C_STANDARD_REQUIRED ON)

if("${CMAKE_BUILD_TYPE}" STREQUAL "Debug")
  set(CMAKE_DEBUG_POSTFIX d)
else()
  set(CMAKE_DEBUG_POSTFIX)
endif()

#message("==CMAKE_BUILD_TYPE  ${CMAKE_BUILD_TYPE}  ${CMAKE_DEBUG_POSTFIX} ")

set(QJS_DIR "${CMAKE_SOURCE_DIR}/../quickjs-${QJS_SOURCE_VERSION}")
set(QJS_SRC
    ${QJS_DIR}/quickjs.c ${QJS_DIR}/libregexp.c ${QJS_DIR}/cutils.c
    ${QJS_DIR}/quickjs-libc.c ${QJS_DIR}/libunicode.c ${QJS_DIR}/libbf.c)

project(qjs)

# include_directories( ${QJS_DIR}  ) link_directories(${LIBS_LIB} )

if(WIN32)
  set(CMAKE_SHARED_LINKER_FLAGS "-static-libgcc -static-libstdc++ -static")
endif()

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fpic")

set(CMAKE_POSITION_INDEPENDENT_CODE ON)

configure_file(_ver.rc.in ver.rc)

add_library(qjs SHARED ${QJS_SRC} ver.rc)

target_compile_options(
  qjs PRIVATE -DCONFIG_BIGNUM -DCONFIG_VERSION="${QJS_SOURCE_VERSION}"
              -D_GNU_SOURCE -fPIC -DJS_SHARED_LIBRARY)
              
if("${CMAKE_BUILD_TYPE}" STREQUAL "Release")
  target_compile_definitions(qjs PRIVATE NDEBUG)
endif()

target_link_libraries(qjs pthread dl)

include("libqjs.cmake")

set_target_properties(qjs PROPERTIES OUTPUT_NAME ${qjs_name})

get_filename_component(MINGW_BIN_DIR ${CMAKE_MAKE_PROGRAM} DIRECTORY)

set(_gendef "${MINGW_BIN_DIR}/gendef.exe")

set(_genlib "${MINGW_BIN_DIR}/dlltool.exe")

add_custom_target(
  qjs_gen_def
  COMMAND ${_gendef} ARGS ${qjs_dll_name}
  DEPENDS qjs
  WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
  VERBATIM)

add_custom_target(
  qjs_gen_lib
  COMMAND ${_genlib} -k -k --output-lib ${qjs_lib_name} --def ${qjs_def_name}
  DEPENDS qjs
  WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
  VERBATIM)


set(lib_dst_base_dir ${CMAKE_SOURCE_DIR}/dist/${QJS_SOURCE_VERSION})
  
set(lib_dst_lib_dir ${lib_dst_base_dir}/lib)

set(lib_dst_inc_dir ${lib_dst_base_dir}/include)

set(lib_src_dir ${CMAKE_CURRENT_BINARY_DIR})


add_custom_target(
  qjs_copy_lib
  COMMAND ${CMAKE_COMMAND} -E copy ${lib_src_dir}/${qjs_lib_name}
          ${lib_dst_lib_dir}/${qjs_lib_name}
  COMMAND ${CMAKE_COMMAND} -E copy ${lib_src_dir}/${qjs_dll_name}
          ${lib_dst_lib_dir}/${qjs_dll_name}
)

add_dependencies(qjs_gen_def qjs)

add_dependencies(qjs_gen_lib qjs_gen_def)

add_dependencies(qjs_copy_lib qjs_gen_lib)
