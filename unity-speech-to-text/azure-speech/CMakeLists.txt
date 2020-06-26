cmake_minimum_required(VERSION 3.10.0 FATAL_ERROR)
project(cpp-azure-speech-to-text)


# -----------------------------------------------------------------------------
# options
# -----------------------------------------------------------------------------
set(CMAKE_INSTALL_PREFIX ${PROJECT_SOURCE_DIR}/../Assets/Plugins)


# -----------------------------------------------------------------------------
# compiler settings
# -----------------------------------------------------------------------------
if(CMAKE_CXX_COMPILER_ID STREQUAL AppleClang)
  if(CMAKE_CXX_COMPILER_VERSION LESS 10.0)
    message(FATAL_ERROR "A supported AppleClang version is greater than or equal to 10.0!")
  endif()

  add_compile_options(-std=c++17 -stdlib=libc++ -Wall -Wextra -Wno-deprecated-declarations)
  set(CMAKE_EXE_LINKER_FLAGS -stdlib=libc++)
  set(VENDOR_CXX_FLAGS -stdlib=libc++)
  set(CMAKE_CXX_STANDARD 17)
  set(CMAKE_CXX_STANDARD_REQUIRED on)

else()
  message(FATAL_ERROR "Unsupported compiler!")
endif()


# -----------------------------------------------------------------------------
# find packages
# -----------------------------------------------------------------------------
find_package(Boost REQUIRED)


# -----------------------------------------------------------------------------
# helpers
# -----------------------------------------------------------------------------
macro(set_project_var name)
  set(${name} ${ARGN})
  set(${name} ${ARGN} PARENT_SCOPE)
endmacro()

macro(append_project_var name)
  set_project_var(${name} ${${name}} ${ARGN})
endmacro()


# -----------------------------------------------------------------------------
# build settings
# -----------------------------------------------------------------------------
include_directories("${PROJECT_SOURCE_DIR}/include")
add_subdirectory(vendor)
add_subdirectory(src)
