##############################################################################
#! @file  FindGTest.cmake
#! @brief Find Google Test package.
#!
#! @par Input variables:
#! <table border="0">
#!   <tr>
#!     <td style="white-space:nowrap; vertical-align:top; padding-right:1em">
#!         @b GTest_DIR</td>
#!     <td>The Google Test package files are searched under the specified
#!         root directory. If they are not found there, the default search
#!         paths are considered.
#!         This variable can also be set as environment variable.</td>
#!   </tr>
#!   <tr>
#!     <td style="white-space:nowrap; vertical-align:top; padding-right:1em">
#!         @b GTEST_DIR</td>
#!     <td>Alternative environment variable for @p GTest_DIR.</td>
#!   </tr>
#!   <tr>
#!     <td style="white-space:nowrap; vertical-align:top; padding-right:1em">
#!         @b GTest_SHARED_LIBRARIES</td>
#!     <td>Forces this module to search for shared libraries.
#!         Otherwise, static libraries are preferred.</td>
#!   </tr>
#! </table>
#!
#! @par Output variables:
#! <table border="0">
#!   <tr>
#!     <td style="white-space:nowrap; vertical-align:top; padding-right:1em">
#!         @b GTest_FOUND</td>
#!     <td>Whether the package was found and the following CMake variables are valid.</td>
#!   </tr>
#!   <tr>
#!     <td style="white-space:nowrap; vertical-align:top; padding-right:1em">
#!         @b GTest_INCLUDE_DIR</td>
#!     <td>Package include directories.</td>
#!   </tr>
#!   <tr>
#!     <td style="white-space:nowrap; vertical-align:top; padding-right:1em">
#!         @b GTest_INCLUDES</td>
#!     <td>Include directories including prerequisite libraries.</td>
#!   </tr>
#!   <tr>
#!     <td style="white-space:nowrap; vertical-align:top; padding-right:1em">
#!         @b GTest_LIBRARY</td>
#!     <td>Path of @c gtest library.</td>
#!   </tr>
#!   <tr>
#!     <td style="white-space:nowrap; vertical-align:top; padding-right:1em">
#!         @b GTest_main_LIBRARY</td>
#!     <td>Path of @c gtest_main library (optional).</td>
#!   </tr>
#!   <tr>
#!     <td style="white-space:nowrap; vertical-align:top; padding-right:1em">
#!         @b GTest_LIBRARIES</td>
#!     <td>Package libraries and prerequisite libraries.</td>
#!   </tr>
#! </table>
#!
#! Copyright (c) 2011 University of Pennsylvania. All rights reserved.
#! See https://www.rad.upenn.edu/sbia/software/license.html or COPYING file.
#!
#! Contact: SBIA Group <sbia-software at uphs.upenn.edu>
##############################################################################

# ----------------------------------------------------------------------------
# initialize search
if (NOT GTest_DIR)
  if ($ENV{GTEST_DIR})
    set (GTest_DIR "$ENV{GTEST_DIR}" CACHE PATH "Installation prefix for Google Test")
  else ()
    set (GTest_DIR "$ENV{GTest_DIR}" CACHE PATH "Installation prefix for Google Test")
  endif ()
endif ()

set (GTest_ORIG_CMAKE_FIND_LIBRARY_SUFFIXES ${CMAKE_FIND_LIBRARY_SUFFIXES})

if (GTest_SHARED_LIBRARIES)
  if (WIN32)
    set (CMAKE_FIND_LIBRARY_SUFFIXES .dll)
  else ()
    set (CMAKE_FIND_LIBRARY_SUFFIXES .so)
  endif()
else ()
  if (WIN32)
    set (CMAKE_FIND_LIBRARY_SUFFIXES .lib)
  else ()
    set (CMAKE_FIND_LIBRARY_SUFFIXES .a)
  endif()
endif ()

# ----------------------------------------------------------------------------
# find paths/files
if (GTest_DIR)

  find_path (
    GTest_INCLUDE_DIR
      NAMES         gtest.h
      HINTS         "${GTest_DIR}"
      PATH_SUFFIXES "include/gtest"
      DOC           "Include directory for Google Test."
      NO_DEFAULT_PATH
  )

  find_library (
    GTest_LIBRARY
      NAMES         gtest
      HINTS         "${GTest_DIR}"
      PATH_SUFFIXES "lib"
      DOC           "Link library for Google Test (gtest)."
      NO_DEFAULT_PATH
  )

  find_library (
    GTest_main_LIBRARY
      NAMES         gtest_main
      HINTS         "${GTest_DIR}"
      PATH_SUFFIXES "lib"
      DOC           "Link library for Google Test's automatic main () definition (gtest_main)."
      NO_DEFAULT_PATH
  )

else ()

  find_path (
    GTest_INCLUDE_DIR
      NAMES gtest.h
      HINTS ENV C_INCLUDE_PATH ENV CXX_INCLUDE_PATH
      DOC   "Include directory for Google Test."
  )

  find_library (
    GTest_LIBRARY
      NAMES gtest
      HINTS ENV LD_LIBRARY_PATH
      DOC   "Link library for Google Test (gtest)."
  )

  find_library (
    GTest_main_LIBRARY
      NAMES gtest_main
      HINTS ENV LD_LIBRARY_PATH
      DOC   "Link library for Google Test's automatic main () definition (gtest_main)."
  )

endif ()

mark_as_advanced (GTest_INCLUDE_DIR)
mark_as_advanced (GTest_LIBRARY)
mark_as_advanced (GTest_main_LIBRARY)

# ----------------------------------------------------------------------------
# add prerequisites
set (GTest_INCLUDES "${GTest_INCLUDE_DIR}")

set (GTest_LIBRARIES)
if (GTest_LIBRARY)
  list (APPEND GTest_LIBRARIES "${GTest_LIBRARY}")
endif ()
if (GTest_main_LIBRARY)
  list (APPEND GTest_LIBRARIES "${GTest_main_LIBRARY}")
endif ()

# ----------------------------------------------------------------------------
# reset CMake variables
set (CMAKE_FIND_LIBRARY_SUFFIXES ${GTest_ORIG_CMAKE_FIND_LIBRARY_SUFFIXES})

# ----------------------------------------------------------------------------
# aliases / backwards compatibility
set (GTest_INCLUDE_DIRS "${GTest_INCLUDES}")

# ----------------------------------------------------------------------------
# handle the QUIETLY and REQUIRED arguments and set *_FOUND to TRUE
# if all listed variables are found or TRUE
include (FindPackageHandleStandardArgs)

find_package_handle_standard_args (
  GTest
# MESSAGE
    DEFAULT_MSG
# VARIABLES
    GTest_INCLUDE_DIR
    GTest_LIBRARY
)

