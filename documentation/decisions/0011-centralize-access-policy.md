# ADR 0011: Centralize Access Policy

## Context

The app needs Free/Premium access control, feature limits, unavailable feature states, and deterministic test access scenarios. If each screen or use case checks entitlement facts directly, business rules will be duplicated and easy to bypass.

## Decision

Centralize capability access decisions in the Application layer with `AccessPolicy`.

Domain defines access concepts:

- `Capability`
- `AccessTier`
- `AccessProfile`
- `EntitlementState`
- `AccessDecision`
- `AccessStatus`
- `AccessReason`

Infrastructure provides entitlement facts through `EntitlementGateway`. Presentation and feature use cases must ask Application for access decisions instead of branching on raw entitlement state.

Use `AccessOverride` and `TestEntitlementGateway` for deterministic test/debug scenarios. Do not model this as a special production user.

## Consequences

- Free/Premium rules live in one place.
- Feature use cases can share the same access decisions.
- UI can display structured denial/limit reasons without owning business logic.
- Tests can force allowed, denied, limited, and unavailable states.
- Real billing integration can later replace entitlement facts without changing Domain rules.

## Alternatives Considered

- UI-level checks: rejected because UI would become the source of truth.
- Entitlement gateway returning only `free` or `premium`: rejected because it cannot represent limits, expired entitlement, unavailable features, or test overrides.
- Billing SDK directly in Application/Domain: rejected because Infrastructure must own external SDK details.
- Test user in Domain: rejected because debug/test access must not become a production bypass.
