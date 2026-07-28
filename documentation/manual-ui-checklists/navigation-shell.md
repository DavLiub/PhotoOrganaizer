# Navigation Shell Checklist

## Preconditions

- App is installed and launches successfully.
- Media permission state can be granted or denied.

## Checklist

- [ ] Open the app.
  Expected: bottom navigation is visible.

- [ ] Verify bottom navigation destinations.
  Expected: `Library`, `Albums`, `History`, and `Settings` are visible.

- [ ] Verify Premium is not a bottom navigation destination.
  Expected: no `Premium` tab is shown.

- [ ] Tap `Library`.
  Expected: library permission state or indexed photo grid is shown.

- [ ] Tap `Albums`.
  Expected: album management placeholder is shown.

- [ ] Tap `History`.
  Expected: history placeholder is shown.

- [ ] Tap `Settings`.
  Expected: grouped Settings screen opens.

- [ ] Switch device locale to Russian and reopen the app.
  Expected: navigation labels and Settings labels are localized.

- [ ] Test on a narrow phone viewport.
  Expected: bottom navigation labels do not overlap.
