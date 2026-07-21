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

## Module Responsibilities

- `domain`: entities, value objects, domain models, and domain rules.
- `application`: use cases, ports, orchestration, and app-specific policies.
- `infrastructure`: Android, storage, cloud, billing, background, and observability adapters.
- `presentation`: Flutter UI, navigation, screens, widgets, and theme.
- `bootstrap`: dependency composition and app startup.

## Integration Direction

Infrastructure must not define business rules. It converts platform/cloud/storage details into Application-level abstractions.

## Current Constraint

Release 1.0 targets Android first. Other Flutter platforms may exist in generated tooling but are not part of the product scope.
