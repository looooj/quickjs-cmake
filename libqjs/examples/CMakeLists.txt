cmake_minimum_required(VERSION 3.20)

set(CMAKE_PREFIX_PATH ${CMAKE_PREFIX_PATH};${CMAKE_CURRENT_SOURCE_DIR}/..)


set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)




project(quickjs-examples)

#find_package(libqjs 1.5 REQUIRED)
find_package(libqjs 1.6 REQUIRED)

message("===libqjs_source_version ${libqjs_source_version}")
message("===CMAKE_BUILD_TYPE  ${CMAKE_BUILD_TYPE}  ${CMAKE_DEBUG_POSTFIX} ")


add_executable(hello_qjs 

   hello.cpp
)

copy_qjs_dll(hello_qjs)

target_link_libraries(hello_qjs qjs_dll)
