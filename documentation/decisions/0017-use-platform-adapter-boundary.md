# ADR 0017: Use Platform Adapter Boundary

## Context

The project is developed Android first, but photo permissions, media library scanning, background behavior, and storage restrictions differ between Android and iOS.

Hardcoding Android adapters directly in use cases or UI would make future iOS support expensive and would weaken the existing layered architecture.

## Decision

Keep platform-specific behavior in Infrastructure adapters selected by Bootstrap.

Use `AppPlatform` and `MediaAdapters` in Bootstrap to select platform media implementations. Android is the default and active development target. iOS and unsupported platforms currently use placeholder adapters.

Domain, Application, and Presentation must remain independent of Android/iOS APIs and plugin types.

## Consequences

- Android implementation can proceed without blocking future iOS support.
- Platform selection is testable without depending on the host operating system.
- iOS behavior can be added later behind existing Application ports.
- Bootstrap owns composition and keeps platform decisions out of business logic.

## Alternatives Considered

- Hardcode Android adapters in composition root: rejected because it hides platform strategy.
- Detect host platform inside Domain/Application: rejected because it breaks layer boundaries.
- Implement iOS now: rejected because current development is Android first.
