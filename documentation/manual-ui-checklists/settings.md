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
  Expected: `Premium / Free plan` and `Storage / Storage is not connected` are
  visible on the right as compact semantic status badges.

- [ ] Tap `Storage` on the left.
  Expected: Provider, connected account, root folder, cloud folder layout, and year/month grouping controls are visible on the right.

- [ ] Tap `Provider`.
  Expected: Placeholder detail screen opens as a status banner and says
  configuration persistence will be added later.

- [ ] Return to Settings.
  Expected: Storage remains selected and the right-side Storage content is visible.

- [ ] Edit `Root folder`.
  Expected: text can be entered directly on the right without opening a new screen.

- [ ] Select `All in root folder`, then `Keep album structure`.
  Expected: only one folder layout option is selected at a time.

- [ ] Toggle `Group by year/month`.
  Expected: checkbox changes state independently from the folder layout choice.

- [ ] Verify `Photo path template`.
  Expected: no free-form path template field is shown.

- [ ] Tap `Media Library` on the left.
  Expected: category controls for Camera, Social, Downloads, Screenshots plus included folders placeholder are visible.

- [ ] Verify removed Media Library placeholders.
  Expected: no `Refresh behavior` row is visible.

- [ ] Tap `Backup Configuration` on the left.
  Expected: optimized/original choice, image quality slider, maximum photo size slider, and keep metadata switch are visible.

- [ ] Select `Original photos`.
  Expected: image quality and maximum photo size controls become disabled.

- [ ] Tap `Background Work` on the left.
  Expected: background backup, background refresh, Wi-Fi only, and battery threshold controls are visible.

- [ ] Verify charging/battery optimization controls.
  Expected: no `Run while charging` or `Battery optimization` row is visible.

- [ ] Tap `Language` on the left.
  Expected: English and Russian language cards with flags are visible, and the selected language has a checkmark.

- [ ] Verify unsupported languages.
  Expected: Hebrew is not visible and cannot be selected.

- [ ] Tap `Russian`.
  Expected: Settings labels switch to Russian immediately without restarting the app.

- [ ] Close and reopen the app.
  Expected: Russian remains selected and visible.

- [ ] Tap `English`.
  Expected: Settings labels switch to English immediately and remain English after restart.

- [ ] Tap `About` on the left.
  Expected: app name, package ID, version, author, and diagnostics consent are visible.

- [ ] Toggle diagnostics consent.
  Expected: checkbox/switch changes state. No network or destructive action happens.

- [ ] Switch device locale to Russian and reopen Settings.
  Expected: Settings labels are shown in Russian.
