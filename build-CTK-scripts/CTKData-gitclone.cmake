# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

cmake_minimum_required(VERSION 3.5)

if(EXISTS "/home/eton/00-src/commontoolkits-CTK/build/CTKData-cmake/src/CTKData-stamp/CTKData-gitclone-lastrun.txt" AND EXISTS "/home/eton/00-src/commontoolkits-CTK/build/CTKData-cmake/src/CTKData-stamp/CTKData-gitinfo.txt" AND
  "/home/eton/00-src/commontoolkits-CTK/build/CTKData-cmake/src/CTKData-stamp/CTKData-gitclone-lastrun.txt" IS_NEWER_THAN "/home/eton/00-src/commontoolkits-CTK/build/CTKData-cmake/src/CTKData-stamp/CTKData-gitinfo.txt")
  message(STATUS
    "Avoiding repeated git clone, stamp file is up to date: "
    "'/home/eton/00-src/commontoolkits-CTK/build/CTKData-cmake/src/CTKData-stamp/CTKData-gitclone-lastrun.txt'"
  )
  return()
endif()

execute_process(
  COMMAND ${CMAKE_COMMAND} -E rm -rf "/home/eton/00-src/commontoolkits-CTK/build/CTKData"
  RESULT_VARIABLE error_code
)
if(error_code)
  message(FATAL_ERROR "Failed to remove directory: '/home/eton/00-src/commontoolkits-CTK/build/CTKData'")
endif()

# try the clone 3 times in case there is an odd git clone issue
set(error_code 1)
set(number_of_tries 0)
while(error_code AND number_of_tries LESS 3)
  execute_process(
    COMMAND "/usr/bin/git" 
            clone --no-checkout --config "advice.detachedHead=false" "git@github.com:commontk/CTKData.git" "CTKData"
    WORKING_DIRECTORY "/home/eton/00-src/commontoolkits-CTK/build"
    RESULT_VARIABLE error_code
  )
  math(EXPR number_of_tries "${number_of_tries} + 1")
endwhile()
if(number_of_tries GREATER 1)
  message(STATUS "Had to git clone more than once: ${number_of_tries} times.")
endif()
if(error_code)
  message(FATAL_ERROR "Failed to clone repository: 'https://github.com/commontk/CTKData.git'")
endif()

execute_process(
  COMMAND "/usr/bin/git" 
          checkout "cc07f1ff391b7828459c" --
  WORKING_DIRECTORY "/home/eton/00-src/commontoolkits-CTK/build/CTKData"
  RESULT_VARIABLE error_code
)
if(error_code)
  message(FATAL_ERROR "Failed to checkout tag: 'cc07f1ff391b7828459c'")
endif()

set(init_submodules TRUE)
if(init_submodules)
  execute_process(
    COMMAND "/usr/bin/git" 
            submodule update --recursive --init 
    WORKING_DIRECTORY "/home/eton/00-src/commontoolkits-CTK/build/CTKData"
    RESULT_VARIABLE error_code
  )
endif()
if(error_code)
  message(FATAL_ERROR "Failed to update submodules in: '/home/eton/00-src/commontoolkits-CTK/build/CTKData'")
endif()

# Complete success, update the script-last-run stamp file:
#
execute_process(
  COMMAND ${CMAKE_COMMAND} -E copy "/home/eton/00-src/commontoolkits-CTK/build/CTKData-cmake/src/CTKData-stamp/CTKData-gitinfo.txt" "/home/eton/00-src/commontoolkits-CTK/build/CTKData-cmake/src/CTKData-stamp/CTKData-gitclone-lastrun.txt"
  RESULT_VARIABLE error_code
)
if(error_code)
  message(FATAL_ERROR "Failed to copy script-last-run stamp file: '/home/eton/00-src/commontoolkits-CTK/build/CTKData-cmake/src/CTKData-stamp/CTKData-gitclone-lastrun.txt'")
endif()
