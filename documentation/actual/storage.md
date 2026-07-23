# Actual Storage

## Current State

Local persistence is implemented with Drift in `lib/infrastructure/storage`.

Implemented components:

- `AppDatabase`
- `PhotoIndexEntries`
- `LocalPhotoIndexRepository`
- `photo_index_mapper.dart`

## Database

The default database name is `photo_organizer`.

`AppDatabase.defaults()` uses Drift's Flutter database factory and is created lazily by `LocalPhotoIndexRepository` on first repository access. This keeps Bootstrap construction side-effect free in tests and app startup wiring.

Schema version: `1`

## Tables

### `photo_index_entries`

Stores the current local photo index entry.

Columns:

- `id`
- `asset_id`
- `identity_key`
- `source_uri`
- `source_provider`
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

## Repository Behavior

`LocalPhotoIndexRepository` supports:

- lookup by asset ids;
- lookup by photo identity key;
- upsert of photo index entries;
- protection summary streaming from stored rows.

Drift row classes and companions do not leave Infrastructure. Application and Domain continue to use project-owned models.

## Known Limitations

- No media source or album catalog table exists yet.
- No backup queue, retry, cloud object, or variant tables exist yet.
- No explicit secondary indexes are tuned yet.
- Migration behavior is limited to initial schema creation.
