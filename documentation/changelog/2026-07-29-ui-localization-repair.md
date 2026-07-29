# 2026-07-29 UI Localization Repair

## Changed

- Hid Hebrew from the Settings language selector for Release 1.0.
- Kept English and Russian as the only selectable UI languages.
- Removed unused Hebrew localization keys from the in-code localization map.
- Extended the localization guard to fail on common mojibake markers in user-visible strings.
- Updated Settings localization tests and validation documentation.

## Validation

- `C:\tools\flutter\bin\cache\dart-sdk\bin\dart.exe format --set-exit-if-changed lib test tools`
- `C:\tools\flutter\bin\flutter.bat analyze`
- `C:\tools\flutter\bin\flutter.bat test --tags pr-gate`
- `python tools\ci\architecture_guard.py`
- `python tools\ci\test_import_guard.py`
- `python tools\ci\sdk_leak_guard.py`
- `python tools\ci\secret_guard.py`
- `python tools\ci\localization_guard.py`
- `python tools\ci\test_tag_guard.py`
- `python tools\ci\naming_report.py`
