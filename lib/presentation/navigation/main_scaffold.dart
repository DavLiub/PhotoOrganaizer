import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../screens/history/history_screen.dart';
import '../screens/photos/photos_screen.dart';
import '../screens/premium/premium_screen.dart';
import '../screens/settings/settings_screen.dart';
import '../localization/app_localizations.dart';
import 'main_destination.dart';
import '../state/main_destination_controller.dart';

class MainScaffold extends ConsumerWidget {
  const MainScaffold({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final destination = ref.watch(mainDestinationProvider);

    return Scaffold(
      body: _buildBody(destination),
      bottomNavigationBar: NavigationBar(
        selectedIndex: destination.index,
        onDestinationSelected: (index) {
          ref
              .read(mainDestinationProvider.notifier)
              .select(MainDestination.values[index]);
        },
        destinations: [
          for (final destination in MainDestination.values)
            NavigationDestination(
              icon: Icon(destination.icon),
              selectedIcon: Icon(destination.selectedIcon),
              label: destination.label(l10n),
            ),
        ],
      ),
    );
  }

  Widget _buildBody(MainDestination destination) {
    return switch (destination) {
      MainDestination.library => const PhotosScreen(),
      MainDestination.history => const HistoryScreen(),
      MainDestination.premium => const PremiumScreen(),
      MainDestination.settings => const SettingsScreen(),
    };
  }
}
