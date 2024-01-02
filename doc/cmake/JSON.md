# CMake Extension JSON Format <!-- omit in toc -->

## Table of Contents <!-- omit in toc -->

## Extensions

### CMake Package Extension

```json
{
    "tests" : {},
    "testFixtures" : {}
}
```

## Reference

### Test Suite

This object represents a [Test Suite](./Concepts/#test-suite) and has the following properties:

```json
{
  "cases" : [],
  "extension" : [
  "fixtures" : [],
  "name" : "",
}
```

### Test Case

The [Test Case](./Concepts.md#test-case) is an object with the following properties:

```json
{
  "arguments" : [],
  "environment" : {},
  "executable" : "",
  "failureExpected" : false,
  "failReturnCodes" : [],
  "failOutputExpressions" : [],
  "fixtures" : [],
  "name" : [],
  "passReturnCodes" : [],
  "passOutputExpressions" : [],
  "preTests" : [],
  "postTests" : [],
  "rules" : [],
  "runCondition" : {},
  "workingDir" : ""
}
```

### Test Fixture

An object representing a [Test Fixture](./Concepts.md#test-fixture) with the following properties:

```json
{
  "cleanupCases" : "",
  "name" : "",
  "setupCases" : ""
}
```
