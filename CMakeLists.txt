cmake_minimum_required(VERSION 3.19.0)

# We need the burt.json to be copied to the binary dir, which is normally done by 'burt init'. Since we don't
# have a burt command to run at all, we need to assume that just straight copying the burt.json is good
# enough. This is not normally an assumption we can make, but we have to here to avoid a chicken-and-egg
# problem.
configure_file(${CMAKE_CURRENT_LIST_DIR}/burt.json ${CMAKE_CURRENT_BINARY_DIR}/burt.json COPYONLY)
# Make sure that if the `burt.json` is modified, we trigger a new configure.
list(APPEND CMAKE_CONFIGURE_DEPENDS ${CMAKE_CURRENT_LIST_DIR}/burt.json)

# Make sure Burt is included after every project()
set(CMAKE_PROJECT_INCLUDE "src/extensions/cmake/burt.cmake")

# This needs to be given the name of the package being built.
project("burt")
