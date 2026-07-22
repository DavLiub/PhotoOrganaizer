# Photo Organizer

Photo Organizer is a Flutter Android application for safe photo backup.

## Authorship

Project owner and primary author: **David Liubinskii**.

- Email: `workdltest@gmail.com`
- GitHub: [@DavLiub](https://github.com/DavLiub)

See [AUTHORS.md](AUTHORS.md) for authorship attribution.

## Documentation

Project documentation is maintained under `documentation/`.

Tracked documentation includes requirements, actual implementation documentation, architecture decisions, and changelog entries. Local raw source documents, feature planning notes, and AI logs are intentionally ignored by Git.

## Development

```powershell
flutter pub get
dart format --set-exit-if-changed .
python tools/ci/architecture_guard.py
flutter analyze
flutter test
flutter run
```

## Structure

- `lib/bootstrap` wires concrete adapters into application use cases.
- `lib/domain` contains business entities, value objects, and domain models.
- `lib/application` contains use cases and ports implemented by infrastructure.
- `lib/presentation` contains Flutter UI, navigation, screens, widgets, and theme.
- `lib/infrastructure` contains platform and external-system adapters grouped by area.
