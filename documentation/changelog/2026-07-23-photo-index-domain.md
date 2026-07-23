# 2026-07-23 Photo Index Domain

## Changed

- Refined `PhotoIdentity` to use local asset id, file size, creation timestamp, and modification timestamp.
- Extended `PhotoAsset` with creation/modification timestamps and optional album/source metadata.
- Added `PhotoIndexEntry`, `PhotoIndexStatus`, `IndexScope`, and `IndexScopeMode`.
- Added protection summary aggregation from photo index entries.
- Updated `PhotoIndexRepository` for asset-id lookup, identity lookup, and entry upsert.
- Added `IndexPhotos` and `ResolvePhotoIdentity`.
- Wired photo index use cases through the composition root.
- Added tests for identity, scope filtering, index entries, summary aggregation, indexing idempotency, permission failures, and storage failures.

## Notes

- No database schema or persistence implementation was added.
- No Android media scanning was added.
- No checksum, perceptual hash, or true duplicate detection was added.
- Photo artifacts and variants are deferred.
