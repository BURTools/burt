# Only import this file once for each directory.
include_guard(DIRECTORY)

# Only do this stuff the first time this is loaded anywhere.
get_property(_burt_first_load GLOBAL PROPERTY _BURT_FIRST_LOAD)
if(NOT _burt_first_load)
    # Global variables used by Burt.
    set(BURT_REPO_URL "https://github.com/BURTools/burt")

    include(${CMAKE_CURRENT_LIST_DIR}/lib/project.cmake)
    include(${CMAKE_CURRENT_LIST_DIR}/lib/target.cmake)

    # Make sure we have a path to Burt's user home directory.
    set(BURT_USER_HOME "" CACHE STRING 
        "Path to the user's home directory and root of Burt's global file storage.")
    if(BURT_USER_HOME STREQUAL "")
        if(DEFINED ENV{HOME})
            set(BURT_USER_HOME "$ENV{HOME}/.burt")
        elseif(DEFINED ENV{USERPROFILE})
            file(TO_CMAKE_PATH "$ENV{USERPROFILE}/.burt" BURT_USER_HOME)
        else()
            message(FATAL_ERROR "Cannot find home directory for current OS")
        endif()
    endif()

    # Fix up the path to the global burt executable.
    if(NOT DEFINED ${BURT_EXE})
        set(BURT_EXE "${BURT_USER_HOME}/bin/burt" CACHE STRING INTERNAL FORCE)
    endif()
endif()

# Always call burt_project() for every inclusion of this file (accounting for the guard). We're assuming it's
# being included in the root CMakeLists.txt of every repository, either directly through an include() call or
# indirectly through project(). Those repositories could be submodules of other repositories, causing
# burt.cmake to be included more than once.
burt_project()
