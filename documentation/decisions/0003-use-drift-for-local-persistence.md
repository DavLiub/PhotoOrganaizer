# ADR 0003: Use Drift for Local Persistence

## Context

Release 1.0 needs a reliable local index for photo identity, backup state, retry metadata, and schema migration. The storage layer must be testable through Application ports and must not leak SQLite details into Domain or Presentation.

## Decision

Use `drift` as the local persistence library. Use `drift_dev` and `build_runner` when schema code generation is introduced.

Do not add persistence dependencies until the first storage implementation PR. Keep the current repository dependency-free until a real adapter is implemented.

Generated Drift files are committed with the schema implementation so repository analysis and tests work from a clean checkout without an implicit build step.

## Consequences

- Storage schema and migrations can be explicit and reviewable.
- Application can keep repository interfaces independent from SQLite.
- Tests can use fake repositories first and in-memory Drift databases later.
- Code generation becomes part of the development workflow once storage starts.

## Alternatives Considered

- `sqflite`: mature and small, but lower-level and easier to spread SQL/string mapping logic through adapters.
- Raw `sqlite3`: powerful, but more manual schema/query plumbing.
- Key-value stores: insufficient for indexed photo state, retries, and migration-heavy data.

## Research Notes

As of 2026-07-21, `drift` is an active SQLite-backed Dart/Flutter persistence library on pub.dev, and `drift_dev` is the matching generator package.
