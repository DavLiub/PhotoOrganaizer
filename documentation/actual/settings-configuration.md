# Settings Configuration

## Current Scope

Settings is the visible configuration center for app status, one active backup
storage, backup behavior, media library controls, background work, language, and
about information.

This PR implements the shell only. Settings values are not persisted yet.

The Settings UI uses a two-level master-detail layout:

- first-level sections are selected from the left side;
- the right side displays subitems and direct controls for the selected
  section;
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

Albums is a placeholder destination for future album management. It does not
change media indexing rules yet.

## Settings Layout

Left-side first-level sections:

- Status
- Storage
- General
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
- Photo path template

Storage represents one active backup storage. The intended model is a single
configured target such as Google Drive, Dropbox, S3, or a later provider. The
Root folder and relative photo path template are direct editable fields in the
right-side pane. Provider and connected account are complex placeholders and
open full-screen detail screens.

Media Library:

- Categories
- Included folders
- Refresh behavior

These are placeholders for future include/exclude and refresh configuration.

Backup Configuration:

- Photo size
- Image quality
- Keep metadata
- Backup originals

Backup Configuration describes what is backed up. It does not select the cloud
provider; provider setup belongs to Storage.

Background Work:

- Background backup
- Background refresh
- Wi-Fi only
- Run while charging
- Battery optimization

Background Work describes when app work is allowed. Real scheduling is not
implemented yet.

Language:

- Language placeholder

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
localization guard to compare real translation keys.

## Known Limitations

- Settings values are not persisted.
- Storage provider authorization is not implemented.
- Background scheduling is not implemented.
- Diagnostics consent does not leave the screen state.
- Albums is a placeholder and does not manage actual albums yet.
