# 2026-07-21 Core Library Decisions

## Changed

- Added ADRs for core dependency decisions.
- Documented approved direction for persistence, state management, background work, media access, Google Drive, secure storage, logging, and code generation policy.
- Updated actual architecture and data model documentation with selected implementation direction.

## Notes

No dependencies were added to `pubspec.yaml`. Each package should be introduced only in the PR that implements the first adapter or feature requiring it.
