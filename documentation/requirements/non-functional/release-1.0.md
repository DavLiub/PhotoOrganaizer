# Non-Functional Requirements Release 1.0

## Reliability

Backup state must remain consistent across app restarts, network changes, and recoverable upload failures.

## Performance

Scanning and indexing must avoid blocking the UI. Long-running work should be scheduled through background infrastructure where appropriate.

## Resource Usage

The app must respect battery, network, and storage constraints. Background processing should use platform-supported scheduling policies.

## Security

- Do not expose cloud tokens in logs.
- Do not commit secrets or signing credentials.
- Store sensitive configuration through platform-appropriate mechanisms.

## Compatibility

Android is the primary Release 1.0 platform. Flutter desktop/web support is not part of the product acceptance scope.

## Observability

Errors, retries, background jobs, and cloud operations must be observable enough for debugging without leaking private user data.
