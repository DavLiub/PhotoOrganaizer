# First Scan UI

## Current Scope

The Home area now hosts the first phone-facing flow for local media access and manual photo indexing.

The flow has two screens:

```text
Welcome / Media Access
  -> First Scan
```

## Welcome / Media Access

The first screen explains why media access is required and shows the current permission state.

Behavior:

- the screen checks media permission when it opens;
- if permission state is `unknown`, it automatically requests access;
- if permission is denied or unavailable, the user stays on the welcome screen;
- `Grant access` remains available while the app can request permission;
- `Scan` is not shown before access is granted or limited.

## First Scan

After permission is `granted` or `limited`, the UI switches to the scan screen.

The scan screen shows:

- scan status;
- found photos;
- indexed photos;
- discovered sources;
- manual `Scan` action.

The `Scan` button is disabled while scanning.

`protected` counts are intentionally not shown yet because backup upload and cloud confirmation are not implemented.

## State Management

Presentation uses Riverpod:

- `appRootProvider` exposes the Bootstrap `AppCompositionRoot`;
- `firstScanActionsProvider` exposes Application use case callbacks;
- `firstScanProvider` owns first scan UI state.

Widgets consume Application behavior through providers only. Presentation does not import Infrastructure.

## Localization

The app has project-owned localization in:

```text
lib/presentation/localization/app_localizations.dart
```

Supported UI locales:

- English: `en`
- Russian: `ru`

The current implementation uses a small in-code localization map. It can later be migrated to ARB/codegen if translation volume grows.

## Known Limitations

- Permission prompt behavior still requires manual Android device validation.
- There is no live per-page progress from the media scan contract yet.
- Source include/exclude settings are not available before or during the first scan.
- The UI does not open Android app settings for permanently denied permission yet.
