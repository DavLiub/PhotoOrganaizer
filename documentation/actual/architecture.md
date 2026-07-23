# Actual Architecture

## Current Module Layout

```text
lib/
  main.dart
  bootstrap/
  domain/
  application/
  infrastructure/
  presentation/
```

## Current Dependency Direction

- `main.dart` delegates startup to `bootstrap`.
- `bootstrap` creates the application composition root.
- `bootstrap` owns app mode selection and production safety checks.
- `application` depends on `domain` and defines ports.
- `infrastructure` implements application ports with placeholder adapters.
- `presentation` displays shell screens and consumes composed application dependencies through the app shell.
- `domain` has no Flutter or platform dependencies.

## Infrastructure Areas

```text
lib/infrastructure/
  background/
  billing/
  cloud/
  entitlements/
  media/
  observability/
  storage/
```

## Known Limitations

- Real Android media access is not implemented.
- Real Google Drive integration is not implemented.
- Real billing and entitlement verification are not implemented.
- Real persistence is not implemented.
- Background scheduling is represented by a placeholder adapter.

## Access Model

- Domain defines access concepts such as capability, profile, decision, status, reason, and tier.
- Application owns `AccessPolicy` and decides if a capability is allowed, limited, denied, or unavailable.
- Infrastructure implements `EntitlementGateway` and provides entitlement facts.
- Test/debug access is represented through `AccessOverride` and `TestEntitlementGateway`.
- Presentation must not make Free/Premium decisions directly.
- Production composition rejects `AccessOverride` and `TestEntitlementGateway`.

## Error Model and Observability

- Domain defines `OperationResult`, `OperationSuccess`, `OperationFailure`, `FailureInfo`, and `FailureKind`.
- Application use cases and ports can return structured failures without depending on Flutter, platform SDKs, or logging SDKs.
- `FailureInfo` separates stable technical codes from optional safe user-facing messages.
- Retryable and user-action-required flags distinguish permanent failures from deferred phone/system states.
- Application defines `ObservabilitySink`.
- Infrastructure implements the sink through `ConsoleObservabilitySink`.
- Observability attributes are sanitized before output and must not contain photo paths, file names, EXIF/location data, account identifiers, cloud object IDs, tokens, secrets, or credentials.

## Media Permissions

- Domain defines `MediaPermission` and `MediaPermissionState`.
- Application defines `MediaPermissionGateway`.
- Application exposes media permission flow through `CheckMediaAccess` and `RequestMediaAccess`.
- Infrastructure implements the current placeholder through `AndroidMediaAccess`.
- Presentation consumes only Application use cases for permission state and request actions.
- Android permission APIs and future plugin types must stay inside Infrastructure.

## Photo Index

- Domain defines local photo identity, photo index entry, index status, and index scope.
- Application exposes `IndexPhotos` and `ResolvePhotoIdentity`.
- `IndexPhotos` checks `MediaPermissionGateway` before writing index entries.
- `PhotoIndexRepository` is the Application port for identity lookup, asset-id lookup, entry upsert, and protection summary streaming.
- Infrastructure storage remains a placeholder and does not implement real persistence yet.
- Presentation does not depend on photo index storage or Infrastructure adapters directly.

## App Mode

App mode is represented by `AppMode` in `lib/bootstrap/app_mode.dart`.

Supported modes:

- `production`
- `debug`
- `test`

The default mode is `production`. Runtime startup reads `APP_MODE` through a compile-time Dart environment value and passes the selected mode into the composition root. App mode is not exposed as a global singleton.

## Project Guards

Custom project checks are implemented in:

```text
tools/ci/architecture_guard.py
tools/ci/test_import_guard.py
tools/ci/sdk_leak_guard.py
tools/ci/secret_guard.py
tools/ci/naming_report.py
```

CI runs guards on changed lines/files only. Layer violations, test/debug imports, SDK/plugin leaks, and secret findings are blocking. Naming findings are advisory and are printed as CI warnings.

## Approved Integration Direction

- Persistence will use Drift behind Infrastructure storage adapters.
- Presentation state will use Riverpod and expose Application use cases to widgets.
- Background work will use Workmanager behind Application scheduling ports.
- Media access will use Photo Manager behind Infrastructure media adapters.
- Google Drive integration will use Google Sign-In, the Google APIs auth bridge, and typed Google APIs clients.
- Secrets will use Flutter Secure Storage.
- Observability will use Dart `logging` behind project observability ports.
- Bootstrap remains the composition root; no DI container is approved yet.
