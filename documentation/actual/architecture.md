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
