include_guard(GLOBAL)
include(${CMAKE_CURRENT_LIST_DIR}/../cli.cmake)

function(_burt_load_current_json out_var)
    _burt_load_json(_temp ".")
    set(${out_var} ${_temp} PARENT_SCOPE)
endfunction()

function(_burt_load_json out_var rel_path)
    # The binary directory corresponding to this current directory should have a burt.json file in that
    # directory that fully defines the JSON with all default values and pre-processing. This allows the CMake
    # code here to assume the file is fully defined and allows us to take shortcuts on a lot of things.
    get_directory_property(_binary_dir DIRECTORY "${CMAKE_SOURCE_DIR}/${rel_path}" BINARY_DIR)
    set(_json_path "${_binary_dir}/burt.json" "")
    if(NOT EXISTS ${_json_path})
        if(EXISTS "${CMAKE_SOURCE_DIR}/${rel_path}/burt.json")
            # In this case, we probably didn't run a 'burt init' on the repo, so run that now.
            burt_cli_execute(COMMAND init --force COMMAND_ERROR_IS_FATAL ANY)
        else()
            message(FATAL_ERROR "Cannot load burt.json from ${CMAKE_CURRENT_LIST_DIR}")
        endif()
    endif()
    file(READ ${_json_path} _json)
    set(${out_var} ${_json} PARENT_SCOPE)
endfunction()
