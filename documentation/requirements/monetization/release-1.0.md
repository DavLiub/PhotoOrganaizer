# Monetization Release 1.0

## Goal

Release 1.0 supports a Free/Premium model without weakening data safety.

## Access Model

Feature availability must be checked through Application-level entitlement interfaces. UI may display Premium prompts, but it must not be the source of truth for access control.

## Free Tier

The Free tier may limit capacity, automation, or advanced features according to product rules.

## Premium Tier

Premium unlocks configured paid capabilities. Entitlement state must be observable and testable through Application ports.

## Implementation Note

The current skeleton includes an entitlement gateway placeholder only. Billing and real entitlement verification are not implemented yet.
