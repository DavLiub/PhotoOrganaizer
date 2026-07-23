# ADR 0018: Centralize Backup State Machine

## Context

Backup behavior will be touched by Application use cases, background workers, cloud upload adapters, retry handling, and UI progress. If each area invents its own statuses, the app will become hard to reason about and unsafe around retry, confirmation, and deletion policy.

## Decision

Define backup lifecycle transitions in Domain models before adding real background and cloud adapters.

Per-photo backup records use:

- `queued`
- `uploading`
- `uploaded`
- `confirmed`
- `failed`
- `cancelled`

Backup jobs use:

- `queued`
- `running`
- `completed`
- `paused`
- `failed`
- `cancelled`

Retryable per-photo failures return the record to `queued` with retry metadata. `paused` is reserved for the job/process state only.

## Consequences

- Workmanager and cloud adapters must reuse Domain transitions.
- Retry behavior can be tested without Android or Google Drive.
- Local deletion remains blocked until backup confirmation and retention rules are implemented.
- Storage schema for backup state must persist these logical states when introduced.

## Alternatives Considered

- Put retry states in Workmanager: rejected because scheduler behavior would own business state.
- Use one combined photo index and backup status: rejected because indexing and backup are separate concerns.
- Add a per-photo `paused` state: rejected because small photo uploads should be requeued with retry metadata instead.
