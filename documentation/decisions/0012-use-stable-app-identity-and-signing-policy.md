# ADR 0012: Use Stable App Identity and Signing Policy

## Context

Android app identity becomes hard to change after public release. The skeleton still used generated naming in several places, including a misspelled package name and debug release signing comments.

## Decision

Use the public app name `Photo Organizer`.

Use `com.davliub.photoorganizer` as the Android `applicationId`, Gradle namespace, and Kotlin package root.

Use `photo_organizer` as the Dart package name.

Use pre-release versioning in the `0.0.x+build` format. GitHub Actions creates `v0.0.x` tags for successful validated pushes to `main`. The app version in `pubspec.yaml` should be kept aligned with the expected next release tag before merging.

Release signing must use local, untracked signing configuration. Real keystore files, passwords, and `android/key.properties` must not be committed. The tracked `android/key.properties.example` file documents the expected local keys only.

## Consequences

- App identity is stable before Google Sign-In, Google Play, and cloud integrations depend on it.
- The Dart package import name no longer carries the old misspelling.
- Release signing material remains outside Git.
- Release builds require local signing configuration when production signing is needed.

## Alternatives Considered

- Keep `com.davliub.photo_organaizer`: rejected because it preserves the old misspelling and underscore style in Android identity.
- Keep `Smart Photo Archive` as the app label: rejected because `Photo Organizer` is the selected public app name.
- Commit signing placeholders with real-looking values: rejected because signing material and passwords must stay local.
- Continue signing release builds with the debug key: rejected because release signing should not silently use debug identity.
