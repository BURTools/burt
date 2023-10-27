# Burt JSON Schema <!-- omit in toc -->

## Table of Contents <!-- omit in toc -->

- [Files](#files)
  - [Fully Defined](#fully-defined)
  - [Project File](#project-file)
  - [Package File](#package-file)
  - [Module File](#module-file)
- [Reference](#reference)
  - [Burt Extension](#burt-extension)
  - [Command](#command)
  - [Command Alias](#command-alias)
  - [Command Argument](#command-argument)
  - [Command Definition](#command-definition)
  - [Command Example](#command-example)
  - [Command Option](#command-option)
  - [Condition](#condition)
  - [Contact](#contact)
  - [Dependency](#dependency)
    - [Dependency String](#dependency-string)
    - [Dependency Object](#dependency-object)
  - [Module](#module)
  - [Module Condition](#module-condition)
  - [Module Dependency](#module-dependency)
  - [Package](#package)
  - [Package Condition](#package-condition)
  - [Package Dependency](#package-dependency)
  - [Profile](#profile)
  - [Profile Condition](#profile-condition)
  - [Project](#project)
  - [Project Rule](#project-rule)
  - [Repository](#repository)
    - [Repository String](#repository-string)
    - [Repository Object](#repository-object)
  - [Tool Dependency](#tool-dependency)

## Files

The `burt.json` file supplies information to Burt about a project. These `burt.json` files can be found in the
followng places:

- [Project File](#project-file) : [required] For each [Project](./Concepts.md/#project), there is at least one
  `burt.json` in the root of the repository.
- [Package File](#package-file) : [optional] There may also be a `burt.json` in the root folder of each
[Package](./Concepts.md#package).
- [Module File](#module-file) : [optional] There may also be a `burt.json` in the root folder of each
  [Module](./Concepts.md#module).

### Fully Defined

### Project File

At the very least, there needs to be a file in the root of each repository using Burt that defines the
high-level information about the repository and the overall project dependencies. The schema for this type of
file is as follows:


The properties on the root of this file are as follows:

- `repository` : **[required]** information about the [repository](./Concepts.md#repository) itself. This is a
  [Repository](#repository) object.
- `package` : **[optional]** the root package in the repository. This can be specified if there is a package
  at the root of the repository, and may alleviate the need for additional [Package File](#package-file)s, if
  this is the only package in the repository.
- `packages` : **[optional]** an object where the properties in the object are relative paths to the
  directories containing packages and the value is either a [Package](#package) or `null`, in which case the
  directory is expected to contain a [Package File](#package-file). The relative path must not begin with a
  `/` or consist of just `.`.
- `plugins` : **[required]** an object where the keys are the names of Burt plugins (which are really just
  normal packages) to be used on the repository. This is required, because at the very least, the repository
  needs to specify which version of Burt to use for that repository.

### Package File

While [Package](./Concepts.md#package)s can be defined in the [Project File](#project-file), it is also
possible to define a [Package](./Concepts.md#package) with a file in the root directory of that package in the
repository, so long as the root of that package is not in the root of the repository. For this package to be
seen by Burt, there needs a corresponding entry in the `packages` property of the [Project
File](#project-file) set to `null`, where the key is the relative path to the directory containing this file
from the root of the repository.

The contents of this file are the same as the [Package](#package) object.

### Module File

## Reference

### Burt Extension

### Command

### Command Alias

### Command Argument

### Command Definition

### Command Example

### Command Option

### Condition

A condition is used to determine when to apply [Rules](./Concepts.md#rules). This allows rudamentary logic
that is akin to [Schema Composition](https://json-schema.org/understanding-json-schema/reference/combining) in
the JSON Schema specification.

The object has the following schema:

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
  equivalent to a logical `NOT`. If omitted, it is ignoired in the condition.
- `oneOf`: **[optional]** an array of [Conditions](#condition) where exactly one of them must be met in order
  for this condition to be considered met, equivalent to a logical `XOR`. If empty or omitted, it is ignored
  in this condition.
- `targetProfile`: **[optional]** a [Profile Condition](#profile-condition) applied to the environment for
  which the code is being built for.

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

### Dependency

A [Dependency](./Concepts.md#dependencies) is used to specify relationships to packages that contain tools,
link targets, etc. One such entry may either be a string or an object.

#### Dependency String

In string form, it is specifying just the version of the package and all default behavior is bieng used to
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

#### Dependency Object

For more precise control over what version of the package to use or what source to acquire the package from,
an object can be specified whose schema is as follows:

```json
{
  "branch" : "",
  "branchType" : "",
  "optional" : false,
  "peer" : false,
  "provider" : "",
  "version" : ""
}
```

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
  "bundle" : false,
  "conditions" : [],
  "dependencies" : {},
  "deploy" : true,
  "export" : false,
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
  "bundle" : false,
  "conditions" : [],
  "dependencies" : {},
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
}
```

- `bundle` : **[optional]** indicates whether or not the target will produce a
  [bundle](./Concepts.md#bundle). This is `true` by default when the `type` is library and `false` by default
  when the `type` is `executable`.
- `conditions` : **[optional]** the list of [conditional rules](./Concepts.md#module-conditions) to apply to
  the module. Each entry in this list is a [Module Condition](#module-condition) object.
- `dependencies` : **[optional]** the [dependencies](./Concepts.md#module-dependencies) this module has on
  other modules. The keys in this object are the fully-qualified names of the modules to be depended upon and
  the value is a [Module Dependency](#module-dependency) object, which may be empty `{}` for default behavior.
- `deploy` : **[optional]** indicates whether or not the target will be [deployed](./Concepts.md#deploy). If
  this option is omitted, the default value is `true` when `type` is `executable` or `type` is `library` and
  `libraryType` is `module`.
- `export` : **[optional]** indicates whether or not the target will be [exported](./Concepts.md#exported)
  to the package produced by the containing package declaration. This is `true` by default when the `type` is
  `library` and `false` by default when the `type` is `executable`.
- `privateHeaderDirs` : **[optional]** the list of directories that contain header files to be included within
  the module itself. For libraries, these header files are not exported to the package and cannot be used by
  dependency modules. These paths are relative to the root of the module.
- `sources` : **[optional]** the list of relative paths to [source files](./Concepts.md#module-sources) that
  will be built with the module. By default, this list is empty and the module will only be built with files
  included with the `sourceDirs` option. These paths are relative to the root directory of the module.
- `sourceDirs` : **[optional]** the list of relative paths to directories containing [source
  files](./Concepts.md#module-sources). This defaults to a directory named `src`. These paths are relative to
  the root directory of the module.
- `sourceExcludes` : **[optional]** the list of patterns that will exclude [source
  files](./Concepts.md#module-sources) located in the `sourceDirs` from being included in the list of source
  files for the module. If this list is omitted or empty, all files are included. If the `sourceGlobs` is
  defined and this option is also defined, the `sourceGlobs` applies first, then the files that match the
  `sourceGlobs` are filtered by this file. These patterns are regular expressions.
- `sourceGlobs` : **[optional]** the list of globbing patterns that will be used to filter [source
  files](./Concepts.md#module-sources) in `sourceDirs`. If this list is empty or omitted, all files found in
  the `sourceDirs` are included in the list of sources. If the `sourceExcludes` is also defined, it further
  filters the files that successfully match one of these patterns. These patterns are globbing patterns, such
  as `*.cpp`.
- `type` : **[optional]** the type of the module. This can be one of the following:
  - `executable` : the module will be an executable (exe, app bundle, etc.)
  - `library` : **(default)** the module will be a library (shared, static, framework, etc.)

These properties only apply to modules with `type` equal to `executable`:

- `stores` : **[optional]** the list of [app stores](./Concepts.md#app-store) that will be supported by the
  executable. The following possible values can be used:
  - `amazon` : the app will be signed and prepared for the Amazon app store for Android.
  - `googleplay` : the app will be signed and prepared for the Google play store for Android.
  - `ios` : the app will be signed and prepared for the Apple store for iOS apps. This involves signing the
    app with the appropriate developer keys, etc.
  - `macos` : the app will be signed and prepared for the MacOS app store.
  - `windows` : the app will be signed and prepared for the Windows app store.

These properties only apply to modules with `type` equal to `library`:

- `libraryType` : **[optional]** the type of library. This can be one of the following:
  - `combined` : **(default)** the module will produce both a shared and static library for use by the
    consumer as it sees fit. This is the default behavior. This is equivalent to defining an `OBJECT` module
    with CMake's [`add_library()`
    command](https://cmake.org/cmake/help/v3.8/command/add_library.html#normal-libraries) and then adding two
    additional libraries using those objects with `STATIC` and `SHARED`.
  - `dynamic` : the library will be a dynamically loaded library that can be loaded with dlopen-like
    functionality, which is equivalent to passing `MODULE` to CMake's
    [`add_library()` command](https://cmake.org/cmake/help/v3.8/command/add_library.html#normal-libraries).
  - `header` : the library does not produce any binary code and only provides headers or declarative
    functionality, which is equivalent to passing `INTERFACE` to CMake's
    [`add_library()` command](https://cmake.org/cmake/help/v3.8/command/add_library.html#normal-libraries).
  - `shared` : the library will be a shared library, equivalent to passing `SHARED` to CMake's
    [`add_library()` command](https://cmake.org/cmake/help/v3.8/command/add_library.html#normal-libraries).
  - `static` : the library will be a static library, equivalent to passing `STATIC` to CMake's
    [`add_library()` command](https://cmake.org/cmake/help/v3.8/command/add_library.html#normal-libraries).
- `publicHeaderDirs` : **[optional]** the list of directories containing header files that will be made
  available to dependency modules and exported to the package. This option is not relevant for the
  `libraryType` of value `module`. These paths are relative to the root of the module.
- `publicHeaderExcludes` : **[optional]** the list of patterns to exclude public headers from the package.
  This behaves in the same manner as `sourceExcludes` except that it is used to filter out header files that
  will be included in the package. Each item in this array is a regular expression.
- `publicHeaderGlobs` : **[optional]** the list of globbing patterns that will be used to filter the header
  files found in `publicHeaderDirs` from the list of header files exported to the package. If this is empty or
  omitted, it defaults to `["*.h", "*.hpp", "*.hh", "*.hxx", "*.H", "*.h++"]`.

### Module Condition

The [Module Condition](./Concepts.md#module-conditions) objects allow tailoring of modules to specific
conditions, usually related to differences between platforms. The schema for this object is as follows:

```json
{
  "filters" : [],
  ...
}
```

This object has the same properties as the [Module](#module) object, with the addition of the following:

- `filters` : **[required]** the list of filters dictating when the condition applies (platform and other
  circumstances).

The rest of the properties either override or supplement the properties specified on the [Module](#module)
that contains the condition, and are identical in nature to the ones specified on the [Module](#module),
except that all properties are optional and have some behavior as to how they override or supplement the
property on the containing [Module](#module).

The following are the detals for each property:

- `bundle` : overrides the `bundle` property on the containing module.
- `conditions` : conditions are not recursive and this property is ignored on a condition.
- `dependencies` : the set of dependencies defined on the condition are added to the dependencies defined on
  the containing module. If the condition contains a dependency with the same key as one in the module, it
  effectively overrides the dependency on the module. It is possible to exclude a dependency defined on the
  containing module by setting it equal to `null` instead of a [Module Dependency](#module-dependency) object.
- `deploy` : overrides the `deploy` property on the containing module.
- `export` : overrides the `export` property on the containing module.
- `privateHeaderDirs` : each private header directory defined on the condition is appended to the list defined
  on the module unless prefixed with a `!:`, in which case the directory in the remaining portion of the
  string will be removed from the list in the containing module, if it exists.
- `publicHeaderDirs` : public header directories specified on the condition are appended to the public header
  directories defined on the containing module unless prefixed with a `!:`, in which case the directory in the
  remaining portion of the string will be removed from list in the containing module, if it exists.
- `publicHeaderExcludes` : public header file exclude patterns defined on the condition are appended ot those
  defined on the containing module, effectively allowing conditions to conditionally filter out public header
  files.
- `publicHeaderGlobs` : public header file glob patterns defined on the condition are appended to those
  defined on the containing module, effectively allowing conditions to conditionally include public header
  files.
- `sources` : sources defined on the condition are appended to those defined on the containing module unless
  prefixed with a `!:`, in which case the source is removed from the `sources`` on the containing module, if
  it exists.
- `sourceDirs` : source directories defined on the condition are appended to those defined on the containing
  module unless prefixed with a `!:`, in which case the directory in the remaining portion of the string will
  be removed from the `sourceDirs` in the containing module, if it exists.
- `sourceExcludes` : source exclude patterns defined on the condition are appended to those defined on the
  containing module, effectively allowing conditions to conditionally filter out files.
- `sourceGlobs` : source glob patterns defind on the condition are appended to those defined on the containing
  module, effectively allowing conditions to conditionally include files.
- `stores` : each store defined on the condition is appended to the list of stores defined on the containing
  module unless prefixed with `!`, in which case the store is removed from the list. For example, `!amazon`
  would remove the `amazon` store from the containing module, if it is defined there.

In addition to the above behavior, conditions are applied sequentially for all rules that match the context
being built. This means that multiple rules may alter the containing module, and may alter what was altered by
the previous rules in the list.

### Module Dependency

A Module Dependency allows the declaration of [dependencies between
modules](./Concepts.md#module-dependencies) that facilitate building, linking, or deploying modules. The
schema for this object is as follows:

```json
{
  "deploy" : true,
  "link" : true,
  "transitive" : true
}
```

The properties on this object are as follows:

- `deploy` : `true` if the dependency should be deployed. This is ignored for static library dependencies and
  `true` by default for all others.
- `link` : `true` if the dependency is a link-time dependency. This is ignored for `library` modules that are
  `header` type, since there is nothing to link against, and `true` by default for all others.
- `transitive` : `true` if the dependency is transitive and inherited by dependents of this module. This is
  `true` by default for all dependencies.

### Package

```json
{
  "author" : {},
  "burtExtensions" : {},
  "contributors" : [], 
  "dependencies" : {},
  "devDependencies" : {},
  "description" : "",
  "homepage" : "",
  "imported" : false,
  "keywords" : [],
  "license" : "",
  "modules" : [],
  "name" : "",
  "profiles" : [],
  "rules" : [],
  "toolDependencies" : {},
  "version" : ""
}
```

The properties on this object are as follows:

- `author` : **[optional]** the principal author of the package. This is a [Contact](#contact). While the
  `author` is not required, it is recommended for packages being advertized for use by others. If this is
  omitted, the author on the containing [Project](#project), if there is one.
- `burtExtensions` : **[optional]** a [Burt Extension](#burt-extension) object that declares the extensions to
  Burt contained in the package. If this is omitted, the 
- `conditions` : **[optional]** [conditional rules](./Concepts.md#package-conditions) applied to the package.
  Each one of the entries in this array are [Package Condition](#package-condition) objects.
- `contributors` : **[optional]** the list of contributors and maintainers of the package. The entries in this
  list are [Contact](#contact) objects. If this is omitted, the list of contributors spedified on the
  containing [Project](#project) is used.
- `dependencies` : **[optional]** the list of [dependencies](./Concepts.md#package-dependencies) this package
  has on other packages. These dependencies are inherited by packages that depend on this package,
  constructing a dependency graph. The keys in this object are the names of packages and each value is a
  [Package Dependency](#package-dependency) object or string. Do not put tools, such as test harnesses,
  compilers, etc. into this collection since they are not dependencies to be inherited, put them into
  `devDependencies` instead. This property can be appended by the [Package Conditions](#package-condition)
  defined in the `conditions` property.
- `devDependencies` : **[optional]** the list of developer dependenceis this package has on other packages.
  These dependencies are only installed for developers actively building this package and will not be
  inherited by downstream packages depending on this package. This object is very similar to the
  `dependencies` object, where each key in this object is the name of the package and each value is the
  [Package Dependency](#package-dependency) object or string. This property can be appended by the [Package
  Conditions](#package-condition) defined in the `conditions` property.
- `description` : **[optional]** a long description of the package. This is not required, but strongly
  suggested since it will be used in package listings and for searching.
- `homepage` : **[optional]** the URL to the homepage for the package (note: not the git repository, since
  that is defined on the [Project File](#project-file)). If this is omitted, the homepage defined on the
  containing [Project](#project) is used.
- `imported` : **[optional]** if `true`, the package is not built and is assumed to already have binaries
  available. This is `false` by default.
- `keywords` : **[optional]** an array of any number of keyword strings used to categorize the package.
- `license` : **[optional]** the [SPDX identifier](https://spdx.org/licenses/) string defining the license or
  a relative path to the file containing the license for the package, which is relative to the file containing
  this package declartion. If this is omitted, either a file named `LICENSE` or `LICENSE.md` is used, if it
  exists, or the license is inherited from the containing [Project](#project).
- `modules` : **[optional]** the list of [module](./Concepts.md#module)s defined in the package. The values in
  this array are either [Module](#module) objects or paths to directories relative to the file containing this
  package declaration that contain a [Module File](#module-file).
- `name` : **[required]** the name of the package. This must be globally unique in all of the [package
  providers](./Concepts.md#package-providers) that this package gets published to.
- `profiles` : **[optional]** the list of [Profiles](#profile) that define combinations of CPU architecture,
  operating system, etc. for which to build the package. If this is empty, all profiles are built.
- `toolDependencies` : **[optional]** the list of [Tool Dependencies](./Concepts.md#tool-dependencies) the
  package has. Much like `dependencies`, the keys in this object are the names of the packages and the values
  are [Tool Dependencies](#tool-dependency).
- `version` : **[required]** the version of the package. This must either be a [Semantic
  Version](https://semver.org) or it must be a version of the form `x.y`, where the patch number will be
  computed automatically to complete the Semantic Version.

### Package Condition

### Package Dependency

### Profile

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
  "subprojects" : [],
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
- `repository` : **[optional]** the main [Repository](#repository) where the source code for the project is
  located.
- `rules` : **[optional]** an array of [Project Rules](#project-rule) that apply to the project. This can be
  used to adjust most of the properties on the project under certain conditions. See the [Project Rules
  Concept](./Concepts.md#project-rules) for more information on the use of these.
- `subprojects` : **[optional]** an array of paths to directories containing [Project Files](#project-file)
  for projects contained within this project. Entries in this list can be relative to the project root (which
  is also the repository root) or can be absolute paths. This list of subprojects can be appended by [Project
  Rules](#project-rule) included in the list of `rules`.
- `toolDependencies` : **[optional]** the [Tool Dependencies](./Concepts.md#tool-dependencies) required by
  everything in the project. These dependencies are not inherited by consumers of any packages produced by the
  repository and are combined with [Tool Dependencies](./Concepts.md#tool-dependencies) that are defined on
  each of the packages. Each key in this object is the name of a package containing a tool and each value is a
  [Tool Dependency](#tool-dependency). These tool dependencies can be overridden or appended by [Project
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
  "subprojects" : [],
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
- `packages` : **[optional]** appends the list of `packages` defind on the containing [Project](#project). If
  omitted, nothing is appended. Each entry in this array is a [Package](#package) object.
- `subprojects` : **[optional]** appends the list of `subprojects` defined on the containing
  [Project](#project). If this is omitted, nothing is appended. Each entry has the same formatting
  requirements as the entries defined in the `subprojects` property on the [Project](#project) object.
- `toolDependencies` : **[optional]** inserts or overrides `toolDependencies` defined on the containing
  [Project](#project). If this is omitted, no changes are made to the tool dependencies. Each key in this
  object is the name of the package providing the tool and each value is a [Tool Dependency](#tool-dependency)
  object.

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

If the [Repository](#repository) is an object avlue, the schema is as follows:

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
  - If the `type` is `"git"`:
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
  add supprot for other version control systems. See documentation for extensions that support version control
  systems. If omitted or empty, the default value of `git` is used.
- `url` : **[required]** the URL for the repository. The contents of this string may be of the formats defined
  in the [Repository String](#repository-string).

### Tool Dependency


