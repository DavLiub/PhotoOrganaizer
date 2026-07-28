# Library First Scan Checklist

## Preconditions

- Media permission is granted or limited.
- The app is on the Library tab.

## Checklist

- [ ] Open the Library tab after media access is granted.
  Expected: the Library screen is shown.

- [ ] Verify the Scan button before starting.
  Expected: `Scan` is visible and enabled.

- [ ] Tap `Scan`.
  Expected: foreground scan starts on the Library tab.

- [ ] Observe scan status after tapping `Scan`.
  Expected: a circular activity indicator appears next to the status label.

- [ ] Observe progress while scanning.
  Expected: visible photo count or checking/scanning status updates, and thumbnails appear as batches are indexed.

- [ ] Tap `Stop` while scanning.
  Expected: scanning stops after already found photos are indexed; already indexed photos remain visible.

- [ ] Start scan again after stopping.
  Expected: scan can run again, counts do not reset below the already indexed library size, and already indexed photos remain visible.

- [ ] Wait for scan completion.
  Expected: the Library tab remains visible with indexed photos or a visible error.

- [ ] Verify visible photo count.
  Expected: visible count matches the selected category and accessible media set closely enough for smoke testing.

- [ ] Tap `Scan` again after completion.
  Expected: scan runs again and the UI remains stable.

- [ ] Run with no selected photos if limited access allows it.
  Expected: scan completes without crash and counts remain zero.

- [ ] Rotate the device during or after scan.
  Expected: UI remains readable and controls do not overlap.

- [ ] Switch device locale to Russian and reopen the app.
  Expected: Library labels are shown in Russian.
