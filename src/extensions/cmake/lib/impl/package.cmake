
function(_burt_create_package_from_json json)
    set(_extra_vars ${ARGN})
    set(rel_path ".")
    list(LENGTH _extra_vars _extra_var_count)
    if(${_extra_var_count} GREATER 0)
        list(GET _extra_vars 0 rel_path)
    endif()

    # Parse the values we care about so we can initialize the project for this package.
    burt_json_query("${json}" "name" _package_name "Package is missing the required 'name' property")
    burt_json_query("${json}" "description" _package_desc
        "Package is missing the required 'description' property")
    burt_json_query("${json}" "version" _package_version "Package is missing the required 'version' property")

    set(CMAKE_CURRENT_PACKAGE_NAME "${_package_name}" CACHE STRING INTERNAL FORCE)
    set(CMAKE_CURRENT_PACKAGE_DESCRIPTION "${_package_desc}" CACHE STRING INTERNAL FORCE)
    set(CMAKE_CURRENT_PACKAGE_VERSION "${json}" CACHE STRING INTERNAL FORCE)

    if(rel_path STREQUAL "")
    endif()
endfunction()
