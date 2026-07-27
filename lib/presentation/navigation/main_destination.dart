import 'package:flutter/material.dart';

import '../localization/app_localizations.dart';

enum MainDestination {
  library(
    icon: Icons.photo_library_outlined,
    selectedIcon: Icons.photo_library,
  ),
  history(icon: Icons.history_outlined, selectedIcon: Icons.history),
  premium(
    icon: Icons.workspace_premium_outlined,
    selectedIcon: Icons.workspace_premium,
  ),
  settings(icon: Icons.settings_outlined, selectedIcon: Icons.settings);

  const MainDestination({required this.icon, required this.selectedIcon});

  final IconData icon;
  final IconData selectedIcon;

  String label(AppLocalizations l10n) {
    return switch (this) {
      MainDestination.library => l10n.library,
      MainDestination.history => l10n.history,
      MainDestination.premium => l10n.premium,
      MainDestination.settings => l10n.settings,
    };
  }
}
