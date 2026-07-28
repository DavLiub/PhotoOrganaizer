import 'package:flutter/material.dart';

import '../../localization/app_localizations.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _diagnosticsEnabled = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          _SettingsSection(
            title: l10n.status,
            children: [
              _InfoTile(
                icon: Icons.workspace_premium_outlined,
                title: l10n.premium,
                subtitle: l10n.freePlan,
              ),
              _InfoTile(
                icon: Icons.cloud_off_outlined,
                title: l10n.storage,
                subtitle: l10n.storageNotConnected,
              ),
            ],
          ),
          _SettingsSection(
            title: l10n.storage,
            children: [
              _NavTile(icon: Icons.cloud_outlined, title: l10n.provider),
              _NavTile(
                icon: Icons.alternate_email_outlined,
                title: l10n.connectedAccount,
              ),
              _NavTile(icon: Icons.folder_outlined, title: l10n.rootFolder),
              _NavTile(
                icon: Icons.account_tree_outlined,
                title: l10n.photoPathTemplate,
              ),
            ],
          ),
          _SettingsSection(
            title: l10n.general,
            children: [
              _NavTile(icon: Icons.tune_outlined, title: l10n.appPreferences),
            ],
          ),
          _SettingsSection(
            title: l10n.mediaLibrary,
            children: [
              _NavTile(icon: Icons.category_outlined, title: l10n.categories),
              _NavTile(
                icon: Icons.create_new_folder_outlined,
                title: l10n.includedFolders,
              ),
              _NavTile(
                icon: Icons.refresh_outlined,
                title: l10n.refreshBehavior,
              ),
            ],
          ),
          _SettingsSection(
            title: l10n.backupConfiguration,
            children: [
              _NavTile(
                icon: Icons.photo_size_select_large,
                title: l10n.photoSize,
              ),
              _NavTile(
                icon: Icons.high_quality_outlined,
                title: l10n.imageQuality,
              ),
              _NavTile(icon: Icons.info_outline, title: l10n.keepMetadata),
              _NavTile(icon: Icons.image_outlined, title: l10n.backupOriginals),
            ],
          ),
          _SettingsSection(
            title: l10n.backgroundWork,
            children: [
              _NavTile(
                icon: Icons.cloud_sync_outlined,
                title: l10n.backgroundBackup,
              ),
              _NavTile(
                icon: Icons.sync_outlined,
                title: l10n.backgroundRefresh,
              ),
              _NavTile(icon: Icons.wifi_outlined, title: l10n.wifiOnly),
              _NavTile(
                icon: Icons.battery_charging_full_outlined,
                title: l10n.runWhileCharging,
              ),
              _NavTile(
                icon: Icons.battery_saver_outlined,
                title: l10n.batteryOptimization,
              ),
            ],
          ),
          _SettingsSection(
            title: l10n.language,
            children: [
              _NavTile(icon: Icons.language_outlined, title: l10n.language),
            ],
          ),
          _SettingsSection(
            title: l10n.about,
            children: [
              _InfoTile(
                icon: Icons.apps_outlined,
                title: l10n.appName,
                subtitle: l10n.appTitle,
              ),
              _InfoTile(
                icon: Icons.badge_outlined,
                title: l10n.packageId,
                subtitle: 'com.davliub.photoorganizer',
              ),
              _InfoTile(
                icon: Icons.tag_outlined,
                title: l10n.appVersion,
                subtitle: '0.0.8+8',
              ),
              _InfoTile(
                icon: Icons.person_outline,
                title: l10n.author,
                subtitle: 'David Liubinskii',
              ),
              SwitchListTile(
                secondary: const Icon(Icons.bug_report_outlined),
                title: Text(l10n.diagnosticsConsent),
                value: _diagnosticsEnabled,
                onChanged: (value) {
                  setState(() {
                    _diagnosticsEnabled = value;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  const _SettingsSection({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 0, 4, 8),
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              border: Border.all(
                color: Theme.of(context).colorScheme.outlineVariant,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
    );
  }
}

class _NavTile extends StatelessWidget {
  const _NavTile({required this.icon, required this.title});

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => _SettingsDetailScreen(title: title),
          ),
        );
      },
    );
  }
}

class _SettingsDetailScreen extends StatelessWidget {
  const _SettingsDetailScreen({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.construction_outlined,
                size: 48,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 16),
              Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(l10n.placeholderDetail, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}
