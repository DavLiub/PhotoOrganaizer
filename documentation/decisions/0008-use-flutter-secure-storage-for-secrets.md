# ADR 0008: Use Flutter Secure Storage for Secrets

## Context

The app must store sensitive values such as tokens or account-related secrets without committing secrets or exposing them in logs. Local photo index metadata is not itself a secret store.

## Decision

Use `flutter_secure_storage` for small sensitive values.

Do not store bulk photo metadata, backup records, or large JSON documents in secure storage. Use the selected local database for structured non-secret state.

## Consequences

- Sensitive values use platform-backed encrypted storage.
- Secret storage remains isolated behind Infrastructure adapters.
- Application code receives high-level account/session state, not raw storage details.
- Android minimum SDK implications must be checked when adding the dependency.

## Alternatives Considered

- Plain shared preferences: rejected for secrets.
- Drift/SQLite encryption for all data: not selected for Release 1.0 foundation because the immediate need is small secret storage.
- Custom crypto/key management: rejected under Library First.

## Research Notes

As of 2026-07-21, `flutter_secure_storage` is active on pub.dev and documents platform-specific secure storage with Android cipher options.
