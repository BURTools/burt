include_guard(GLOBAL)

cmake_minimum_required(VERSION 3.20)
define_property(GLOBAL PROPERTY BURT_CMAKE_TEST_SUITES
    BRIEF_DOCS "The names of all CMake test suites that have been added."
    FULL_DOCS "A list of names of all test suites that have been added through the Burt CMake test suite "
        "API. These names are unique and can be passed to the rest of the Burt testing API."
)
define_property(GLOBAL PROPERTY BURT_CURRENT_CMAKE_TEST_SUITE
    BRIEF_DOCS "The name of the current test suite. Test suite names must be unique."
    FULL_DOCS "The name of the current test suite that can be used with any of the test suite API. "
        "This identifies the test suite that is currently executing."
)



function(burt_add_test_folder)
    # Process and validate arguments.
    set(_options RECURSE)
    set(_oneValueArgs)
    set(_multiValueArgs PATHS SUITE_SUFFIXES CASE_SUFFIXES)
    cmake_parse_arguments(_arg "${_options}" "${_oneValueArgs}" "${_multiValueArgs}" ${ARGN})
    if(NOT _arg_SUITE_SUFFIXES)
        set(_arg_SUITE_SUFFIXES "_test_suite")
    endif()
    if(NOT _arg_PATHS)
        message(FATAL_ERROR "No root CMake test paths given")
    endif()
    set(_case_suffixes_arg)
    if(_arg_CASE_SUFFIXES)
        set(_case_suffixes_arg CASE_SUFFIXES ${_arg_CASE_SUFFIXES})
    endif()
    set(_glob_command "GLOB")
    if(_arg_RECURSE)
        set(_glob_command "GLOB_RECURSE")
    endif()
    set(_depends_arg)
    if(NOT CMAKE_SCRIPT_MODE_FILE)
        set(_depends_arg "CONFIGURE_DEPENDS")
    endif()
    foreach(_path ${_arg_PATHS})
        message(DEBUG "Processing tests in root folder '${_path}'")
        if(NOT EXISTS "${_path}")
            message(FATAL_ERROR "Cannot add CMake root test folder: No such folder exists at '${_path}'")
        endif()

        foreach(_suffix ${_arg_SUITE_SUFFIXES})
            message(DEBUG "Processing suite suffix '${_suffix}'")
            file(${_glob_command} _suite_dirs ${_depends_arg} LIST_DIRECTORIES true "${_path}/*${_suffix}/")
            message(TRACE "Suite directory paths found: ${_suite_dirs}")
            foreach(_suite_dir ${_suite_dirs})
                # The name of the suite is the name of the last directory in the path.
                message(DEBUG "Test suite folder '${_suite_dir}' found in root")
                get_filename_component(_suite_name "${_suite_dir}" NAME)
                string(REPLACE "${_suffix}" "" _suite_name ${_suite_name})
                burt_test_cmake_suite_folder(${_suite_dir} NAME ${_suite_name} ${_case_suffixes_arg})
            endforeach()
            file(${_glob_command} _suite_files ${_depends_arg} "${_path}/*${_suffix}.cmake")
            message(TRACE "Suite file paths found: ${_suite_files}")
            foreach(_suite_file ${_suite_files})
                # The name of the suite is the filename sans the pattern at the end.
                message(DEBUG "Test suite file '${_suite_file}' found in root")
                cmake_path(GET _suite_file STEM _suite_name)
                string(REPLACE "${_suffix}" "" _suite_name ${_suite_name})
                burt_test_cmake_begin_suite("${_suite_name}")
                include("${_suite_file}")
                burt_test_cmake_end_suite()
            endforeach()
        endforeach()
    endforeach()    
endfunction()












unset(BURT_TEST_SUITES CACHE)
unset(BURT_CURRENT_TEST_SUITE CACHE)
unset(BURT_CURRENT_TEST_CASE CACHE)

function(burt_test_cmake_report_error)
    message(SEND_ERROR ${ARGV})
    set(BURT_CURRENT_TEST_CASE_STATUS FAILED)
    math(EXPR BURT_TEST_CASE_${BURT_CURRENT_CMAKE_TEST_CASE}_FAILURE_COUNT
        "${BURT_CMAKE_TEST_CASE_${BURT_CURRENT_CMAKE_TEST_CASE}_FAILURE_COUNT}+1")
endfunction()

