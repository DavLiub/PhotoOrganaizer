# Media Permissions and Privacy

## Current Permission Boundary

Media permission state is modeled in Domain through `MediaPermission` and `MediaPermissionState`.

Supported states:

- `granted`
- `limited`
- `denied`
- `permanentlyDenied`
- `unavailable`
- `unknown`

Application defines `MediaPermissionGateway` and exposes permission flow through:

- `CheckMediaAccess`
- `RequestMediaAccess`

Infrastructure implements the current placeholder adapters:

```text
lib/infrastructure/media/android_media_access.dart
lib/infrastructure/media/ios_media_access.dart
lib/infrastructure/media/unsupported_media_access.dart
```

Android currently returns `unavailable` with detail code `media.permission_adapter_deferred` because the real Android permission plugin integration is intentionally deferred.

iOS currently returns `unavailable` with detail code `media.ios_not_implemented`. This is a placeholder boundary only, not active iOS feature development.

## UI Boundary

`PermissionsScreen` consumes Application use cases only. It does not import Android APIs, plugin types, or Infrastructure adapters.

## Privacy Rules

Permission and media-access workflows must not log or expose:

- local photo paths;
- file names or display names;
- EXIF data;
- location or GPS metadata;
- account identifiers;
- cloud object identifiers;
- tokens or credentials.

Permission state is runtime state. It is not persisted in the current implementation.

## Known Limitations

- Real Android permission status mapping is not implemented yet.
- Real iOS permission status mapping is not implemented yet.
- The setup screen is not wired into the main navigation flow yet.
- Limited-access photo selection behavior is modeled but not implemented.
