# Settings Checklist

## Preconditions

- App is open.
- Bottom navigation is visible.

## Checklist

- [ ] Tap `Settings` in the bottom navigation.
  Expected: Settings screen opens.

- [ ] Verify bottom navigation labels.
  Expected: `Library`, `Albums`, `History`, and `Settings` are visible. `Premium` is not a bottom navigation tab.

- [ ] Verify the `Status` section.
  Expected: `Premium / Free plan` and `Storage / Storage is not connected` are visible.

- [ ] Verify the `Storage` section.
  Expected: Provider, connected account, root folder, and photo path template rows are visible.

- [ ] Tap `Provider`.
  Expected: Placeholder detail screen opens and says configuration persistence will be added later.

- [ ] Return to Settings.
  Expected: Settings sections are visible again.

- [ ] Verify the `Media Library` section.
  Expected: Categories, included folders, and refresh behavior rows are visible.

- [ ] Verify the `Backup Configuration` section.
  Expected: Photo size, image quality, keep metadata, and backup originals rows are visible.

- [ ] Verify the `Background Work` section.
  Expected: Background backup, background refresh, Wi-Fi only, charging, and battery optimization rows are visible.

- [ ] Verify the `Language` section.
  Expected: Language row is visible.

- [ ] Verify the `About` section.
  Expected: app name, package ID, version, author, and diagnostics consent are visible.

- [ ] Toggle diagnostics consent.
  Expected: checkbox/switch changes state. No network or destructive action happens.

- [ ] Switch device locale to Russian and reopen Settings.
  Expected: Settings labels are shown in Russian.
