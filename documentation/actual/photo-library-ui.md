# Photo Library UI

## Current Scope

The Library tab is the primary app screen after media permission is available.
It combines local scan control, live indexed thumbnails, category filtering, a
planned sort control, and backup entry point.

The old scanner-first Home flow is no longer part of bottom navigation.
Settings is a bottom navigation destination.

## Entry Points

- On app start, users land on Library.
- If media permission is missing, Library shows the permission request state.
- If permission is available, Library shows the current local photo index.

If no indexed photos exist, the screen shows an empty library state and keeps
the primary `Scan` action visible in the bottom action bar.

## Library Grid

The library uses a lazy thumbnail grid over the current read model.

Each tile shows:

- thumbnail loaded through an Application port;
- safe display filename;
- current backup status.

The initial status for indexed photos is `No backup`. Durable backup records
and real upload progress are not implemented yet.

The library controller reloads the photo list after indexed batches are written,
so tiles can appear before the full media scan completes. Thumbnail data is
still loaded lazily by visible grid tiles through `PhotoThumbnailGateway`; there
is no durable thumbnail generation queue yet.

## Categories And Sorting

The top control row supports five compact icon filters:

- All
- Camera
- Social
- Downloads
- Screenshots

Selecting a category filters the visible grid only. It does not persist
include/exclude settings and does not change indexing rules.

Filter labels are exposed as tooltips/accessibility text instead of permanent
visible text so the control fits phone width. When the compact filter is
narrower than the screen, the full segmented control is centered.

The screen also shows a sort selector and visible photo count on one line. Sort
state is Presentation-only for now. Repository-level ordering remains unchanged.

Available sort labels:

- Date descending
- Date ascending
- Name A-Z
- Name Z-A

## Actions

Bottom actions:

- `Scan` starts or continues foreground discovery/indexing.
- `Stop` replaces `Scan` while scanning and requests cooperative cancellation.
- `Backup (X%)` remains enabled, but warns that a backup target must be
  configured first.

`Scan` is the lightweight foreground indexing command. Full `Rescan` is a
separate future workflow for reconciling deleted, changed, or permission-limited
media and should be exposed from Settings or overflow rather than the primary
action row.

User-facing scan progress is represented by the live photo count, grid, and a
small circular activity indicator next to the photo count while scanning. The
technical indexed/source counters are no longer shown on the main Library UI.

`Stop` cancels further discovery but lets already delivered/current page batches
finish indexing. When a scan starts with an existing library, visible counts use
the current library as the baseline so retry scans after `Stop` do not visually
reset the library to zero.

## Visual Assets

The Library and permission states use `assets/images/library_background.png` as
a light background image.

The Android launcher icon is generated from a cropped version of
`assets/branding/app_icon.png` into the standard
`android/app/src/main/res/mipmap-*` density folders so legacy launchers do not
show a white border around the icon.

Android 8+ uses adaptive icon resources in
`android/app/src/main/res/mipmap-anydpi-v26`. The adaptive background fills the
launcher mask with brand blue, while the foreground reuses density-specific
launcher artwork. The manifest also sets `android:roundIcon` to the same
adaptive icon.

Android launch backgrounds reference the launcher icon. Android 12+ splash
styles in `values-v31` and `values-night-v31` set
`android:windowSplashScreenAnimatedIcon` to the same launcher icon.

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
- Full rescan and automatic refresh configuration are not implemented yet.
- Backup target settings are not implemented yet.
- Backup status is derived from current index state, not from durable backup records.
- Full photo details and full-resolution preview remain out of scope.
- Pause/resume controls are not implemented for photo scanning.
- Sort selection is visible but does not yet change repository ordering.
