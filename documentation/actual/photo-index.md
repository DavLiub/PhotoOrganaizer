# Photo Index

## Current Scope

The current implementation defines the Domain/Application photo index slice. It does not include Android media scanning, database persistence, cloud backup, or image hashing.

## Identity

`PhotoIdentity` is derived from:

- local media asset id;
- file size;
- creation timestamp;
- modification timestamp.

This identity is used to detect whether a discovered local asset still represents the same known local photo version.

## Index Entry

`PhotoIndexEntry` links:

- stable index entry id;
- current `PhotoIdentity`;
- current `PhotoAsset` metadata;
- `PhotoIndexStatus`;
- indexed timestamp;
- updated timestamp.

When the same local asset id is seen again, the existing entry is refreshed instead of creating a duplicate row. If file size or modification timestamp changes, the entry keeps its index id and receives the new identity.

## Statuses

Current statuses:

- `indexed`
- `pendingBackup`
- `protected`
- `failed`
- `ignored`

`protected` means backup protection has been confirmed by later backup workflows. Full backup state transitions remain out of scope until the backup state machine PR.

## Index Scope

`IndexScope` models indexing selection before Android implementation:

- all photos;
- camera only;
- custom albums;
- excluded album ids;
- excluded source names;
- screenshot inclusion flag.

The current scope model is Domain-only. Android album/source mapping is deferred.

## Application Use Cases

Application exposes:

- `IndexPhotos`
- `ResolvePhotoIdentity`
- existing `ObserveProtectionSummaryUseCase`

`IndexPhotos` checks media permission through `MediaPermissionGateway` before writing index entries. If photo access is not available, it returns a structured permission failure.

## Repository Port

`PhotoIndexRepository` supports:

- lookup by local asset ids;
- lookup by `PhotoIdentity`;
- upsert of `PhotoIndexEntry` records;
- protection summary stream.

The current Infrastructure implementation is still a placeholder. Real persistence is deferred to the storage schema PR.

## Known Limitations

- No physical database schema exists yet.
- No image checksum or perceptual hash exists yet.
- True duplicate detection across different local assets is not implemented.
- Cloud copies, optimized files, thumbnails, and other variants are not modeled yet.
