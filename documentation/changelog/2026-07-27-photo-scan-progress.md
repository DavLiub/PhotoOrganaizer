# 2026-07-27 Photo Scan Progress

## Changed

- Added callback-based progress reporting to local media scan and photo indexing.
- Added streaming media batches so discovered photos are indexed before the full scan completes.
- Updated the first scan UI to refresh found, indexed, and source counters while work is running.
- Updated the library UI to show progress counters, reload indexed batches, and keep visible photos while scan/refresh is running.
- Added a cooperative `Stop` action for foreground scan/refresh.
- Added Android scan diagnostic logs under the `PhotoOrganizer.Scan` logger name.

## Validation

- `dart analyze lib test`
- `flutter analyze lib test`
- `flutter test`
