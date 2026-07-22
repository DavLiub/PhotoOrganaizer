# 2026-07-22 Error Model and Observability

## Changed

- Extended `OperationResult` with structured `FailureInfo` and typed `FailureKind`.
- Added retryability and user-action-required flags for expected workflow failures and deferred device/system states.
- Replaced raw observability error recording with structured failure recording.
- Added `safeAttributes` to sanitize observability diagnostics.
- Added focused tests for operation failures, safe attributes, and console observability output.
- Documented the implemented error model and observability boundary.

## Notes

- No external logging dependency was added in this PR.
- Crash reporting, analytics, remote telemetry, and UI error presentation remain out of scope.
