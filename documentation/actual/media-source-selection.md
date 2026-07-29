# Media Source Selection

## Current Scope

Media source selection lets the user control which indexed sources and global
categories are included in the visible local library.

The implementation is Android-first but remains platform-neutral because source
selection works on project-owned `MediaSource` ids and `LibraryCategory` values.

## Application Model

Application owns:

- `LibraryCategory`
- `SourceSelectionSettings`
- `SourceSelectionPolicy`
- `MediaSourceSelection`
- `MediaSourceGroup`
- `SelectableSource`

`LibraryCategoryClassifier` maps media sources and indexed photo entries into:

- Camera
- Social
- Downloads
- Screenshots

## Persistence

Infrastructure persists source selection through `SourceSelectionStore`.

Missing category/source rows mean enabled. This keeps default behavior simple:
new categories and sources are included unless the user disables them.

## UI Behavior

Settings > Media Library controls global category inclusion.

Albums shows found sources grouped by enabled categories. Each source has an
individual switch and a semantic availability badge. Disabling a source hides
photos linked to that source from Library while keeping the source in the
source catalog.

Source availability badges use the shared `StatusBadge` widget:

- available: neutral;
- missing: ignored;
- inaccessible: failed.

Library filters are dynamic. Disabled global categories are removed from the
filter row, and photos from disabled categories or disabled sources are not
included in the Library read model.

## Architecture

Presentation talks to `ListMediaSources`, `UpdateSourceSelection`, and
`ListLibraryPhotos` through provider actions.

Application applies selection through `SourceSelectionPolicy`.

Infrastructure only persists the settings and implements the Application port.

## Known Limitations

- Source selection affects visible indexed content, not Android media access.
- Full rescan semantics after source changes are not implemented yet.
- Folder-level include/exclude beyond existing media source ids is not
  implemented yet.
