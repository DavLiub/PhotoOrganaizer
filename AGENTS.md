# Repository Guidelines

## Project Structure & Module Organization

This repository contains a Flutter Android application skeleton for Smart Photo Archive / PhotoOrganaizer.

- `lib/main.dart` is the Dart entry point.
- `lib/bootstrap` wires concrete implementations into application use cases.
- `lib/domain` contains platform-independent entities, value objects, and domain models.
- `lib/application` contains use cases and ports/interfaces.
- `lib/infrastructure` is the preferred location for platform and external-system adapters, grouped by area such as `media`, `storage`, `cloud`, `background`, `billing`, `entitlements`, and `observability`.
- `lib/presentation` contains Flutter UI: app shell, navigation, screens, widgets, and theme.
- `android` contains generated Android/Gradle platform files.
- `test` contains Flutter tests.
- `documentation` contains project specifications, actual implementation documentation, architecture decisions, and project documentation maintained together with the source code.

## Branch Policy

Never work directly on:

- `main`
- `master`

Before making any code changes:

1. Check the current branch.
2. If the branch is `main` or `master`, stop.
3. Create a feature branch.
4. Perform all work inside that branch.

Typical branch names:

- `feature/photo-index`
- `feature/google-drive`
- `bugfix/upload-retry`
- `docs/data-model`
- `refactor/image-cache`

## Pull Request Planning

Before implementation, prepare a PR plan. Implementation starts only after the plan has been prepared.

The plan must include:

- Goal
- Scope
- Out of Scope
- Files to modify
- Architecture impact
- Data Model impact
- Dependencies
- Risks
- Testing plan

## AI Action Log

Every completed task must include an AI action log with this structure:

- Task
- Branch
- PR
- Files changed
- Existing libraries reused
- Existing modules reused
- Architecture decisions
- Tests added
- Tests executed
- Documentation updated
- Known limitations
- Remaining work

## Documentation

Documentation is part of every implementation. When changing the project, update the corresponding specification documents.

Changes require updates to:

- Architecture: `documentation/requirements/architecture`
- Data Model: `documentation/requirements/data-model`
- Functional behavior: `documentation/requirements/functional-specification`
- UI: `documentation/requirements/ui`
- Non-functional requirements: `documentation/requirements/non-functional`

In addition to the original specifications, maintain an Actual Documentation folder:

```text
documentation/actual
```

Use `documentation/actual` to describe the current implementation as it exists in source code.

Recommended documentation layout:

```text
documentation/
  requirements/   English working requirements, product docs, roadmap
  actual/         current implemented design
  decisions/      architecture decision records
  changelog/      changes between versions
```

Rules:

- Original specification documents describe the intended design.
- `documentation/actual` describes the implemented design.
- If implementation intentionally differs from the original specification, document the difference.
- Every significant architectural, data model, or workflow change must be reflected in `documentation/actual`.
- Actual documentation should include diagrams, module descriptions, sequence flows, configuration, implementation notes, and known deviations from the original design.
- Documentation must evolve together with the code.
- Code and Actual Documentation should always remain synchronized.

If implementation cannot follow the original specification:

1. Document the reason.
2. Update `documentation/actual`.
3. If the change is permanent, update the original specification or create an Architecture Decision Record in `documentation/decisions`.
4. Never allow implementation and documentation to diverge silently.

## Library First

Always prefer existing solutions. Search in this order:

1. Dart Standard Library
2. Flutter SDK
3. Official packages
4. Approved project dependencies
5. Existing project modules
6. New project implementation

Never implement common infrastructure manually when a mature library already solves the problem.

Before adding a new dependency, evaluate:

- maintenance
- popularity
- documentation
- license
- security
- transitive dependencies
- project size impact

Do not add a dependency for trivial functionality.

## Internal Reuse

Before writing new code, search the project. If similar logic already exists, reuse it.

If the same project-specific logic appears in multiple places, extract it into a reusable project module.

Shared project logic should exist in one place only.

Avoid duplicated validation, retry logic, error mapping, cloud responses, configuration, logging, hashing, and serialization.

## Architecture Direction

Keep dependencies aligned with the project layers:

```text
Presentation
        v
Application
        v
Domain

Infrastructure
        ^
Application interfaces

Bootstrap wires the app together.
```

- Domain must not depend on any other layer.
- Application may depend only on Domain.
- Infrastructure implements interfaces defined by Application.
- Presentation communicates only through Application.
- Bootstrap owns the composition root and wires concrete implementations.

## Build, Test, and Development Commands

Run these from the repository root:

```powershell
flutter pub get
dart format .
flutter analyze
flutter test
flutter run
flutter build apk --debug
```

`flutter pub get` restores dependencies. `dart format .` applies Dart formatting. `flutter analyze` runs static analysis. `flutter test` runs widget/unit tests. `flutter run` launches the app on a connected device. `flutter build apk --debug` verifies Android debug APK packaging.

## Coding Style & Naming Conventions

Use Dart defaults and the configured `flutter_lints` rules in `analysis_options.yaml`.

- Prefer `const` constructors where valid.
- Use `lower_snake_case.dart` for file names.
- Use `UpperCamelCase` for classes, enums, and typedefs.
- Use `lowerCamelCase` for methods, variables, and fields.
- Keep `domain` free of Flutter, Android SDK, storage SDK, and cloud SDK imports.
- Do not import `infrastructure` from `presentation`; access behavior through `application` use cases.

Prefer names containing no more than three words for modules, classes, interfaces, files, methods, and other identifiers.

Good examples:

- `PhotoRepository`
- `UploadQueue`
- `CheckAccess`

Avoid:

- `PhotoRepositoryManager`
- `CreateBackupForCloudStorage`

Make the smallest change that solves the task. Do not reformat unrelated files, rename unrelated classes, rewrite working code, or perform opportunistic refactoring. Avoid generic `Utils`, `Helpers`, `Managers`, and `Common` containers; prefer purpose-specific classes.

## Decision Priority

When multiple implementations are possible, always prefer:

1. Existing project module
2. Standard Library
3. Flutter SDK
4. Approved dependency
5. New reusable project component
6. Custom implementation

## Testing Guidelines

Use `flutter_test`. Keep skeleton tests lightweight and focused on app shell behavior until real features are implemented.

Name test files with `_test.dart`, for example:

```text
test/app_smoke_test.dart
```

When adding feature logic, place tests close to the behavior being validated and include edge cases for backup state, idempotency, and failure handling.

## Commit & Pull Request Guidelines

Current history uses conventional-style commit prefixes:

- `chore: initialize repository`
- `chore: add Flutter architecture skeleton`

Use short imperative commit messages such as `feat: add setup flow shell` or `fix: correct backup status mapping`.

For PRs, include:

- purpose and scope;
- what is intentionally out of scope;
- validation commands run;
- screenshots for UI changes;
- notes about any skipped checks or local environment limitations.

## Security & Configuration

Never commit secrets, OAuth tokens, signing keys, generated signing keys, keystore passwords, service account credentials, or local SDK paths. Keep `android/local.properties`, `.dart_tool/`, and IDE files out of Git.

## Completion Criteria

A task is complete only when:

- implementation is finished
- tests pass or skipped checks are explicitly documented
- documentation is updated
- AI Action Log is updated
- PR summary is prepared
- no unrelated files are modified
- architecture remains valid
