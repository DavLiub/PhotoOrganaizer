# Actual App Identity

## Public Identity

- App name: `Photo Organizer`
- Android application ID: `com.davliub.photoorganizer`
- Android namespace: `com.davliub.photoorganizer`
- Kotlin package root: `com.davliub.photoorganizer`
- Dart package name: `photo_organizer`

## Versioning

The project uses pre-release versioning while the app is under active foundation development:

```text
0.0.x+build
```

Current source version:

```text
0.0.8+8
```

Flutter maps this to Android as:

- `versionName`: `0.0.8`
- `versionCode`: `8`

Successful validated pushes to `main` are tagged by GitHub Actions as `v0.0.x`. Before merging a PR that changes app behavior or configuration, keep `pubspec.yaml` aligned with the expected next `main` tag.

## Signing Policy

Release signing uses local untracked configuration:

- tracked template: `android/key.properties.example`
- ignored local config: `android/key.properties`
- ignored keystore files: `*.jks`, `*.keystore`

Do not commit keystore files, signing passwords, or generated signing material.

If `android/key.properties` exists locally, Gradle uses the configured release signing key. If it does not exist, the project does not silently sign release builds with the debug key.
