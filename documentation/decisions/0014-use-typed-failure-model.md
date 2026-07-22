# ADR 0014: Use Typed Failure Model

## Context

Permission flows, background work, storage, media scanning, and cloud integration can fail for different reasons. Some failures require user action, while others should be retried later because of device or network state.

The project already had `OperationResult`, so adding a second result abstraction would create competing error paths.

## Decision

Extend `OperationResult` with typed `FailureInfo` and `FailureKind`.

Use `OperationFailure` for structured failures that cross application boundaries. Keep technical codes, safe user-facing messages, retryability, user-action requirements, and diagnostics separate.

Observability records structured failures and sanitized attributes. Raw exceptions are not part of the application observability port.

## Consequences

- Use cases can report failures consistently without Flutter or platform SDK dependencies.
- Infrastructure adapters map external failures into project categories.
- Deferred states such as low battery, stopped background work, or missing network can be modeled without treating them as permanent errors.
- UI can decide how to display failures without parsing technical diagnostics.
- Future logging or crash reporting adapters can be added behind `ObservabilitySink`.

## Alternatives Considered

- Keep string-only `code/message`: too weak for retry and user-action handling.
- Throw exceptions through use cases: rejected because expected phone, permission, network, and quota states are part of normal workflow control.
- Add a new result type: rejected to avoid parallel abstractions.
