# ADR 0021: Use Source Selection Policy

## Status

Accepted

## Context

The app now indexes media sources/albums separately from photos. Users need to
exclude broad categories such as Screenshots or individual albums without
destroying the source catalog or Android media index.

This behavior must affect Library, Albums, and future backup workflows without
creating direct Presentation-to-Infrastructure dependencies.

## Decision

Represent source selection as an Application-level policy:

- `SourceSelectionSettings` stores enabled categories and per-source overrides.
- `SourceSelectionPolicy` decides whether a source or indexed photo entry is
  included.
- `SourceSelectionRepository` is the Application port.
- `SourceSelectionStore` persists settings in Infrastructure.

The media source catalog remains separate from selection settings.

## Consequences

- Library and Albums share one selection model.
- Disabled sources are hidden from visible library results without deleting
  source or photo index records.
- Future backup planning can reuse the same policy before enqueueing work.
- Storage schema version increases to `3`.

## Alternatives Considered

- Store enabled flags directly in `media_sources`: rejected because catalog
  state and user preference would be coupled.
- Keep selection only in Presentation state: rejected because backup and other
  use cases also need the same rule.
