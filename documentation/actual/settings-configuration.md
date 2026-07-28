# Settings Configuration

## Current Scope

Settings is the visible configuration center for app status, one active backup
storage, backup behavior, media library controls, background work, language, and
about information.

This PR implements the shell only. Settings rows are structured and navigable,
but values are not persisted yet.

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
root folder and relative photo path template determine where uploaded photos
will be placed.

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

Diagnostics consent is local UI state only in this PR. It is not persisted and
does not send data.

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
