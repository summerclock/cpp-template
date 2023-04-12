cmake_minimum_required(VERSION 3.22.0 FATAL_ERROR)
project(cpp-template VERSION 0.1.0)

execute_process(
  COMMAND git rev-parse --short HEAD
  WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
  OUTPUT_VARIABLE GIT_HASH
  OUTPUT_STRIP_TRAILING_WHITESPACE
)
message("GIT HASH: ${GIT_HASH}")
configure_file(
  "${PROJECT_SOURCE_DIR}/apps/version.hpp.in"
  "${PROJECT_BINARY_DIR}/version.hpp"
)

include_directories("${CMAKE_SOURCE_DIR}" "${PROJECT_BINARY_DIR}" "/opt/include")

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

if(UNIX)
  set(CMAKE_SKIP_BUILD_RPATH FALSE)
  set(CMAKE_BUILD_WITH_INSTALL_RPATH FALSE)
  set(CMAKE_INSTALL_RPATH "${CMAKE_INSTALL_PREFIX}/lib")
  set(CMAKE_INSTALL_RPATH_USE_LINK_PATH TRUE)
endif()

if(MSVC)
  set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${PROJECT_BINARY_DIR}/bin")
  set(CMAKE_LIBRARY_OUTPUT_DIRECTORY "${PROJECT_BINARY_DIR}/bin")
  add_compile_options("/Zc:preprocessor")
endif()

find_package(glog 0.6.0 REQUIRED)
find_package(CLI11 REQUIRED)
find_package(TBB REQUIRED)

add_subdirectory(cpptemplate)
add_subdirectory(tests)
add_subdirectory(apps)
