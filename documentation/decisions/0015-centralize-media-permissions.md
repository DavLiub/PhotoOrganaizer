# ADR 0015: Centralize Media Permissions

## Context

The app must request access to local photos before scanning and backup. Android permission APIs and plugin-specific states differ across API levels and should not leak into UI or Application workflows.

## Decision

Represent media permission state with Domain value objects and expose permission checks through Application use cases.

Infrastructure maps Android/plugin permission results into `MediaPermission`. Presentation communicates only through `CheckMediaAccess` and `RequestMediaAccess`.

The current Android implementation is a placeholder adapter that returns `unavailable` until the real media permission plugin integration is implemented.

## Consequences

- UI remains independent from Android APIs and plugin types.
- Real media scanning can reuse the same permission boundary later.
- Permission states such as limited, permanently denied, unavailable, and unknown are modeled before platform integration.
- Privacy rules can be enforced before photo paths, EXIF, or account identifiers enter workflows.

## Alternatives Considered

- Let UI request Android permissions directly: rejected because it breaks layer boundaries.
- Mix permission checks into photo scanning: rejected because permission state is a separate workflow concern.
- Add `photo_manager` in this PR: deferred because this PR only establishes the boundary.
