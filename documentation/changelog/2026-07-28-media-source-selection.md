# 2026-07-28 Media Source Selection

## Changed

- Added Application source selection settings, policy, and use cases.
- Added persisted category/source selection storage in Drift schema version `3`.
- Replaced the Albums placeholder with grouped media source selection UI.
- Connected Settings > Media Library category toggles to persisted selection.
- Made Library filters and visible photos respect the same selection policy.
- Added focused tests for source grouping, persisted selection, and UI toggles.

## Notes

Selection affects visible indexed content. Full rescan and backup enqueue
semantics will be handled in later PRs.
