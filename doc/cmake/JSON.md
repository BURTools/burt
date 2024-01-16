# CMake JSON Extensions <!-- omit in toc -->

## Table of Contents <!-- omit in toc -->

## Extensions

This extension allows additional information to be defined on the following entities:

| Entity | Extension |
| ------ | ----------|
| [Module](../JSON.md#module) | [Module Extension](#module-extension) |
| [Module Rule](../JSON.md#module-rule) | [Module Rule Extension](#module-rule-extension) |
| [Package](../JSON.md#package) | [Package Extension](#package-extension) |
| [Package Rule](../JSON.md#package-rule) | [Package Rule Extension](#package-rule-extension) |
| [Project](../JSON.md#project) | [Project Extension](#project-extension)
| [Project Rule](../JSON.md#project-rule) | [Project Rule Extension](#project-rule-extension) |

Each of Entities above supports specifying this extended data via the following:

```json
{
    "extended" : {
        "cmake" : {}
    }
}
```

The `cmake` object under the `extended` property is where additional information specific to
this extension can be defined. The value of the `cmake` property is an object whose type depends on what is
being extended as is shown as Extension in the table above.

### Module

Data may be defined on a [Module](../JSON.md#module) in the `extended` property for the `cmake` extension.
Suppose the module JSON looks like follows:

```json
{
    "extended" : {
        "cmake" : {}
    }
}
```

The `cmake` object under the `extended` property on the module is where additional information specific to
this extension can be defined. THis object is a [Module Extension](#module-extension) object.

### Module Rule

Data may be defined on a [Module Rule](../JSON#module)

### Package

Data may be defined on a [Package](../JSON.md#package) in the `extended` property for the `cmake` extension.
Suppose the package JSON looks like follows:

```json
{
    "extended" : {
        "cmake" : {}
    }
}
```

The `cmake` object under the `extended` property on the package is where additional information specific to
this extension can be defined. This object is a [Package Extension](#package-extension) object.

### Package Rule

Data may defined on a [Package Rule](../JSON.md#package-rule) in the `extended` property for the `cmake`
extension. Suppose the package JSON looks like follows:

```json
{
    "rules" : [
        {
            "extended" : {
                "cmake" : {}
            }
        }
    ]
}
```

The `cmake` object under the `extended` property on the package rule is where additional information specific
to this extension can be defined. This object is a [Package Rule Extension](#package-rule-extension) object.

### Project

### Project Rule

## Reference

### Module Extension

An object defining some additional CMake-specific data on a [Module](../JSON.md#module).

```json
{
    "directoryProperties" : {},
    "directoryPropertyChanges" : [],
    "sourceRules" : [],
    "targetProperties" : {},
    "targetPropertyChanges" : [],
    "variables" : {},
    "variableChanges" : []
}
```

- `directoryProperties` : **[optional]** an object defining values of [CMake Directory
  Properties](https://cmake.org/cmake/help/latest/manual/cmake-properties.7.html#properties-on-directories)
  for the [Module's](../Concepts.md#module) directory, where keys are the names of the directory properties
  and values are strings to be set on the properties. Properties set using this mechanism overwrite the values
  inherited from containing directories. See the [Directory Properties](./Concepts.md#directory-properties) concept for details.
- `directoryPropertyChanges` : **[optional]** an array of [Property Changes](#property-change) that make
  modifications to the values of [CMake Directory
  Properties](https://cmake.org/cmake/help/latest/manual/cmake-properties.7.html#properties-on-directories) on
  the [Module's](../Concepts.md#module) directory. These modifications alter the value specified in
  `directoryProperties` or inherited from the parent directory, and are processed in the order they are
  listed. See the [Directory Properties](./Concepts.md#directory-properties) concept for details.
- `sourceRules` : **[optional]** an array of [Source Rules](#source-rule) that define the [CMake
  Properties](https://cmake.org/cmake/help/latest/manual/cmake-properties.7.html#properties-on-source-files)
  on source files in the module.
- `targetProperties` : **[optional]** an object defining the values of [CMake Target
  Properties](https://cmake.org/cmake/help/latest/manual/cmake-properties.7.html#properties-on-targets) on the
  [target](https://cmake.org/cmake/help/book/mastering-cmake/chapter/Key%20Concepts.html#targets) created for
  the [Module](../Concepts.md#module), where the keys are the names of the properties and the values are
  strings to be set on the properties. Properties set using this mechanism override the default values of the
  target properties. See the [Target Properties](./Concepts.md#target-properties) concept for details.
- `targetPropertyChanges` : **[optional]** an array of [Property Changes](#property-change) that make
  modifications to the values of [CMake Target
  Properties](https://cmake.org/cmake/help/latest/manual/cmake-properties.7.html#properties-on-targets) on the
  [Module's](../Concepts.md#module) target. Tehse modifications alter the value specified in
  `targetProperties` or default values CMake sets on the target, and are processed in the order they are
  listed. See the [Target Properties](./Concepts.md#target-properties) concept for details.
- `variables` : **[optional]** an object defining [CMake
  Variable](https://cmake.org/cmake/help/latest/manual/cmake-language.7.html#cmake-language-variables) values
  to be used in the [Module](../JSON.md#module) containing this extension, where the keys are the names of
  variables and values are the boolean, number, or string to be used as the value of the variable. Variables
  set using this mechansim override the values of variables inherited from the parent scope of the
  [Module](../Concepts.md#module). See the [Variables](./Concepts.md#variables) concept for details.
- `variableChanges` : **[optional]** an array of [Variable Changes](#variable-change) that modify the values
  of variables set in `variables` or inherited from the parent scope of the [Module](./Concepts.md#module).
  See the [Variables](./Concepts.md#variables) for details.

### Module Rule Extension

An object defining some additional CMake-specific data on a [Module Rule](../JSON.md#module-rule).

```json
{
    "directoryProperties" : {},
    "directoryPropertyChanges" : [],
    "sourceRules" : [],
    "targetProperties" : {},
    "targetPropertyChanges" : [],
    "variables" : {},
    "variableChanges" : []
}
```

- `directoryProperties` : **[optional]** an object that functions exactly like the `directoryProperties`
  property on the [Module Extension](#module-extension), except that the property value changes dictated on
  this object are applied when the [Module Rule](../JSON.md#module-rule) containing this extension is
  processed.
- `directoryPropertyChanges` : **[optional]** an array of [Property Changes](#property-change) that functions
  exactly like the `directoryPropertyChanges` property on the [Module Extension](#module-extension), except
  that these property changes are applied when the [Module Rule](../JSON.md#module-rule) containing this
  extension is processed.
- `sourceRules` : **[optional]** an array of [Source Rules](#source-rule) that functions exactly like the
  `sourceRules` property on the [Module Extension](#module-extension), except that these rules are processed
  when the [Module Rule](../JSON.md#module-rule) containing this extension is processed.
- `targetProperties` : **[optional]** an object that functions exactly like the `targetProperties` property on
  the [Module Extension](#module-extension), except that the property value changes dictated on this object
  are applied when the [Module Rule](../JSON.md#module-rule) containing this extension is processed.
- `targetPropertyChanges` : **[optional]** an array of [Property Changes](#property-change) that functions
  exactly like the `targetPropertyChanges` property on the [Module Extension](#module-extension), except that
  these property changes are applied when the [Module Rule](../JSON.md#module-rule) containing this extension
  is processed.
- `variables` : **[optional]** an object that functions exactly like the `vairables` property on the [Module
  Extension](#module-extension), except that the variable value changes dictated on this object are applied
  when the [Module Rule](../JSON.md#module-rule) containing this extension is processed.
- `variableChanges` : **[optional]** an array of [Variable Changes](#variable-change) that functions
  exactly like the `variableChanges` property on the [Module Extension](#module-extension), except that these
  variable changes are applied when the [Module Rule](../JSON.md#module-rule) containing this extension is
  processed.

### Package Extension

An object defining some additional CMake-specific data on a [Package](../JSON.md#package).

```json
{
    "directoryProperties" : {},
    "directoryPropertyChanges" : [],
    "tests" : [],
    "testResourceData" : {},
    "testResourceMethod" : {},
    "variables" : {},
    "variableChanges" : []
}
```

- `directoryProperties` : **[optional]** the [Directory
  Properties](https://cmake.org/cmake/help/latest/manual/cmake-properties.7.html#properties-on-directories)
  that will be set on the directory for the Package (either from source or the one generated by Burt). The
  keys of this object are the names of the directory properties and their values are strings. These values are
  set after the [Project Extension](#project-extension) directory properties in `directoryProperties` are set.
  See the [Directory Properties](./Concepts.md#directory-properties) concept for details.
- `tests` : **[optional]** an array of [Test](#test) objects defining each test in the package.
- `testResourceData` : **[conditionally required]** the contents of this property depend on the value of the
  `testResourceMethod` property.
- `testResourceMethod` : **[optional]** the method to use to define the resources available for tests. If this
  is omitted, no test resources will be defined for tests. The valid values are:
  - `json` : the available resources data is embedded in this object in the `testResourceData` property or via
    a file referenced as a string in the `testResourceData` property. The format of the file or the contents
    of the object in `testResourceData` are defined in the [Resource Specification
    File](https://cmake.org/cmake/help/latest/manual/ctest.1.html#resource-specification-file) documentation.
    Note that when embedding, the entire contents of that format are included (including the version).
  - `test` : the name of the test is stored in the `testResourceData` property as a string.
- `variables` : **[optional]** an object defining [CMake
  Variable](https://cmake.org/cmake/help/latest/manual/cmake-language.7.html#cmake-language-variables) values
  to be used in the [Package](../JSON.md#package) containing this extension, where the keys are the names of
  variables and values are the boolean, number, or string to be used as the value of the variable. Variables
  set using this mechansim override the values of variables inherited from the parent scope of the
  [Package](../Concepts.md#package). See the [Variables](./Concepts.md#variables) concept for details.
- `variableChanges` : **[optional]** an array of [Variable Changes](#variable-change) that modify the values
  of variables set in `variables` or inherited from the parent scope of the [Package](./Concepts.md#package).
  See the [Variables](./Concepts.md#variables) for details.

### Package Rule Extension

An object defining some additional CMake-specific data on a [Package Rule](../JSON.md#package-rule).

```json
{
    "directoryProperties" : {},
    "directoryPropertyChanges" : [],
    "tests" : [],
    "testResourceData" : {},
    "testResourceMethod" : {},
    "variables" : {},
    "variableChanges" : []
}
```

- `directoryProperties`: **[optional]** an object that functions exactly like the `directoryProperties`
  property on the [Package Extension](#package-extension), except that the directory properties are set when
  the [Package Rule](../JSON.md#package-rule) containing the extension is processed.
- `directoryPropertyChanges`: **[optional]** an array of [Property Changes](#property-change) that functions
  exactly like the `directoryPropertyChanges` property on the [Package Extension](#package-extension), except
  that the changes are applied when the [Package Rule](#package-rule) containing this extension is processed.
- `tests`: **[optional]** an array of [Tests](#test) that contains tests to be executed only when the
  conditions are met for the [Package Rule](../JSON.md#package-rule) containing this extension.
- `testResourceData`: **[conditionally required]** overrides the value of the `testResourceData` property on
  the [Package Extension](#package-extension) when the conditions are met for the [Package
  Rule](#package-rule) containing this extension.
- `testResourceMethod`: **[optional]** overrides the value of the `testResourceMethod` property on the
  [Package Extension](#package-extension) when the conditions are met for the [Package Rule](#package-rule)
  containing this extension.
- `variables`: **[optional]** an object that functions exactly like the `variables` property on the [Package
  Extension](#package-extension), except that the variables are set when the [Package
  Rule](../JSON.md#package-rule) containing the extension is processed.
- `variableChanges`: **[optional]** an array of [Variable Changes](#variable-change) that functions exactly
  like the `variableChanges` property on the [Package Extension](#package-extension), except that the changes
  are applied when the [Package Rule](#package-rule) containing this extension is processed.

### Project Extension

The data for the `cmake` extension in the `extended` property of a [Project](../JSON.md#project).

```json
{
    "directoryProperties" : {},
    "directoryPropertyChanges" : [],
    "globalProperties" : {},
    "testResourceSpecification" : {},
    "variables" : {},
    "variableChanges" : []
}
```

- `directoryProperties` : **[optional]** the [Directory
  Properties](https://cmake.org/cmake/help/latest/manual/cmake-properties.7.html#properties-on-directories)
  that will be set on the project source directory. Each key in this object is the name of a property and each
  value is a string that will be set as the value of the property. See the [Directory
  Properties](./Concepts.md#directory-properties) concept for details.
- `directoryPropertyChanges` : **[optional]** changes that will be made to inherited [Directory
  Properties](https://cmake.org/cmake/help/latest/manual/cmake-properties.7.html#properties-on-directories) on
  the project source directory. Each entry in this array is a [Property Change](#property-change) object and
  the changes are applied in the order they are specified in this array. See the [Directory
  Properties](./Concepts.md#directory-properties) concept for details.
- `globalProperties` : **[optional]** an object defining [Global
  Properties](https://cmake.org/cmake/help/latest/manual/cmake-properties.7.html#properties-of-global-scope),
  where the keys are the names of the properties and the values are boolean, number, or string values given to
  the properties. See the [Global Properties](./Concepts.md#global-properties) concept for details.
- `testResourceSpecification` : **[optional]** the [test resource
  specification](https://cmake.org/cmake/help/latest/manual/ctest.1.html#resource-specification-file) to be
  used by default for tests in this project. This may either be a string specifying the path to the file or it
  may be the resource specification. In either case, the JSON format is defined in the
  [specification](https://cmake.org/cmake/help/latest/manual/ctest.1.html#resource-specification-file).
- `variables` : **[optional]** the values of [CMake
  Variables](https://cmake.org/cmake/help/latest/manual/cmake-language.7.html#cmake-language-variables) set in
  the scope of the project. The keys are the names of the variables and the values are the strings defining
  the value of the variables in the scope of the project. See the [Variables](./Concepts.md) concept for
  details.
- `variableChanges` : **[optional]** an array of [Variable Change](#variable-change) objects that define
  modifications to values of variables in the scope of the project. These changes are applied in the order
  they are defined here before any packages are processed in the project.

### Project Rule Extension

The data for the `cmake` extension in the `extended` property of a [Project Rule](../JSON.md#project-rule).

```json
{
    "directoryProperties" : {},
    "directoryPropertyChanges" : [],
    "globalProperties" : {},
    "testResourceSpecification" : {},
    "variables" : {},
    "variableChanges" : []
}
```

- `directoryProperties` : **[optional]** the values of [directory
  properties](https://cmake.org/cmake/help/latest/manual/cmake-properties.7.html#properties-on-directories) to
  be set when the [Project Rule](../JSON.md#project-rule) condition is met. The keys are the names of
  properties and the values are the values to be set on the properties. The properties set here overwrite the
  properties set in the `directoryProperties` property on the [Project Extension](#project-extension) under
  the [Project](../JSON.md#project) containing the package rule. See the [Directory
  Properties](./Concepts.md#directory-properties) concepts for details.
- `directoryPropertyChanges` : **[optional]** an array of [Property Change](#property-change) objects defining
  changes that will be made to the values of [Directory
  Properties](https://cmake.org/cmake/help/latest/manual/cmake-properties.7.html#properties-on-directories).
  This is different from `directoryProperties` in that it allows augmenting the value of the property rather
  than simply overwriting it. These changes are applied after the values defined in `directoryProperties` are
  set. See the [Directory Properties](./Concepts.md#directory-properties) concept for details.
- `globalProperties` : **[optional]** an object modifying the value of [Global
  Properties](https://cmake.org/cmake/help/latest/manual/cmake-properties.7.html#properties-of-global-scope)
  that has the same behavior as the `globalProperties` property on the [Project
  Extension](#project-extension), except that these properties are set when the conditions are met of the
  [Project Rule](../JSON.md#project-rule) containing this extension.
- `testResourceSpecification` : **[optional]** overrides the `testResourceSpecification` property on the
  [Project Extension](#project-extension).
- `variables` : **[optional]** the [CMake
  Variables](https://cmake.org/cmake/help/latest/manual/cmake-language.7.html#cmake-language-variables) to be
  set if the containing [Project Rule](../JSON.md#project-rule) condition is met. The keys of this object are
  the names of the variables and the value is the variable value. The variable value is set in the scope of
  the Project. See the [Variables](./Concepts.md) concept for more details.
- `variableChanges` : **[optional]** an array of [Variable Change](#variable-change) objects defining changes
  to be applied to variables in the scope of the [Project](../JSON.md#project) should the containing [Project
  Rule](../JSON.md#project-rule) condition be met. This allows augmenting the value rather than simply
  overwriting it. See the [Variables](./Concepts.md#variables) concept for details.

### Property Change

An object describing a modification to the existing value of a [CMake
Property](https://cmake.org/cmake/help/latest/manual/cmake-properties.7.html#cmake-properties-7). See the
[Property Changes](./Concepts.md#property-changes) concept for details.

```json
{
    "match" : "",
    "name" : "",
    "oper" : "",
    "value" : ""
}
```

- `match` : **[conditionally required]** the regular expression used to match a string to replace. This is
  required if using the `oper` value of `regex`.
- `name` : **[required]** the name of the property being modified.
- `oper` : **[required]** the operation to perform on the property value.
  - `cmake_list_append` : the value of the property is treated as a [CMake
    List](https://cmake.org/cmake/help/latest/manual/cmake-language.7.html#cmake-language-lists) and the
    `value` is appended to that list (i.e. with the `;` separator).
  - `cmake_list_prepend` : the value of the property is treated as a [CMake
    List](https://cmake.org/cmake/help/latest/manual/cmake-language.7.html#cmake-language-lists) and the
    `value` is inserted at the beginning of that list (i.e. with the `;` separator).
  - `path_list_append` : the value of the property is treated as a list of file paths, separated with either
    `;` on Windows or `:` elsewhere, and the `value` is appaneded to that list.
  - `path_list_prepend` : the value of the property is treated as a list of file paths, separated with either
    `;` on windows or `:` elsewhere, and the `value` is inserted at the beginning of that list.
  - `reset` : the value of the property is reset to the inherited or default value. This is only applicable to
    [Directory](./Concepts.md#directory-properties), [Target](./Concepts.md#target-properties) and
    [Test](./Concepts.md#test-properties) properties.
  - `regex` : uses the regular expression in `match` to match areas of a string that will be replaced by the
    replacement expression in `value`. See the [string(REGEX REPLACE
    )](https://cmake.org/cmake/help/latest/command/string.html#regex-replace) command documentation for
    details on how this works.
  - `set` : the value of the property is set to `value`.
  - `string_append` : the value of the property is treated as a string and the `value` is appended to that
    string.
  - `string_prepend` : the value of the property is treated as a string and the `value` is inserted at the
    beginning of that string.
  - `unset` : the value of the property is unset (`value` is not used or required).
- `value` : **[conditionally required]** the value to use in modifying the property. How the value defined
  here is used, or whether it is used at all, is dependent on the value of `oper`.

### Source Rule

An object that enables defining
[properties](https://cmake.org/cmake/help/latest/manual/cmake-properties.7.html#properties-on-source-files) on
source files. See the [Source Properties](./Concepts.md#source-properties) concept for details.

```json
{
    "excludeRegex" : "",
    "includePattern" : "",
    "includeRegex" : "",
    "properties" : {},
    "propertyChanges" : []
}
```

- `excludeRegex` : **[optional]** a string or an array of strings defining one or more regular expressions
  used to determine the source files for which the rule will be applied. Any source files whose paths match
  any of these regular expressions are excluded from the rule.
- `includePattern` : **[optional]** a string or an array of strings defining [glob
  expressions](https://cmake.org/cmake/help/latest/command/file.html#glob-recurse) that are used to determine
  the files to which this rule will be applied. If this is omitted, all files defined in the list of sources
  for the [Module](../Concepts.md#module) are used.
- `includeRegex` : **[optional]** a string or an array of strings defining defining one or more regular
  expressions used to determine the source files for which the rule will be applied. Any source files in the
  original list from `includePattern` must match at least one of these expressions to be included in the list.
- `properties` : **[optional]** an object that sets the value of [Source
  Properties](https://cmake.org/cmake/help/latest/manual/cmake-properties.7.html#properties-on-source-files)
  on the matching source files, where the keys of this object are the names of the source properties and the
  values are the booelan, number, or string value to be used as the new value of the property.
- `propertyChanges` : **[optional]** an array of [Property Changes](#property-change) that modify the values
  of [Source
  Properties](https://cmake.org/cmake/help/latest/manual/cmake-properties.7.html#properties-on-source-files)
  on the matching source files. These changes are processed in the order they are listed.

Note that the filtering is applied in the following order: `includePattern`, `includeRegex`, and then
`excludeRegex`.

### Test

An object representing a [Test](./Concepts.md#tests).

```json
{
    "command" : [],
    "configurations" : [],
    "name" : "",
    "properties" : {},
    "propertyChanges" : [],
    "rules" : [],
}
```

- `command` : **[required]** an array of strings defining the command to be executed along with any arguments
  to that command. This array is passed to the
  [`add_test()`](https://cmake.org/cmake/help/latest/command/add_test.html) function in CMake as the`COMMAND`
  option.
- `configurations` : **[optional]** an array of strings defining the list of configurations for which to run
  the test. This array is passed to the
  [`add_test()`](https://cmake.org/cmake/help/latest/command/add_test.html) function in CMake as
  the`CONFIGURATIONS` option.
- `name` : **[required]** a string defining the name of the test. This name must be unique to the package.
  This string is passed to the [`add_test()`](https://cmake.org/cmake/help/latest/command/add_test.html)
  function in CMake as the`NAME` option.
- `properties` : **[optional]** an object that overrides the default values of properties on the test, where
  the key is the name of the [Test
  Property](https://cmake.org/cmake/help/latest/manual/cmake-properties.7.html#properties-on-tests) and the
  value is a boolean, number, or string specifying the value of the property.
- `propertyChanges` : **[optional]** a list of [Property Changes](#property-change) that modify the values of
  the [Properties](https://cmake.org/cmake/help/latest/manual/cmake-properties.7.html#properties-on-tests) on
  the test.
- `rules` : **[optional]** an array of [Test Rules](#test-rule) that apply to the test. This can be used to
  adjust most of the properties on the test under certain conditions. See the [Test Rules
  Concept](./Concepts.md#test-rules) for more information on the use of these.

### Test Rule

An object that modifies a [Test](#test) based on certain conditions. See the [Test
Rule](./Concepts.md#test-rules) for details.

```json
{
    "additionalArguments" : [],
    "command" : [],
    "condition" : {},
    "configurations" : [],
    "continue" : true,
    "properties" : [],
    "propertyChanges" : []
}
```

- `additionalArguments` : **[optional]** an array of additional arguments that are appended to the `command`
  specified on the [Test](#test) that contains this rule.
- `command` : **[optional]** overrides the `command` property on the [Test](#test) that contains this rule. If
  this is omitted, the `command` is unchanged by the rule.
- `condition` : **[optional]** the [Condition](../JSON.md#condition) under which this rule applies if the
  condition is true. If omitted, the rule is always applied.
- `configurations` : **[optional]** overrides the `conditions` property of the [Test](#test) that contains
  this rule.
- `continue` : **[optional]** if `false`, the rules in the `rules` property on the [Test](#test) that follow
  this rule are skipped. If omitted, the value is `true` and additional rules are also processed.
- `properties` : **[optional]** an object defining [CMake Test
  Properties](https://cmake.org/cmake/help/latest/manual/cmake-properties.7.html#properties-on-tests) on the
  [Test](#test) containing this rule that will be set when this rule's `condition` is met, where the keys are
  names of properties and values are boolean, number, or string values of the properties. These modifications
  are applied after the `properties` on the [Test](#test).
- `propertyChanges` : **[optional]** a list of [Property Changes](#property-change) that modify the [CMake Test
  Properties](https://cmake.org/cmake/help/latest/manual/cmake-properties.7.html#properties-on-tests) on the
  [Test](#test) containing this rule. These are in addition to the `propertyChanges` on the [Test](#test).

### Variable Change

An object describing a modification to the existing value of a [CMake
Variable](https://cmake.org/cmake/help/latest/manual/cmake-language.7.html#cmake-language-variables). See the
[Variable Changes](./Concepts.md#variable-changes) concept for details.

```json
{
    "match" : "",
    "name" : "",
    "oper" : "",
    "value" : ""
}
```

- `match` : **[conditionally required]** the regular expression used to match a string to replace. This is
  required if using the `oper` value of `regex`.
- `name` : **[required]** the name of the variable being modified.
- `oper` : **[required]** the operation to perform on the variable value.
  - `cmake_list_append` : the value of the variable is treated as a [CMake
    List](https://cmake.org/cmake/help/latest/manual/cmake-language.7.html#cmake-language-lists) and the
    `value` is appended to that list (i.e. with the `;` separator).
  - `cmake_list_prepend` : the value of the variable is treated as a [CMake
    List](https://cmake.org/cmake/help/latest/manual/cmake-language.7.html#cmake-language-lists) and the
    `value` is inserted at the beginning of that list (i.e. with the `;` separator).
  - `path_list_append` : the value of the variable is treated as a list of file paths, separated with either
    `;` on Windows or `:` elsewhere, and the `value` is appaneded to that list.
  - `path_list_prepend` : the value of the variable is treated as a list of file paths, separated with either
    `;` on windows or `:` elsewhere, and the `value` is inserted at the beginning of that list.
  - `regex` : uses the regular expression in `match` to match areas of a string that will be replaced by the
    replacement expression in `value`. See the [string(REGEX REPLACE
    )](https://cmake.org/cmake/help/latest/command/string.html#regex-replace) command documentation for
    details on how this works.
  - `set` : the value of the variable is set to `value`.
  - `string_append` : the value of the variable is treated as a string and the `value` is appended to that
    string.
  - `string_prepend` : the value of the variable is treated as a string and the `value` is inserted at the
    beginning of that string.
  - `unset` : the value of the variable is unset (`value` is not used or required).
- `value` : **[conditionally required]** the value to use in modifying the variable. How the value defined
  here is used, or whether it is used at all, is dependent on the value of `oper`.
