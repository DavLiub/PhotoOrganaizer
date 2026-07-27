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
- Kept full Rescan out of the primary action row; it remains a future Settings/overflow workflow.
- Added tracked visual assets for the launcher icon and Library background.
- Regenerated Android launcher icons for all standard mipmap densities.

## Documentation

- Added ADR 0020 for the unified Library screen decision.
- Updated actual Library UI documentation.
- Updated the manual Library UI checklist.
