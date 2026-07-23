# 2026-07-23 Platform Boundary

## Changed

- Added `AppPlatform` and platform-name parsing.
- Added `MediaAdapters` for Bootstrap-owned platform adapter selection.
- Kept Android as the default active platform.
- Added iOS placeholder media permission and media library adapters.
- Added unsupported platform placeholder media adapters.
- Updated composition root to select media adapters through Bootstrap.
- Added tests for Android, iOS, and unsupported platform selection.
- Documented Android-first, iOS-ready architecture boundaries.

## Notes

- No real iOS functionality was implemented.
- No Android media scanning functionality was implemented.
- Platform selection currently affects media adapters only.
