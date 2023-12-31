
include(cmake_tests.cmake)



# Add in all of the test for the CMake code. 
set(_test_root_dir "${CMAKE_CURRENT_SOURCE_DIR}/cmake/tests")
file(GLOB_RECURSE _test_files 
    LIST_DIRECTORIES false 
    RELATIVE ${_test_root_dir}
    CONFIGURE_DEPENDS 
    "${_test_root_dir}/*_suite.cmake")
foreach(_test_file ${_test_files})
    string(REPLACE "_suite.cmake" "" _test_name ${_test_file})
    add_test(NAME ${_test_name} COMMAND ${CMAKE_COMMAND} -P "${_test_root_dir}/${_test_file}")
endforeach()
