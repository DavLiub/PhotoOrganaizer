# 2026-07-28 Testing Tags And Nightly Validation

## Changed

- Added `dart_test.yaml` with project test tags:
  - `smoke`
  - `ci-gate`
  - `extended`
  - `sanity`
  - `pr-gate`
  - `night`
- Tagged all current tests as `ci-gate`, `pr-gate`, and `night`.
- Tagged `test/app_smoke_test.dart` as `smoke`.
- Reused the `Tags` annotation exported by `flutter_test`.
- Changed PR workflow test command to `flutter test --tags pr-gate`.
- Added scheduled/manual `Nightly Tests` workflow with:
  - `flutter test --tags night`;
  - full project guards with `--all`;
  - debug APK build.
- Added `tools/ci/test_tag_guard.py` to block unclassified test files.
- Added `tools/ci/localization_guard.py` to block mismatched supported locales
  and translation keys.
- Added both guards to PR validation and nightly full-project validation.
- Documented PR Gate vs Night validation and the independent test type/run
  profile tag axes.
- Added Android device validation checklist.
- Updated contributor/local development commands to use tagged test profiles.

## Validation

- `C:\tools\flutter\bin\cache\dart-sdk\bin\dart.exe pub get`
- `C:\tools\flutter\bin\cache\dart-sdk\bin\dart.exe format .`
- `C:\tools\flutter\bin\cache\dart-sdk\bin\dart.exe analyze lib test`
- `python tools\ci\architecture_guard.py`
- `python tools\ci\test_import_guard.py`
- `python tools\ci\sdk_leak_guard.py`
- `python tools\ci\secret_guard.py`
- `python tools\ci\test_tag_guard.py`
- `python tools\ci\localization_guard.py`
- `python tools\ci\test_tag_guard.py --all`
- `python tools\ci\localization_guard.py --all`
- `python tools\ci\naming_report.py`
- `flutter test --tags pr-gate` was not completed locally because
  `flutter.bat` timed out in the local shell.
