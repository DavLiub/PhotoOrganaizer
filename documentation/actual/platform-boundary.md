# Platform Boundary

## Current Direction

Development targets Android first. The runtime architecture is prepared so Domain, Application, and Presentation do not depend on Android-only APIs.

## Platform Selection

Bootstrap owns platform selection through:

```text
lib/bootstrap/app_platform.dart
lib/bootstrap/media_adapters.dart
```

Supported platform values:

- `android`
- `ios`
- `unsupported`

`APP_PLATFORM` can be provided as a Dart environment value. The default runtime platform is Android.

## Media Adapters

Current media adapters:

```text
lib/infrastructure/media/android_media_access.dart
lib/infrastructure/media/android_media_library_gateway.dart
lib/infrastructure/media/ios_media_access.dart
lib/infrastructure/media/ios_media_library_gateway.dart
lib/infrastructure/media/unsupported_media_access.dart
lib/infrastructure/media/unsupported_media_library_gateway.dart
```

Android adapters are the active production direction. Android media permissions and image metadata scanning are implemented through `photo_manager`.

iOS and unsupported adapters are placeholders that return empty media results or unavailable permission state.

## Layer Rules

- Domain must not contain Android, iOS, or Flutter platform APIs.
- Application must use ports such as `MediaPermissionGateway` and `MediaLibraryGateway`.
- Infrastructure owns platform-specific adapters.
- Bootstrap selects concrete platform adapters.
- Presentation consumes Application use cases only.

## Known Limitations

- No real iOS native project work is implemented.
- No iOS permission or media scanning behavior exists.
- Platform selection currently affects media adapters only.
- iOS remains architecture-ready only; no iOS project or native permission behavior is implemented.
