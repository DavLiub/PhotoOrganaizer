import 'package:flutter/material.dart';

import '../../localization/app_localizations.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.language_outlined),
            title: Text(l10n.language),
          ),
          ListTile(
            leading: const Icon(Icons.cloud_outlined),
            title: Text(l10n.googleDrive),
          ),
          ListTile(
            leading: const Icon(Icons.tune_outlined),
            title: Text(l10n.backupProfile),
          ),
        ],
      ),
    );
  }
}
