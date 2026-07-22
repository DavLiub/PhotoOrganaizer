# Error Model and Observability

## Current Error Model

The project uses `OperationResult<T>` as the shared result boundary for application operations that can fail without throwing through use case APIs.

Implemented result types:

- `OperationSuccess<T>`: contains the successful value.
- `OperationFailure<T>`: contains structured `FailureInfo`.

`FailureInfo` contains:

- `kind`: typed failure category.
- `code`: stable technical code.
- `safeMessage`: optional message safe for UI display.
- `retryable`: whether the operation can be retried automatically.
- `userActionRequired`: whether the user must change something before retry.
- `diagnostics`: structured technical context.

## Failure Categories

Current categories:

- `permission`
- `userAction`
- `deviceState`
- `background`
- `storage`
- `media`
- `cloudAuth`
- `cloudQuota`
- `network`
- `validation`
- `cancelled`
- `unknown`

## Observability Boundary

Application defines `ObservabilitySink`. Infrastructure implements it through `ConsoleObservabilitySink`.

The current sink records:

- named events;
- structured failures.

Raw exceptions are intentionally not part of the port contract. Future adapters can map exceptions into `FailureInfo` before recording.

## Privacy Rules

Observability data must be sanitized before output. The current sanitizer drops sensitive keys and sensitive string values.

Do not record:

- local photo paths;
- file names and display names;
- EXIF and location data;
- email addresses and account identifiers;
- cloud object identifiers;
- tokens, secrets, API keys, credentials, passwords, and private keys.

## Known Limitations

- No external logging dependency is added yet.
- `ConsoleObservabilitySink` is a minimal adapter with an injectable writer for tests.
- No crash reporting, analytics, or remote telemetry adapter exists yet.
- Current use cases do not yet emit observability events.
