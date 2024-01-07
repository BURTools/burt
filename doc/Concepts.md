# Burt Concepts <!-- omit in toc -->

## Table of Contents <!-- omit in toc -->

### Declarative

### Project

Burt uses the term Project to refer to the contents of a repository. Each source code repository that uses
Burt for its build system is expected to define a [Project File](./JSON.md#project-file) in the root of the
repository, which Burt then uses to understand what is defined in the repository, such as
[Packages](#package), [Modules](#module), [Plugins](#plugin) and even information about the
[Repository](#repository) itself.

In order for Burt to be efficient, it depends on the Project to declare where everything is in the repository.
As such, all of the contents of the [Project File](./JSON.md#project-file) and any of the other optional [JSON
Files](./JSON.md#files) must be discoverable from the [Project File](./JSON.md#project-file) in the root of
the repository. This alleviates the need for a discovery of these things by scouring the file system.

#### Repository

In order for packages to be able to advertise their sources, Burt needs a definition of where the repository
is located. Since the source code management cannot provide this in a reliable way, Burt depends on it being
defined in the [Project File](./JSON.md#project). Depending on the circumstances, Burt may simply need a URL
for repository, which it will deduce what source code management system is used from the supported [Version
Control Systems](./Compatibility#version-control-systems). By default, the following rules are applied:

- If it is a valid URL matching a pattern `^https?`, then it is assumed to be a Git repository hosted at a
  given URL.
- If it is a simple `user/repo` kind of format, where `user` is the owner of the repository and `repo` is the
  name of the repository, it is assumed to be a Git repository hosted on [GitHub](https://github.com) at an
  address of `https://github.com/user/repo.git`.
- `github:user/repo` is analogous to the above.
- `bitbucket:user/repo` is assumed to be a Git repository hosted on [Bitbucket](https://bitbucket.com) at an
  address of `https://bitbucket.com/user/repo.git`
- `gitlab:user/repo` is analogous to 

##### Branch Types

##### Versioning

### Package

### Package Provider

### Package Rules

### Package Dependencies

### Exported

### Bundle

### Deploy

### App Store

### Module

### Module Rules

### Module Dependencies

### Module Sources

### Extensions

#### Extension Commands

##### Arguments

#### Extension Functions

#### Extension Hooks

#### Extension Configuration Options

#### Extension Services

#### Feature Branches

#### Release Branches

#### Tool Dependencies

### Rules

### Project Rules

### Profile

A profile refers to a description of a specific environment in which software runs, including but not limited
to operating system, CPU architecture, and any other platform-specific differentiation between environments in
which software can run. This is used to describe both the environment in which the software is being built
will run, but also the environment in which the build is done. This means it is used to help determine
packages that supply tooling that can run on the host machine as well as producing a build for some
cross-compiled platform. The profile for the environment where the build is occurring can match the profile
for the environment where the build artifacts will be able to run, but it can also represent a scenario where
they don't match, aka [Cross Compiling](#cross-compiling).

Profiles are used throughout Burt's [Files](./JSON.md#files) to indicate the profile for which a
[Package](#package) is applicable, to define [Conditions](#conditions), and a whole host of functionality in
between. Anything that would be contextual to a particular environment uses this common declaration of a
Profile to communicate that concept.

### Cross Compiling

### Test Suite

### Test Case

### Test Fixture

### Extension Schemas

### Extension Properties

### Packages as Source

#### Embedded Package Source
