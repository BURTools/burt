# Burt CMake Reference

## Functions

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

## Properties

### Directory Properties

#### `BURT_PROJECT_NAME`

## Variables

### `BURT_PROJECT_ROOTS`

The list of directories that are roots of projects.

### `BURT_REPO_URL`

The URL to the repository where Burt itself is defined.
