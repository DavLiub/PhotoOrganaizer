# 2026-07-22 App Identity and Versioning

## Changed

- Set public Android app label to `Photo Organizer`.
- Set Android `applicationId`, namespace, and Kotlin package to `com.davliub.photoorganizer`.
- Renamed the Dart package to `photo_organizer`.
- Changed pre-release source version to `0.0.8+8`.
- Added Android signing secret ignore rules and a safe `android/key.properties.example` template.
- Added ADR 0012 for app identity, versioning, and signing policy.
- Added actual app identity documentation.

## Notes

No real keystore, signing password, or release signing credential was added.