function(burt_test_execute_process)
    set(_options)
    set(_oneValueArgs WORKING_DIRECTORY TIMEOUT)
    set(_multiValueArgs COMMAND RESULT_SUCCESS_VALUES RESULT_FAIL_VALUES OUTPUT_SUCCESS_PATTERNS 
        OUTPUT_FAIL_PATTERNS ERROR_SUCCESS_PATTERNS ERROR_FAIL_PATTERNS)
    cmake_parse_arguments(_arg "${_options}" "${_oneValueArgs}" "${_multiValueArgs}" ${ARGN})
    if(NOT ${_arg_COMMAND})
        message(FATAL_ERROR "No COMMAND option given")
    endif()
    if(NOT ${_arg_RESULT_SUCCESS_VALUES} AND NOT ${_arg_RESULT_FAIL_VALUES})
        set(_arg_RESULT_SUCCESS_VALUES 0)
    endif()
    if(NOT ${_arg_ERROR_SUCCESS_PATTERNS} AND NOT ${_arg_ERROR_FAIL_PATTERNS})
        set(_arg_FAIL_PATTERNS ".*")
    endif()

    set(CMAKE_MESSAGE_INDENT "    ")
    message(DEBUG "Testing execution of '${_arg_COMMAND}'")
    set(_exec_args 
        COMMAND ${_arg_COMMAND} 
        RESULT_VARIABLE _result 
        OUTPUT_VARIABLE _output 
        ERROR_VARIABLE _error)
    # Forward some of the arguments along to the execute_process()
    foreach(_pt_arg IN WORKING_DIRECTORY TIMEOUT)
        if(${_arg_${_pt_arg}})
            list(APPEND _exec_args ${_pt_arg} ${_arg_${_pt_arg}})
        endif()
    endforeach()

    # Print the output of the executed process to the console if we're more verbose than default.
    set(_output_print_levels DEBUG TRACE)
    if(CMAKE_MESSAGE_LOG_LEVEL IN_LIST _output_print_levels)
        # If debugging, also print out the command being executed.
        list(APPEND _exec_args ECHO_OUTPUT_VARIABLE COMMAND_ECHO STDOUT)
    endif()
    set(_error_print_levels ${_output_print_levels} VERBOSE)
    if(CMAKE_MESSAGE_LOG_LEVEL IN_LIST _error_print_levels)
        list(APPEND _exec_args ECHO_ERROR_VARIABLE)
    endif()

    # Run the process
    execute_process(${_exec_args})

    message(DEBUG "  Return code: ${_result}")
    message(TRACE "  STDOUT: ${_output}")
    message(TRACE "  STDERR: ${_error}")

    # Handle the output of the process to determine if it was a failure or not.
    if(${_result} IN_LIST _arg_RESULT_FAIL_VALUES AND NOT ${_result} IN_LIST _arg_RESULT_SUCCESS_VALUES)
        burt_test_cmake_report_error("Process exited with return code ${_result} which was found in the "
            "list of fail codes")
    endif()
    macro(_test_variable value label success_patterns fail_patterns)
        set(_success FALSE)
        foreach(_pat IN ${success_patterns})
            if(${value} MATCHES ${_pat})
                set(_success TRUE)
            endif()
        endforeach()
        if(${_success} OR NOT ${success_patterns})
            foreach(_pat IN ${fail_patterns})
                if(${value} MATCHES ${_pat})
                    burt_test_cmake_report_error("Process ${label} matched the fail pattern '${_pat}': 
                        ${value}")
                endif()
            endforeach()
        endif()
    endmacro()
    _test_variable(${_output} "STDOUT" "${_arg_OUTPUT_SUCCESS_PATTERNS}" "${_arg_OUTPUT_FAIL_PATTERNS}")
    _test_variable(${_error} "STDERR" "${_arg_ERROR_SUCCESS_PATTERNS}" "${_arg_ERROR_FAIL_PATTERNS}")
endfunction()

function(burt_test_cmake_begin_suite name)
    if(${BURT_CURRENT_CMAKE_TEST_SUITE})
        message(FATAL_ERROR "Cannot begin test suite '${name}' because test suite '${_current_suite}' has "
            "not been ended with '_burt_test_end_suite'")
    endif()
    message(NOTICE "BEGIN TEST SUITE '${name}'")
    if(name IN_LIST BURT_CMAKE_TEST_SUITES)
        message(FATAL_ERROR "Cannot begin test suite '${name}' because a test suite with that name has "
            "already been created")
    endif()
    set(_name_pattern "^[A-Za-z][A-Za-z0-9_+\\.-]*$")
    if(NOT name MATCHES "${_name_pattern}")
        message(FATAL_ERROR "Cannot begin test suite '${name}' because it contains invalid characters. "
            "Please use a name matching the pattern '${_name_pattern}'")
    endif()
    set(BURT_CURRENT_CMAKE_TEST_SUITE ${name} CACHE INTERNAL "")
    set(BURT_CMAKE_TEST_SUITES ${BURT_CMAKE_TEST_SUITES} ${name} CACHE INTERNAL "")
endfunction()

function(burt_test_cmake_end_suite)
    if(NOT ${BURT_CURRENT_CMAKE_TEST_SUITE})
        message(FATAL_ERROR "No current test suite to end")
    endif()
    if(${BURT_CURRENT_CMAKE_TEST_CASE})
        message(FATAL_ERROR "Cannot end test suite with active test case '${BURT_CURRENT_CMAKE_TEST_CASE}'")
    endif()
    message(NOTICE "END TEST SUITE '${BURT_CURRENT_CMAKE_TEST_SUITE}'")
    unset(BURT_CURRENT_CMAKE_TEST_SUITE CACHE)
endfunction()

function(burt_test_cmake_begin_case name)
    if(NOT ${BURT_CURRENT_CMAKE_TEST_SUITE})
        message(FATAL_ERROR "Cannot begin a test case with no current test suite")
    endif()
    if(${BURT_CURRENT_CMAKE_TEST_CASE})
        message(FATAL_ERROR "Cannot begin test case '${name}' because test case "
            "'${BURT_CURRENT_CMAKE_TEST_CASE}' is still active")
    endif()
    if(${name} IN_LIST BURT_TEST_SUITE_${BURT_CMAKE_CURRENT_TEST_SUITE}_CASES)
        message(FATAL_ERROR "Cannot begin test case '${name}' because current test suite "
            "'${BURT_CMAKE_CURRENT_TEST_SUITE}' already contains a test case with that name")
    endif()
    message(NOTICE "  BEGIN TEST CASE '${name}'")
    set(BURT_CURRENT_CMAKE_TEST_CASE ${name} CACHE INTERNAL "")
    set(BURT_TEST_SUITE_${BURT_CMAKE_CURRENT_TEST_SUITE}_CASES 
        ${BURT_TEST_SUITE_${BURT_CMAKE_CURRENT_TEST_SUITE}_CASES} ${name} CACHE INTERNAL "")
    
endfunction()

function(burt_test_cmake_end_case)
    get_property(_current_case GLOBAL PROPERTY BURT_CURRENT_CMAKE_TEST_CASE)
    if(NOT _current_case)
        message(FATAL_ERROR "No current test case to end")
    endif()
    message(NOTICE "  END TEST CASE '${_current_case}'")
endfunction()

function(burt_test_cmake_root_folder)
    # Process and validate arguments.
    set(_options RECURSE)
    set(_oneValueArgs)
    set(_multiValueArgs PATHS SUITE_SUFFIXES CASE_SUFFIXES)
    cmake_parse_arguments(_arg "${_options}" "${_oneValueArgs}" "${_multiValueArgs}" ${ARGN})
    if(NOT _arg_SUITE_SUFFIXES)
        set(_arg_SUITE_SUFFIXES "_test_suite")
    endif()
    if(NOT _arg_PATHS)
        message(FATAL_ERROR "No root CMake test paths given")
    endif()
    set(_case_suffixes_arg)
    if(_arg_CASE_SUFFIXES)
        set(_case_suffixes_arg CASE_SUFFIXES ${_arg_CASE_SUFFIXES})
    endif()
    set(_glob_command "GLOB")
    if(_arg_RECURSE)
        set(_glob_command "GLOB_RECURSE")
    endif()
    set(_depends_arg)
    if(NOT CMAKE_SCRIPT_MODE_FILE)
        set(_depends_arg "CONFIGURE_DEPENDS")
    endif()
    foreach(_path ${_arg_PATHS})
        message(DEBUG "Processing tests in root folder '${_path}'")
        if(NOT EXISTS "${_path}")
            message(FATAL_ERROR "Cannot add CMake root test folder: No such folder exists at '${_path}'")
        endif()

        foreach(_suffix ${_arg_SUITE_SUFFIXES})
            message(DEBUG "Processing suite suffix '${_suffix}'")
            file(${_glob_command} _suite_dirs ${_depends_arg} LIST_DIRECTORIES true "${_path}/*${_suffix}/")
            message(TRACE "Suite directory paths found: ${_suite_dirs}")
            foreach(_suite_dir ${_suite_dirs})
                # The name of the suite is the name of the last directory in the path.
                message(DEBUG "Test suite folder '${_suite_dir}' found in root")
                get_filename_component(_suite_name "${_suite_dir}" NAME)
                string(REPLACE "${_suffix}" "" _suite_name ${_suite_name})
                burt_test_cmake_suite_folder(${_suite_dir} NAME ${_suite_name} ${_case_suffixes_arg})
            endforeach()
            file(${_glob_command} _suite_files ${_depends_arg} "${_path}/*${_suffix}.cmake")
            message(TRACE "Suite file paths found: ${_suite_files}")
            foreach(_suite_file ${_suite_files})
                # The name of the suite is the filename sans the pattern at the end.
                message(DEBUG "Test suite file '${_suite_file}' found in root")
                cmake_path(GET _suite_file STEM _suite_name)
                string(REPLACE "${_suffix}" "" _suite_name ${_suite_name})
                burt_test_cmake_begin_suite("${_suite_name}")
                include("${_suite_file}")
                burt_test_cmake_end_suite()
            endforeach()
        endforeach()
    endforeach()    
endfunction()

function(burt_test_cmake_suite_folder path)
    set(_options RECURSE)
    set(_oneValueArgs NAME)
    set(_multiValueArgs CASE_SUFFIXES)
    cmake_parse_arguments(_arg "${_options}" "${_oneValueArgs}" "${_multiValueArgs}" ${ARGN})
    if(NOT EXISTS ${path})
        message(FATAL_ERROR "The given test suite folder '${path}' does not exist")
    endif()
    if(NOT IS_DIRECTORY "${path}")
        message(FATAL_ERROR "The given test suite path '${path}' is not a folder")
    endif()
    if(NOT _arg_NAME)
        get_filename_component(_arg_NAME "${path}" NAME)
    endif()
    if(NOT _arg_CASE_SUFFIXES)
        set(_arg_CASE_SUFFIXES "_test_case")
    endif()
    set(_depends_arg)
    if(NOT CMAKE_SCRIPT_MODE_FILE)
        set(_depends_arg "CONFIGURE_DEPENDS")
    endif()
    message(DEBUG "Processing test cases in suite folder '${path}'")
    burt_test_cmake_begin_suite(${_arg_NAME})
    foreach(_suffix ${_arg_CASE_SUFFIXES})
        message(TRACE "Looking for test cases with suffix '${_suffix}'")
        file(GLOB_RECURSE _case_files
            LIST_DIRECTORIES false 
            ${_depends_arg}
            "${path}/*${_suffix}.cmake"
        )
        foreach(_case_file ${_case_files})
            message(DEBUG "Test case file '${_case_file}' found in root")
            cmake_path(GET _case_file STEM _case_name)
            string(REPLACE "${_suffix}" "" _case_name ${_case_name})
            burt_test_cmake_begin_case(${_case_name})
            include(${_case_file})
            burt_test_cmake_end_case()
        endforeach()
    endforeach()

    burt_test_cmake_end_suite()
endfunction()

function(burt_test_cmake_compare_lists list1 list2)
    set(_list1 ${list1})
    set(_list2 ${list2})
    list(SORT _list1)
    list(SORT _list2)
    list(LENGTH _list1 _list1_len)
    list(LENGTH _list2 _list2_len)
    if(NOT _list1_len EQUAL _list2_len)
        burt_test_cmake_report_error("List lengths do not match: '${_list1_len}' vs '${_list2_len}'")
        return()
    endif()
    math(EXPR _list_end "${_list1_len}-1")
    foreach(_idx RANGE ${_list_end})
        list(GET _list1 ${_idx} _list1_val)
        list(GET _list2 ${_idx} _list2_val)
        if(NOT ${_list1_val} STREQUAL ${_list2_val})
            message(SEND_ERROR )
            burt_test_cmake_report_error("Lists contain different values at index '${_idx}' : "
                "'${_list1_val}' vs '${_list2_val}'")
        endif()
    endforeach()
endfunction()
