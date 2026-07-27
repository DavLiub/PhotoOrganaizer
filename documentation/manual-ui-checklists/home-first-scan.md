# Home First Scan Checklist

## Preconditions

- Media permission is granted or limited.
- The app is on the Home tab.

## Checklist

- [ ] Open the Home tab after media access is granted.
  Expected: the first scan screen is shown.

- [ ] Verify the Scan button before starting.
  Expected: `Scan` is visible and enabled.

- [ ] Tap `Scan`.
  Expected: the button becomes disabled while scanning starts.

- [ ] Observe scan status after tapping `Scan`.
  Expected: the screen shows an in-progress state.

- [ ] Wait for scan completion.
  Expected: the screen shows scan completion or a visible error.

- [ ] Verify found photo count.
  Expected: found photo count matches the selected/full accessible media set closely enough for smoke testing.

- [ ] Verify indexed photo count.
  Expected: indexed photo count is greater than zero when accessible photos exist.

- [ ] Verify source count.
  Expected: source count is greater than zero when accessible photos exist.

- [ ] Tap `Scan` again after completion.
  Expected: scan runs again and the UI remains stable.

- [ ] Run with no selected photos if limited access allows it.
  Expected: scan completes without crash and counts remain zero.

- [ ] Rotate the device during or after scan.
  Expected: UI remains readable and controls do not overlap.

- [ ] Switch device locale to Russian and reopen the app.
  Expected: first scan labels are shown in Russian.
