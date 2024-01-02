# Burt JSON Format <!-- omit in toc -->

## Table of Contents <!-- omit in toc -->

- [Files](#files)
  - [Fully Defined](#fully-defined)
  - [Project File](#project-file)
  - [Package File](#package-file)
  - [Module File](#module-file)
    - [Referenced From Project](#referenced-from-project)
    - [Referenced From Package](#referenced-from-package)
- [Reference](#reference)
  - [Command](#command)
  - [Command Argument](#command-argument)
  - [Command Example](#command-example)
  - [Command Example Option](#command-example-option)
  - [Command Option](#command-option)
  - [Command Option Enum Value](#command-option-enum-value)
  - [Condition](#condition)
  - [Configuration Option](#configuration-option)
  - [Contact](#contact)
  - [Extension](#extension)
  - [Function](#function)
  - [Function Parameter](#function-parameter)
  - [Help](#help)
  - [Help Section](#help-section)
  - [Hook](#hook)
  - [Module](#module)
  - [Module Dependency](#module-dependency)
    - [Module Dependency String](#module-dependency-string)
    - [Module Dependency Object](#module-dependency-object)
  - [Module Rule](#module-rule)
  - [Package](#package)
  - [Package Dependency](#package-dependency)
    - [Package Dependency String](#package-dependency-string)
    - [Package Dependency Object](#package-dependency-object)
  - [Package Rule](#package-rule)
  - [Profile Condition](#profile-condition)
  - [Project](#project)
  - [Project Rule](#project-rule)
  - [Repository](#repository)
    - [Repository String](#repository-string)
    - [Repository Object](#repository-object)

## Files

The `burt.json` file supplies information to Burt about a project. These `burt.json` files can be found in the
following places:

- [Project File](#project-file) : **[required]** For each [Project](./Concepts.md/#project), there is at least
  one `burt.json` in the root of the repository.
- [Package File](#package-file) : **[optional]** There may also be a `burt.json` in the root folder of each
[Package](./Concepts.md#package).
- [Module File](#module-file) : **[optional]** There may also be a `burt.json` in the root folder of each
  [Module](./Concepts.md#module).

### Fully Defined

### Project File

At the very least, there needs to be a file in the root of each repository using Burt that defines the
high-level information about the repository and the overall project dependencies. This file contains a
[Project](#project) object at its root.

### Package File

While [Packages](./Concepts.md#package) can be defined in the [Project File](#project-file), it is also
possible to define a [Package](./Concepts.md#package) with a file in the root directory of that package in the
repository, so long as the root of that package is not the same as the root of the repository. The root of
this file is a [Package](#package) object and contains the declaration for the
[Package](./Concepts.md#package). For this package to be seen by Burt, there needs to be a corresponding entry
in the `packages` array property of the [Project File](#project-file) that is a string defining the path to
the root of the package relative to the directory containing the [Project File](#project-file).

Suppose the location of the [Project File](#project-file) is `[repository-root]/burt.json` and the contents
are as follows (truncated for brevity):

```json
{
    "packages" : [
        "my/package"
    ]
}
```

The location of this file would be `[repository-root]/my/package/burt.json`.

### Module File

While [Modules](./Concepts.md#module) can be defined in the [Package File](#package-file) or [Project
File](#project-file), it is also possible to define a [Module](./Concepts#module) with a file in the root
directory of that module in the repository, so long as the root of that module is not the same as the root of
the repository or the root of the containing [Package](./Concepts#package). The root of this file is the
[Module](#module) object that defines the [Module](./Concepts.md#module).

For this module to be seen by Burt, there needs to be a corresponding entry in the `modules` array property of
the [Package](#package) in either a [Package File](#package-file) or [Project File](#project-file) that is a
string defining the path to the root of the module relative to the directory containing the file that declares
the [Package](#package) containing the module.

#### Referenced From Project

Suppose there is a [Project File](#project-file) located at the path `[repository-root]/burt.json` that
contains a [Package](#package) such as this:

```json
{
    "packages" : [
        {
            "path" : "my/package",
            "modules" : [
                "my/module"
            ]
        }
    ]
}
```

In this case, the [Module File](#module-file) would be located at the path
`[repository-root]/my/package/my/module/burt.json`.

It is also possible that the package is defined at the root of the [Project](./Concepts.md#project) with the
[Project File](#project-file) contents as follows:

```json
{
    "packages" : [
        {
            "modules" : [
                "my/module"
            ]
        }
    ]
}
```

In this case, the [Module File](#module-file) would be located at the path
`[repository-root]/my/module/burt.json`.

#### Referenced From Package

Suppose there is a [Package File](#package-file) located at the path `[repository-root]/my/package/burt.json`
with the following contents:

```json
{
    "modules" : [
        "my/module"
    ]
}
```

In this case, the [module File](#module-file) would be located at the path
`[repository-root]/my/package/my/module/burt.json`.

## Reference

### Command

Defines a [Command](./Concepts.md#extension-commands) provided by a [Burt
Extension](./Concepts.md#extensions), which amounts to a command added to the command line of Burt, such as
`burt <command>`. A command can either be a string, in which case it is an alias for another command, or it
may be an object, in which case the schema is as follows:

```json
{
    "args" : [],
    "briefHelp" : "",
    "examples" : [],
    "longHelp" : "",
    "options" : {}
}
```

- `args` : **[optional]** the list of [Arguments](#command-argument) to the command. If this is empty, the
  command does not have any arguments.
- `briefHelp` : **[required]** a brief one-line string to describe the command.
- `examples` : **[optional]** a list of [Examples](#command-example) of how the command is intended to be
  used. If empty, this section is omitted from the documentation.
- `longHelp` : **[optional]** a longer, complete description of the command. This is defined as [Help](#help),
  which may be a string or an array.
- `options` : **[optional]** the [Options](#command-option) that can be passed to the command. If this is
  empty, the command does not have any options. Each key in this object is the name of the option, which is
  used internally to refer to the value passed by the option from the command line, and each value of the
  object is an [Option](#command-option) object.

### Command Argument

Defines a [Positional Argument](./Concepts.md#arguments) to a command. This is either a string, in which case
it simply defines the name of the argument with all of the defaults, or it is an object to allow more precise
control. If this is an object, the schema is as follows:

```json
{
    "enumValues" : [],
    "help" : "",
    "multiple" : false,
    "optional" : false,
    "type" : "",
}
```

- `enumValues` : **[conditionally required]** if the `type` is `enum`, this is the list of potential values.
  Each entry in this array is a [Command Option Enum Value](#command-option-enum-value) object. This option is
  required if the `type` is `enum` and ignored any other time.
- `help` : **[required]** the [Help](#help) describing what the argument is used for.
- `multiple` : **[optional]** if `true`, it indicates that the argument can be repeated. If this is omitted,
  the argument is assumed to be `false` and not be allow the argument multiple times.
- `optional` : **[optional]** if `true`, it indicates that the argument is required for the command. If this
  is omitted, the argument is assumed to be `false`, meaning required by default.
- `type` : **[optional]** the type of value expected by the command line argument. The possible types are:
  - `enum` : an enumeration, in which case the possible values are defined in the `values` property
  - `integer` : a whole number
  - `number` : a floating point number, with or without the decimal
  - `string` : **(default)** any sequence of characters

### Command Example

Defines an example of how a command is to be used. This is then used for help documentation and to
automatically generate user interface for wizards. The schema for this object is as follows:

```json
{
    "name" : "",
    "help" : "",
    "multiArgCount" : -1,
    "options" : {}
}
```

- `name` : **[required]** the name of the example, which must be unique among the other examples for the same
  command.
- `help` : **[required]** the help describing how to use the example. This is a [Help](#help), which may be an
  array or a string.
- `multiArgCount` : **[optional]** the number of arguments expected when the last positional argument can be
  specified multiple times. If this is negative, the example shows and wizards allow any number of these. This
  is only used if the `multiple` property is `true` on one of the [Arguments](#command-argument) on a command.
- `options` : **[option]** the list of options used in the example. Each key in this object is the name of the
  option, as defined in the keys of the `options` property on the [Command](#command), and each value is a
  [Command Example Option](#command-example-option).

### Command Example Option

An option that is defined in a [Command Example](#command-example). This can either be the default value of
the option (as a string) or it can be an object. For no default, simply use `{}`. The schema for this object
is as follows:

```json
{
    "defaultValue" : "",
    "quantity" : 1
}
```

- `defaultValue` : **[optional]** the default value used to display the option in help text and as the default
  value in generated wizard UI. If omitted, there is no default value.
- `quantity` : **[optional]** the number of the option to be specified in the example. By default, this is -1,
  which effectively means the option is specified limitless times.

### Command Option

A command line option for a command. This specifies a `-a` or `--arg` command line switch that can be passed
to the command. The schema for this object is as follows:

```json
{
    "enumValues" : [],
    "help" : "",
    "longSwitch" : "",
    "multiple" : false,
    "required" : false,
    "shortSwitch" : "",
    "type" : ""
}
```

- `enumValues` : **[conditionally required]** the values that can be specified when an option has a `type` of
  `enum`. If the `type` is `enum`, this option is required, otherwise it is ignored.
- `help` : **[required]** the [Help](#help) describing the option.
- `longSwitch` : **[optional]** this may be a string or an array of strings of at least 2 characters in length
  defining the long form of the command line switch (and aliases), i.e. `--xx`. The first of these such
  switches is considered the "main" switch and is used as such in help documentation, and the remainders are
  considered aliases. If this is empty, there must be at least one `shortSwitch`.
- `multiple` : **[optional]** if `true`, the option can be specified multiple times. If omitted, the default
  value is `false`, meaning the option is only specified once on the command line.
- `required` : **[optional]** if `true`, the option will be required each time the command is invoked. If
  omitted, the default value is `false`, meaning the option is optional.
- `shortSwitch` : **[optional]** this may be a string or an array of strings of exactly 1 character in length
  defining the short form of the command line switch (and aliases), i.e. `-x`. The first of these such
  switches is considered the "main" switch and is used as such in help documentation, and the remainders are
  considered aliases. If this is empty, there must be at least one `longSwitch`.
- `type` : **[optional]** the type of the switch, which may be one of the following:
  - `enum` : the type is an enumeration, where the possible values are defined in the `enumValues` property
  - `integer` : the option expects a whole number
  - `number` : the option expects a floating point number
  - `string` : **(default)** the option allows any string to be specified

### Command Option Enum Value

Defines an enumeration for a [Command Argument](#command-argument) or [Command Option](#command-option), which
is an enumeration that can be passed in via the command line. The schema for this object is as follows:

```json
{
    "help" : "",
    "value" : ""
}
```

- `help` : **[required]** the [Help](#help) describing the enumeration option.
- `value` : **[required]** the string that will be accepted for the argument or option.

### Condition

A condition is used to determine when to apply [Rules](./Concepts.md#rules). This allows rudimentary logic
that is akin to [Schema Composition](https://json-schema.org/understanding-json-schema/reference/combining) in
the JSON Schema specification.

```json
{
    "allOf" : [],
    "anyOf" : [],
    "hostProfile" : {},
    "not" : [],
    "oneOf" : [],
    "targetProfile" : {}
}
```

- `allOf` : **[optional]** an array of [Conditions](#condition) that must all be met for this condition to be
  considered met, equivalent to a logical `AND`. If empty or omitted, it is ignored in the condition.
- `anyOf` : **[optional]** an array of [Conditions](#condition) where at least one of them must be met for
  this condition to be considered met, equivalent to a logical `OR`. If empty, it is ignored in the condition.
- `hostProfile` : **[optional]** a [Profile Condition](#profile-condition) applied to the environment in which
  Burt itself is being executed. If empty or omitted, all environments meet the condition.
- `not` : **[optional]** a [Condition](#condition) that is considered to be the opposite of its result,
  equivalent to a logical `NOT`. If omitted, it is ignored in the condition.
- `oneOf`: **[optional]** an array of [Conditions](#condition) where exactly one of them must be met in order
  for this condition to be considered met, equivalent to a logical `XOR`. If empty or omitted, it is ignored
  in this condition.
- `targetProfile`: **[optional]** a [Profile Condition](#profile-condition) applied to the environment for
  which the code is being built for.

### Configuration Option

Defines a [Configuration Option](./Concepts.md#extension-configuration-options) that can be used to configure
an [Extension](#extension).

```json
{
    "briefHelp" : "",
    "context" : "",
    "itemOption" : {},
    "longHelp" : "",
    "options" : {},
    "type" : ""
}
```

- `briefHelp` : **[required]** the help text displayed in listing of many options. Should be no longer than
  one line.
- `context` : **[optional]** the context where the option is relevant, which may be:
  - `both` : **(default)** the option can be applied both locally and globally
  - `global` : the option can be applied globally
  - `local` : the option can be applied locally
- `itemOption` : **[conditionally required]** the [Configuration Option](#configuration-option) contained
  within an option whose `type` is `array` or `object`. This is required if the `type` is `array` or `object`.
- `longHelp` : **[optional]** the detailed [Help](#help) that describes how the option works and how it is to
  be used.
- `options` : **[optional]** a recursive definition of options within the option if the `type` is `group`.
- `type` : **[optional]** the type of data expected to be specified in the option, which may be:
  - `array` : an array of [Configuration Options](#configuration-option), where the option is specified in
    `itemOption`
  - `boolean` : a `true` or `false` value
  - `group` : a container of [Configuration Options](#configuration-option), used to define options
    recursively
  - `integer` : an whole number value
  - `object` : a key-value pair, where the key is a string and the value is an [Configuration
    Option](#configuration-option), as specified in `itemOption`
  - `string` : **(default)** a string value

### Contact

A reference to a person. This may be a string or an object as defined below. If this is a string, the format
of the string is as follows: `name <email> (url)`, where `name`, is required, but `<email>`, and `(url)` are
optional (including brackets `<>` and parentheses `()`). The following are legal string examples:

- `John Doe`
- `John Doe <john@doe.com>`
- `John Doe (http://johndoe.com)`
- `John Doe <john@doe.com> (http://johndoe.com)`.

If this is an object, it should look like this:

```json
{
    "email" : "",
    "name" : "",
    "url" : ""
}
```

The properties of this object are as follows:

- `email` : **[optional]** the email contact for the person.
- `name` : **[required]** the name of the person.
- `url` : **[optional]** a URL where the person's public profile can be found.

> ⓘ Note:
>
> This is essentially the same as the [corresponding
> entry](https://docs.npmjs.com/cli/v10/configuring-npm/package-json#people-fields-author-contributors) in
> `package.json` used by NPM.

### Extension

This object defines an extension to Burt itself. There are a number of ways a package can [Extend
Burt](./Concepts.md#extensions), which are defined here on this object.

```json
{
    "commands" : {},
    "functions" : {},
    "hooks" : [],
    "options" : {},
    "schemas" : {}
}
```

- `commands` : **[optional]** the [Commands](./Concepts.md#extension-commands) provided by this extension.
  Each key in this object is the name of the command, as it will be typed on the command line, and the value
  is a [Command](#command) object.
- `functions` : **[optional]** the [Functions](./Concepts.md#extension-functions) provided by this extension.
  Each key in this object is the name of a function that can be called, as it will be executed, and the value
  is a [Function](#function) object.
- `hooks` : **[optional]** the [Hooks](./Concepts.md#extension-hooks) provided by this extension. Each entry
  in this array is a [Hook](#hook) object.
- `options` : **[optional]** the [Options](./Concepts.md#extension-options) provided by this extension. Each
  key in this object is the name of the option as it will be passed on the command line or defined in the
  options file and each value is an [Configuration Option](#configuration-option) object.
- `schemas` : **[optional]** an object where each value is a [JSON Schema](./Concepts.md#extension-schemas)
  and each key is one of the following:
  - `module` : the schema defined at this key is for the data stored in the `extended` property on a
    [Module](#module) object belonging to this extension.
  - `package` : the schema defined at this key is for the data stored in the `extended` property on a
    [Package](#package) object belonging to this extension.
  - `project` : the schema defined at this key is for the data stored in the `extended` property on a
    [Project](#project) object belonging to this extension.

### Function

This object defines a function exposed by an [Extension](#extension). See the documentation for
[Functions](./Concepts.md#extension-functions) for more detail.

```json
{
    "args" : [],
    "help" : "",
    "pipe" : false,
    "return" : {},
}
```

- `args` : **[optional]** the list of arguments as [Function Parameter](#function-parameter) to pass to the
  function. If empty, the function will ignore any arguments passed to it. If this function is defined with
  `pipe` being `true`, the first argument must have the same type as the `return`.
- `help` : **[required]** the [Help](#help) explaining the purpose of the function and how to use it.
- `pipe` : **[optional]** if `true`, the function can be extended by pipe (see the documentation for
  [Functions](./Concepts.md#extension-functions) for more detail). If omitted, the default value is `false`,
  meaning the function is not extendable by a pipe. If this is `true`, the `args` must contain the same type
  as `return` for the first argument.
- `return` : **[optional]** the [Function Parameter](#function-parameter) serving as the return type of the
  function. If this is omitted, the function returns nothing (equivalent to `void`).

### Function Parameter

Defines a parameter to be passed to a function as an argument or returned from a function.

```json
{
    "help" : "",
    "schema" : ""
}
```

- `help` : **[required]** the [Help](#help) explaining the purpose of the parameter and how to use it.
- `schema` : **[optional]** the [JSON schema](https://json-schema.org/) defining the requirements for the
  parameter. If this is not specified, it is assumed to allow any type of argument, and relies heavily on the
  documentation in `help` to explain what this is. It is strongly recommended to specify a schema. This may be
  a string containing the schema or a path to the file containing the schema definition, which is a path
  relative to the file containing the function definition.

### Help

A specification of help documentation accompanying any number of constructs in a JSON file. This documentation
can be a string or an array type. If it is an array type, the contents of the array can be either a string or
a [Help Section](#help-section), and can be any mixture thereof. It is possible to nest [Help
Sections](#help-section) up to 2 times. Separate strings are treated as separate paragraphs, so there is no
need to embed '\n' in the strings, specifying an array of strings will do the trick.

### Help Section

A specification of a section in [Help](#help).

```json
{
    "help" : "",
    "indent" : false,
    "title" : ""
}
```

- `help` : **[required]** a [Help](#help) representing the contents of the section.
- `indent` : **[optional]** if `true`, the section is indented. If this is omitted, it is `false` by default
  and the section is not indented.
- `title` : **[optional]** the title for the section. If this is omitted or empty, it can be used to simply
  indent a section of help documentation.

### Hook

Defines a [Hook](./Concepts.md#extension-hooks) in an [Extension](#extension).

```json
{
    "after" : [],
    "before" : [],
    "callback" : "",
    "extension" : "",
    "function" : "",
    "type" : ""
}
```

- `after` : **[optional]** the list of names of plugins whose hooks should be processed before this one. This
  can be helpful to force certain ordering in execution. Note that cyclic definitions like this will result in
  undefined behavior, so it should really be used sparingly.
- `before` : **[optional]** the list of names of plugins whose hooks should be processed after this one. This
  can be helpful to force certain ordering in execution. Note that cyclic definitions like this will result in
  undefined behavior, so it should really be used sparingly.
- `callback` : **[required]** the name of the callback function to be called when the hook is triggered.
- `extension` : **[required]** the name of the package providing the [Extension](#extension) containing the
  `function`.
- `function` : **[required]** the name of the function on the given `extension` that triggers the hook.
- `type` : **[required]** the type of hook, which may be one of the following:
  - `pipe` : the hook is called with the return type of the `function` as the first argument with the
    remaining arguments being the same as the original call to the `function`. This hook is triggered in
    series with all other hooks. The `function` is called first, then the return of that function is piped
    into the first argument of the first hook, and each subsequent hook is passed the return of the previous
    hook as the first argument.
  - `post` : the hook is called after the `function` is called. Such a hook is passed the same arguments as
    the `function` that will be called.
  - `pre` : the hook is called prior to the `function` being called. Such a hook is passed the same arguments
    as the `function` that will be called.

### Module

[Modules](./Concepts.md#module) represent individual components containing functionality provided by a
[package](./Concepts.md#package). Modules are generally not required to be defined in a [package
declaration](#package), but doing so will make it easier or sometimes even eliminate the need to define the
module using a corresponding build system like CMake. See documentation for the [Module](./Concepts.md#module)
concept for more details.

There are two different kinds of modules supported by Burt: executables and libraries. The following are two
examples showing the appropriate properties for each of these types of modules:

```json
{
    "type" : "executable",
    "buildCondition" : {},
    "bundle" : false,
    "dependencies" : [],
    "deploy" : true,
    "export" : false,
    "name" : "",
    "privateHeaderDirs" : [],
    "rules" : [],
    "sources" : [],
    "sourceDirs" : [],
    "sourceExcludes" : [],
    "sourceGlobs" : [],
    "stores" : []
}
```

```json
{
    "type" : "library",
    "buildCondition" : {},
    "bundle" : false,
    "dependencies" : [],
    "deploy" : true,
    "export" : false,
    "libraryType" : "",
    "name" : "",
    "privateHeaderDirs" : [],
    "publicHeaderDirs" : [],
    "publicHeaderExcludes" : [],
    "publicHeaderGlobs" : [],
    "rules" : [],
    "sources" : [],
    "sourceDirs" : [],
    "sourceExcludes" : [],
    "sourceGlobs" : [],
}
```

- `bundle` : **[optional]** indicates whether or not the target will produce a
  [bundle](./Concepts.md#bundle). This is `true` by default when the `type` is library and `false` by default
  when the `type` is `executable`. This property can be overridden by the [Module Rules](#module-rule) defined
  in the `rules` property.
- `buildCondition` : **[optional]** the [Condition](#condition) under which the module will be built. If
  omitted, the module will always be built when the containing [Package](#package) is built.
- `dependencies` : **[optional]** the array of [dependencies](./Concepts.md#module-dependencies) this module
  has on other modules or library files. Each item in the array is a [Module Dependency](#module-dependency),
  which may be a string or an object for more refined behavior. This property can be appended by the [Module
  Rules](#module-rule) defined in the `rules` property.
- `deploy` : **[optional]** indicates whether or not the target will be [deployed](./Concepts.md#deploy). If
  this option is omitted, the default value is `true` when `type` is `executable` or `type` is `library` and
  `libraryType` is `module`. This property can be overridden by the [Module Rules](#module-rule) defined in
  the `rules` property.
- `export` : **[optional]** indicates whether or not the target will be [exported](./Concepts.md#exported)
  to the package produced by the containing package declaration. This is `true` by default when the `type` is
  `library` and `false` by default when the `type` is `executable`. This property can be overridden by the
  [Module Rules](#module-rule) defined in the `rules` property.
- `name` : **[optional]** the name of the module. If this is omitted, the name of the root directory of the
  module is used as the name of the module. For example, if the module is located at `path/to/MyModule`, the
  name of the module would be `MyModule`.
- `privateHeaderDirs` : **[optional]** the list of directories that contain header files to be included within
  the module itself. For libraries, these header files are not exported to the package and cannot be used by
  dependency modules. These paths are relative to the root of the module. This property can be appended by
  the [Module Rules](#module-rule) defined in the `rules` property.
- `rules` : **[optional]** an array of [Module Rules](#module-rule) that apply to the module. THis can be used
  to adjust most of the properties on the module under certain conditions. See the [Module
  Rules](./Concepts.md#module-rules) for more information on the use of these.
- `sources` : **[optional]** the list of relative paths to [source files](./Concepts.md#module-sources) that
  will be built with the module. By default, this list is empty and the module will only be built with files
  included with the `sourceDirs` option. These paths are relative to the root directory of the module. This
  property can be appended by the [Module Rules](#module-rule) defined in the `rules` property.
- `sourceDirs` : **[optional]** the list of relative paths to directories containing [source
  files](./Concepts.md#module-sources). This defaults to a directory named `src`. These paths are relative to
  the root directory of the module. This property can be appended by the [Module Rules](#module-rule) defined
  in the `rules` property.
- `sourceExcludes` : **[optional]** the list of patterns that will exclude [source
  files](./Concepts.md#module-sources) located in the `sourceDirs` from being included in the list of source
  files for the module. If this list is omitted or empty, all files are included. If the `sourceGlobs` is
  defined and this option is also defined, the `sourceGlobs` applies first, then the files that match the
  `sourceGlobs` are filtered by this file. These patterns are regular expressions. This property can be
  appended by the [Module Rules](#module-rule) defined in the `rules` property.
- `sourceGlobs` : **[optional]** the list of glob patterns that will be used to filter [source
  files](./Concepts.md#module-sources) in `sourceDirs`. If this list is empty or omitted, all files found in
  the `sourceDirs` are included in the list of sources. If the `sourceExcludes` is also defined, it further
  filters the files that successfully match one of these patterns. These patterns are glob patterns, such as
  `*.cpp`. This property can be appended by the [Module Rules](#module-rule) defined in the `rules` property.
- `type` : **[required]** the type of the module. This can be one of the following:
  - `executable` : the module will be an executable (exe, app bundle, etc.)
  - `library` : **(default)** the module will be a library (shared, static, framework, etc.)
  This property can be overridden by the [Module Rules](#module-rule) defined in the `rules` property.

These properties only apply to modules with `type` equal to `executable`:

- `stores` : **[optional]** the list of [app stores](./Concepts.md#app-store) that will be supported by the
  executable. The following possible values can be used:
  - `amazon` : the app will be signed and prepared for the Amazon app store for Android.
    <!-- cspell: disable-next-line -->
  - `google-play` : the app will be signed and prepared for the Google play store for Android.
  - `ios` : the app will be signed and prepared for the Apple store for iOS apps. This involves signing the
    app with the appropriate developer keys, etc.
  - `macos` : the app will be signed and prepared for the MacOS app store.
  - `windows` : the app will be signed and prepared for the Windows app store.
  This property can be overridden by the [Module Rules](#module-rule) defined in the `rules` property.

These properties only apply to modules with `type` equal to `library`:

- `libraryType` : **[optional]** the type of library. This can be one of the following:
  - `combined` : **(default)** the module will produce both a shared and static library for use by the
    consumer as it sees fit. This is the default behavior. This is equivalent to defining an `OBJECT` module
    with CMake's [`add_library()`
    command](https://cmake.org/cmake/help/v3.8/command/add_library.html#normal-libraries) and then adding two
    additional libraries using those objects with `STATIC` and `SHARED`. <!-- cspell: disable-next-line -->
  - `dynamic` : the library will be a dynamically loaded library that can be loaded with "dlopen"-like
    functionality, which is equivalent to passing `MODULE` to CMake's
    [`add_library()` command](https://cmake.org/cmake/help/v3.8/command/add_library.html#normal-libraries).
  - `header` : the library does not produce any binary code and only provides headers or declarative
    functionality, which is equivalent to passing `INTERFACE` to CMake's
    [`add_library()` command](https://cmake.org/cmake/help/v3.8/command/add_library.html#normal-libraries).
  - `shared` : the library will be a shared library, equivalent to passing `SHARED` to CMake's
    [`add_library()` command](https://cmake.org/cmake/help/v3.8/command/add_library.html#normal-libraries).
  - `static` : the library will be a static library, equivalent to passing `STATIC` to CMake's
    [`add_library()` command](https://cmake.org/cmake/help/v3.8/command/add_library.html#normal-libraries).
  This property can be overridden by the [Module Rules](#module-rule) defined in the `rules` property.
- `publicHeaderDirs` : **[optional]** the list of directories containing header files that will be made
  available to dependency modules and exported to the package. This option is not relevant for the
  `libraryType` of value `module`. These paths are relative to the root of the module. This property can be
  appended by the [Module Rules](#module-rule) defined in the `rules` property.
- `publicHeaderExcludes` : **[optional]** the list of patterns to exclude public headers from the package.
  This behaves in the same manner as `sourceExcludes` except that it is used to filter out header files that
  will be included in the package. Each item in this array is a regular expression. This property can be
  appended by the [Module Rules](#module-rule) defined in the `rules` property.
- `publicHeaderGlobs` : **[optional]** the list of glob patterns that will be used to filter the header files
  found in `publicHeaderDirs` from the list of header files exported to the package. If this is empty or
  omitted, it defaults to `["*.h", "*.hpp", "*.hh", "*.hxx", "*.H", "*.h++"]`. This property can be appended
  by the [Module Rules](#module-rule) defined in the `rules` property.

### Module Dependency

A Module Dependency allows the declaration of [dependencies between
modules](./Concepts.md#module-dependencies) that facilitate building, linking, or deploying modules. This may
be expressed as a string or as an object.

#### Module Dependency String

When expressed as a string, the module dependency can have the following format:

- `<module-name>` : the entire string is the name of a module in the current package.
- `<package-name>::<module-name>` : the dependency is a module named `<module-name>` in the package named
  `<package-name>`.
- `<library-path>` : the path to a library file that should be linked against. This can be a relative path to
  the library file relative to the root of a package that contains it. It may also simply be the filename of a
  library that should be linked, as is the case when using API from the operating system.

When specifying a string, it is not much different than specifying an [object](#module-dependency-object) with
the `name` property and accepting all other properties as defaults.

#### Module Dependency Object

```json
{
    "deploy" : true,
    "link" : true,
    "name" : "",
    "package" : "",
    "transitive" : true
}
```

- `deploy` : **[optional]**`true` if the dependency should be deployed. This is ignored for static library
  dependencies and `true` by default for all others.
- `link` : **[optional]** `true` if the dependency is a link-time dependency. This is ignored for `library`
  modules that are `header` type, since there is nothing to link against, and `true` by default for all
  others.
- `name` : **[required]** a [Module Dependency String](#module-dependency-string) that defines the library
  upon which there is a dependency.
- `package` : **[optional]** the package that contains the module. If this is omitted, the module is either
  specified in `name` using its fully qualified `<package-name>::<module-name>` format, the module is a part
  of the [Package](#package) defining the module that has the dependency, or it is a library file.
- `transitive` : **[optional]** `true` if the dependency is transitive and inherited by dependents of this
  module. This is `true` by default for all dependencies.

### Module Rule

A [Module Rule](#module-rule) provides a mechanism to alter some of the properties of a [Module](#module)
based on certain conditions. See the [Module Rule Concept](./Concepts.md#module-rules) for further explanation
of this feature.

```json
{
    "bundle" : true,
    "condition" : {},
    "continue" : true,
    "dependencies" : [],
    "deploy" : true,
    "export" : false,
    "libraryType" : "",
    "privateHeaderDirs" : [],
    "publicHeaderDirs" : [],
    "publicHeaderExcludes" : [],
    "publicHeaderGlobs" : [],
    "sources" : [],
    "sourceDirs" : [],
    "sourceExcludes" : [],
    "sourceGlobs" : [],
    "stores" : [],
    "type" : ""
}
```

- `bundle` : **[optional]** if specified, overrides the value of the `bundle` property on the containing
  [Module](#module) and modifications by any previously applied rules. If omitted, the `bundle` property is
  not modified.
- `condition` : **[optional]** the [Condition](#condition) under which the rule will be applied. If this is
  omitted, the rule is always applied.
- `continue` : **[optional]** if the `condition` matches and this is `false`, processing will not continue to
  the next rule. If this is `true` (the default), processing will always continue to the next rule.
- `dependencies` : **[optional]** appends [Module Dependencies](#module-dependency) to the `dependencies`
  defined on the containing  [Module](#module) and modifications by any previously applied rules. If this is
  omitted, no changes are made to the `dependencies` property.
- `deploy` : **[optional]** if specified overrides the value of the `deploy` property on the containing
  [Module](#module) and modifications from previously applied rules. If omitted, the `deploy` property is not
  modified.
- `export` : **[optional]** if specified, overrides the value of the `export` property on the containing
  [Module](#module) and modifications from previously applied rules. If omitted, the `export` property is not
  modified.
- `libraryType` : **[optional]** if specified, overrides the value of the `libraryType` property on the
  containing [Module](#module). Note that this property is ignored if the final resulting `type` property on
  the [Module](#module) after all rules are processed is not `library`.
- `privateHeaderDirs` : **[optional]** if specified, all entries in this array are appended to the
  `privateHeaderDirs` property on the containing [Module](#module) after the modifications by previous rules.
  If this is omitted, the `privateHeaderDirs` property is not modified by this rule.
- `publicHeaderDirs` : **[optional]** if specified, all entries in this array are appended to the
  `publicHeaderDirs` property on the containing [Module](#module) after the modifications by previous rules.
  If this is omitted, the `publicHeaderDirs` property is not modified by this rule. Note that this property is
  ignored if the final resulting `type` property on the [Module](#module) after all rules are processed is not
  `library`.
- `publicHeaderExcludes` : **[optional]** if specified, all entries in this array are appended to the
  `publicHeaderExcludes` property on the containing [Module](#module) after the modifications by previous
  rules. If this is omitted, the `publicHeaderExcludes` property is not modified by this rule. Note that this
  property is ignored if the final resulting `type` property on the [Module](#module) after all rules are
  processed is not `library`.
- `publicHeaderGlobs` : **[optional]** if specified, all entries in this array are appended to the
  `publicHeaderGlobs` property on the containing [Module](#module) after the modifications by previous rules.
  If this is omitted, the `publicHeaderGlobs` property is not modified by this rule. Note that this property
  is ignored if the final resulting `type` property on the [Module](#module) after all rules are processed is
  not `library`.
- `sources` : **[optional]**  if specified, all entries in this array are appended to the `sources` property
  on the containing [Module](#module) after the modifications by previous rules. If this is omitted, the
  `sources` property is not modified by this rule.
- `sourceDirs` : **[optional]** if specified, all entries in this array are appended to the `sourceDirs`
  property on the containing [Module](#module) after the modifications by previous rules. If this is omitted,
  the `sourceDirs` property is not modified by this rule.
- `sourceExcludes` : **[optional]** if specified, all entries in this array are appended to the
  `sourceExcludes` property on the containing [Module](#module) after the modifications by previous rules. If
  this is omitted, the `sourceExcludes` property is not modified by this rule.
- `sourceGlobs` : **[optional]** if specified, all entries in this array are appended to the `sourceGlobs`
  property on the containing [Module](#module) after the modifications by previous rules. If this is omitted,
  the `sourceGlobs` property is not modified by this rule.
- `stores` : **[optional]** if specified, all entries in this array are appended to the `stores` property on
  the containing [Module](#module) after the modifications by previous rules. If this is omitted, the `stores`
  property is not modified by this rule. Note that this property is ignored if the final resulting `type`
  property on the [Module](#module) after all rules are processed is not `executable`.
- `type` : **[optional]** if specified, overrides the `type` property on the containing [Module](#module)
  after modifications from previous rules. If this is omitted, the `type` property is not overridden by this
  rule.

### Package

Defines a [Package](./Concepts.md#package) either in a [Project](#project) or as a [Package
File](#package-file).

```json
{
    "author" : {},
    "buildCondition" : {},
    "contributors" : [], 
    "dependencies" : {},
    "devDependencies" : {},
    "description" : "",
    "extended" : {},
    "extension" : {},
    "homepage" : "",
    "imported" : false,
    "keywords" : [],
    "license" : "",
    "modules" : [],
    "name" : "",
    "path" : "",
    "providers" : "",
    "rules" : [],
    "toolDependencies" : {},
    "version" : ""
}
```

- `author` : **[optional]** the principal author of the package. This is a [Contact](#contact). While the
  `author` is not required, it is recommended for packages being advertized for use by others. If this is
  omitted, the author on the containing [Project](#project), if there is one.
- `buildCondition` : **[optional]** the [Condition](#condition) under which this package will be built. If
  this is omitted, the package will always be available to build.
- `contributors` : **[optional]** the list of contributors and maintainers of the package. The entries in this
  list are [Contact](#contact) objects. If this is omitted, the list of contributors specified on the
  containing [Project](#project) is used.
- `dependencies` : **[optional]** the list of [dependencies](./Concepts.md#package-dependencies) this package
  has on other packages. These dependencies are inherited by packages that depend on this package,
  constructing a dependency graph. The keys in this object are the names of packages and each value is a
  [Package Dependency](#package-dependency) object or string. Do not put tools, such as test harnesses,
  compilers, etc. into this collection since they are not dependencies to be inherited, put them into
  `devDependencies` instead. This property can be appended by the [Package Rules](#package-rule) defined in
  the `rules` property.
- `devDependencies` : **[optional]** the list of developer dependencies this package has on other packages.
  These dependencies are only installed for developers actively building this package and will not be
  inherited by downstream packages depending on this package. This object is very similar to the
  `dependencies` object, where each key in this object is the name of the package and each value is the
  [Package Dependency](#package-dependency) object or string. This property can be appended by the [Package
  Rules](#package-rule) defined in the `rules` property.
- `description` : **[optional]** a long description of the package. This is not required, but strongly
  suggested since it will be used in package listings and for searching.
- `extended` : **[optional]** an object whose keys are the names of [Extensions](./Concepts.md#extensions) and
  the values are data supplied to that extension in the context of this package. The schema of this object
  depends on this #################################################
- `extension` : **[optional]** an [Extension](#extension) object that declares the extensions to Burt
  contained in the package. If this is omitted, the package is not treated as a Burt extension.
- `homepage` : **[optional]** the URL to the homepage for the package (note: not the git repository, since
  that is defined on the [Project File](#project-file)). If this is omitted, the homepage defined on the
  containing [Project](#project) is used.
- `imported` : **[optional]** if `true`, the package is not built and is assumed to already have binaries
  available. This is `false` by default.
- `keywords` : **[optional]** an array of any number of keyword strings used to categorize the package.
- `license` : **[optional]** the [SPDX identifier](https://spdx.org/licenses/) string defining the license or
  a relative path to the file containing the license for the package, which is relative to the file containing
  this package declaration. If this is omitted, either a file named `LICENSE` or `LICENSE.md` is used, if it
  exists, or the license is inherited from the containing [Project](#project).
- `modules` : **[optional]** the list of [module](./Concepts.md#module)s defined in the package. The values in
  this array are either [Module](#module) objects or paths to directories relative to the file containing this
  package declaration that contain a [Module File](#module-file).
- `name` : **[required]** the name of the package. This must be globally unique in all of the [package
  providers](./Concepts.md#package-providers) that this package gets published to.
- `path` : **[optional]** the path to the directory containing the source code for the package. If this is a
  relative path, it is relative to the root of the repository. If omitted, the path defaults to a relative
  path to the directory containing the `burt.json` file that declared the package. Note that using absolute
  paths will likely prevent the package and code from being useful for other projects.
- `rules` : **[optional]** [conditional rules](./Concepts.md#package-rules) applied to the package.
  Each one of the entries in this array are [Package Rule](#package-rule) objects.
- `toolDependencies` : **[optional]** the list of [Tool Dependencies](./Concepts.md#tool-dependencies) the
  package has. Much like `dependencies`, the keys in this object are the names of the packages and the values
  are [Package Dependencies](#package-dependency).
- `version` : **[required]** the version of the package. This must either be a [Semantic
  Version](https://semver.org) or it must be a version of the form `x.y`, where the patch number will be
  computed automatically to complete the Semantic Version.

### Package Dependency

A [Dependency](./Concepts.md#package-dependencies) is used to specify relationships to packages that contain
tools, link targets, etc. One such entry may either be a string or an object.

#### Package Dependency String

In string form, it is specifying just the version of the package and all default behavior is being used to
find the package. The format of the string itself follows the exact specification of
[node-semver](https://github.com/npm/node-semver/blob/v7.5.4/README.md). Some examples are:

- `2.3.4`, `v2.3.4`, `=2.3.4` : matches exactly version `2.3.4`
- `>2.3.4` : matches any version greater than `2.3.4`, such as `2.3.4`, `2.4.0`, and `3.0.1`
- `>=2.3.4` : matches any version greater than or equal to `2.3.4`, such as `2.3.4`, `2.3.5`, `2.4.0`, and
  `3.0.1`
- `<2.3.4` : matches any version less than `2.3.4`, such as `2.3.3`, `2.2.0`, and `1.0.1`
- `<=2.3.4` : matches any version less than or equal to `2.3.4`, such as `2.3.4`, `2.3.3`, `2.2.0`, and
  `1.0.1
- `~2.3.4` : matches any patch version greater than or equal to `2.3.4`, such as `2.3.4`, `2.3.5`, but not
  `2.4.0`
- `^2.3.4` : matches any major and minor version greater than or equal to `2.3.4`, such as `2.3.5` and
  `2.4.0`, but not `3.0.0`

See the the [node-semver README](https://github.com/npm/node-semver/blob/v7.5.4/README.md) for more examples
and an exhaustive list of supported behavior.

#### Package Dependency Object

For more precise control over what version of the package to use or what source to acquire the package from,
an object can be specified whose schema is as follows:

```json
{
    "branch" : "",
    "branchType" : "",
    "optional" : false,
    "path" : "",
    "version" : ""
}
```

- `branch` : **[conditionally required]** the branch for which to retrieve the package of the given version.
  This is required for `branchType` of `internal` or `feature` in order to determine which branch it is for.
- `branchType` : **[optional]** a designation for the type of branch from which to source the package at the
  given version. This may be one of the following:
  - `dev` : indicates the main development branch
  - `feature` : indicates a long-running feature branch. The `branch` property is also required for this
    branch type.
  - `internal` : indicates an internal testing branch. The `branch` property is also required for this branch
    type.
  - `release` : **(default)** indicates the official release branch
- `path` : **[optional]** the path to the dependency. This may be a relative path or an absolute path, but
  packages with absolute paths cannot be published. If this is empty, the location of the dependency is
  determined automatically by the package manager.
- `version` : **[optionally required]** the version string designating which version or ranges of versions are
  allowed to be used. See the [Dependency String](#package-dependency-string) for details on the formatting of
  this property, since it uses the same formatting. This may be omitted if a `path` is specified, though the
  package can never be published in that case.

### Package Rule

Defines a [Package Rule](./Concepts.md#package-rules) in a [Package](#package).

```json
{
    "condition" : {},
    "continue" : true,
    "dependencies" : {},
    "devDependencies" : {},
    "imported" : true,
    "license" : [],
    "packageExtensions" : [],
    "toolDependencies" : {}
}
```

- `condition` : **[optional]** the [Condition](#condition) under which the rule will be applied. If this is
  omitted, the rule is always applied.
- `continue` : **[optional]** if the `condition` matches and this is `false`, processing will not continue to
  the next rule. If this is `true` (the default), processing will always continue to the next rule.
- `dependencies` : **[optional]** inserts or overrides `dependencies` defined on the containing
  [Package](#package) after modifications from previous rules. If this is omitted, no changes are made to the
  `dependencies` property by this rule. Each key is the name of the dependency and each value is a
  [Package Dependency](#package-dependency).
- `devDependencies` : **[optional]** inserts or overrides `devDependencies` defined on the containing
  [Package](#package) after modifications from previous rules. If this is omitted, no changes are made to the
  `devDependencies` property by this rule. Each key is the name of the dependency and each value is a
  [Package Dependency](#package-dependency).
- `license` : **[optional]** overrides the `license` property on the containing [Package](#package). If
  omitted, the license is not overridden by this rule. This entry has the same formatting requirements as the
  `license` property on the [Package](#package) object.
- `toolDependencies` : **[optional]** inserts or overrides `toolDependencies` defined on the containing
  [Package](#package) after modifications from previous rules. If this is omitted, no changes are made to the
  `toolDependencies` property by this rule. Each key is the name of the dependency and each value is a
  [Package Dependency](#package-dependency).

### Profile Condition

A condition used to match a [Profile](./Concepts.md#profile), either for the environment in which Burt itself
is running or for the environment the code is being built for. These are used in [Conditions](#condition).

The schema for this object is as follows:

```json
{
    "architectures" : [],
    "operatingSystems" : []
}
```

- `architectures` : **[optional]** the list of [CPU Architectures](./Compatibility.md#cpu-architectures) that
  will be matched in the condition. Any of the architectures in this list can match. If this list is empty or
  omitted, all architectures will match.
- `operatingSystems` : **[optional]** the list of [Operating Systems](./Compatibility.md#operating-systems)
  that will be matched in the condition. Any of the operating systems in this list can match. If this list is
  empty or omitted, all operating systems will match.

### Project

The [Project](#project) object is the root of a [Project File](#project-file) and is the entry point for
everything contained within an repository. See the documentation on the [Project](./Concepts.md#project)
concept for more details on the role of a project.

```json
{
    "author" : {},
    "contributors" : [],
    "homepage" : "",
    "license" : "",
    "packages" : [],
    "repository" : {},
    "rules" : [],
    "subProjects" : [],
    "toolDependencies" : {}
}
```

- `author` : **[optional]** the [Contact](#contact) for the main author and owner of the project. This
  [Contact](#contact) is used as the default author for any packages included in the project.
- `contributors` : **[optional]** the [Contact](#contact) for any contributors to the overall project. These
  contributors are used as the default or can be added to the contributors for any packages included in the
  project.
- `homepage` : **[optional]** a URL where the main website for the project is located. Note that this is not
  the repository URL, since that is defined in the `repository` property.
- `license` : **[optional]** the overall license for the project. This is used as the default license for any
  packages included in the project, and must be a valid [SPDX Identifier](https://spdx.org/licenses/). This
  property can be overridden by [Project Rules](#project-rule) included in the list of `rules`.
- `packages` : **[required]** the [Packages](#package) defined in the project. This is an array whose entries
  may either be a path relative to the root where the [Package File](#package-file) is located for the package
  or may be a [Package](#package) object, which is essentially the contents of the [Package
  File](#package-file). This list of packages can be appended by [Project Rules](#project-rule)
  included in the list of `rules`.
- `repository` : **[required]** the main [Repository](#repository) where the source code for the project is
  located.
- `rules` : **[optional]** an array of [Project Rules](#project-rule) that apply to the project. This can be
  used to adjust most of the properties on the project under certain conditions. See the [Project Rules
  Concept](./Concepts.md#project-rules) for more information on the use of these.
- `subProjects` : **[optional]** an array of paths to directories containing [Project Files](#project-file)
  for projects contained within this project. Entries in this list can be relative to the project root (which
  is also the repository root) or can be absolute paths. This list of sub-projects can be appended by [Project
  Rules](#project-rule) included in the list of `rules`.
- `toolDependencies` : **[required]** the [Tool Dependencies](./Concepts.md#tool-dependencies) required by
  everything in the project. These dependencies are not inherited by consumers of any packages produced by the
  repository and are combined with [Tool Dependencies](./Concepts.md#tool-dependencies) that are defined on
  each of the packages. Each key in this object is the name of a package containing a tool and each value is a
  [Package Dependency](#package-dependency). These tool dependencies can be overridden or appended by [Project
  Rules](#project-rule) included in the list of `rules`.

### Project Rule

A [Project Rule](#project-rule) provides a mechanism to alter some of the properties of a [Project](#project)
based on certain conditions. See the [Project Rule Concept](./Concepts.md#project-rule) for further
explanation of this feature.

This is an object with the following schema:

```json
{
    "condition" : {},
    "continue" : true,
    "license" : {},
    "packages" : [],
    "subProjects" : [],
    "toolDependencies" : {}
}
```

- `condition` : **[optional]** the [Condition](#condition) under which the rule will be applied. If this is
  omitted, the rule is always applied.
- `continue` : **[optional]** if the `condition` matches and this is `false`, processing will not continue to
  the next rule. If this is `true` (the default), processing will always continue to the next rule.
- `license` : **[optional]** overrides the `license` property on the containing [Project](#project). If
  omitted, the license is not overridden. This entry has the same formatting requirements as the `license`
  property on the [Project](#project) object.
- `packages` : **[optional]** appends the list of `packages` defined on the containing [Project](#project). If
  omitted, nothing is appended. Each entry in this array is a [Package](#package) object.
- `subProjects` : **[optional]** appends the list of `subProjects` defined on the containing
  [Project](#project). If this is omitted, nothing is appended. Each entry has the same formatting
  requirements as the entries defined in the `subProjects` property on the [Project](#project) object.
- `toolDependencies` : **[optional]** inserts or overrides `toolDependencies` defined on the containing
  [Project](#project). If this is omitted, no changes are made to the tool dependencies. Each key in this
  object is the name of the package providing the tool and each value is a [Package
  Dependency](#package-dependency).

### Repository

The repository defined on a [Project](#project) must be defined either as a string referencing the URL of the
repository for the project or an object defining the URL of the project and other details. A [fully
defined](#fully-defined) repository is defined as an [object](#repository-object).

#### Repository String

If the [Repository](#repository) is a string value, the format of the string is as follows:

- `https://domain.com/repo/path.git` for URLs to Git repositories. This can be any valid URL accepted by the
  `git`` command line tool.
- `user/repo` or `github:user/repo` for repositories on GitHub.com.
- `bitbucket:user/repo` for repositories on bitbucket.com.
- `gitlab:user/repo` for repositories on gitlab.com

There may be additional URL formats supported by extensions, which should define these in their documentation.

> ⓘ Note:
>
> This format generally follows that of NPM defined
> [here](https://docs.npmjs.com/cli/v10/configuring-npm/package-json#repository) except that gists are not
> supported.

#### Repository Object

If the [Repository](#repository) is an object value, the schema is as follows:

```json
{
    "featureBranchPattern" : "",
    "mainBranch" : "",
    "releaseBranchPattern" : "",
    "type" : "",
    "url" : ""
}
```

- `featureBranchPattern` : **[optional]** a regular expression that identifies branches considered to be
  [feature branches](./Concepts.md#feature-branches). If omitted or empty, a default value of `^feature\/.+`
  is used, which will match any branch that starts with `feature/`.
- `mainBranch` : **[optional]** the name of the branch considered the main development branch for the
  repository. If this is omitted or empty, the branch is automatically determined based on the following:
  - If the `type` is `"git"`: <!-- cspell: disable-next-line -->
    - The command `git ls-remote --symref <url> HEAD` is executed to determine what the main branch is.
  - Other types:
    - The behavior depends on the corresponding extension that implements support for the version control
      system.
  Note that it is usually much faster to define this explicitly for a repository as it causes another remote
  query to the repository hosting solution to determine it.
- `releaseBranchPattern`: **[optional]** a regular expression that identifies branches considered to be
  [release branches](./Concepts.md#release-branches). If omitted or empty, a default value of `^release.*` is
  used, which will match any branch that starts with `release`.
- `type` : **[optional]** the type of the repository, which ultimately defines the version control system used
  to supply the source code for the repository. Burt defines the base support for `git`, but extensions may
  add support for other version control systems. See documentation for extensions that support version control
  systems. If omitted or empty, the default value of `git` is used.
- `url` : **[required]** the URL for the repository. The contents of this string may be of the formats defined
  in the [Repository String](#repository-string).
