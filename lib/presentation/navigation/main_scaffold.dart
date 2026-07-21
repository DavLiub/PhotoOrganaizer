import 'package:flutter/material.dart';

import '../../bootstrap/app_composition_root.dart';
import '../screens/history/history_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/photos/photos_screen.dart';
import '../screens/premium/premium_screen.dart';
import '../screens/settings/settings_screen.dart';
import 'main_destination.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({
    required this.compositionRoot,
    super.key,
  });

  final AppCompositionRoot compositionRoot;

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  MainDestination _destination = MainDestination.home;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Photo Archive'),
        actions: [
          IconButton(
            tooltip: 'Settings',
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const SettingsScreen(),
                ),
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
              label: destination.label,
            ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return switch (_destination) {
      MainDestination.home => HomeScreen(
          observeProtectionSummary:
              widget.compositionRoot.observeProtectionSummary,
          startBackup: widget.compositionRoot.startBackup,
        ),
      MainDestination.photos => const PhotosScreen(),
      MainDestination.history => const HistoryScreen(),
      MainDestination.premium => const PremiumScreen(),
    };
  }
}
