# Error Handling Release 1.0

## Goal

Errors must be recoverable when possible, understandable to users, and diagnosable for development.

## Error Categories

- Permission denied.
- Cloud authorization failure.
- Network failure.
- Storage quota or local storage failure.
- Upload conflict.
- Corrupted or unreadable media.
- Background execution interruption.
- Internal unexpected failure.

## User Response

The UI should show clear status and next action. It must not expose raw stack traces or provider-specific implementation details.

## Retry Policy

Retry behavior belongs in Application or Infrastructure policy, depending on whether it is business-level or adapter-level. Duplicate retry logic should not be spread across screens.

## Logging

Logs must help diagnose failures without storing private media data, OAuth tokens, service account credentials, or signing material.
