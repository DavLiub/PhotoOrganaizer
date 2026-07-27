# Photo Library Checklist

## Preconditions

- App is installed as a debug build.
- Media permission is granted or limited.
- At least one manual scan has completed.

## Checklist

- [ ] Finish a scan from Home.
  Expected: the app opens the Photos tab automatically.

- [ ] Verify the library header.
  Expected: the screen title is visible and photo count matches the visible grid.

- [ ] Verify photo tiles.
  Expected: each indexed photo appears as a thumbnail tile with safe filename and `No backup` status.

- [ ] Tap `Catalogs`.
  Expected: a category sheet opens with `All photos`, `Camera`, `Social`, `Downloads`, and `Screenshots`.

- [ ] Select `Screenshots`.
  Expected: the grid shows only screenshot-category photos; no include/exclude setting is changed.

- [ ] Reopen `Catalogs` and select `All photos`.
  Expected: the full indexed grid is visible again.

- [ ] Tap `Refresh`.
  Expected: a dialog offers manual refresh and automatic refresh settings.

- [ ] In the refresh dialog, tap `Run now`.
  Expected: the library starts a manual refresh and stays on the Photos tab.

- [ ] Tap `Refresh` again and choose automatic refresh settings.
  Expected: the app opens Settings.

- [ ] Tap `Backup`.
  Expected: a warning says backup target storage is not configured.

- [ ] In the backup warning, tap `Go to settings`.
  Expected: the app opens Settings.

- [ ] Switch device locale to Russian and reopen the screen.
  Expected: library labels and action labels are shown in Russian.

- [ ] Rotate the device.
  Expected: thumbnail grid, bottom actions, and dialogs remain readable without overlap.
