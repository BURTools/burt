# CMake Extension Concepts <!-- omit in toc -->

## Table of Contents <!-- omit in toc -->

- [Basics](#basics)
  - [Build System Complexity](#build-system-complexity)
  - [Declarative vs Imperative](#declarative-vs-imperative)
  - [Simplicity](#simplicity)
    - [Flexibility](#flexibility)
    - [Bare Declarative](#bare-declarative)
    - [Declarative Custom Structure](#declarative-custom-structure)
    - [Declarative with Customizations](#declarative-with-customizations)
    - [Bare Imperative](#bare-imperative)
    - [Imperative with Customizations](#imperative-with-customizations)
    - [Legacy Imperative Code](#legacy-imperative-code)
  - [Default Behaviors](#default-behaviors)
    - [Module Structure](#module-structure)
- [CMake Modules](#cmake-modules)
- [Extending Burt CMake Functionality](#extending-burt-cmake-functionality)
- [Integration with Burt](#integration-with-burt)
- [Integration with CMake](#integration-with-cmake)
- [Imperative Concepts](#imperative-concepts)
- [Declarative Concepts](#declarative-concepts)
  - [JSON Format Extensions](#json-format-extensions)
  - [Variable Substitutions](#variable-substitutions)
  - [Properties](#properties)
    - [Property Changes](#property-changes)
    - [Global Properties](#global-properties)
    - [Directory Properties](#directory-properties)
    - [Target Properties](#target-properties)
    - [Test Properties](#test-properties)
    - [Source Properties](#source-properties)
  - [Variables](#variables)
    - [Variable Change](#variable-change)
  - [Tests](#tests)
    - [Test Resources](#test-resources)

## Basics

The Burt CMake extension aims to enable using [CMake](https://cmake.org) as the [build
system](https://cmake.org/cmake/help/latest/manual/cmake-buildsystem.7.html) and [testing
system](https://cmake.org/cmake/help/book/mastering-cmake/chapter/Testing%20With%20CMake%20and%20CTest.html)
for a [Project](../Concepts.md#project). Using this extension, a project should have all of their needs met in
the area of building code and executing tests using CMake in a way that leverages the Burt ecosystem and
seamlessly integrates with other build systems, package managers, CI/CD systems, etc.

The Burt CMake extension consists of two major parts:

- An [extension](../Concepts.md#extensions) to Burt, which supports integration with built-in concepts in
  Burt, such as the [`burt.json`](../JSON.md) files, [commands](../Concepts.md#extension-commands),
  [hooks](../Concepts.md#extension-hooks) into Burt infrastructure of various kinds
  ([targets](../Concepts.md#targets) for example), [packaging](../Concepts.md#package) and more.
- A set of [CMake Modules](https://cmake.org/cmake/help/book/mastering-cmake/chapter/Modules.html) that
  provide [API](#modules) for consistently defining [Targets](./Reference.md#target-functions),
  [Tests](./Reference.md#test-functions), and functionality for
  [extending](#extending-burt-cmake-functionality) this API with other extensions.

### Build System Complexity

Complexity for a project building with CMake is typically most severe in the areas where multiple platforms
are being supported, since behavior is often very different on different platforms, and around tooling and
cross-compiling. These issues often require a different skill set and experience to resolve than the team
writing the software typically has. Developers are often experts on C++, but not necessarily on the
intricacies of building apps for several different platforms (Mac, Windows, Linux, iOS, Android, WASM, etc.).
Because of this disconnect in expertise, there are many great libraries that do not have support for various
different platforms, because their authors simply do not have the experience or the means to test their
libraries on those platforms.

The aim of the Burt CMake extension is to capture that intersection of experience building C++ code for all of
the desired platforms in an abstraction layer that simplifies the usage of CMake by project developers to
target all of these platforms without the need to be experts in those platforms. For example, the Burt CMake
extension captures all of the know-how of creating an "app" for all of the target platforms, even as the form
of an "app" on different platforms can be _very_ different:

- On iOS and MacOs, it means a [Bundle](https://en.wikipedia.org/wiki/Bundle_(macOS))
- On Windows, it could be an [EXE](https://en.wikipedia.org/wiki/.exe) file, or it could be a [UWP
  app](https://learn.microsoft.com/en-us/windows/uwp/get-started/universal-application-platform-guide).
- On Android, it is an [Android Package](https://en.wikipedia.org/wiki/Apk_(file_format)).
- WASM applications produce HTML files with embedded or linked assembly code.

This illustration is meant to drive home the point that there is a large amount of variety in how that concept
is implemented, and the goal of the Burt CMake extension is to simplify it down to simply providing an API
that allows developers to "create an app" without caring how that app actually gets packaged and distributed
on a particular platform. The "right thing" just happens when building for each platform.

### Declarative vs Imperative

CMake is driven by the [CMake Language](https://cmake.org/cmake/help/latest/manual/cmake-language.7.html) and
does not provide a [declarative](https://en.wikipedia.org/wiki/Declarative_programming) mechanism out of the
box, which means that CMake is inherently [imperative](https://en.wikipedia.org/wiki/Imperative_programming).
While the language is mature and powerful, and indeed many very complicated cross-platform projects have
successfully used CMake as their build system, it has a learning curve as developers need to learn the details
of working with CMake's language and all of the caveats therein.

The Burt CMake extension addresses this complexity in two ways:

- A set of [CMake Modules](#cmake-modules) that simplifies creating targets, tests, and dealing with other
  CMake and Burt concepts in a generic abstract way. This is the Burt CMake extension's
  [imperative](#imperative-concepts) interface.
- A [declarative](#declarative-concepts) mechanism via extensions of the [`burt.json`](../JSON.md) file format
  used by Burt itself for information for its main source of information about a project.

### Simplicity

This section talks about conceptually how simple usage of the Burt CMake extension can be, while increasing
complexity in certain ways to accommodate special needs. This explains how a project can use as much or as
little of the Burt CMake extension's functionality as needed.

#### Flexibility

Obviously not every application and library can be built and run the same way. There are always exceptions to
every rule and always cases where special needs have to be accounted for. The Burt CMake extension was
designed with complete awareness of these cases, so it embraces a philosophy of using as much or as little of
its functionality as a project needs or is able. There may be many reasons a project needs to do its own
thing:

- It's an old project that had established CMake code and does not want to start over.
- There are platform-specific details in the project that cannot be handled in the generic way supported by
  the Burt CMake extension.
- Philosophically developers of a project want tight control over everything done with CMake.

Whatever the reason, the goal of the Burt CMake extension is to make it possible to use as much or as little
of it as possible to accommodate these cases where it will not be used in the fullest extent. The following
are areas where the Burt CMake extension provides flexibility:

- The [declarative](#declarative-concepts) mechanism may be used in entirety.
- The [declarative](#declarative-concepts) and [imperative](#imperative-concepts) can be mixed if needed.
- The [declarative](#declarative-concepts) mechanism may not be used at all and instead the
  [imperative](#imperative-concepts) mechanisms provided by the Burt CMake extension may be used instead.
- Targets may be defined by `CMakeLists.txt` code that uses CMake's `add_xxx` functions directly (in legacy
  scenarios, for example), and the [`burt_add_target()`](./Reference.md#burt_add_target) function can be used
  to initialize the Burt CMake extension's [properties](./Reference.md#properties).
- Targets may be defined by `CMakeLists.txt` code that uses CMake's `add_xxx` functions directly and the Burt
  CMake extension's [properties](./Reference.md#properties) set explicitly by the code.
- Targets may be defined entirely without using Burt CMake extension functionality at all, but the resulting
  binaries can be included into a [Package](../Concepts.md#package) after they are built (see the
  documentation for [Foreign Built Packages](../Concepts.md#foreign-built-packages) for details).

Note that these scenarios are listed in order of ease of use and consistent functionality, where the first
option provides the most functionality with the least amount of work and the last depends entirely on the
CMake code within the project to produce the binaries correctly on every platform and to prepare files in such
a way that they can be packaged and reused (if a package is being distributed). In fact, the last option does
not involve Burt in the build process of the package at all until the very end where metadata instructs Burt
about where the binaries are located.

#### Bare Declarative

The simplest way to use the functionality provided by the Burt CMake extension is to use the
[declarative](#declarative-concepts) approach to defining the build system inputs. Since the
[`burt.json`](../JSON.md) file already exists for other purposes, the most basic cases may not even need to
add more information to the file for the CMake extension to successfully build the code. Without adding any
information, the base definition of [Modules](../JSON.md#module) contains all of the information to compile
code with default compiler flags and behavior. It is convenient and suggested to build code in this way, using
this [declarative](#declarative-concepts) mechanism with no use of the [JSON Format
extensions](#json-format-extensions), as it is the least amount of effort, and it makes the code more portable
and easier to support other platforms. Complicating the build system comes at the cost of compatibility with
different platforms.

A [module](../JSON.md#module) can be defined in  as simply as this:

```json
{
    "type" : "executable",
    "dependencies" : ["libraryX", "libraryY"]
}
```

There are a lot of defaults being depended upon here, such as the structure of the code under the module's
folder, but for new projects being built from scratch with the Burt CMake extension, the structure can follow
that of the defaults for an extremely simple use case.

#### Declarative Custom Structure

If a project does not follow the default Burt CMake [module structure](#module-structure), customizations can
be made easily without using any extension of the [`burt.json`](../JSON.md) file format. See the following
example altered from the example above:

```json
{
    "type" : "executable",
    "dependencies" : ["libraryX", "libraryY"],
    "privateHeaderDirs" : "include",
    "sourceDirs" : "sources"
}
```

This is telling Burt that there is a folder named "include" directly under the module folder that contains all
of the local header files and there is a "sources" folder that contains all of the ".cpp" files.

#### Declarative with Customizations

If a project needs to make changes to [properties](#properties), [variables](#variables), etc., it can do so
with [extensions](#json-format-extensions) to the [`burt.json`](../JSON.md) file. These changes are specific
to CMake, as it is directly altering CMake data. An example of this is as follows;

```json
{
    "type" : "executable",
    "dependencies" : ["libraryX", "libraryY"],
    "extended" : {
        "cmake" : {
            "targetPropertyChanges" : [
                {
                    "name" : "COMPILE_DEFINITIONS",
                    "oper" : "cmake_list_append",
                    "value" : "MY_COMPILE_FLAG"
                }
            ]
        }
    }
}
```

This example appends a compiler definition `MY_COMPILE_FLAG` to the list of definitions already set by default
on the target's `COMPILE_DEFINITIONS` property.

#### Bare Imperative

A project may be able to use the declarative mechanism for defining the majority of modules while needing to
explicitly define a `CMakeLists.txt` for specific ones to work around limitations of the declarative
mechanism. In this case, it is as simple as putting a `CMakeLists.txt` file in the root directory of the
module:

```cmake
burt_add_executable(DEPENDENCIES libraryX libraryY)
```

This has exactly the same result as the simplest declarative example provided in the [Bare
Declarative](#bare-declarative) example. In order for Burt to be aware that the module exists, it does need to
have an entry in the `modules` property on a [Package](../JSON.md#package), but this can simply be a path to
the root directory of the module. The Burt CMake extension will then tell Burt what the type of the module is.

#### Imperative with Customizations

Just like with the [Declarative with Customizations](#declarative-with-customizations), projects may include
any manner of custom CMake code in the `CMakeLists.txt` to customize input to the `burt_xxx` functions or to
set properties on the target after it is created. See the following example:

```cmake
burt_add_executable(NAME MyExe DEPENDENCIES libraryX libraryY)
get_target_property(_val MyExe COMPILE_DEFINITIONS)
list(APPEND _val MY_COMPILE_FLAG)
set_target_properties(MyExe PROPERTIES COMPILE_DEFINITIONS ${_val})
```

This example has the same result as the example given in the [Declarative with
Customizations](#declarative-with-customizations) section.

#### Legacy Imperative Code

For projects with existing `CMakeLists.txt` that are being migrated to use Burt and do not use the
[API](#imperative-concepts) to create targets and so-forth, it is still possible to make minimal changes to
keep the existing target definition code. This can be done by setting [variables](./Reference.md#variables)
and [properties](./Reference.md#properties) used by the Burt CMake extension to specify certain behaviors or
by using the [`burt_add_target()`](./Reference.md#burt_add_target) function, or any combination therein. This
approach is only for the most advanced user that fully understands what properties and variables are needed by
Burt to do what it needs and should be avoided if possible. An overly simplistic example of this in a
`CMakeLists.txt` file is as follows:

```cmake
add_executable(MyExe ${_sources})
burt_add_target(MyExe)
set_target_properties(MyExe PROPERTIES BURT_DEPLOY TRUE)
```

This example is **not** complete, but shows how this sort of hybrid scenario would work. In this case, the
CMake [`add_executable()`](https://cmake.org/cmake/help/latest/command/add_executable.html) is used to create
the target and the [`burt_add_target()`](./Reference.md#burt_add_target) function is called to have the Burt
CMake extension initialize all of the properties as it would if the
[`burt_add_executable()`](./Reference.md#burt_add_executable) function was called. Finally, the
[`BURT_DEPLOY`](./Reference.md#burt_deploy) property on the target is forced to `TRUE`. Note that the
[`burt_add_target`](./Reference.md#burt_add_target) call is optional as all of the necessary `BURT_XXX`
properties could be set on the target explicitly as needed, but using the
[`burt_add_target()`](./Reference.md#burt_add_target) function is preferred as it will reduce the burden of
understanding what properties to set and why.

### Default Behaviors

#### Module Structure

## CMake Modules

## Extending Burt CMake Functionality

## Integration with Burt

## Integration with CMake

## Imperative Concepts

## Declarative Concepts

### JSON Format Extensions

### Variable Substitutions

There are a number of areas where paths are specified in the [CMake Extension JSON](./JSON.md) that may have
paths relative to directories that cannot otherwise be determined automatically. In these cases, a placeholder
can be put at the beginning of the path with the format `${variable}`, where the string `variable` a CMake
variable that is available at generate time. Any value that is being given from the [CMake Extension
JSON](./JSON.md) to set a variable, property, or other string being passed to CMake code can contain an
embedded variable reference that will be properly replaced with the value of the given variable. This is made
possible by the `cmake_language(EVAL ...)` command, which this extension uses to allow CMake to perform the
proper substitution before passing the strings on to other CMake commands.

### Properties

This extension allows defining [CMake
properties](https://cmake.org/cmake/help/latest/manual/cmake-properties.7.html) of all types applicable to
Burt and the CMake extension: Global, Directory, Target, Test, and Sources. In a general sense, this extension
allows these properties to either be set explicitly set via a `xxxProperties` kind of property on an `cmake`
[extension object](./JSON.md#extensions), or modified by a `xxxPropertyChanges` property via [Property
Changes](./JSON.md#property-change).

The `xxxProperties` properties are objects where the key is the name of the property and the value is the
value that will be set on the property. These changes are applied to the property with no regard to the
inherited values, and. The `xxxPropertyChanges` contain [Property Changes](#property-changes) to the existing
values of properties. This allows string modification, list manipulation, regular expressions, etc.

Strings that are used in `xxxProperties` or [Property Changes](#property-changes) can include [Generator
Expressions](https://cmake.org/cmake/help/latest/manual/cmake-generator-expressions.7.html) for those
properties that support them, and [Variable Substitutions](#variable-substitutions) can be included in both
the property names and values anywhere in `xxxProperties` or [Property Changes](#property-changes). Note that
properties set via `xxxProperties` are handled in an indeterminate order, so [Variable
Substitutions](#variable-substitutions) that rely on variables being set beforehand may not be reliable. If
this case occurs, use [Property Changes](#property-changes) via the `xxxPropertyChanges` instead, since the
order of processing is guaranteed.

#### Property Changes

Property changes are transformations that can be applied to modify the existing value of a property. The main
concept is an `operation` that defines the nature of the change, followed by some data to go with it. The
following kinds of changes can be made via a [Property Change](./JSON.md#property-change) object:

- Reset the value to the inherited value (if applicable).
- Replace the value with a new value (equivalent to using `xxxProperties`).
- Unset the property.
- Append or prepend a string to the current value of the property;
  - As a string (no delimiter).
  - As a CMake list (with the `;` delimiter).
  - As a path list (with a `;` on Windows or `:` on other operating systems).
- Apply a regular expression substitution to the current value of the property.

#### Global Properties

The CMake Extension has limited support setting [Global
Properties](https://cmake.org/cmake/help/latest/manual/cmake-properties.7.html#properties-of-global-scope) for
a variety of reasons:

- It's possible to have several [Projects](../Concepts.md#project) in the same environment being loaded, and
  they may not all agree on the global property values. Since scoping is not supported for global properties
  like it is with [CMake
  Variables](https://cmake.org/cmake/help/latest/manual/cmake-language.7.html#cmake-language-variables), this
  makes it impossible for one project to not conflict with another project.
- [Global
  Properties](https://cmake.org/cmake/help/latest/manual/cmake-properties.7.html#properties-of-global-scope)
  are mostly read-only, making the need to set them moot.

For those [Global
Properties](https://cmake.org/cmake/help/latest/manual/cmake-properties.7.html#properties-of-global-scope)
that can be set, the `globalProperties` property on the [Project Extension](./JSON.md#project-extension) can
be used. The property values specified using this mechansim are not necessarily direct sets, because of the
conflict between multiple projects that are being configured together (as with [Embedding Package
Source](../Concepts.md#embedded-package-source)).

The following properties can only be set by the [Project Extension](./JSON.md#project-extension) on the root
[Project](../JSON.md#project). Any value defined in subprojects is ignored.

- [AUTOGEN_SOURCE_GROUP](https://cmake.org/cmake/help/latest/prop_gbl/AUTOGEN_SOURCE_GROUP.html)
- [AUTOGEN_TARGETS_FOLDER](https://cmake.org/cmake/help/latest/prop_gbl/ALLOW_DUPLICATE_CUSTOM_TARGETS.html)
- [AUTOMOC_SOURCE_GROUP](https://cmake.org/cmake/help/latest/prop_gbl/ALLOW_DUPLICATE_CUSTOM_TARGETS.html)
- [AUTOMOC_TARGETS_FOLDER](https://cmake.org/cmake/help/latest/prop_gbl/ALLOW_DUPLICATE_CUSTOM_TARGETS.html)
- [AUTORCC_SOURCE_GROUP](https://cmake.org/cmake/help/latest/prop_gbl/ALLOW_DUPLICATE_CUSTOM_TARGETS.html)
- [AUTOUIC_SOURCE_GROUP](https://cmake.org/cmake/help/latest/prop_gbl/ALLOW_DUPLICATE_CUSTOM_TARGETS.html)
- [DEBUG_CONFIGURATIONS](https://cmake.org/cmake/help/latest/prop_gbl/ALLOW_DUPLICATE_CUSTOM_TARGETS.html)
- [ECLIPSE_EXTRA_CPROJECT_CONTENTS](https://cmake.org/cmake/help/latest/prop_gbl/ALLOW_DUPLICATE_CUSTOM_TARGETS.html)
- [ECLIPSE_EXTRA_NATURES](https://cmake.org/cmake/help/latest/prop_gbl/ALLOW_DUPLICATE_CUSTOM_TARGETS.html)
- [GLOBAL_DEPENDS_NO_CYCLES](https://cmake.org/cmake/help/latest/prop_gbl/ALLOW_DUPLICATE_CUSTOM_TARGETS.html)
- [PREDEFINED_TARGETS_FOLDER](https://cmake.org/cmake/help/latest/prop_gbl/ALLOW_DUPLICATE_CUSTOM_TARGETS.html)
- [USE_FOLDERS](https://cmake.org/cmake/help/latest/prop_gbl/ALLOW_DUPLICATE_CUSTOM_TARGETS.html)
- [XCODE_EMIT_EFFECTIVE_PLATFORM_NAME](https://cmake.org/cmake/help/latest/prop_gbl/ALLOW_DUPLICATE_CUSTOM_TARGETS.html)

The following properties have property-specific behavior:

- [ALLOW_DUPLICATE_CUSTOM_TARGETS](https://cmake.org/cmake/help/latest/prop_gbl/ALLOW_DUPLICATE_CUSTOM_TARGETS.html)
  : any value other than a valid [true constant](https://cmake.org/cmake/help/latest/command/if.html#constant)
  is ignored. It is only possible to enable this behavior, not disable it.

The following properties can't be set directly, but have alternate means of being set:

- [JOB_POOLS](https://cmake.org/cmake/help/latest/prop_gbl/ALLOW_DUPLICATE_CUSTOM_TARGETS.html) can be set by
  setting the
  [CMAKE_JOB_POOLS](https://cmake.org/cmake/help/latest/variable/CMAKE_JOB_POOLS.html#variable:CMAKE_JOB_POOLS)
  variable.

Any property not listed here is ignored, most likely due to that property being read-only or because the
property is expected to be set by
[toolchains](https://cmake.org/cmake/help/latest/manual/cmake-toolchains.7.html) or by the Burt CMake
extension itself.

Note that no global properties can be set to a complex value, so there is no support for [Property
Changes](#property-changes) for global properties.

#### Directory Properties

This concept defines how the Burt CMake extension works with [CMake Directory
Properties](https://cmake.org/cmake/help/latest/manual/cmake-properties.7.html#properties-on-directories).
Since [Projects](../Concepts.md#project), [Packages](../Concepts.md#package), and
[Modules](../Concepts.md#module) are all directories, the CMake extension allows these constructs to have
control over their associated [Directory
Properties](https://cmake.org/cmake/help/latest/manual/cmake-properties.7.html#properties-on-directories) via
mechanisms that either allow explicitly setting the property values or making changes to existing values. This
is controlled with consistently-named property values as follows:

- `directoryProperties`: this property on objects sets the directory property to a specific value, overriding
  any inherited or previously set value.
- `directoryPropertyChanges`: this property on objects augments the value of the property via a list of
  [Property Changes](#property-changes).

In all cases, the directory property's value is set to a value found in `directoryProperties` first before
applying the changes in `directoryPropertyChanges`.

These properties are found on the following objects:

- [Project Extensions](./JSON.md#project-extension)
- [Project Rule Extensions](./JSON.md#project-rule-extension)
- [Package Extensions](./JSON.md#package-extension)
- [Package Rule Extensions](./JSON.md#package-rule-extension)
- [Module Extensions](./JSON.md#module-extension)
- [Module Rule Extensions](./JSON.md#module-rule-extension)

For each kind of object ([Project](../Concepts.md#project), [Package](../Concepts.md#package), or
[Module](../Concepts.md#module)), the `directoryProperties` and `directoryPropertyChanges` are handled on the
extension first, then followed by rules that have their conditions met in the order they are listed in their
`rules` property.

Many directory properties can be inherited from the directory that added the subdirectory, so the
`directoryPropertyChanges` property makes it easy to modify these properties based on what is coming from the
parent directory. Since this mechanism is built into the directory properties by CMake, this extension does
not handle inheriting directory property values from the extensions or rule extensions of parent constructs.
For example, `directoryProperties` on a [Project](../JSON.md#project) are not inherited by a contained
[Package](../JSON.md#package) unless the properties are inheritable properties in CMake. Not all [directory
properties](https://cmake.org/cmake/help/latest/manual/cmake-properties.7.html#properties-on-directories) are
inherited.

#### Target Properties

This concept defines how the Burt CMake extension works with [CMake Target
Properties](https://cmake.org/cmake/help/latest/manual/cmake-properties.7.html#properties-on-targets).
[Targets](https://cmake.org/cmake/help/book/mastering-cmake/chapter/Key%20Concepts.html#targets) are not
hierarchical like directories are, so the inheritance in [Directory Properties](#directory-properties) does
not apply. It is for this reason, that properties are defined on the [Module
Extension](./JSON.md#module-extension) only, via the `targetProperties` and `targetPropertyChanges`
properties.

The value of the `targetProperties` property is an object whose property names are the names of the [Target
Properties](https://cmake.org/cmake/help/latest/manual/cmake-properties.7.html#properties-on-targets) being
set, and the values are the values to set on those properties. This setting of properties overwrites any
default values of the properties set when the target is created.

The value of the `targetPropertyChanges` property is a list of [Property Changes](#property-changes) which
make changes to the default values of properties that were set when the target was created after any property
setting was done in the `targetProperties` property.

Since inheritance via the CMake properties mechanism is not available for target properties, there are two
mechanisms that can be used to set property values for targets more globally:

- Using the `CMAKE_XXXX`
  [variables](https://cmake.org/cmake/help/latest/manual/cmake-variables.7.html#variables-that-control-the-build)
  that CMake itself uses to initialize the CMake's own [target
  properties](https://cmake.org/cmake/help/latest/manual/cmake-properties.7.html#properties-on-targets).
- Using the `BURT_XXXX` [variables](./Reference.md#target-property-default-variables) that the Burt CMake
  extension will use to initialize the Burt-specific [target properties](./Reference.md#target-properties).

See the section on [Variables](#variables) for details on how these can be set.

#### Test Properties

This concept defines how the Burt CMake extension works with [CMake Test
Properties](https://cmake.org/cmake/help/latest/manual/cmake-properties.7.html#properties-on-tests). Much like
[Targets](#target-properties), tests do not have a hierarchical nature and therefore do not have the ability
to inherit property values like [Directory Properties](#directory-properties). As a result, property values
can only be manipulated from the `properties` and `propertyChanges` properties on the [Test](./JSON.md#test)
objects.

The value of the `properties` property is an object whose property names are the names of the properties
whose values are being set and whose values are the values of those properties. This setting of properties
overwrites any default values of the properties when the test is created.

The value of the `propertyChanges` property is a list of [Property Changes](#property-changes) which make
changes to the default values of properties that were set when the test was created and after any property
setting was done in the `properties` property.

Since inheritance via the CMake properties mechanism is not available for test properties, the mechanism
available to manipulate test properties more globally resides in the [Test Property Default
Variables](./Reference.md#test-property-default-variables). Note that unlike target properties, CMake doesn't
define variables that initialize the properties for tests, so Burt supplies variables it uses to initialize
these properties. See the [Variables](#variables) section for details on how these variables can be set.

#### Source Properties

This concept defines how the Burt CMake extension works with [CMake Source
Properties](https://cmake.org/cmake/help/latest/manual/cmake-properties.7.html#properties-on-source-files).
Many of the properties on source files inherit or override from the target building the file. It is for this
reason that properties explicitly set on source files are only done through [Sources](./JSON.md#source)
defined in the `sources` property of the [Module Extension](./JSON.md#module-extension) and [Module Rule
Extension](./JSON.md#module-rule-extension). The main properties on this object for modifying properties are
the `properties` and `propertyChanges` properties on the [Source](./JSON.md#source) object.

The value of the `properties` property is an object whose property names are the names of the source
properties to set and the values of the properties are the values that will be set on the corresponding source
property.

The value of the `propertyChanges` property is a list of [Property Changes](#property-changes) that modify the
existing value of the property. These changes are applied after the test is created and its default values
applied and after the `properties` are processed.

### Variables

This concept defines how the Burt CMake extension works with [CMake
Variables](https://cmake.org/cmake/help/latest/manual/cmake-language.7.html#cmake-language-variables). Since
variables are scoped to directories automatically, it makes sense to allow variable setting and modification
on the Burt constructs directly associated with directories, [Projects](../Concepts.md#project),
[Packages](../Concepts.md#package), and [Modules](../Concepts.md#module) and their corresponding rules.
Changes to variables can either be overwriting or modification of existing values via the following
consistently-named properties on objects:

- `variables` : an object whose properties are the names of variables and the values are strings.
- `variableChanges` : an array of [Variable Change](#variable-change) objects that each make changes to a
  variable.

The variables found in `variables` are set first before any `variableChanges` are processed.

These properties are found on the following objects:

- [Project Extensions](./JSON.md#project-extension)
- [Project Rule Extensions](./JSON.md#project-rule-extension)
- [Package Extensions](./JSON.md#package-extension)
- [Package Rule Extensions](./JSON.md#package-rule-extension)
- [Module Extensions](./JSON.md#module-extension)
- [Module Rule Extensions](./JSON.md#module-rule-extension)

For each kind of object ([Project](../Concepts.md#project), [Package](../Concepts.md#package), or
[Module](../Concepts.md#module)), the `variables` and `variableChanges` are handled on the extension first,
then followed by rules that have their conditions met in the order they are listed in their `rules` property.

Variables are be inherited from the directory that added the subdirectory, so the `variableChanges` property
makes it easy to modify these variables based on what is coming from the parent directory. Since this
mechanism is built into the variables by CMake, this extension does not handle inheriting variable values from
the extensions or rule extensions of parent constructs. See the documentation related to directory scoping in
the CMake Language documentation section on
[Variables](https://cmake.org/cmake/help/latest/manual/cmake-language.7.html#cmake-language-variables) for
details.

This functionality makes use of [Variable Substitutions](#variable-substitutions) for both variable names and
variable values in both `variables` and [Variable Changes](#variable-change). Practically any string that
affects the name or value or processing of variables in these constructs supports this functionality.

#### Variable Change

Variable changes are transformations that can be applied to modify the existing value of a variable. The main
concept is an `operation` that defines the nature of the change, followed by some data to go with it. The
following kinds of changes can be made via a [Variable Change](./JSON.md#variable-change) object:

- Replace the value with a new value (equivalent to using `variables`).
- Unset the value.
- Append or prepend a string to the current value of the variable;
  - As a string (no delimiter).
  - As a CMake list (with the `;` delimiter).
  - As a path list (with a `;` on Windows or `:` on other operating systems).
- Apply a regular expression substitution to the current value of the variable.

### Tests

Burt does not address testing in its model for `burt.json`, so CMake provides all of the support itself via
the `tests` property on the [Package Extension](./JSON.md#package-extension) object. Given that testing may
also need to be conditional, tests can be created as part of the `tests` property on the [Package Rule
Extension](./JSON.md) to further control under which conditions tests are executed.

Tests are handled exactly like [Modules](../Concepts.md#module) are handled, with tests being added after all
modules have been added. This is done to ensure that should a test need to use a module as input, that target
would exist at the time of test creation. Each defined test results in a call to
[`burt_add_test()`](./Reference.md#burt_add_test), followed by processing of [Test
Properties](#test-properties).

#### Test Resources

The Burt CMake extension enhances the [Resource
Allocation](https://cmake.org/cmake/help/latest/manual/ctest.1.html#resource-allocation) for tests by allowing
the [specification](https://cmake.org/cmake/help/latest/manual/ctest.1.html#ctest-resource-specification-file)
of those resources to be provided in the following ways:

- At the project level via the [Project Extension](./JSON.md#project-extension) via the following means:
  - Via the `testResourceSpecification` property as an embedded object following the structure of the
    [resource specification
    format](https://cmake.org/cmake/help/latest/manual/ctest.1.html#ctest-resource-specification-file).
  - Via the `testResourceSpecification` property as a path to a file on disk in the [resource
    specification
    format](https://cmake.org/cmake/help/latest/manual/ctest.1.html#ctest-resource-specification-file).
- At the package level via the [Package Extension](./JSON.md#package-extension) via the following means:
  - Using a static JSON for the resource specification using `testResourceMethod` as `json`:
    - Via the `testResourceData` property as an embedded object following the structure of the [resource
      specification
      format](https://cmake.org/cmake/help/latest/manual/ctest.1.html#ctest-resource-specification-file).
    - Via the `testResourceData` property as a path to a file on disk in the [resource
      specification
      format](https://cmake.org/cmake/help/latest/manual/ctest.1.html#ctest-resource-specification-file).
  - Via execution of a test to generate the [resource specification
    file](https://cmake.org/cmake/help/latest/manual/ctest.1.html#ctest-resource-specification-file) by
    specifying `test` for the `testResourceMethod` property and then supplying the name of the test to execute
    via the `testResourceData` property.

When specifying the embedded or file path to a [resource specification
file](https://cmake.org/cmake/help/latest/manual/ctest.1.html#ctest-resource-specification-file), the resource
specification is passed to `ctest` by the Burt CMake extension via the
[`--resource-spec-file`](https://cmake.org/cmake/help/latest/manual/ctest.1.html#cmdoption-ctest-resource-spec-file)
command line argument. When specifying a test to run to generate this file, `ctest` handles the file itself.

#### Test Rules

