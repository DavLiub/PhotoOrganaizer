# 2026-07-24 Android Media Scan

## Changed

- Added `photo_manager` as the Android media access dependency.
- Implemented Android image-only media source and photo metadata scanning.
- Added Application `ScanMediaLibrary` orchestration for permission check, source persistence, and photo indexing.
- Replaced Android media permission placeholder with `photo_manager` permission status mapping.
- Added Android read-only image media permissions to the manifest.
- Added unit tests for scan orchestration, permission mapping, and media metadata mapping.

## Notes

- No video scan, thumbnails, full-image reads, or cloud backup behavior was added.
- Manual Android device smoke testing remains pending.
