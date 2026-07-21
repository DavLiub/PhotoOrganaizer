# ADR 0005: Use Workmanager for Background Work

## Context

Release 1.0 requires background scan, index, optimization, upload, retry, cleanup, and integrity work. Android background execution must respect OS constraints and survive app restarts.

## Decision

Use the Flutter `workmanager` package as the default background scheduling adapter for Release 1.0.

Keep scheduling behind Application ports. Infrastructure owns Workmanager-specific task registration, payload mapping, retry signaling, and callback setup.

## Consequences

- The project aligns with Android WorkManager concepts for persistent constrained work.
- Background task code remains isolated in Infrastructure.
- Application use cases can be tested without Workmanager.
- Long-running upload work must be chunked so tasks respect platform execution limits.

## Alternatives Considered

- Native Android WorkManager through custom platform channels: more control, but slower to implement and more Android-specific code.
- Foreground service first: may be needed later for long uploads, but is not the first default scheduler.
- In-app timers or isolates only: not reliable after app termination.

## Research Notes

Android documentation identifies WorkManager as the recommended library for persistent work with constraints. The Flutter `workmanager` package wraps Android WorkManager and iOS background tasks.
