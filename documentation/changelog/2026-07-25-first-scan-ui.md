# 2026-07-25 First Scan UI

## Changed

- Added Riverpod for Presentation state.
- Added project-owned English/Russian UI localization.
- Added a two-step Home flow:
  - welcome/media access screen;
  - manual first scan screen.
- Wired the scan UI to Application use cases through providers.
- Added widget tests for denied access, automatic unknown-permission request, scan result counts, and Russian labels.
- Localized current shell and placeholder screen labels.
- Updated project guard diff parsing to handle UTF-8 multilingual UI text on Windows.
- Added manual UI checklists for welcome/access, first scan, navigation, and settings screens.

## Notes

- Protected counts are intentionally not displayed yet.
- Source include/exclude settings remain deferred until sources are visible to the user.
- Manual Android device validation is still required.
