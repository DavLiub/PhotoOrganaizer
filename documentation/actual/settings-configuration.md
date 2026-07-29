# Settings Configuration

## Current Scope

Settings is the visible configuration center for app status, one active backup
storage, backup behavior, media library controls, background work, language, and
about information.

Most settings values are still shell-only placeholders. Media Library category
include/exclude values are persisted and shared with Library and Albums.

The Settings UI uses a two-level master-detail layout:

- first-level sections are selected from the left side;
- the right side displays subitems and direct controls for the selected section
  in soft Material-style panels;
- complex subitems open a full-screen placeholder editor;
- simple values can be entered or toggled directly in the right side.

## Navigation

Bottom navigation currently contains:

- Library
- Albums
- History
- Settings

Premium is no longer a bottom navigation destination. It is represented as an
account/status concept inside Settings.

Albums is a source selection destination. It shows indexed media sources grouped
by enabled category and allows individual source include/exclude toggles.

## Settings Layout

Left-side first-level sections:

- Status
- Storage
- Media Library
- Backup Configuration
- Background Work
- Language
- About

The selected section owns the right-side content.

## Settings Sections

Status:

- Premium status, currently `Free plan`
- Storage status, currently `Storage is not connected`

Storage:

- Provider
- Connected account
- Root folder
- Cloud folder layout:
  - all photos in the root folder
  - keep album structure
- Group by year/month

Storage represents one active backup storage. The intended model is a single
configured target such as Google Drive, Dropbox, S3, or a later provider. The
root folder is a direct editable field. Folder layout is a radio-style choice,
and year/month grouping is an independent checkbox. Provider and connected
account are complex placeholders and open full-screen detail screens.

There is no free-form path template in the UI. The shell intentionally limits
the first version to understandable choices.

Media Library:

- Camera
- Social
- Downloads
- Screenshots
- Included folders placeholder

Category controls are persisted global include/exclude rules. They affect:

- the Library category switcher;
- which indexed photos are shown in Library;
- which category sections are shown in Albums.

Included folder configuration remains a future workflow.

Backup Configuration:

- Photo mode:
  - optimized copies
  - original photos
- Image quality
- Maximum photo size
- Keep metadata

Backup Configuration describes what is backed up. It does not select the cloud
provider; provider setup belongs to Storage.

When original photos are selected, image quality and maximum size controls are
disabled because originals are not recompressed by the app.

Background Work:

- Background backup
- Background refresh
- Wi-Fi only
- Run when battery is above X%

Background Work describes when app work is allowed. Real scheduling is not
implemented yet.

Language:

- Large language cards with flag, language name, and selected-state checkmark
- English and Russian are selectable for Release 1.0
- Hebrew is not shown or selectable yet

About:

- App name
- Package ID
- Version
- Author
- Diagnostics consent checkbox

Diagnostics consent is direct local UI state only in this PR. It is not
persisted and does not send data.

## Localization

Settings strings are routed through `AppLocalizations`.

The localization file has been normalized to UTF-8 for English and Russian
labels. This removes the previous mojibake Russian text and allows the
localization guard to compare real translation keys. The guard also blocks
common mojibake markers in user-visible localization values.

## Known Limitations

- Most Settings values are not persisted.
- Storage provider authorization is not implemented.
- Background scheduling is not implemented.
- Diagnostics consent does not leave the screen state.
- Media Library source selection is implemented, but full folder include/exclude
  workflows are not implemented.
