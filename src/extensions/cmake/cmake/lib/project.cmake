include_guard(GLOBAL)

include(${CMAKE_CURRENT_LIST_DIR}/json.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/util.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/impl/project.cmake)

unset(BURT_PROJECT_ROOTS CACHE)
unset(BURT_PROJECT_NAMES CACHE)
unset(BURT_PACKAGE_NAMES CACHE)

function(burt_project_initialize)
    # CMake needs to be aware of the burt.json files that are supplying information so it can trigger a
    # configure should any of those files change. This is the only time we look at the source burt.json files.
    # After that we'll be looking at a consolidated burt.json file created by Burt (the 'burt target init' 
    # command).
    _burt_project_find_source_json_files(_json_files ${CMAKE_SOURCE_DIR})





    # # The main goal here is to load all of the packages, including ANY defined in the project file. We can
    # # assume that the project file in the build directory has no subprojects.

    # # Load the JSON for this project.
    # _burt_read_project_json(_project)

    # # The name of this project comes from the URL for the package. There really is no other way to determine
    # # what the name of the project is since Burt doesn't really name projects.
    # burt_project_get_name(_project _project_name)
    # if(_project_name IN_LIST BURT_PROJECT_NAMES)
    #     message(DEBUG "Skipping project ${_project_name} because a project with that name was already loaded")
    #     return()
    # endif()
    # set(_project_names ${BURT_PROJECT_NAMES})
    # list(APPEND _project_names ${_project_name})
    # set(BURT_PROJECT_NAME ${_project_names} CACHE INTERNAL)



    # # Look through the subprojects noted in that JSON and recursively call this function for them.


    # # See if we've seen this project before.
    # burt_json_query(_repository "${_project_json}")

    # # Parse out the names of the packages defined in the project. Store the names in a global list and store
    # # their directories and other metadata in variables whose name is specific to the package name.
    # burt_json_query(_packages "${_project}" GET "packages"
    #     ERROR_MESSAGE "The project burt.json must have a 'packages' property.")
    # burt_json_query(_packages_size "${_packages}" LENGTH
    #     ERROR_MESSAGE "The project burt.json has a malformed 'packages' property.")
    # if(_packages_size EQUAL 0)
    #     message(FATAL_ERROR "The project burt.json has an empty array of packages in the 'packages' property")
    # endif()

    # # Loop through the packages and add the info for each package into variables.
    # math(EXPR _last_package_idx "${_packages_size}-1")
    # set(_package_names ${BURT_PACKAGE_NAMES})
    # set(_package_found FALSE)
    # foreach(_package_idx RANGE ${_last_package_idx})
    #     burt_json_query(_package_json "${_packages_array_json}" GET ${_package_idx}
    #         ERROR_MESSAGE "Could not get JSON from burt.json for package at index ${_package_idx}")
    #     burt_json_query(_package_name "${_package_json}" GET "name"
    #         ERROR_MESSAGE "Package defined in burt.json does not have a 'name' property.")
    #     burt_json_query(_package_path "${_package_json}" GET "path")
    #     list(APPEND _package_names ${_package_name})
    #     file(TO_CMAKE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/${_package_path}" _package_path)
    #     set(BURT_PACKAGE_${_package_name}_PATH ${_package_path} CACHE INTERNAL)
    #     set(BURT_PACKAGE_${_package_name} ${_package_json} CACHE INTERNAL)
    #     if(_package_name STREQUAL PROJECT_NAME)
    #         set(_package_found TRUE)
    #     endif()
    # endforeach()
    # set(BURT_PACKAGE_NAMES ${_package_names} CACHE INTERNAL)

    # # Make sure we found the package we're supposed to be building.


endfunction()
