# ADR 0007: Use Google APIs for Drive Integration

## Context

Release 1.0 uses Google Drive as the first cloud provider. The app needs user authentication, scoped authorization, and typed Drive API access without shipping service account credentials.

## Decision

Use:

- `google_sign_in` for user authentication and authorization;
- `extension_google_sign_in_as_googleapis_auth` to create authenticated clients;
- `googleapis` for typed Google Drive API access;
- `http` only as required by Google API clients or explicit adapter needs.

Do not use service account credentials inside the Flutter app.

## Consequences

- Drive integration follows Flutter's documented Google API flow.
- User-data access remains based on user consent and scopes.
- Cloud adapter can stay behind Application `CloudProvider` interfaces.
- Token refresh and authorization failures must be handled explicitly in the adapter.

## Alternatives Considered

- Raw REST calls: more manual request/auth/error mapping.
- `googleapis_auth` directly in Flutter: rejected because package documentation warns against direct Flutter app usage and recommends the extension bridge.
- Backend service account access: out of scope for Release 1.0 and unsafe if credentials ship with the app.

## Research Notes

Flutter's Google APIs documentation recommends `google_sign_in`, scoped authorization, the extension bridge, and `googleapis` API classes for user-data APIs.
