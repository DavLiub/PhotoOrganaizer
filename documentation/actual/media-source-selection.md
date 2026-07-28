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

The Albums screen starts with a short title and explanation so the purpose is
visible before the source list.

Settings > Media Library controls global category inclusion.

Albums shows found sources grouped by enabled categories. Sections are separated
by centered category headers with horizontal dividers. Each source is presented
as an album tile:

- folder icon;
- photo count on the folder;
- circular selection mark in the lower-right corner;
- album/source name below the tile;
- path or provider hint below the name.

Tapping an album tile toggles whether that source is included. Disabling a
source hides photos linked to that source from Library while keeping the source
in the source catalog.

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
