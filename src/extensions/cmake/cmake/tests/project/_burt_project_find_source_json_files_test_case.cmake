
include("${CMAKE_CURRENT_LIST_DIR}/../../lib/impl/project.cmake")

_burt_project_find_source_json_files(_files "${CMAKE_CURRENT_LIST_DIR}/find_source_json_files")
file(GLOB_RECURSE _glob_files "${CMAKE_CURRENT_LIST_DIR}/find_source_json_files" "*/burt.json")
burt_test_cmake_compare_lists("${_files}" "${_glob_files}")
