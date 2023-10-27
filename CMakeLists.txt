cmake_minimum_required(VERSION 3.19.0)

# This flag is unique to Burt and indicates that it is building itself. This triggers some unique behavior to
# avoid the chicken-and-egg problem.
set(_BURT_BUILDING_SELF ON)

# We need the burt.json to be copied to the binary dir, which is normally done by 'burt init'. Since we don't
# have a burt command to run at all, we need to assume that just straight copying the burt.json is good
# enough. This is not normally an assumption we can make, but we have to here to avoid a chicken-and-egg
# problem.
configure_file(${CMAKE_CURRENT_LIST_DIR}/burt.json ${CMAKE_CURRENT_BINARY_DIR}/burt.json COPYONLY)

include(src/extensions/cmake/burt.cmake)

project(${BURT_CURRENT_PACKAGE_NAME} 
    DESCRIPTION ${BURT_CURRENT_PACKAGE_DESCRIPTION}
    HOMEPAGE_URL ${BURT_CURRENT_PACKAGE_URL}
)
