# Actual Access Model

## Current State

The project now has a centralized access model for future feature checks.

Implemented Domain concepts:

- `Capability`
- `AccessTier`
- `AccessProfile`
- `EntitlementState`
- `AccessDecision`
- `AccessStatus`
- `AccessReason`

Implemented Application concepts:

- `AccessPolicy`
- `AccessOverride`
- `EntitlementGateway` returning an `AccessProfile`

Implemented Infrastructure concepts:

- `StaticEntitlementGateway`
- `TestEntitlementGateway`

## Dependency Direction

- Domain models access concepts and has no billing, UI, Flutter, or platform dependency.
- Application owns the access policy and decides whether a capability is allowed, limited, denied, or unavailable.
- Infrastructure provides entitlement facts through `EntitlementGateway`.
- Presentation must ask Application/use cases for access outcomes and must not decide Free/Premium rules directly.

## Current Rules

- Free tier can start backup with a limit.
- Premium-only capabilities require active Premium entitlement.
- Expired Premium entitlement is denied for Premium-only capabilities.
- Disabled capabilities are unavailable.
- Limited access can proceed, but the decision carries a limit and reason.

## Test Access Mode

`AccessOverride` and `TestEntitlementGateway` support deterministic test/debug scenarios:

- forced allow;
- forced deny;
- forced limit;
- Free profile;
- Premium profile;
- expired Premium profile;
- unavailable capability.

These are not production users and must not be wired as a hidden production bypass.

## Known Limitations

- No real billing integration exists yet.
- No Google Play Billing state exists yet.
- No persisted entitlement state exists yet.
- UI does not yet display access decisions.
