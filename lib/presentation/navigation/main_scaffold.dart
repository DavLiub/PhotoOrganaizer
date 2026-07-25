import 'package:flutter/material.dart';

import '../screens/history/history_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/photos/photos_screen.dart';
import '../screens/premium/premium_screen.dart';
import '../screens/settings/settings_screen.dart';
import '../localization/app_localizations.dart';
import 'main_destination.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  MainDestination _destination = MainDestination.home;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          IconButton(
            tooltip: l10n.settings,
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (_) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: _buildBody(),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _destination.index,
        onDestinationSelected: (index) {
          setState(() {
            _destination = MainDestination.values[index];
          });
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

  Widget _buildBody() {
    return switch (_destination) {
      MainDestination.home => const HomeScreen(),
      MainDestination.photos => const PhotosScreen(),
      MainDestination.history => const HistoryScreen(),
      MainDestination.premium => const PremiumScreen(),
    };
  }
}
