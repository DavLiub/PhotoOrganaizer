# 2026-07-22 Architecture Guards and App Mode

## Changed

- Added explicit `AppMode` values for production, debug, and test.
- Wired app mode through the Bootstrap composition root.
- Rejected active `AccessOverride` and `TestEntitlementGateway` in production composition.
- Added a diff-based architecture guard script.
- Added the architecture guard to Flutter Checks CI.
- Added advisory naming warnings for changed Dart lines.
- Added ADR 0013 and actual documentation updates.

## Notes

The architecture guard blocks layer violations. Naming findings are advisory and do not fail CI by themselves.
