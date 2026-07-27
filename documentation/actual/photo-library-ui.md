# Photo Library UI

## Current Scope

The Photos tab now shows the local photo library after indexing.

The screen is read-oriented and safe before backup configuration exists.

## Entry Points

- The user can open the Photos tab manually.
- A successful Home scan invalidates the library state and switches the app to the Photos tab.

If no indexed photos exist, the screen shows an empty state with a `Scan photos` action that returns the user to Home.

## Library Grid

The library uses a lazy thumbnail grid.

Each tile shows:

- thumbnail loaded through an Application port;
- safe display filename;
- current backup status.

The initial status for indexed photos is `No backup`. Durable backup records and real upload progress are not implemented in this PR.

## Categories

The UI supports four global read-only categories:

- Camera
- Social
- Downloads
- Screenshots

`Catalogs` opens a category sheet. Selecting a category filters the visible grid only. It does not persist include/exclude settings and does not change indexing rules.

## Actions

Bottom actions:

- `Catalogs`: opens category filtering.
- `Settings`: opens the current settings placeholder screen.
- `Backup`: remains enabled, but warns that a backup target must be configured first.

The top `Refresh` action opens a dialog:

- `Run now` starts a manual media refresh through the existing scan use case.
- `Auto refresh settings` opens settings. Automatic refresh itself is not implemented yet.

While refresh or first scan is running, the library header shows live found/indexed/source counters. If the library is still empty, the screen shows the same counters in a centered progress state instead of a spinner-only state.

The library controller reloads the photo list after indexed batches are written, so tiles can appear before the full media scan completes. Thumbnail data is still loaded lazily by visible grid tiles through `PhotoThumbnailGateway`; there is no durable thumbnail generation queue yet.

`Stop` is available while scan/refresh is running. It requests cooperative cancellation and keeps already indexed photos visible.

## Architecture

Presentation uses:

- `PhotoLibraryController`
- `PhotoLibraryActions`
- `PhotoLibraryState`
- `MainDestinationController`

Application owns:

- `PhotoLibrary`
- `LibraryPhoto`
- `LibraryCategory`
- `LibraryBackupStatus`
- `ListLibraryPhotos`
- `PhotoThumbnailGateway`

Infrastructure implements thumbnail loading through `PhotoThumbnailAdapter`, which uses `photo_manager` behind the Application port.

Presentation does not import Infrastructure, Drift, Android SDK, or `photo_manager`.

## Localization

Library UI strings are routed through `AppLocalizations`.

Supported languages remain:

- English
- Russian

The localization map is key-based so Hebrew can be added later without changing widget call sites.

## Known Limitations

- The grid does not persist source include/exclude settings.
- Automatic refresh configuration is only linked to settings; scheduling is not implemented yet.
- Backup target settings are not implemented yet.
- Backup status is derived from current index state, not from durable backup records.
- Full photo details and full-resolution preview remain out of scope.
- Pause/resume controls are not implemented for photo scanning.
