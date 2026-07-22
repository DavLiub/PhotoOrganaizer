# Actual Documentation

This directory describes the implementation as it currently exists in the source code.

## Current State

The repository contains a Flutter Android skeleton with Clean Architecture-style layers:

- `lib/domain`
- `lib/application`
- `lib/infrastructure`
- `lib/presentation`
- `lib/bootstrap`

Business functionality is represented by domain models, application ports, use case shells, infrastructure placeholders, and presentation placeholders.

## Files

- [architecture.md](architecture.md): current module layout and dependency direction.
- [access-model.md](access-model.md): current capability and entitlement access model.
- [data-model.md](data-model.md): currently implemented domain model skeleton.
- [documentation-layout.md](documentation-layout.md): tracked and local documentation structure.
- [library-decisions.md](library-decisions.md): approved dependency and integration direction.
- [ownership.md](ownership.md): current authorship and ownership attribution.
- [validation.md](validation.md): local and CI validation path.

## Synchronization Rule

Whenever code changes architecture, workflow, data model, configuration, or integration behavior, update this directory in the same task.
