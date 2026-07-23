# ADR 0016: Use Local Asset Identity

## Context

The first photo index slice needs stable idempotency without Android media byte access, image hashing, cloud upload, or database persistence.

Using only local asset id is too weak because the same media item can be edited or rewritten. Using checksum or perceptual hash is premature because the project has not implemented media byte access or selected a hashing strategy.

## Decision

Use local asset id, file size, creation timestamp, and modification timestamp as the initial `PhotoIdentity`.

Keep a separate stable `PhotoIndexEntry.id` so an entry can be refreshed when the same local asset id is seen with changed metadata.

Do not model optimized files, cloud copies, thumbnails, or previews as local source assets in this PR. They will be related artifacts or variants in a later PR.

## Consequences

- Repeated scans of the same local asset are idempotent.
- Changed local metadata can update an existing index entry without creating a second entry.
- True duplicate detection across different local asset ids remains out of scope.
- Future checksum or perceptual hash support can extend identity without changing the current layer boundaries.

## Alternatives Considered

- Asset id only: rejected because it cannot represent changed local asset content.
- Checksum now: rejected because media byte access is not implemented.
- Perceptual hash now: rejected because duplicate detection is not part of PR 011.
