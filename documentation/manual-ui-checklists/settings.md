# Settings Checklist

## Preconditions

- App is open.
- Bottom navigation is visible.

## Checklist

- [ ] Tap `Settings` in the bottom navigation.
  Expected: Settings screen opens.

- [ ] Verify bottom navigation labels.
  Expected: `Library`, `Albums`, `History`, and `Settings` are visible. `Premium` is not a bottom navigation tab.

- [ ] Verify the two-level layout.
  Expected: first-level sections are listed on the left, and selected section content is shown on the right.

- [ ] Verify the initial `Status` selection.
  Expected: `Premium / Free plan` and `Storage / Storage is not connected` are visible on the right.

- [ ] Tap `Storage` on the left.
  Expected: Provider, connected account, root folder, and photo path template controls are visible on the right.

- [ ] Tap `Provider`.
  Expected: Placeholder detail screen opens and says configuration persistence will be added later.

- [ ] Return to Settings.
  Expected: Storage remains selected and the right-side Storage content is visible.

- [ ] Edit `Root folder`.
  Expected: text can be entered directly on the right without opening a new screen.

- [ ] Tap `Media Library` on the left.
  Expected: Categories, included folders, and refresh behavior rows are visible.

- [ ] Tap `Backup Configuration` on the left.
  Expected: photo size selector, image quality slider, keep metadata switch, and backup originals switch are visible.

- [ ] Tap `Background Work` on the left.
  Expected: background backup, background refresh, Wi-Fi only, charging, and battery optimization controls are visible.

- [ ] Tap `Language` on the left.
  Expected: language selector is visible on the right.

- [ ] Tap `About` on the left.
  Expected: app name, package ID, version, author, and diagnostics consent are visible.

- [ ] Toggle diagnostics consent.
  Expected: checkbox/switch changes state. No network or destructive action happens.

- [ ] Switch device locale to Russian and reopen Settings.
  Expected: Settings labels are shown in Russian.
