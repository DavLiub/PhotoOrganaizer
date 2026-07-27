# Home Welcome Checklist

## Preconditions

- App is installed as a debug build.
- Media permission is not granted, or app data was cleared before the test.

## Checklist

- [ ] Open the app.
  Expected: the Home tab shows the welcome/media access screen.

- [ ] Verify the welcome title and explanation.
  Expected: the screen explains that photo access is required before scanning.

- [ ] Verify the photo access card.
  Expected: current media permission status is visible.

- [ ] Verify the Scan action before granting permission.
  Expected: `Scan` is not visible on the welcome screen.

- [ ] Tap `Grant access`.
  Expected: Android media permission prompt is shown, or permission state refresh starts.

- [ ] Deny media permission in the Android prompt.
  Expected: the app stays on the welcome screen and explains that it cannot work without media access.

- [ ] Tap `Grant access` again after denial.
  Expected: the app requests access again if Android allows another request.

- [ ] Grant full media access.
  Expected: the app navigates to the first scan screen and `Scan` is enabled.

- [ ] Repeat with limited media access if Android offers it.
  Expected: the app navigates to the first scan screen and scans only selected photos.

- [ ] Switch device locale to Russian and reopen the app.
  Expected: welcome screen labels are shown in Russian.
