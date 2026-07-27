# 2026-07-27 Unified Library Screen

## Changed

- Made Library the primary bottom navigation destination.
- Removed the separate Home destination from bottom navigation.
- Added Settings as a bottom navigation destination.
- Reworked the Library UI around:
  - category filter: All, Camera, Social, Downloads, Screenshots;
  - sort selector placeholder;
  - visible photo count;
  - live thumbnail grid with backup status;
  - bottom actions `Scan` / `Stop` and `Backup (X%)`.
- Removed user-facing indexed/source counters from the main Library screen.
- Added a compact scan activity indicator next to the photo count while scanning.
- Kept full Rescan out of the primary action row; it remains a future Settings/overflow workflow.
- Added tracked visual assets for the launcher icon and Library background.
- Regenerated cropped Android launcher icons for all standard mipmap densities.
- Added Android adaptive and round icon resources for Android launchers.
- Added Android launch background and Android 12+ splash style references to the new launcher icon.
- Changed category filters to compact icon segments with tooltips so the control fits phone width.
- Centered the compact category filter panel when it is narrower than the screen.

## Documentation

- Added ADR 0020 for the unified Library screen decision.
- Updated actual Library UI documentation.
- Updated the manual Library UI checklist.
