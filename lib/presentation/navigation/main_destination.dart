import 'package:flutter/material.dart';

enum MainDestination {
  home(label: 'Home', icon: Icons.home_outlined, selectedIcon: Icons.home),
  photos(
    label: 'Photos',
    icon: Icons.photo_library_outlined,
    selectedIcon: Icons.photo_library,
  ),
  history(
    label: 'History',
    icon: Icons.history_outlined,
    selectedIcon: Icons.history,
  ),
  premium(
    label: 'Premium',
    icon: Icons.workspace_premium_outlined,
    selectedIcon: Icons.workspace_premium,
  );

  const MainDestination({
    required this.label,
    required this.icon,
    required this.selectedIcon,
  });

  final String label;
  final IconData icon;
  final IconData selectedIcon;
}
