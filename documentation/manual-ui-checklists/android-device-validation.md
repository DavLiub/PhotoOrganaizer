# Android Device Validation Checklist

## Preconditions

- Debug APK is built from the branch under test.
- Android developer mode and USB debugging are enabled.
- Test device is connected with `adb devices -l`.

## Device Record

```text
Date:
Tester:
Device model:
Android version:
App build:
Locale:
Permission mode:
Branch/commit:
Result: Pass / Fail
Notes:
```

## Checklist

- [ ] Install the debug APK with `adb install -r`.
  Expected: install completes successfully without uninstalling app data unless
  the scenario explicitly requires a clean install.

- [ ] Launch the app from the device launcher.
  Expected: app opens without crash and shows the current first screen.

- [ ] Verify media permission flow.
  Expected: if permission is missing, the app asks for photo/media access and
  scan remains unavailable until permission is granted.

- [ ] Run foreground Library scan.
  Expected: `Scan` changes to `Stop`, the activity indicator is visible, and
  Library status updates while the grid remains responsive.

- [ ] Stop foreground scan.
  Expected: scan stops cooperatively, already indexed photos remain visible,
  and the app stays usable.

- [ ] Force-close and reopen the app.
  Expected: persisted local photo index is loaded and previously indexed photos
  are visible without requiring a new scan.

- [ ] Start scan again with an existing index.
  Expected: status starts as `Checking X/Y`, then switches to `Scanning N photos`
  if new photos are discovered or checking passes the existing baseline.

- [ ] Verify category filtering and sorting.
  Expected: category filters and sort control update only the visible grid, not
  media permissions or persisted source settings.

- [ ] Tap `Backup (X%)` before backup configuration exists.
  Expected: app shows a safe warning and offers navigation to Settings.

- [ ] Rotate the device.
  Expected: main Library UI remains readable without overlapping controls.
