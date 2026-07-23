# Release 1.0 Architecture

## Intended Architecture

The application follows a layered Flutter architecture.

```text
Presentation
        v
Application
        v
Domain

Infrastructure
        ^
Application interfaces

Bootstrap
        v
Composition Root
```

## Layer Rules

- Domain must not depend on any other layer.
- Application may depend only on Domain.
- Application defines ports/interfaces required by use cases.
- Infrastructure implements Application interfaces.
- Presentation talks to Application use cases and view models only.
- Bootstrap wires concrete Infrastructure implementations into Application services.

## Enforcement Direction

Deterministic architecture guards should run in CI for changed code. Layer violations are blocking. Naming recommendations are advisory until proven accurate enough to become stricter.

## App Mode Direction

Runtime mode must be explicit and owned by Bootstrap. Production mode must not use test-only entitlement sources or access overrides.

## Module Responsibilities

- `domain`: entities, value objects, domain models, and domain rules.
- `application`: use cases, ports, orchestration, and app-specific policies.
- `infrastructure`: platform, storage, cloud, billing, background, and observability adapters.
- `presentation`: Flutter UI, navigation, screens, widgets, and theme.
- `bootstrap`: dependency composition and app startup.

## Integration Direction

Infrastructure must not define business rules. It converts platform/cloud/storage details into Application-level abstractions.

## Current Constraint

Release 1.0 targets Android first. Other Flutter platforms may exist in generated tooling but are not part of the product acceptance scope.

Platform-specific code must be isolated in Infrastructure and selected by Bootstrap. Domain, Application, and Presentation must remain Android/iOS independent.

iOS readiness means keeping adapter boundaries available, not implementing iOS behavior during Android-first development.
