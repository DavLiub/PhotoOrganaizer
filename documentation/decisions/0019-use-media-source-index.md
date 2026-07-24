# ADR 0019: Use Media Source Index

## Context

The app needs source-level indexing so users can include camera photos, exclude social app folders, and understand what local media areas are protected. Android exposes bucket/album style metadata, while iOS exposes PhotoKit collections. A filesystem directory index would overfit Android and may expose unstable or private paths.

## Decision

Use a platform-neutral `MediaSource` catalog instead of a filesystem directory index.

Persist sources in Drift through `media_sources`. Link indexed photos to sources through optional `sourceId`. Keep raw platform metadata such as `albumId` on photo assets for diagnostics and mapping, but treat `sourceId` as the project-owned catalog reference.

Use `pathHint` only as optional non-authoritative context.

## Consequences

- Android MediaStore and iOS PhotoKit details remain inside Infrastructure.
- Future UI can present include/exclude source settings without depending on platform SDK types.
- Source id normalization can evolve independently from raw album ids.
- Full source discovery remains deferred until Android media scan integration.

## Alternatives Considered

- Filesystem directory index: rejected because it is not portable and may rely on inaccessible Android/iOS paths.
- Treat `albumId` as the source id: rejected because it mixes raw platform metadata with project-owned identity.
- Store source names only: rejected because names are not stable enough for settings or joins.
