# Actual Storage

## Current State

Local persistence is implemented with Drift in `lib/infrastructure/storage`.

Implemented components:

- `AppDatabase`
- `PhotoIndexEntries`
- `MediaSources`
- `LocalPhotoIndexRepository`
- `LocalMediaSourceRepository`
- `photo_index_mapper.dart`
- `media_source_mapper.dart`

## Database

The default database name is `photo_organizer`.

`AppDatabase.defaults()` uses Drift's Flutter database factory and is created lazily by storage repositories on first repository access. Bootstrap passes a shared lazy database factory to the photo index and media source repositories.

Schema version: `2`

## Tables

### `photo_index_entries`

Stores the current local photo index entry.

Columns:

- `id`
- `asset_id`
- `identity_key`
- `source_uri`
- `source_provider`
- `source_id`
- `source_name`
- `album_id`
- `filename`
- `mime_type`
- `file_size`
- `created_at`
- `modified_at`
- `discovered_at`
- `last_seen_at`
- `availability_status`
- `width`
- `height`
- `status`
- `indexed_at`
- `updated_at`

`id` is the primary key. Date values are normalized to UTC when mapped between Drift rows and Domain models.

### `media_sources`

Stores the current platform-neutral media source or album catalog.

Columns:

- `id`
- `provider`
- `name`
- `path_hint`
- `asset_count`
- `last_seen_at`
- `availability_status`
- `camera_like`
- `system_like`

`id` is the primary key. `path_hint` is optional and must remain a hint, not a required filesystem path.

## Repository Behavior

`LocalPhotoIndexRepository` supports:

- lookup by asset ids;
- lookup by photo identity key;
- upsert of photo index entries;
- protection summary streaming from stored rows.

`LocalMediaSourceRepository` supports:

- lookup of all media sources;
- lookup by source id;
- upsert of media sources;
- media source list streaming from stored rows.

Drift row classes and companions do not leave Infrastructure. Application and Domain continue to use project-owned models.

## Known Limitations

- No backup queue, retry, cloud object, or variant tables exist yet.
- No explicit secondary indexes are tuned yet.
- Migration behavior currently creates `media_sources` and adds nullable `source_id` when upgrading from schema version `1`.
