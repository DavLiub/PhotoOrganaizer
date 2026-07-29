# 0022. Use Null Locale Override

## Context

Release 1.0 supports English and Russian UI. The app should follow the Android
system locale before the user makes a manual language choice, but a manual
choice must override the system locale and survive restart.

Persisting the resolved system locale on first launch would make the app stop
reacting to future system language changes even though the user did not choose
an app language.

## Decision

Persist app language as an optional app-level setting:

- `selectedLocaleCode == null`: no user override, use Flutter system locale
  resolution with supported locales.
- `selectedLocaleCode == "en"` or `"ru"`: user override, pass that locale to
  `MaterialApp.locale`.

The setting is stored separately from media source selection.

## Consequences

- First launch does not write any app language row.
- Unsupported system locales fall back to English through Flutter locale
  resolution.
- Manual language selection applies immediately and survives restart.
- A future `System default` UI option can clear the stored override instead of
  introducing a new state model.

## Alternatives Considered

- Persist the resolved system locale on first launch: rejected because it loses
  true system fallback behavior.
- Add a visible `System default` option now: rejected as out of Release 1.0
  scope.
