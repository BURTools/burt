# CMake Extension Concepts <!-- omit in toc -->

## Table of Contents <!-- omit in toc -->

- [Variable Substitutions](#variable-substitutions)
- [Properties](#properties)
  - [Property Changes](#property-changes)
  - [Global Properties](#global-properties)
  - [Directory Properties](#directory-properties)
  - [Target Properties](#target-properties)
  - [Test Properties](#test-properties)
  - [Source Properties](#source-properties)
- [Variables](#variables)
- [Tests](#tests)
- [Test Fixtures](#test-fixtures)

## Variable Substitutions

There are a number of areas where paths are specified in the [CMake Extension JSON](./JSON.md) that may have
paths relative to directories that cannot otherwise be determined automatically. In these cases, a placeholder
can be put at the beginning of the path with the format `${variable}`, where the string `variable` a CMake
variable that is available at generate time. Any value that is being given from the [CMake Extension
JSON](./JSON.md) to set a variable, property, or other string being passed to CMake code can contain an
embedded variable reference that will be properly replaced with the value of the given variable. This is made
possible by the `cmake_language(EVAL ...)` command, which this extension uses to allow CMake to perform the
proper substitution before passing the strings on to other CMake commands.

## Properties

This extension allows defining [CMake
properties](https://cmake.org/cmake/help/latest/manual/cmake-properties.7.html) of all types applicable to
Burt and the CMake extension: Global, Directory, Target, Test, and Sources. In a general sense, this extension
allows these properties to either be set explicitly set via a `xxxProperties` kind of property on an `cmake`
[extension object](./JSON.md#extensions), or modified by a `xxxPropertyChanges` property via [Property
Changes](./JSON.md#property-change).

The `xxxProperties` properties are objects where the key is the name of the property and the value is the
value that will be set on the property. These changes are applied to the property with no regard to the
inherited values. The `xxxPropertyChanges` contain [Property Changes](#property-changes) to the existing
values of properties. This allows string modification, list manipulation, regular expressions, etc.

Strings that are used in `xxxProperties` or [Property Changes](#property-changes) can include [Generator
Expressions](https://cmake.org/cmake/help/latest/manual/cmake-generator-expressions.7.html) for those
properties that support then.

### Property Changes

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

### Global Properties

This concept defines how the Burt CMake extension works with [CMake Global
Properties](https://cmake.org/cmake/help/latest/manual/cmake-properties.7.html#properties-of-global-scope).
Although these properties are technically global, there is a huge risk of conflict should multiple
[Projects](../Concepts.md#project) be present in the same environment, which happens when consuming a package
as [embedded source](../Concepts.md#embedded-package-source). As a result, this extension has support for
scoping the global properties set via this extension to the [Project](../Concepts.md#project) that defines
them.

The [Project Extension](./JSON.md#project-rule-extension) allows setting global properties to explicit values
via the `globalProperties` object or by specifying a list of [Property Changes](#property-changes) in the
`globalPropertyChanges` property. These global properties are then applied to the entire project and scoped in
such a way that their values are independent of those needed by other projects. Note that if using
`globalPropertyChanges`, the value of the properties being modified is the value inherited from the
[Project](../Concepts.md#project) that added the project via the `subprojects` property, if the project was
added in that way.

### Directory Properties

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

These properties are found on objects to the following effects:

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

### Target Properties

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

### Test Properties

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

### Source Properties

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

## Variables



## Tests

## Test Fixtures
