# 2026-07-23 Permission and Privacy Boundary

## Changed

- Added `MediaPermission` and `MediaPermissionState`.
- Added `MediaPermissionGateway`.
- Added `CheckMediaAccess` and `RequestMediaAccess`.
- Added `AndroidMediaAccess` placeholder adapter.
- Wired media permission use cases through the composition root.
- Updated `PermissionsScreen` to consume Application use cases instead of static placeholder text.
- Added tests for domain permission state, application use cases, infrastructure placeholder behavior, and permission UI behavior.
- Documented media permission and privacy boundaries.

## Notes

- Real Android permission API integration is still deferred.
- Permission state is runtime workflow metadata and is not persisted.
