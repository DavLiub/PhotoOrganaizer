# Actual Data Model

## Implemented Skeleton Models

The current codebase contains Dart model classes for the initial domain shape:

- `PhotoAsset`
- `PhotoIdentity`
- `PhotoIndexEntry`
- `PhotoIndexStatus`
- `IndexScope`
- `IndexScopeMode`
- `BackupProfile`
- `BackupJob`
- `BackupRecord`
- `CloudAccount`
- `ProtectionSummary`
- `OperationResult`
- `FailureInfo`
- `FailureKind`
- `AccessProfile`
- `AccessDecision`
- `Capability`
- `AccessTier`
- `MediaPermission`
- `MediaPermissionState`

## Current Persistence State

The project uses Drift for the first local SQLite persistence implementation.

Implemented database:

- `AppDatabase`
- schema version `1`
- table `photo_index_entries`

`LocalPhotoIndexRepository` implements the Application `PhotoIndexRepository` port using this table. Drift classes, generated rows, and SQLite details remain inside Infrastructure.

## Current Data Model Boundaries

- Domain models are platform-independent.
- Application use cases work through ports.
- Infrastructure is expected to translate platform and storage details into Application-level abstractions.

## Known Deviations

The original specification describes a fuller logical data model with persistence rules and migrations. The current implementation intentionally contains only skeleton-level models until storage technology and schema are selected.

## Persistence Direction

Drift is the approved persistence technology for local state. The first implemented schema persists photo index entries only.

## Photo Index State

Local photo identity is currently derived from:

- local asset id;
- file size;
- creation timestamp;
- modification timestamp.

`PhotoIndexEntry` is the current in-memory/domain representation of an indexed local photo. It stores the current identity, local asset metadata, index status, and index/update timestamps.

Index statuses:

- `indexed`
- `pendingBackup`
- `protected`
- `failed`
- `ignored`

Repeated scan results for the same local asset id refresh the existing entry instead of creating duplicates. If file size or modification timestamp changes, the entry keeps its stable index id and receives a new identity.

True duplicate detection across different local asset ids is not implemented yet because no checksum or perceptual hash exists.

The physical photo index schema currently stores the local asset metadata snapshot together with the index entry status and timestamps. Backup state, retry metadata, cloud ids, and media source catalog records are not persisted yet.

## Access Model State

Access state is currently modeled in memory only. There is no persisted entitlement schema yet.

Current access model concepts:

- capability being requested;
- access tier;
- entitlement state;
- decision status;
- decision reason;
- optional free-tier limit.

## Error Model State

Operation failures are currently represented by `FailureInfo` and `FailureKind`.

This model is not persisted. It is workflow/result metadata used by application ports, use cases, and observability adapters.

## Media Permission State

Media permission state is represented by `MediaPermission` and `MediaPermissionState`.

This state is runtime workflow metadata and is not persisted in the current implementation.

## Backup State

Backup lifecycle is modeled in Domain only.

Per-photo `BackupRecordStatus` values:

- `queued`
- `uploading`
- `uploaded`
- `confirmed`
- `failed`
- `cancelled`

Retry metadata on `BackupRecord`:

- attempt count;
- last attempt timestamp;
- next retry timestamp;
- last failure code.

Retryable failures return records to `queued` and keep retry metadata. Non-retryable failures move records to `failed`.

Backup process `BackupJobStatus` values:

- `queued`
- `running`
- `completed`
- `paused`
- `failed`
- `cancelled`

`paused` is a job/process state only, not a per-photo state. Local photo deletion remains out of scope.
