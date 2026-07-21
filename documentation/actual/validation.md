# Actual Validation

## CI Validation

GitHub Actions runs Flutter checks for pull requests and pushes to `main`.

Workflow:

```text
.github/workflows/flutter-checks.yml
```

Checks:

- `flutter pub get`
- `dart format --set-exit-if-changed .`
- `flutter analyze`
- `flutter test`

## Local Validation

Preferred local commands:

```powershell
flutter pub get
dart format --set-exit-if-changed .
flutter analyze
flutter test
```

## Codex Shell Note

In the current Codex sandbox on Windows, `dart.bat` and `flutter.bat` may time out because Flutter SDK cache access under `C:\tools\flutter` requires permissions outside the repository sandbox.

For diagnostics from Codex, use the Dart executable directly where possible:

```powershell
& 'C:\tools\flutter\bin\cache\dart-sdk\bin\dart.exe' analyze lib test
```

For Flutter commands, run with access to the Flutter SDK cache.
