# Android Media Scan

## Current Scope

Android photo discovery is implemented through `photo_manager` inside Infrastructure.

The scan is image-only. Video, thumbnails, full-image reads, checksums, and cloud backup are out of scope for this implementation.

## Application Flow

`ScanMediaLibrary` is the Application entry point for local photo discovery.

Flow:

```text
ScanMediaLibrary
  -> MediaPermissionGateway.currentStatus
  -> MediaLibraryGateway.scanLibrary
  -> MediaSourceRepository.upsertSources
  -> IndexPhotos
```

If permission is denied or unavailable, scanning is skipped and a structured permission failure is returned.

If source persistence fails, photo indexing is skipped and a structured storage failure is returned.

## Android Adapter

`AndroidMediaLibraryGateway` uses:

- `PhotoManager.getAssetPathList(hasAll: false, type: RequestType.image)`
- `AssetPathEntity.assetCountAsync`
- `AssetPathEntity.relativePathAsync`
- `AssetPathEntity.getAssetListPaged(page, size, type: RequestType.image)`
- `AssetEntity.id`
- `AssetEntity.title` / `titleAsync`
- `AssetEntity.mimeType` / `mimeTypeAsync`
- `AssetEntity.fileSize`
- `AssetEntity.createDateTime`
- `AssetEntity.modifiedDateTime`
- `AssetEntity.width`
- `AssetEntity.height`

Default page size is `100`.

## Mapping Rules

Plugin types do not leave Infrastructure.

Media source mapping:

- provider: `photo_manager`
- source id: `photo_manager:<albumId>`
- `albumId`: raw `AssetPathEntity.id`
- `pathHint`: `AssetPathEntity.relativePathAsync`
- source name: `AssetPathEntity.name`

Photo mapping:

- asset id: `AssetEntity.id`
- source URI: `photo-manager://asset/<assetId>`
- source id: mapped media source id
- file size and timestamps come from `AssetEntity`
- MIME type comes from plugin metadata, with extension fallback

Photos are deduplicated by asset id inside a single scan result.

## Permissions

`AndroidMediaAccess` uses `PhotoManager` with `RequestType.image`.

Android manifest declares:

- `READ_EXTERNAL_STORAGE` up to SDK 32
- `READ_MEDIA_IMAGES`
- `READ_MEDIA_VISUAL_USER_SELECTED`

Media location is not requested.

## Known Limitations

- No manual Android device smoke test has been executed yet.
- Limited access indexes only assets visible to the app.
- The scan does not generate thumbnails.
- The scan does not read or copy full image bytes.
- Deleted or inaccessible local photos are not marked yet.
- Source include/exclude settings are not implemented yet.
