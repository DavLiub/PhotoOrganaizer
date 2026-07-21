# Actual Library Decisions

## Current Dependency State

No new dependencies were added in the core library decision PR. The current `pubspec.yaml` remains the Flutter skeleton dependency set.

## Approved Direction

| Area | Decision |
|---|---|
| Local persistence | Use `drift`; add `drift_dev` and `build_runner` when schema implementation starts. |
| Presentation state | Use `flutter_riverpod`; defer generator/lint packages initially. |
| Background scheduling | Use `workmanager` behind Application ports. |
| Media access | Use `photo_manager` behind Infrastructure media adapters. |
| Google Drive | Use `google_sign_in`, `extension_google_sign_in_as_googleapis_auth`, and `googleapis`. |
| Secret storage | Use `flutter_secure_storage` for small sensitive values only. |
| Logging | Use Dart `logging` as the base logging API. |
| Dependency injection | Keep explicit Bootstrap composition root; no DI container yet. |
| Model code generation | Do not add `freezed` yet. |

## Layering Rule

All selected packages must be used through Infrastructure adapters or Presentation state wiring. Domain must remain package-independent except for Dart SDK types.

## Implementation Rule

Each dependency must be added only in the PR that implements the first real adapter/use case needing it.
