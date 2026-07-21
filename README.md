# PhotoOrganaizer

Smart Photo Archive / PhotoOrganaizer is a Flutter Android application for safe photo backup.

The detailed project documentation is kept locally under `documentation/` and is intentionally excluded from Git.

## Development

```powershell
flutter pub get
flutter analyze
flutter test
flutter run
```

## Structure

- `lib/bootstrap` wires concrete adapters into application use cases.
- `lib/domain` contains business entities, value objects, and domain models.
- `lib/application` contains use cases and ports implemented by infrastructure.
- `lib/presentation` contains Flutter UI, navigation, screens, widgets, and theme.
- `lib/infra` contains platform and external-system adapters grouped by area.
