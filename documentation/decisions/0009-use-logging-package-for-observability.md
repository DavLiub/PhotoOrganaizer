# ADR 0009: Use Logging Package for Observability

## Context

The app needs diagnostics for permissions, scanning, background jobs, upload attempts, retries, and unexpected failures. Logging must avoid private media data and secrets.

## Decision

Use the Dart `logging` package as the base logging API.

Project-specific observability remains behind Application ports. Infrastructure decides where records are emitted in debug, file, analytics, or crash reporting adapters.

## Consequences

- Logging API stays lightweight and maintained by the Dart ecosystem.
- Application and Infrastructure can share level-based diagnostic vocabulary without a heavy logging framework.
- Handlers can be swapped without changing Domain or Application behavior.
- Structured event needs may require a project-level wrapper around `logging`.

## Alternatives Considered

- `logger`: convenient console formatting, but more presentation-oriented than the base logging API.
- Custom logger: rejected because a mature Dart package already solves the common logging API.
- Crash/analytics SDK first: deferred until product telemetry requirements are implemented.

## Research Notes

As of 2026-07-21, `logging` is a Dart-published package with broad usage and a small API for logger hierarchy, levels, and handlers.
