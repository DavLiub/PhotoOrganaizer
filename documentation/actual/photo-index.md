# Photo Index

## Current Scope

The current implementation defines the Domain/Application photo index slice, a Drift-backed Infrastructure storage adapter, and Android photo metadata scanning. It does not include cloud backup, thumbnails, video, or image hashing.

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

The current scope model is Domain-only. Android album/source mapping will use the media source catalog when the Android media scan adapter is implemented.

## Application Use Cases

Application exposes:

- `IndexPhotos`
- `ScanMediaLibrary`
- `ResolvePhotoIdentity`
- existing `ObserveProtectionSummaryUseCase`

`IndexPhotos` checks media permission through `MediaPermissionGateway` before writing index entries. If photo access is not available, it returns a structured permission failure.

`ScanMediaLibrary` checks permission, scans Android-visible photo metadata through `MediaLibraryGateway`, upserts media sources, and then delegates photo writes to `IndexPhotos`.

## Repository Port And Storage

`PhotoIndexRepository` supports:

- lookup by local asset ids;
- lookup by `PhotoIdentity`;
- upsert of `PhotoIndexEntry` records;
- protection summary stream.

`LocalPhotoIndexRepository` implements this port with Drift. The repository maps between project Domain models and the generated `photo_index_entries` row model through an Infrastructure mapper.

The default database is created lazily so Bootstrap can construct the composition root without opening SQLite. Repository tests use an in-memory Drift database.

## Physical Schema

Schema version `2` contains the photo index table:

- `photo_index_entries`

The table stores stable index id, current identity key, local asset id, optional source id, source metadata, file metadata, availability status, index status, and index/update timestamps.

## Known Limitations

- No image checksum or perceptual hash exists yet.
- True duplicate detection across different local assets is not implemented.
- Cloud copies, optimized files, thumbnails, and other variants are not modeled yet.
- Backup queue state, retry counters, and cloud object ids are not part of this table.
- Deleted or inaccessible Android assets are not reconciled into existing index rows yet.
