# ADR 0006: Use Photo Manager for Media Access

## Context

The app needs to enumerate local photo assets, read metadata, handle albums where useful, and respect Android media permissions. This should be isolated in Infrastructure behind media-library Application ports.

## Decision

Use `photo_manager` as the first media library access package for Release 1.0.

The adapter must expose only project-specific photo metadata and identifiers to Application. `photo_manager` types must not cross into Domain or Presentation.

## Consequences

- The first media scan implementation can reuse a mature Flutter plugin instead of custom MediaStore code.
- Permission and asset access behavior remains centralized in the Infrastructure media adapter.
- If Android-specific behavior is insufficient, the adapter can later move to platform channels without changing Application interfaces.

## Alternatives Considered

- Custom Android MediaStore adapter: maximum control, but more code and permission complexity.
- `image_picker`: designed for user-selected media, not full-library indexing.
- Flutter file APIs: insufficient for modern scoped storage and media permissions.

## Research Notes

As of 2026-07-21, `photo_manager` is active on pub.dev and provides asset and album APIs for Android and other platforms.
