# Functional Specification Release 1.0

## Primary User Flow

1. User opens the app.
2. App explains the setup state through the UI.
3. User grants access to local photos.
4. User connects Google Drive.
5. App scans the photo library.
6. App creates or updates a local index.
7. App builds a backup queue.
8. App uploads optimized copies.
9. App records backup results.
10. User sees protected and pending photos.

## Required Screens

- Home / protection summary.
- Setup flow.
- Photos list.
- Photo details.
- Backup progress.
- History.
- Settings.
- Premium / access control.

## Backup Behavior

- Backup work must be resumable.
- Already protected photos must not be uploaded again.
- Failed uploads must be visible and retryable.
- Local status must reflect the latest known outcome.

## Access Control

Free and Premium behavior must be enforced through Application-level entitlement rules, not hardcoded in UI widgets.

Feature use cases must request an access decision before performing restricted work. Access decisions must distinguish allowed, limited, denied, and unavailable states.

## Media Permissions

Photo access must be handled through Application-level permission use cases. UI widgets must not call Android permission APIs or plugin APIs directly.

Media permission states must distinguish granted, limited, denied, permanently denied, unavailable, and unknown states.

Scanning and backup workflows must not proceed as if full media access exists when permission is limited, denied, unavailable, or unknown.

## Diagnostics

User-visible errors must be understandable. Internal diagnostic detail should be available through observability/logging infrastructure.
