# Media Source Selection Checklist

## Preconditions

- App is installed on an Android phone.
- Media permission is granted.
- At least one Library scan has completed or partially completed.
- The device has photos in at least one visible source/album.

## Checks

- Open `Albums` from bottom navigation -> the screen shows a title and short explanation.
- Scroll the `Albums` screen -> sources are shown as folder-style album tiles grouped by category.
- Inspect an album tile -> the folder shows a photo count, with name and path below it.
- Tap an album tile -> the lower-right circular selection mark toggles selected/unselected.
- Disable `Screenshots` in `Settings > Media Library` -> `Screenshots` section disappears from `Albums`.
- Return to `Library` -> the `Screenshots` filter is not shown.
- Re-enable `Screenshots` in `Settings > Media Library` -> `Screenshots` section and Library filter return.
- Disable one source in `Albums` -> photos from that source disappear from `Library`.
- Re-enable the source in `Albums` -> photos from that source return to `Library`.
- Close and reopen the app -> category and source selections remain applied.

## Notes

Full rescan behavior after source selection changes is not part of this
checklist yet.
