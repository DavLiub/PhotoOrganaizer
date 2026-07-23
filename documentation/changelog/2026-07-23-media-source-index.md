# 2026-07-23 Media Source Index

## Changed

- Added platform-neutral `MediaSource` and `MediaSourceStatus`.
- Added Application `MediaSourceRepository` port.
- Added Drift `media_sources` table and schema version `2`.
- Added nullable `source_id` to persisted photo index rows.
- Added `MediaSourceStore` and mapper.
- Wired media source and photo index repositories through a shared lazy database factory in Bootstrap.
- Added tests for media source model, repository behavior, and photo source id persistence.

## Validation

- `dart analyze lib test`
- `flutter test --reporter compact`
