# ADR 0002: Name the Infrastructure Layer Explicitly

## Context

The initial skeleton used `lib/infra` as a short directory name for platform and external-system adapters.

## Decision

Rename `lib/infra` to `lib/infrastructure`.

## Consequences

- The layer name is explicit and easier for new contributors to understand.
- The directory aligns with common Clean Architecture terminology.
- Imports must reference `lib/infrastructure`.

## Alternatives Considered

- Keep `lib/infra`. Rejected because the short name is less clear and conflicts with the contributor guide preference.
