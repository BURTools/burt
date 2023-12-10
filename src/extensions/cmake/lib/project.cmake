include_guard(GLOBAL)

include(${CMAKE_CURRENT_LIST_DIR}/json.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/util.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/impl/package.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/impl/project.cmake)

define_property(DIRECTORY PROPERTY BURT_PROJECT_NAME INHERITED
    BRIEF_DOCS "The name of the project defined in the project's burt.json file."
    FULL_DOCS "The name of the project defined in the project's burt.json file. The repository for the "
        "project must contain a burt.json file that conforms to the specification defined in "
        "${BURT_REPO_URL}/blob/main/doc/JSON.md#project-file")
define_property(DIRECTORY PROPERTY BURT_PROJECT_URL INHERITED
    BRIEF_DOCS "The repository URL of the project defined in the project's burt.json file."
    FULL_DOCS "The repository URL of the project defined in the project's burt.json file. The repository for "
        "the project must contain a burt.json file that conforms to the specification defined in "
        "${BURT_REPO_URL}/blob/main/doc/JSON.md#project-file")

set(BURT_PROJECT_ROOTS "" CACHE INTERNAL)
set(BURT_PACKAGE_NAMES "" CACHE INTERNAL)

function(burt_project_initialize)
    
    _burt_read_project_json(_project)

    # See if we've seen this project before.
    burt_json_query(_repository "${_project_json}")

    # Parse out the names of the packages defined in the project. Store the names in a global list and store
    # their directories and other metadata in variables whose name is specific to the package name.
    burt_json_query(_packages "${_project}" GET "packages"
        ERROR_MESSAGE "The project burt.json must have a 'packages' property.")
    burt_json_query(_packages_size "${_packages}" LENGTH
        ERROR_MESSAGE "The project burt.json has a malformed 'packages' property.")
    if(_packages_size EQUAL 0)
        message(FATAL_ERROR "The project burt.json has an empty array of packages in the 'packages' property")
    endif()

    # Loop through the packages and add the info for each package into variables.
    math(EXPR _last_package_idx "${_packages_size}-1")
    set(_package_names ${BURT_PACKAGE_NAMES})
    set(_package_found FALSE)
    foreach(_package_idx RANGE ${_last_package_idx})
        burt_json_query(_package_json "${_packages_array_json}" GET ${_package_idx}
            ERROR_MESSAGE "Could not get JSON from burt.json for package at index ${_package_idx}")
        burt_json_query(_package_name "${_package_json}" GET "name"
            ERROR_MESSAGE "Package defined in burt.json does not have a 'name' property.")
        burt_json_query(_package_path "${_package_json}" GET "path")
        list(APPEND _package_names ${_package_name})
        file(TO_CMAKE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/${_package_path}" _package_path)
        set(BURT_PACKAGE_${_package_name}_PATH ${_package_path} CACHE INTERNAL)
        set(BURT_PACKAGE_${_package_name} ${_package_json} CACHE INTERNAL)
        if(_package_name STREQUAL PROJECT_NAME)
            set(_package_found TRUE)
        endif()
    endforeach()
    set(BURT_PACKAGE_NAMES ${_package_names} CACHE INTERNAL)

    # Make sure we found the package we're supposed to be building.


endfunction()

function(burt_project)

    _burt_load_current_json(_json)

    # Handle the project we're starting here. We must supply the project info for the project() call in the
    # root CMakeLists.txt. If this project has a root package, then we use all of the information in the
    # package itself. Otherwise, we use information in the root of the project.
    # See if there is a root package. If there is, we essentially skip the root project.
    burt_json_query("${_json}" "package" _package)
    if(NOT _package STREQUAL "NOTFOUND")
        message(DEBUG "Treating project as package due to root package")
        # This is a package that is essentially defined in the root of the project.
        _burt_create_package_from_json("${_package}")
        set(BURT_CURRENT_PROJECT_NAME ${CMAKE_CURRENT_PACKAGE_NAME} CACHE STRING INTERNAL FORCE)
        set(BURT_CURRENT_PROJECT_URL ${CMAKE_CURRENT_PACKAGE_URL} CACHE STRING INTERNAL FORCE)
    else()
        message(DEBUG "Using root project info for new project due to no root package")
        # Parse the values we care about for the project out of the root JSON.
        burt_json_query("${_json}" "name" _project_name 
            "The project burt.json must define the project name in the root 'name' property")
        burt_json_query("${_json}" "description" _project_desc 
            "The project burt.json must define the project description in the root 'description' property")
        burt_json_query("${_json}" "repository" _repo 
            "The project burt.json must define the project repository in the root 'repository' property")
        burt_json_query("${_repo}" "url" _repo_url 
            "The repository defined in the project burt.json is missing the 'url' property.")
        
        # We'll use directory properties to store the information about the project. This 
        set(BURT_CURRENT_PROJECT_NAME ${_project_name} CACHE STRING INTERNAL FORCE)
        set(BURT_CURRENT_PROJECT_DESCRIPTION ${_project_desc} CACHE STRING INTERNAL FORCE)
        set(BURT_CURRENT_PROJECT_URL ${_repo_url} CACHE STRING INTERNAL FORCE)
        set(BURT_CURRENT_PROJECT_VERSION "0")
    endif()
    set(BURT_PROJECT_ROOTS ${BURT_PROJECT_ROOTS} ${CMAKE_CURRENT_SOURCE_DIR} CACHE STRING INTERNAL FORCE)
    set_directory_properties(PROPERTIES 
        BURT_PROJECT_NAME "${BURT_CURRENT_PROJECT_NAME}" 
        BURT_PROJECT_DESCRIPTION "${BURT_CURRENT_PROJECT_DESCRIPTION}"
        BURT_PROJECT_URL "${BURT_CURRENT_PROJECT_URL}")
    message(STATUS "New Project '${BURT_CURRENT_PROJECT_NAME}'")
    message(STATUS "  description: ${BURT_CURRENT_PROJECT_DESCRIPTION}")
    message(STATUS "  repo: ${BURT_CURRENT_PROJECT_URL}")

    burt_json_query(${_json} "packages" _packages)
    if(NOT _packages STREQUAL "NOTFOUND")
        string(JSON _package_count LENGTH ${_packages})
        foreach(_pkg_idx RANGE 1 ${_package_count})
            string(JSON _pkg_path MEMBER ${_packages} ${_pkg_idx})
            string(JSON _pkg_obj GET ${_packages} "${_pkg_path}")
            _burt_create_package_from_json("${_pkg_obj}" ${_pkg_path})
        endforeach()
    endif()
endfunction()

function(burt_load_extensions)

endfunction()

function(burt_package)

endfunction()
