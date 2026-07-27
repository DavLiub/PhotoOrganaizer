# 2026-07-27 Photo Library UI

## Changed

- Added Application photo library read model and `ListLibraryPhotos` use case.
- Added `PhotoThumbnailGateway` and `photo_manager` thumbnail adapter behind Infrastructure.
- Added Photos tab library grid with thumbnails, safe filenames, and backup status.
- Added category filtering for Camera, Social, Downloads, and Screenshots.
- Added Refresh dialog with manual refresh and automatic-refresh settings path.
- Added Backup warning when target storage is not configured.
- Added Riverpod shell destination state so successful first scan opens the library.
- Fixed Russian localization strings and added library UI localization keys.
- Added widget tests for empty, loaded, filtered, refresh, backup warning, Russian labels, and scan-to-library navigation.

## Notes

- Source include/exclude settings are still deferred.
- Automatic refresh scheduling is still deferred.
- Backup target configuration and real backup execution are still deferred.
