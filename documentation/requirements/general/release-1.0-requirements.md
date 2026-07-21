# Release 1.0 Requirements

## Goal

Release 1.0 must provide a dependable Android photo backup MVP with Google Drive as the first cloud provider.

## Functional Scope

- First-run setup.
- Runtime access to local photos.
- Google Drive connection.
- Local photo indexing.
- Backup queue creation.
- Optimized copy preparation.
- Cloud upload.
- Backup status tracking.
- Basic history and diagnostics.
- Free/Premium access control.

## Out of Scope

- Video backup.
- Restore from cloud.
- Multi-cloud support.
- AI-based organization.
- Similar-photo cleanup.
- Automatic deletion of originals.
- Desktop platforms.

## Acceptance Direction

The application is acceptable when a user can complete setup, start backup, leave and reopen the app, and still see a consistent protection state for indexed photos.

## Constraints

- Android is the primary platform.
- Google Drive is the initial cloud target.
- Background work must respect device and OS constraints.
- The application must avoid data loss and silent corruption.
- Local identifiers must support deduplication and retry.
