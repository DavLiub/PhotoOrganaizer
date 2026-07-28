# Manual UI Checklists

This directory contains manual UI verification checklists.

Use these checklists during Android device smoke testing when a UI change cannot be fully validated by automated widget tests.

## Rules

- Use one checklist per screen or stable workflow.
- Write checks as user action -> expected result.
- Keep checks specific enough to reproduce on a real phone.
- Record device model, Android version, app build, and permission mode before testing.
- Do not treat a checklist as complete if the expected result was only assumed.

## Checklists

- [home-welcome.md](home-welcome.md): welcome screen and media permission request.
- [home-first-scan.md](home-first-scan.md): manual local scan screen.
- [navigation-shell.md](navigation-shell.md): app shell, tabs, and settings entry.
- [photo-library.md](photo-library.md): indexed photo grid, category filters, refresh, and backup warning.
- [settings.md](settings.md): grouped settings configuration shell.
- [android-device-validation.md](android-device-validation.md): repeated real-device validation for PRs, night checks, and pre-release sanity.

## Test Record Template

```text
Date:
Tester:
Device:
Android version:
App build:
Locale:
Permission mode:
Checklist:
Result: Pass / Fail
Notes:
```
