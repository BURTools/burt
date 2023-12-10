# Burt CMake Reference <!-- omit in toc -->

## Table of Contents <!-- omit in toc -->

- [Functions](#functions)
  - [`burt_load_project()`](#burt_load_project)
  - [`burt_json_query()`](#burt_json_query)
- [Properties](#properties)
  - [Directory Properties](#directory-properties)
    - [`BURT_PROJECT_NAME`](#burt_project_name)
    - [`BURT_PROJECT_URL`](#burt_project_url)
- [Variables](#variables)
  - [`BURT_PROJECT_ROOTS`](#burt_project_roots)
  - [`BURT_REPO_URL`](#burt_repo_url)

## Functions

### `burt_load_project()`

Loads all of the information from the given [Project](../Concepts.md#project) into CMake so
[Packages](../Concepts.md#package) can be built. Packages may build in conjunction with other packages, so
Burt loads all of the information about all of them at once. Once loaded, the top-level package can then be
processed with [`burt_add_package()`](#burt_add_package), which may cause other packages defined in the same
project to get loaded with it.

### `burt_json_query()`

A convenience function for calling CMake's
[string(JSON)](https://cmake.org/cmake/help/latest/command/string.html#json) functionality with pass through
on the queries and boilerplate error handling. See the following equivalent calls.

```cmake
string(JSON _my_member ERROR_VARIABLE _err GET ${_json} member_name)
if(NOT _err STREQUAL NOTFOUND)
  message(FATAL_ERROR "Member 'member_name' was not found on object 'blah'")
endif()
```

is the same as

```cmake
burt_json_query(_my_member ${_json} GET member_name 
    ERROR_MESSAGE "Member 'member_name' was not found on object 'blah'")
```

## Properties

### Directory Properties

#### `BURT_PROJECT_NAME`

The name of the project defined at the directory containing the current directory scope. This property is
inherited by subdirectories and will always contain the name of the project that contained it.

#### `BURT_PROJECT_URL`

The URL of the project defined at the directory containing the current directory scope. This property is
inherited by subdirectories and will always contain the URL of the project that contained it.

## Variables

### `BURT_PACKAGE_NAMES`

The list of names of all packages that have been defined.

### `BURT_PROJECT_ROOTS`

The list of directories that are roots of projects.

### `BURT_REPO_URL`

The URL to the repository where Burt itself is defined.

<!--
### JSON

#### `burt_json_query()`

Convenience function for querying a JSON string for a value. This function handles error and trace logging so
the boilerplate for that part of it doesn't have to be repeated.

Signature: `burt_json_query(json query out_var err_msg)`

- `json`: **[required]** the string containing the JSON to query
- `query`: **[required]** the query to perform. This is what would be passed to  the CMake json query as
  follows: `string(JSON <var> GET <json> <query>)`. Each token in this list is a member or index.
- `out_var`: **[required]** the name of the variable where the query will be stored.
- `err_msg` : **[optional]** the fatal error message that will be displayed if the query fails.

Example:

```cmake
set(_json "{\"var\" : [ \"1", \"2\", \"3\" ] }")
burt_json_query(${_json} "var;1" _middle)
message("Value is: ${_middle}" ) # should print "2"
```

### Project

#### `burt_project()`

Loads a [`burt.json` project file](../JSON.md#project-file) for the current directory. This will reuslt in alo
of the packages and modules for the project being loaded accordingly. Note that this is a replacement for the
CMake [`project()`](https://cmake.org/cmake/help/latest/command/project.html) function, which simplifies its
use (since there does not need to be any argument) and keeps the `burt.json` as the single source of truth for
information about the project. Simply call from the top-level `CMakeLists.txt` as follows:

```cmake
include(${BURT_CMAKE_PATH})

burt_project()
```
-->
