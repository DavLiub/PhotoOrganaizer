# 2026-07-28 Settings Configuration Shell

## Changed

- Replaced the bottom navigation `Premium` destination with an `Albums`
  placeholder destination.
- Moved Premium into Settings as a status concept.
- Rebuilt Settings as grouped configuration shell:
  - Status;
  - Storage;
  - Media Library;
  - Backup Configuration;
  - Background Work;
  - Language;
  - About.
- Changed Settings from a long one-column list to a two-level master-detail
  shell:
  - first-level sections on the left;
  - selected section subitems and direct controls on the right;
  - complex subitems open full-screen placeholder editors.
- Added direct local controls for root folder, storage folder layout, backup
  quality, backup switches, background switches, language selection, and
  diagnostics consent.
- Replaced free-form storage path template with:
  - root folder field;
  - all-in-root versus keep-albums radio-style choice;
  - independent year/month grouping checkbox.
- Reworked Backup controls:
  - optimized copies versus original photos;
  - image quality;
  - maximum photo size;
  - keep metadata.
- Disabled quality and maximum size controls when original photos are selected.
- Replaced charging-only and battery optimization rows with a battery threshold
  slider for background work.
- Replaced language dropdown with large flag language cards and selected-state
  checkmark based on the UX source material.
- Improved Settings visual treatment with selected left navigation, soft right
  panels, icon boxes, chips, sliders, and card-style language choices.
- Represented storage as one active backup storage with provider, connected
  account, root folder, folder layout, and year/month grouping.
- Kept Backup Configuration focused on photo backup behavior, not provider
  selection.
- Removed the synthetic `General` section because theme switching and generic
  app preference toggles are not planned yet.
- Kept Media Library focused on global category include/exclude controls that
  should later affect the Library switcher and Albums list.
- Removed the `Refresh behavior` placeholder from Media Library until the
  refresh workflow has a clear home.
- Added local diagnostics consent placeholder under About.
- Normalized `AppLocalizations` to UTF-8 English and Russian strings.
- Added Settings widget tests.
- Updated Settings manual UI checklist and actual documentation.
- Updated navigation and first-scan manual/actual docs from the old Home/Photos wording to the current Library flow.

## Validation

- `C:\tools\flutter\bin\cache\dart-sdk\bin\dart.exe format lib test`
- `python tools\ci\localization_guard.py --all`
- `python tools\ci\test_tag_guard.py --all`
- `python tools\ci\test_tag_guard.py`
- `python tools\ci\localization_guard.py`
- `python tools\ci\secret_guard.py`
- `python tools\ci\architecture_guard.py`
- `python tools\ci\test_import_guard.py`
- `python tools\ci\sdk_leak_guard.py`
- `python tools\ci\naming_report.py`
- `C:\tools\flutter\bin\cache\dart-sdk\bin\dart.exe analyze lib test`
- `flutter test --tags pr-gate` timed out locally after 120 seconds.
- `flutter test test\presentation\settings_screen_test.dart -r expanded` timed out locally after 180 seconds.
- `flutter build apk --debug`
- `adb install -r build\app\outputs\flutter-apk\app-debug.apk`
- `adb shell monkey -p com.davliub.photoorganizer -c android.intent.category.LAUNCHER 1`
