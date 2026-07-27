# 2026-07-27 Photo Scan Progress

## Changed

- Added callback-based progress reporting to local media scan and photo indexing.
- Updated the first scan UI to refresh found, indexed, and source counters while work is running.
- Updated the library refresh UI to show progress counters instead of a spinner-only state.
- Added Android scan diagnostic logs under the `PhotoOrganizer.Scan` logger name.

## Validation

- `dart analyze lib test`
- `flutter analyze lib test`
- `flutter test`
