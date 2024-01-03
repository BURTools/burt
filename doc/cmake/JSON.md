# CMake Extension JSON Format <!-- omit in toc -->

## Table of Contents <!-- omit in toc -->

## Extensions

### CMake Package Extension

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
this extension can be defined. This object is a [CMake Package Extension](#cmake-package-extension) object.

## Reference

### Environment Modification

An object defining an environment modification for the
[`ENVIRONMENT_MODIFICATION`](https://cmake.org/cmake/help/latest/prop_test/ENVIRONMENT_MODIFICATION.html)
property on a test, whose properties are as follows:

```json
{
    "name" : "",
    "oper" : "",
    "value" : ""
}
```

- `name` : **[required]** the name of the environment variable to modify.
- `oper` : **[required]** the operation to perform on the environment variable. This may be one of the
  following:
  - `cmake_list_append` : Appends `value` as a string to a CMake list in the `name` environment variable with
    the `;` separator.
  - `cmake_list_prepend` : Prepends `value` as a string to a CMake list in the `name` environment variable
    with the `;` separator.
  - `path_list_append` : Appends `value` as a path to a list of paths in the `name` environment variable with
    the appropriate path separator (`;` on Windows and `:` elsewhere).
  - `path_list_prepend` : Prepends `value` as a path to a list of paths in the `name` environment variable
    with the appropriate path separator (`;` on Windows and `:` elsewhere).
  - `reset` : Reset to the unmodified value, ignoring all modifications to MYVAR prior to this entry. Note
    that this will reset the variable to the value set by ENVIRONMENT, if it was set, and otherwise to its
    state from the rest of the CTest execution.
  - `set` : Replaces the value of the variable `name` with the `value`.
  - `string_append` : Appends the string `value` to the end of the `name` environment variable.
  - `string_prepend` : Prepends the string `value` to the beginning of the `name` environment variable.
  - `unset` : Unsets the value of the `name` environment variable.
- `value` : **[conditionally required]** the value used to modify the environment variable.

See the [documentation](https://cmake.org/cmake/help/latest/prop_test/ENVIRONMENT_MODIFICATION.html) for
environment modification for details on this behavior. Newer versions of CMake may support new operations.

### Package Extension

This object defines the CMake exension data on a [Package](../Concepts.md#package) and is defined with the
properies as follows:

```json
{
    "rules" : [],
    "tests" : {},
    "testFixtures" : {},
    "testResources" : {}
}
```

- `rules` : **[optional]** the list [Package Extension Rules](#package-extension-rule) to apply to the
  extension data.
- `tests` : **[optional]** an object where the keys are the names of the [Tests](./Concepts.md#tests) (which
  must be unique) and the values are the [Test](#test) objects defining each test.
- `testFixtures` : **[optional]** an object where the keys are the names of the [Test
  Fixtures](./Concepts.md#test-fixtures) and the values are the [Test Fixture](#test-fixture) objects defining
  each test fixture.
- `testResources` : **[optional]** a [Test Resources](#test-resources) object that specifies available test
  resources or how available test resources are to be determined.

### Package Extension Rule

This object defines a rule to apply to a [Package Extension](#package-extension) to alter it under certain
[Conditions](../JSON.md#condition). The properties of this object are as follows:

```json
{
    "condition" : {},
    "continue" : true,
    "tests" : {},
    "testFixtures" : {},
    "testResources" : {}
}
```

- `condition` : **[optional]** the [Condition](../JSON.md#condition) under which the rule will be applied. If
  omitted, the rule is always applied.
- `continue` : **[optional]** if the `condition` matches and this is `false`, the following rules will not be
  processed. If this is `true` (the default), processing always continues to the next rule.
- `tests` : **[optional]** inserts additional [Tests](#test) into the `tests` property of the containing
  [Package Extension](#package-extension). If a name in this object is the same as the name of a test on the
  containing [Package Extension](#package-extension), the test on the original package extension is
  essentially overwritten. If omitted, no changes are made to the tests.
- `testFixtures` : **[optional]** inserts additional [Test Fixtures](#test-fixture) into the `testFixtures`
  property of the containing [Package Extension](#package-extension). If a name in this object is the same as
  the name of a test fixture on the containing [Package Extension](#package-extension), the test fixture on
  the original package extension is essentially overwritten. If omitted, no changes are made to the test fixtures.
- `testResources` : **[optional]** overrides the `testResources` property on the containing [Package
  Extension](#package-extension) by replacing with a different [Test Resources](#test-resources) object. If
  omitted, the test resources on the [Package Extension](#package-extension) remain unchanged.

### Test

Defines a [Test](./Concepts.md#tests) object with the following properties:

```json
{
    "arguments" : [],
    "attachedFiles" : [],
    "attachedFilesOnFailure" : [],
    "command" : "",
    "cost" : 0,
    "dependencies" : [],
    "disabled" : false,
    "environment" : {},
    "environmentModifications" : [],
    "failRegEx" : "",
    "fixtures" : [],
    "labels" : [],
    "measurement" : "",
    "passRegEx" : "",
    "processors" : 1,
    "processorAffinity" : false,
    "requiredFiles" : [],
    "resourceGroups" : [],
    "resourceLocks" : [],
    "rules" : [],
    "runCondition" : {},
    "runSerial" : false,
    "skipRegex" : "",
    "skipReturnCode" : 0,
    "timeout" : 0,
    "timeoutAfterRegex" : {},
    "timeoutSignalGracePeriod" : 1.0,
    "timeoutSignal" : "",
    "willFail" : false,
    "workingDirectory" : ""
}
```

- `arguments` : **[optional]** the list of arguments to be passed to the `command`. Any of the arguments can
  be a [Generator
  Expression](https://cmake.org/cmake/help/latest/manual/cmake-generator-expressions.7.html#manual:cmake-generator-expressions(7)).
- `attachedFiles` : **[optional]** a list of paths to files that will be attached to the dashboard submission.
  If these are relative paths, they are relative to the build directory for the package and target. This is
  used to initialize the [`ATTACHED_FILES`](https://cmake.org/cmake/help/latest/prop_test/ATTACHED_FILES.html)
  property on the test.
- `attachedFilesOnFailure` : **[optional]** a list of paths to files that will be attached to the dashboard
  submission if the test fails. This is used to initialize the
  [`ATTACHED_FILES_ON_FAIL`](https://cmake.org/cmake/help/latest/prop_test/ATTACHED_FILES_ON_FAIL.html) property
  on the test.
- `command` : **[required]** the command to be executed. This may be one of the following:
  - the name of an executable module provided by the package itself
  - the name of an executable module in another package of the form `<package>::<module>`, where `<package>`
    is the name of the package containing the module and `<module>` is the name of the executable module
  - a path to a script or executable to be executed. If this is a relative path, the path is relative to the
    directory containing the file that defines the package. If the path is in the build directory, a [Path
    Substitution](./Concepts.md#path-substitutions) can be used instead.
  - a [Generator Expression](https://cmake.org/cmake/help/latest/manual/cmake-generator-expressions.7.html#manual:cmake-generator-expressions(7)).
- `cost` : **[optional]** the cost of the test, which is used to determine the order of execution of tests (in
  descending order of cost). This is used to initialize the
  [`COST`](https://cmake.org/cmake/help/latest/prop_test/COST.html) property on the test. If omitted, the
  default cost is `0`.
- `dependencies` : **[optional]** the list of names of tests upon which this test depends. The tests whose
  names are listed here must finish before this test will start. This is used to initialize the
  [DEPENDS](https://cmake.org/cmake/help/latest/prop_test/DEPENDS.html) property on the test.
- `disabled` : **[optional]** if `true`, the test will not be executed and will be listed as "Not Run". This
  is used to initialize the [`DISABLED`](https://cmake.org/cmake/help/latest/prop_test/DISABLED.html) property
  on the test. If omitted, the test is not disabled.
- `environment` : **[optional]** an object defining the environment variables with which the test will be
  executed, where the keys are the environment variable names and the values are the string values of the
  environment variables. This is used to initialize the
  [`ENVIRONMENT`](https://cmake.org/cmake/help/latest/prop_test/ENVIRONMENT.html) property on the test.
- `environmentModifications` : **[optional]** a list of all modifications to environment variables. This is
  used to initialize the
  [`ENVIRONMENT_MODIFICATION`](https://cmake.org/cmake/help/latest/prop_test/ENVIRONMENT_MODIFICATION.html)
  property on the test. This is an alternative to overriding environment variables with the `environment`
  property. The values in this list are either strings whose format is defined on the definition of the
  [`ENVIRONMENT_MODIFICATION`](https://cmake.org/cmake/help/latest/prop_test/ENVIRONMENT_MODIFICATION.html) or
  alternatively can use the [Environment Modification](#environment-modification) object instead. The list can
  contain any combination of strings or [Environment Modification](#environment-modification) objects.
- `failRegEx` : **[optional]** a regular expression used to determine whether a test failed from the output
  of the command (STDOUT and STDERR). This is used to initialize the
  [`FAIL_REGULAR_EXPRESSION`](https://cmake.org/cmake/help/latest/prop_test/FAIL_REGULAR_EXPRESSION.html) on
  the test. If omitted, the output of the test is not considered in determining the failure of the test.
- `fixtures` : **[optional]** a list of names of [Fixtures](#test-fixture) that are used by the test. This is
  used to initialize the
  [`FIXTURES_REQUIRED`](https://cmake.org/cmake/help/latest/prop_test/FIXTURES_REQUIRED.html) property of the
  test. If omitted, the test requires no fixtures to run.
- `labels` : **[optional]** a list of strings defining lables used to filter the tests. This is used to
  initialize the [`LABELS`](https://cmake.org/cmake/help/latest/prop_test/LABELS.html) property on the test.
- `measurement` : **[optional]** the measurement to report for the test. This is used to initialize the
  [`MEASUREMENT`](https://cmake.org/cmake/help/latest/prop_test/MEASUREMENT.html) property of the test.
- `passRegEx` : **[optional]** a regular expression used to dtermine whether a test passed from the output of
  the command (STDOUT and STDERR). This is used to initialize the
  [`PASS_REGULAR_EXPRESSION`](https://cmake.org/cmake/help/latest/prop_test/PASS_REGULAR_EXPRESSION.html)
  property on the test. If omitted, the output is not considered in the determination of test success.
- `processors` : **[optional]** the number of processor slots the test requires. This is used to initilize the
  [`PROCESSORS`](https://cmake.org/cmake/help/latest/prop_test/PROCESSORS.html) property on the test. If omitted, the default value is `1`.
- `processorAffinity` : **[optional]** if `true`, the test is given affinity to the `processors` given. This
  is used to initialize the
  [`PROCESSOR_AFFINITY`](https://cmake.org/cmake/help/latest/prop_test/PROCESSOR_AFFINITY.html) property on
  the test. If omitted, the processor affinity is not guranteed for the processor slots dedicated to this
  test.
- `requiredFiles` : **[optional]** the list of paths to files that are required to exist for the test to run.
  If relative, the paths are relative to the `workingDirectory` in which the test is run. This is used to
  initialize the [`REQUIRED_FILES`](https://cmake.org/cmake/help/latest/prop_test/REQUIRED_FILES.html)
  property on the test.
- `resourceGroups` : **[optional]** the list of resource groups required by the test. Each entry in this list
  is a [Test Resource Groups](#test-resource-groups) object or a string as defined in the documentation for
  the [RESOURCE_GROUPS](https://cmake.org/cmake/help/latest/prop_test/RESOURCE_GROUPS.html) test property,
  which this list is used to initialize.
- `resourceLocks` : **[optional]** a list of strings defining resources that are locked by this test. Entries
  in this list are guaranteed to cause this test to not run concurrently with another test that locks any of
  the same resources. This is used to initialize the
  [`RESOURCE_LOCK`](https://cmake.org/cmake/help/latest/prop_test/RESOURCE_LOCK.html) property on the test.
- `rules` : **[optional]** the [Test Rules](#test-rule) that alter the test based on certain conditions.
- `runCondition` : **[required]** the [Condition](../JSON.md#condition) under which the test will be run.
  this is omitted, the test will always be run for every target.
- `runSerial` : **[optional]** if `true`, this test will not be run in parallel with any other tests. This is
  used to initialize the [`RUN_SERIAL`](https://cmake.org/cmake/help/latest/prop_test/RUN_SERIAL.html) on the
  test. If omitted, the test may run in parallel with other tests.
- `skipRegEx` : **[optional]** the regular expression used to determine whether a test is to be considered
  skipped by matching against the output (STDOUT and STDERR) of the test. This is used to initialize the
  [`SKIP_REGULAR_EXPRESSION`](https://cmake.org/cmake/help/latest/prop_test/SKIP_REGULAR_EXPRESSION.html)
  property on the test. If omitted, the output of the test will not be considered in determining if the test
  was skipped.
- `skipReturnCode` : **[optional]** the return code of a test that is used to consider a test to be skipped.
  This is used to initialize the
  [`SKIP_RETURN_CODE`](https://cmake.org/cmake/help/latest/prop_test/SKIP_RETURN_CODE.html) property on the
  test. If omitted, the return code will not be considered in determining if the test was skipped.
- `timeout` : **[optional]** the maximum amount of time (in seconds) the test will run before it is
  automatically terminated. This is used to initialize the
  [`TIMEOUT`](https://cmake.org/cmake/help/latest/prop_test/TIMEOUT.html) property on the test. If omitted,
  the test will never timeout unless CTest is run with a timeout option specified.
- `timeoutAfterRegex` : **[optional]** changes the `timeout` of a [Test](#test) when a regular expression is
  matched. The value of this property is a [Timeout Regex](#test-timeout-regex) object. This is used to
  initialize the
  [`TIMEOUT_AFTER_MATCH`](https://cmake.org/cmake/help/latest/prop_test/TIMEOUT_AFTER_MATCH.html) property of
  the test. If omitted, the `timeout` will be used under all conditions of the test.
- `timeoutSignalGracePeriod` : **[conditionally required]** specifies the time (in floating point seconds) to
  wait for a test to terminate after the `timeoutSignal` is sent. This is used to initialize the
  [`TIMEOUT_SIGNAL_GRACE_PERIOD`](https://cmake.org/cmake/help/latest/prop_test/TIMEOUT_SIGNAL_GRACE_PERIOD.html)
  property on the test. This property is required if the `timeoutSignal` property is defined. If omitted, the
  grace period defaults to `1.0` seconds.
- `timeoutSignal` : **[optional]** the name of the signal to be sent to the process when the `timeout` is
  reached. This may be `SIGINT`, `SIGQUIT`, `SIGTERM`, `SIGUSR1`, or `SIGUSR2`. This is used to initialize the
  [`TIMEOUT_SIGNAL_NAME`](https://cmake.org/cmake/help/latest/prop_test/TIMEOUT_SIGNAL_NAME.html) on the test.
  If omitted, no signal is sent to the process to terminate ie when the `timeout` is reached.
- `willFail` : **[optional]** if `true`, the test is expected to fail, meaning the failure status is negated.
  If omitted, the process is expected to succeed. This is used to initialize the
  [`WILL_FAIL`](https://cmake.org/cmake/help/latest/prop_test/WILL_FAIL.html) property on the test.
- `workingDirectory` : **[optional]** the working directory where the test will be executed. If this is a
  relative path, the path is relative to the directory containing the file that defined the package. If a path
  relative to the build directory is desired, a [Path Substitution](./Concepts.md#path-substitutions) can be
  used instead. If this is omitted, the build directory for the package and target is used. This may also be
  defined using a [Generator Expression](https://cmake.org/cmake/help/latest/manual/cmake-generator-expressions.7.html#manual:cmake-generator-expressions(7)).

### Test Fixture

An object representing a [Test Fixture](./Concepts.md#test-fixture) with the following properties:

```json
{
  "cleanupCases" : [],
  "setupCases" : []
}
```

- `cleanupCases` : **[optional]** the names of test cases to be run as cleanup for the test fixture. These
  tests will be run after all tests using the fixture have completed, whether they succeeded or not. This is
  used to initialize the
  [`FIXTURES_CLEANUP`](https://cmake.org/cmake/help/latest/prop_test/FIXTURES_CLEANUP.html) property on the
  associated tests.
- `setupCases` : **[optional]** the names of test cases to be run as setup for the test fixture. These tests
  will be run before all tests using the fixture. This is used to initialize the
  [`FIXTURES_SETUP`](https://cmake.org/cmake/help/latest/prop_test/FIXTURES_SETUP.html) property on the
  associated tests.

### Test Resource Group

An object that defines the resource requirements for a [Resource Groups](#test-resource-groups) definition,
which is in turn used to initialize the
[RESOURCE_GROUPS](https://cmake.org/cmake/help/latest/prop_test/RESOURCE_GROUPS.html) property on a test. The
properties of this object are as follows:

```json
{
    "count" : 1,
    "name" : ""
}
```

- `name` : **[required]** the name of the resource needed by the group.
- `count` : **[required]** the quantity of slots of the resource needed by the group.

### Test Resource Groups

An object that defines test resource groups for the
[RESOURCE_GROUPS](https://cmake.org/cmake/help/latest/prop_test/RESOURCE_GROUPS.html) property on a test. The
properties on this object are as follows:

```json
{
    "count" : 1,
    "resources" : []
}
```

- `count` : **[optional]** the number of groups to define. If omitted, a count of `1` is used.
- `resources` : **[required]** the resources required by the groups. Each entry in this list is a [Test
  Resource Group](#test-resource-group).

### Test Resources

An object defining how to determine what [Test
Resources](https://cmake.org/cmake/help/latest/manual/ctest.1.html#resource-allocation) are available for
tests. Whatever the mechanism, the result should be a [Test
Resources](https://cmake.org/cmake/help/latest/manual/ctest.1.html#resource-specification-file) file that
CTest can use when executing tests. This object has the following properties:

```json
{
    "method" : "",
    "resources" : {}
}
```

- `data` : **[required]** the contents of this property depend on the `method`.
- `method` : **[required]** the method to use to define the resources available for tests. The valid values are:
  - `json` : the available resources data is embedded in this object in the `data` property or via a file
    referenced as a string in the `data` property. The format of the file or the contents of the object in
    `data` are defined in the [Resource Specification
      File](https://cmake.org/cmake/help/latest/manual/ctest.1.html#resource-specification-file)
      documentation. Note that when embedding, the entire contents of that format are included (including the
      version).
  - `test` : a test is executed to generate the resource specification file. In this case, `data` is an object with the following
    properties:
    - `file` : the path to the file that is generated by the test. If relative, this path is relative to the
      working directory of the test. This is used to initialize the
      [GENERATED_RESOURCE_SPEC_FILE](https://cmake.org/cmake/help/latest/prop_test/GENERATED_RESOURCE_SPEC_FILE.html)
      property on the test with the given `name`.
    - `name` : the name of the [Test](#test) to execute.

### Test Rule

An object allowing a [Test](#test) to be modified under certain [Conditions](../JSON.md#condition) with the
following properties:

```json
{
    "arguments" : [],
    "argumentsAppend" : [],
    "argumentsPrepend" : [],
    "attachedFiles" : [],
    "attachedFilesOnFailure" : [],
    "command" : "",
    "cost" : 0,
    "dependencies" : [],
    "disabled" : false,
    "environment" : {},
    "environmentModifications" : [],
    "failRegEx" : "",
    "fixtures" : [],
    "labels" : [],
    "measurement" : "",
    "passRegEx" : "",
    "processors" : 1,
    "processorAffinity" : false,
    "requiredFiles" : [],
    "resourceGroups" : [],
    "resourceLocks" : [],
    "rules" : [],
    "runCondition" : {},
    "runSerial" : false,
    "skipRegex" : "",
    "skipReturnCode" : 0,
    "timeout" : 0,
    "timeoutAfterRegex" : {},
    "timeoutSignalGracePeriod" : 1.0,
    "timeoutSignal" : "",
    "willFail" : false,
    "workingDirectory" : ""
}
```

- `arguments` : **[optional]** the list of arguments to replace the `arguments` defined on the [Test](#test)
  containing the rule. If omitted, the arguments are not replaced. This can be an empty list.
- `argumentsAppend` : **[optional]** specifies a list of arguments to be appended to the `arguments` on the
  [Test](#test) containing the rule.
- `argumentsPrepend` : **[optional]** specifies a list of arguments to be prepended to the `arguments` on the
  [Test](#test) containing the rule.

### Test Timeout Regex

An object that alters the `timeout` of a [Test](#test) when a regular expression matches a line in the output
of the test program (STDOUT and STDERR). The properties of this object are:

```json
{
    "regex" : "",
    "timeout" : 1
}
```

- `regex` : **[required]** the regular expression that will be matched against the output of the test.
- `timeout` : **[required]** the new timout value in seconds.
