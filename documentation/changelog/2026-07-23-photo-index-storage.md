# 2026-07-23 Photo Index Storage

## Changed

- Added Drift-backed SQLite storage for the local photo index.
- Added schema version `1` with the `photo_index_entries` table.
- Implemented `LocalPhotoIndexRepository` behind the Application repository port.
- Added in-memory repository tests for lookup, upsert, idempotency, and protection summary streaming.
- Documented that media source catalog persistence, backup queue state, and cloud ids are deferred.

## Validation

- `dart analyze lib test`
- `flutter test --reporter compact`
