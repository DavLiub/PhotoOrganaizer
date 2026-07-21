# ADR 0004: Use Riverpod for Presentation State

## Context

The app will need async UI state for setup, permissions, photo index progress, backup progress, entitlement state, and retryable failures. Presentation must communicate through Application use cases and must not import Infrastructure directly.

## Decision

Use `flutter_riverpod` for Presentation state and dependency exposure to widgets.

Do not introduce `riverpod_generator`, `riverpod_lint`, or `custom_lint` in the first Riverpod PR unless the implementation clearly needs generated providers.

## Consequences

- UI async state can model loading, data, and errors consistently.
- Providers can expose Application use cases without direct Infrastructure imports.
- Tests can override providers with fake use cases.
- Avoiding generator packages initially keeps the first state-management step smaller.

## Alternatives Considered

- Flutter built-in `InheritedWidget` / `ChangeNotifier`: acceptable for tiny apps, but likely too manual for backup workflows.
- `provider`: simpler but less strict around async state and overrides.
- `bloc`: mature, but heavier than needed for the first implementation slice.

## Research Notes

As of 2026-07-21, `flutter_riverpod` is active on pub.dev and explicitly targets state management, caching, async state, and testable UI logic.
