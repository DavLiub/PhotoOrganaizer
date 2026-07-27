# Photo Library Checklist

## Preconditions

- App is installed as a debug build.
- Media permission is granted or can be granted during the check.

## Checklist

- [ ] Open the app without media permission.
  Expected: Library shows the permission request state and `Grant access`.

- [ ] Grant media permission.
  Expected: the app stays on the Library flow and `Scan` becomes available.

- [ ] Verify the top controls.
  Expected: `All`, `Camera`, `Social`, `Downloads`, and `Screenshots` are available as a segmented filter.

- [ ] Verify sort and count row.
  Expected: `Date ↓` and the current visible photo count are shown on one line.

- [ ] Tap `Scan` with an empty or old index.
  Expected: `Scan` changes to `Stop`; photo tiles begin appearing before the full scan completes.

- [ ] Observe scan progress.
  Expected: the visible photo count and thumbnail grid update live; `Indexed photos` and `Sources` are not shown.

- [ ] Verify photo tiles.
  Expected: each indexed photo appears as a thumbnail tile with safe filename and `No backup` status.

- [ ] Select `Screenshots`.
  Expected: the grid shows only screenshot-category photos; no include/exclude setting is changed.

- [ ] Select `All`.
  Expected: the full indexed grid is visible again.

- [ ] Open the sort control and choose `Name A-Z`.
  Expected: the selected sort label changes. Actual ordering can remain unchanged until sorting implementation is added.

- [ ] Tap `Stop` during scan.
  Expected: scan stops after already found photos are indexed, and already indexed photos remain visible.

- [ ] Tap `Scan` again after stopping.
  Expected: visible photo count starts from the current library size rather than dropping to zero.

- [ ] Verify bottom navigation.
  Expected: Library is the first tab, and Settings is available as a bottom tab.

- [ ] Tap `Backup (X%)`.
  Expected: a warning says backup target storage is not configured.

- [ ] In the backup warning, tap `Go to settings`.
  Expected: the app selects the Settings tab.

- [ ] Switch device locale to Russian and reopen the screen.
  Expected: library labels and action labels are shown in Russian.

- [ ] Rotate the device.
  Expected: thumbnail grid, bottom actions, and dialogs remain readable without overlap.

- [ ] Check launcher icon on the device home/app list.
  Expected: the new blue cloud/photo app icon is visible.
