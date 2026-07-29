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
- current backup status through the shared `StatusBadge` widget.

The initial status for indexed photos is `No backup`. Durable backup records
and real upload progress are not implemented yet.

Backup status badges use semantic Presentation tones:

- `No backup`: not configured;
- `Queued`: queued;
- `Protected`: protected;
- `Failed`: failed;
- `Ignored`: ignored.

The library controller reloads the photo list after indexed batches are written,
so tiles can appear before the full media scan completes. Thumbnail data is
still loaded lazily by visible grid tiles through `PhotoThumbnailGateway`; there
is no durable thumbnail generation queue yet.

## Categories And Sorting

The top control row supports compact icon filters:

- All
- Camera
- Social
- Downloads
- Screenshots

The category list is dynamic. It is built from the current library read model,
which applies the persisted media source selection policy. If a global category
is disabled in Settings, the corresponding filter is removed from Library and
photos from that category are hidden.

Selecting a category filters the visible grid within the already selected
library scope. The selected filter itself is Presentation state and is not
persisted.

Filter labels are exposed as tooltips/accessibility text instead of permanent
visible text so the control fits phone width. When the compact filter is
narrower than the screen, the full segmented control is centered.

The screen also shows a sort selector and visible photo count on one line.
Sorting is applied in Presentation state after category filtering. Repository
ordering remains unchanged.

Available sort labels:

- Date descending
- Date ascending
- Name A-Z
- Name Z-A

The thumbnail grid includes a visible interactive right-side scrollbar for
fast manual navigation through long libraries. The thumb is thicker than the
Flutter default and offset inward from the screen edge so it is easier to hit
with a finger on a phone.

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

User-facing scan progress is represented by the live status label, grid, and a
small circular activity indicator next to the status label while scanning. The
technical indexed/source counters are no longer shown on the main Library UI.

When the Library already has a persisted index, a new foreground scan starts in
checking mode. The status label shows `Checking X/Y`, where `Y` is the current
indexed library size at scan start and `X` is the number of photos already
written or refreshed during the current pass. After checking reaches the
baseline or newly discovered photos exceed the baseline, the label switches to
`Scanning N photos`.

When no persisted index exists, scan progress starts directly as
`Scanning N photos`.

`Stop` cancels further discovery but lets already delivered/current page batches
finish indexing. When a scan starts with an existing library, visible counts use
the current library as the baseline so retry scans after `Stop` do not visually
reset the library to zero.

## Visual Assets

The Library and permission states use `assets/images/library_background.png` as
a light background image.

Library empty and failure states use the shared `EmptyState` and `FailureState`
widgets from the Presentation design foundation.

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
- `SourceSelectionController`

Application owns:

- `PhotoLibrary`
- `LibraryPhoto`
- `LibraryCategory`
- `LibraryBackupStatus`
- `ListLibraryPhotos`
- `SourceSelectionPolicy`
- `PhotoThumbnailGateway`

Infrastructure implements thumbnail loading through `PhotoThumbnailAdapter`, which uses `photo_manager` behind the Application port.

Presentation does not import Infrastructure, Drift, Android SDK, or `photo_manager`.

## Localization

Library UI strings are routed through `AppLocalizations`.

Supported languages remain:

- English
- Russian

The localization map is key-based. Release 1.0 exposes English and Russian UI
strings; Hebrew remains a future localization task.

## Known Limitations

- Full rescan and automatic refresh configuration are not implemented yet.
- Backup target settings are not implemented yet.
- Backup status is derived from current index state, not from durable backup records.
- Full photo details and full-resolution preview remain out of scope.
- Pause/resume controls are not implemented for photo scanning.
- Sort selection changes visible grid ordering but is not persisted between app launches.
