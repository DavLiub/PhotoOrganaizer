# Smart Photo Archive Documentation

This directory contains the project documentation that should evolve together with the source code.

## Tracked Documentation

| Directory | Purpose |
|---|---|
| [requirements](requirements) | English requirement documents derived from the original source specifications. |
| [actual](actual) | Current implemented design as it exists in the repository. |
| [decisions](decisions) | Architecture Decision Records (ADR). |
| [changelog](changelog) | Documentation and architecture change history. |

## Local Working Documentation

The following directories are intentionally local and ignored by Git:

| Directory | Purpose |
|---|---|
| `source documentation` | Original Russian source specifications, UX references, and raw input documents. |
| `feature planning` | Local PR implementation plans prepared before coding. |
| `AI log` | Local AI action logs describing what was done during a task. |

## Reading Order

1. Start with [requirements/README.md](requirements/README.md).
2. Check [actual/README.md](actual/README.md) to understand what is currently implemented.
3. Read relevant ADRs in [decisions](decisions) before changing architecture.
4. Update [changelog](changelog) when documentation, architecture, or workflow structure changes.

## Synchronization Rule

Original specifications describe the intended design. Actual documentation describes the implemented design. If implementation cannot follow the original specification, document the reason, update `actual`, and create an ADR when the change is permanent.
