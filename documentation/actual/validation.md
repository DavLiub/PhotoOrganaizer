# Actual Validation

## CI Validation

GitHub Actions runs Flutter checks for pull requests and pushes to `main` or `master`.

Workflow:

```text
.github/workflows/flutter-checks.yml
```

Checks:

- `flutter pub get`
- `dart format --set-exit-if-changed .`
- `flutter analyze`
- `flutter test`

## Main Branch Tags

Successful push validation on `main` or `master` triggers:

```text
.github/workflows/release-tag.yml
```

The release tag workflow creates a patch tag for the checked commit:

```text
v0.0.1
v0.0.2
v0.0.3
```

Tags are created only for successful push events on `main` or `master`. Pull request branches are not tagged.

## Branch Protection

Configure GitHub branch protection for `main`:

- require pull requests before merging;
- require `Flutter Checks / Format, Analyze, Test`;
- block direct pushes;
- keep tag creation limited to the release workflow.

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
