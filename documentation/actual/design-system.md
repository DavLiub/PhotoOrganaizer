# Design System

## Current Scope

The app uses Flutter Material 3 as the base design system. The current design
foundation is intentionally small and Presentation-only.

No new UI dependencies are used.

## Theme

`lib/presentation/theme/app_theme.dart` defines the light app theme.

The theme configures:

- seed color and light app background;
- app bars;
- cards;
- chips;
- filled buttons;
- input fields;
- navigation bar;
- segmented buttons;
- sliders;
- switches;
- dividers.

Dark theme is not implemented yet.

## Status Palette

`AppStatusPalette` is a `ThemeExtension` used by Presentation widgets for
semantic status rendering.

Current tones:

- `protected`: photo is protected/backed up;
- `queued`: work is queued;
- `inProgress`: scan or upload is running;
- `failed`: operation failed;
- `ignored`: item is excluded or ignored;
- `notConfigured`: required configuration is missing;
- `neutral`: informational status.

Widgets should use the semantic tone instead of hard-coded colors.

## Shared Widgets

Current reusable widgets:

- `StatusBadge`: compact status label with icon and semantic colors.
- `StatusBanner`: inline status message with optional actions.
- `EmptyState`: centered empty-state content.
- `FailureState`: standard error state built on `StatusBanner`.

These widgets do not own business state. Screens pass labels, status tones,
icons, and callbacks into them.

## Applied Screens

The foundation is currently applied to:

- Library backup status badges and empty/error states;
- Albums/Sources availability status badges and empty/error states;
- Settings status cards and placeholder detail screens.

## Known Limitations

- Palette is ready for visual review, not final brand approval.
- There is no dark theme.
- There are no typography tokens beyond `ThemeData`.
- There are no shared layout templates yet.
