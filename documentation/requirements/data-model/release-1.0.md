# Data Model Release 1.0

## Purpose

The data model must support reliable photo identity, local indexing, cloud backup status, retry, and user-facing protection state.

## Core Concepts

- Photo asset: local media item discovered on the device.
- Photo identity: stable identity used for deduplication.
- Backup profile: configured backup target and policy.
- Cloud account: connected cloud provider account.
- Backup job: unit of background work.
- Backup record: persisted result of a backup attempt or completed upload.
- Protection summary: aggregate view shown to the user.

## Persistence Expectations

The local store must support:

- idempotent writes;
- lookup by stable photo identity;
- backup status transitions;
- retry metadata;
- timestamps for scan, queue, upload, and completion events;
- migration between schema versions.

## Current Implementation Note

The current repository contains skeleton Domain models only. A concrete database schema, migrations, and persistence engine are not implemented yet.

## Integrity Requirements

- Duplicate local photos must not create duplicate cloud uploads.
- Cloud identifiers must be stored after successful upload.
- Partial failures must remain recoverable.
- User-facing status must be derived from persisted state, not transient UI state.
