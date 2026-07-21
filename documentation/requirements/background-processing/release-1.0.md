# Background Processing Release 1.0

## Purpose

Background processing supports scanning, indexing, optimizing, uploading, retry, cleanup, and integrity checks.

## Scheduling Requirements

- Use platform-supported Android background execution.
- Respect charging, network, and OS execution limits.
- Persist enough state to resume safely after termination.

## Job Types

- Photo scan.
- Index update.
- Checksum or identity calculation.
- Optimization.
- Upload.
- Retry.
- Cleanup.
- Integrity validation.

## Failure Handling

Jobs must report structured outcomes to Application use cases. Retry decisions must not be hidden inside UI code.

## Current Implementation Note

The current skeleton contains a background scheduler port and a placeholder infrastructure implementation. Real scheduling is not implemented yet.
