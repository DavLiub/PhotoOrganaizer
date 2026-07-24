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
- [app-identity.md](app-identity.md): current app name, package identifiers, versioning, and signing policy.
- [android-media-scan.md](android-media-scan.md): current Android photo discovery, source mapping, and scan workflow.
- [backup-state.md](backup-state.md): current backup job and per-photo record state machine.
- [data-model.md](data-model.md): currently implemented domain model skeleton.
- [documentation-layout.md](documentation-layout.md): tracked and local documentation structure.
- [error-model-observability.md](error-model-observability.md): current failure model and observability boundary.
- [library-decisions.md](library-decisions.md): approved dependency and integration direction.
- [media-permissions.md](media-permissions.md): current media permission boundary and privacy rules.
- [media-source-index.md](media-source-index.md): current media source and album catalog model.
- [ownership.md](ownership.md): current authorship and ownership attribution.
- [photo-index.md](photo-index.md): current local photo index domain and application model.
- [platform-boundary.md](platform-boundary.md): current Android-first, iOS-ready platform adapter boundary.
- [storage.md](storage.md): current Drift database schema and storage adapter behavior.
- [validation.md](validation.md): local and CI validation path.

## Synchronization Rule

Whenever code changes architecture, workflow, data model, configuration, or integration behavior, update this directory in the same task.
