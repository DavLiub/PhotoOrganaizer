# Actual Library Decisions

## Current Dependency State

The first storage implementation added Drift dependencies:

- `drift`
- `drift_flutter`
- `sqlite3_flutter_libs`
- `drift_dev`
- `build_runner`

Other approved dependencies remain deferred until their first real adapters are implemented.

## Approved Direction

| Area | Decision |
|---|---|
| Local persistence | Use `drift`; `drift_dev` and `build_runner` generate the storage schema support code. |
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

Generated Drift files are committed so CI and local builds do not require implicit code generation before analysis and tests.
