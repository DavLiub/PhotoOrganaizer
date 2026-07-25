import 'package:flutter/material.dart';

import '../localization/app_localizations.dart';

enum MainDestination {
  home(icon: Icons.home_outlined, selectedIcon: Icons.home),
  photos(icon: Icons.photo_library_outlined, selectedIcon: Icons.photo_library),
  history(icon: Icons.history_outlined, selectedIcon: Icons.history),
  premium(
    icon: Icons.workspace_premium_outlined,
    selectedIcon: Icons.workspace_premium,
  );

  const MainDestination({required this.icon, required this.selectedIcon});

  final IconData icon;
  final IconData selectedIcon;

  String label(AppLocalizations l10n) {
    return switch (this) {
      MainDestination.home => l10n.home,
      MainDestination.photos => l10n.photos,
      MainDestination.history => l10n.history,
      MainDestination.premium => l10n.premium,
    };
  }
}
