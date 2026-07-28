# 2026-07-27 Library Scan Status

## Changed

- Changed Library scan status text to distinguish existing-index checking from
  active scanning.
- Kept the circular scan activity indicator visible next to the status label
  while foreground scan is running.
- Added `Checking X/Y` status when a scan starts with an existing persisted
  library index.
- Added `Scanning N photos` status when checking reaches the baseline or newly
  discovered photos exceed the existing index size.
- Kept the normal idle label as the visible photo count.

## Validation

- `C:\tools\flutter\bin\cache\dart-sdk\bin\dart.exe format ...`
- `C:\tools\flutter\bin\cache\dart-sdk\bin\dart.exe analyze lib test`
- `python tools\ci\architecture_guard.py --all`
- `python tools\ci\test_import_guard.py --all`
- `python tools\ci\sdk_leak_guard.py --all`
- `python tools\ci\secret_guard.py --all`
- `flutter test test\presentation\photo_library_ui_test.dart` was not completed
  because `flutter.bat` and direct `flutter_tools.dart` execution timed out in
  the local shell.
