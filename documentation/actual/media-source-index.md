# Actual Media Source Index

## Current Scope

The current implementation defines a platform-neutral media source catalog, stores it locally with Drift, and populates it from Android-visible photo albums through `photo_manager`.

## Model

`MediaSource` represents a source/album visible to the app.

Fields:

- `id`
- `provider`
- `name`
- `pathHint`
- `assetCount`
- `lastSeenAt`
- `availabilityStatus`
- `cameraLike`
- `systemLike`

Statuses:

- `available`
- `missing`
- `inaccessible`

`canIndex` is true only when the source is available and has at least one asset.

## Photo Link

`PhotoAsset` has an optional `sourceId`.

`sourceId` links a photo to the project-owned media source catalog. `albumId` remains raw platform metadata from Android/iOS adapters.

## Storage

Drift schema version `2` adds:

- `media_sources`
- nullable `photo_index_entries.source_id`

`MediaSourceStore` implements the Application `MediaSourceRepository` port.

## Platform Boundary

The model intentionally avoids mandatory filesystem paths.

Android bucket ids, Android album names, iOS PhotoKit collections, and future provider-specific source details must be mapped inside Infrastructure before reaching Application or Domain.

Current Android source id format:

```text
photo_manager:<albumId>
```

`albumId` remains the raw `AssetPathEntity.id` from `photo_manager`.

## Known Limitations

- No user-facing include/exclude source settings exist yet.
- No explicit source relationship constraint exists between `photo_index_entries.source_id` and `media_sources.id`.
- Source id normalization may still change if a native Android adapter replaces `photo_manager`.
