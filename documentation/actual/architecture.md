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

## App Mode

App mode is represented by `AppMode` in `lib/bootstrap/app_mode.dart`.

Supported modes:

- `production`
- `debug`
- `test`

The default mode is `production`. Runtime startup reads `APP_MODE` through a compile-time Dart environment value and passes the selected mode into the composition root. App mode is not exposed as a global singleton.

## Architecture Guard

Custom architecture checks are implemented in:

```text
tools/ci/architecture_guard.py
```

CI runs the guard on changed Dart lines only. Layer violations are blocking. Naming findings are advisory and are printed as CI warnings.

## Approved Integration Direction

- Persistence will use Drift behind Infrastructure storage adapters.
- Presentation state will use Riverpod and expose Application use cases to widgets.
- Background work will use Workmanager behind Application scheduling ports.
- Media access will use Photo Manager behind Infrastructure media adapters.
- Google Drive integration will use Google Sign-In, the Google APIs auth bridge, and typed Google APIs clients.
- Secrets will use Flutter Secure Storage.
- Observability will use Dart `logging` behind project observability ports.
- Bootstrap remains the composition root; no DI container is approved yet.
