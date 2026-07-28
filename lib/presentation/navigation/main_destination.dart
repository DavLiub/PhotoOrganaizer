import 'package:flutter/material.dart';

import '../localization/app_localizations.dart';

enum MainDestination {
  library(
    icon: Icons.photo_library_outlined,
    selectedIcon: Icons.photo_library,
  ),
  albums(icon: Icons.folder_outlined, selectedIcon: Icons.folder),
  history(icon: Icons.history_outlined, selectedIcon: Icons.history),
  settings(icon: Icons.settings_outlined, selectedIcon: Icons.settings);

  const MainDestination({required this.icon, required this.selectedIcon});

  final IconData icon;
  final IconData selectedIcon;

  String label(AppLocalizations l10n) {
    return switch (this) {
      MainDestination.library => l10n.library,
      MainDestination.albums => l10n.albums,
      MainDestination.history => l10n.history,
      MainDestination.settings => l10n.settings,
    };
  }
}
