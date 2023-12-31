include_guard(GLOBAL)

cmake_minimum_required(VERSION 3.20)

if(NOT CMAKE_SCRIPT_MODE_FILE)
    define_property(GLOBAL PROPERTY BURT_CMAKE_TEST_SUITES
        BRIEF_DOCS "The names of all CMake test suites that have run."
        FULL_DOCS "A list of names of all test suites that have run through the Burt CMake test suite API. "
            "These names are unique and can be passed to the rest of the Burt testing API."
    )

    define_property(GLOBAL PROPERTY BURT_CURRENT_CMAKE_TEST_SUITE
        BRIEF_DOCS "The name of the current test suite. Test suite names must be unique."
        FULL_DOCS "The name of the current test suite that can be used with any of the test suite API. "
            "This identifies the test suite that is currently executing."
    )
    define_property(GLOBAL PROPERTY BURT_CURRENT_CMAKE_TEST_CASE 
        BRIEF_DOCS "The name of the current test suite in the current test case."
        FULL_DOCS "The name of teh current test case in the current test suite that can be used with any of "
            "the test case API. This identifies the test case that is currently executing."
    )
    define_property(GLOBAL PROPERTY BURT_CURRENT_CMAKE_TEST_CASE_FAILURE
        BRIEF_DOCS "A boolean value indicating failure of the current test case."
        FULL_DOCS "If set to TRUE, the current test case will be considered a failure when it ends and will "
            "be reported as such."
    )

endif()

set_property(GLOBAL PROPERTY BURT_CURRENT_CMAKE_TEST_SUITE)
set_property(GLOBAL PROPERTY BURT_CURRENT_CMAKE_TEST_CASE)
set_property(GLOBAL PROPERTY BURT_CURRENT_CMAKE_TEST_CASES)

function(burt_test_cmake_begin_suite name)
    get_property(_current_suite GLOBAL PROPERTY BURT_CURRENT_CMAKE_TEST_SUITE)
    if(_current_suite)
        message(FATAL_ERROR "Cannot begin test suite '${name}' because test suite '${_current_suite}' has "
            "not been ended with '_burt_test_end_suite'")
    endif()
    message(NOTICE "BEGIN TEST SUITE '${name}'")
    get_property(_prev_suites GLOBAL PROPERTY BURT_CMAKE_TEST_SUITES)
    if(name IN_LIST _prev_suites)
        message(FATAL_ERROR "Cannot begin test suite '${name}' because a test suite with that name has "
            "already been created")
    endif()
    set(_name_pattern "^[A-Za-z][A-Za-z0-9_+\\.-]*$")
    if(NOT name MATCHES "${_name_pattern}")
        message(FATAL_ERROR "Cannot begin test suite '${name}' because it contains invalid characters. "
            "Please use a name matching the pattern '${_name_pattern}'")
    endif()
    set_property(GLOBAL PROPERTY BURT_CURRENT_CMAKE_TEST_SUITE ${name})
    set_property(GLOBAL APPEND PROPERTY BURT_CMAKE_TEST_SUITES ${name})
endfunction()

function(burt_test_cmake_end_suite)
    get_property(_current_suite GLOBAL PROPERTY BURT_CURRENT_CMAKE_TEST_SUITE)
    if(NOT _current_suite)
        message(FATAL_ERROR "No current test suite to end")
    endif()
    get_property(_current_cases GLOBAL PROPERTY BURT_CURRENT_CMAKE_TEST_CASES)
    set_property(GLOBAL PROPERTY BURT_CURRENT_CMAKE_TEST_CASES)
    set_property(GLOBAL PROPERTY BURT_CURRENT_CMAKE_TEST_SUITE)
    message(NOTICE "END TEST SUITE '${_current_suite}'")
endfunction()

function(burt_test_cmake_begin_case name)
    message(NOTICE "  BEGIN TEST CASE '${name}'")

    set_property(GLOBAL PROPERTY BURT_CURRENT_CMAKE_TEST_CASE ${name})
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

function(burt_test_cmake_report_error)
endfunction()

function(burt_test_cmake_compare_lists list1 list2)
    set(_list1 ${list1})
    set(_list2 ${list2})
    list(SORT _list1)
    list(SORT _list2)
    list(LENGTH _list1 _list1_len)
    list(LENGTH _list2 _list2_len)
    if(NOT _list1_len EQUAL _list2_len)
        message(SEND_ERROR "List lengths do not match: '${_list1_len}' vs '${_list2_len}'")
        burt_test_cmake_report_error()
    endif()
    math(EXPR _list_end "${_list1_len}-1")
    foreach(_idx RANGE ${_list_end})
        list(GET _list1 ${_idx} _list1_val)
        list(GET _list2 ${_idx} _list2_val)
        if(NOT ${_list1_val} STREQUAL ${_list2_val})
            message(SEND_ERROR "Lists contain different values at index '${_idx}' : '${_list1_val}' vs "
                "'${_list2_val}'")
            burt_test_cmake_report_error()
        endif()
    endforeach()
endfunction()
