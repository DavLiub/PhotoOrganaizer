# 2026-07-29 App Settings And Language

## Changed

- Added app-level settings model, repository port, and read/save locale use cases.
- Added `AppSettingsStore` backed by a separate `app_settings` table.
- Bumped Drift schema version to `4` and added migration for app settings.
- Connected `MaterialApp.locale` to persisted app language override through Riverpod.
- Updated Settings language selection so English/Russian apply immediately and persist.
- Documented null locale override behavior in ADR `0022`.

## Validation

- `C:\tools\flutter\bin\cache\dart-sdk\bin\dart.exe format --set-exit-if-changed lib test tools`
- `C:\tools\flutter\bin\flutter.bat analyze`
- `C:\tools\flutter\bin\flutter.bat test --tags pr-gate`
- `C:\tools\flutter\bin\flutter.bat build apk --debug`
- `python tools\ci\architecture_guard.py`
- `python tools\ci\test_import_guard.py`
- `python tools\ci\sdk_leak_guard.py`
- `python tools\ci\secret_guard.py`
- `python tools\ci\localization_guard.py --all`
- `python tools\ci\test_tag_guard.py`
- `python tools\ci\naming_report.py`
