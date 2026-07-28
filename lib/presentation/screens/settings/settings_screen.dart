import 'package:flutter/material.dart';

import '../../localization/app_localizations.dart';

enum _SettingsCategory {
  status(Icons.info_outline),
  storage(Icons.cloud_outlined),
  general(Icons.tune_outlined),
  library(Icons.photo_library_outlined),
  backup(Icons.cloud_upload_outlined),
  background(Icons.sync_outlined),
  language(Icons.language_outlined),
  about(Icons.apps_outlined);

  const _SettingsCategory(this.icon);

  final IconData icon;

  String label(AppLocalizations l10n) {
    return switch (this) {
      _SettingsCategory.status => l10n.status,
      _SettingsCategory.storage => l10n.storage,
      _SettingsCategory.general => l10n.general,
      _SettingsCategory.library => l10n.mediaLibrary,
      _SettingsCategory.backup => l10n.backupConfiguration,
      _SettingsCategory.background => l10n.backgroundWork,
      _SettingsCategory.language => l10n.language,
      _SettingsCategory.about => l10n.about,
    };
  }
}

enum _PhotoSize { optimized, original }

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _rootFolderController = TextEditingController(text: '/PhotoOrganizer');
  final _pathTemplateController = TextEditingController(
    text: '{device}/{year}/{month}',
  );

  _SettingsCategory _selectedCategory = _SettingsCategory.status;
  _PhotoSize _photoSize = _PhotoSize.optimized;
  double _imageQuality = 85;
  bool _keepMetadata = true;
  bool _backupOriginals = false;
  bool _backgroundBackup = false;
  bool _backgroundRefresh = false;
  bool _wifiOnly = true;
  bool _runWhileCharging = false;
  bool _diagnosticsEnabled = false;
  String _language = 'en';

  @override
  void dispose() {
    _rootFolderController.dispose();
    _pathTemplateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: SafeArea(
        child: Row(
          children: [
            _CategoryPane(
              selected: _selectedCategory,
              onSelected: (category) {
                setState(() {
                  _selectedCategory = category;
                });
              },
            ),
            const VerticalDivider(width: 1),
            Expanded(
              child: _SettingsDetailPane(
                category: _selectedCategory,
                rootFolderController: _rootFolderController,
                pathTemplateController: _pathTemplateController,
                photoSize: _photoSize,
                imageQuality: _imageQuality,
                keepMetadata: _keepMetadata,
                backupOriginals: _backupOriginals,
                backgroundBackup: _backgroundBackup,
                backgroundRefresh: _backgroundRefresh,
                wifiOnly: _wifiOnly,
                runWhileCharging: _runWhileCharging,
                diagnosticsEnabled: _diagnosticsEnabled,
                language: _language,
                onPhotoSizeChanged: (value) {
                  setState(() {
                    _photoSize = value;
                  });
                },
                onImageQualityChanged: (value) {
                  setState(() {
                    _imageQuality = value;
                  });
                },
                onKeepMetadataChanged: (value) {
                  setState(() {
                    _keepMetadata = value;
                  });
                },
                onBackupOriginalsChanged: (value) {
                  setState(() {
                    _backupOriginals = value;
                  });
                },
                onBackgroundBackupChanged: (value) {
                  setState(() {
                    _backgroundBackup = value;
                  });
                },
                onBackgroundRefreshChanged: (value) {
                  setState(() {
                    _backgroundRefresh = value;
                  });
                },
                onWifiOnlyChanged: (value) {
                  setState(() {
                    _wifiOnly = value;
                  });
                },
                onRunWhileChargingChanged: (value) {
                  setState(() {
                    _runWhileCharging = value;
                  });
                },
                onDiagnosticsChanged: (value) {
                  setState(() {
                    _diagnosticsEnabled = value;
                  });
                },
                onLanguageChanged: (value) {
                  setState(() {
                    _language = value;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryPane extends StatelessWidget {
  const _CategoryPane({required this.selected, required this.onSelected});

  final _SettingsCategory selected;
  final ValueChanged<_SettingsCategory> onSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return SizedBox(
      width: 116,
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          for (final category in _SettingsCategory.values)
            _CategoryButton(
              category: category,
              label: category.label(l10n),
              selected: selected == category,
              onTap: () {
                onSelected(category);
              },
            ),
        ],
      ),
    );
  }
}

class _CategoryButton extends StatelessWidget {
  const _CategoryButton({
    required this.category,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final _SettingsCategory category;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final background = selected
        ? colorScheme.secondaryContainer
        : Colors.transparent;
    final foreground = selected
        ? colorScheme.onSecondaryContainer
        : colorScheme.onSurfaceVariant;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      child: Material(
        color: background,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          key: ValueKey('settings_category_${category.name}'),
          borderRadius: BorderRadius.circular(8),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(category.icon, size: 22, color: foreground),
                const SizedBox(height: 4),
                Text(
                  label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: Theme.of(
                    context,
                  ).textTheme.labelSmall?.copyWith(color: foreground),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SettingsDetailPane extends StatelessWidget {
  const _SettingsDetailPane({
    required this.category,
    required this.rootFolderController,
    required this.pathTemplateController,
    required this.photoSize,
    required this.imageQuality,
    required this.keepMetadata,
    required this.backupOriginals,
    required this.backgroundBackup,
    required this.backgroundRefresh,
    required this.wifiOnly,
    required this.runWhileCharging,
    required this.diagnosticsEnabled,
    required this.language,
    required this.onPhotoSizeChanged,
    required this.onImageQualityChanged,
    required this.onKeepMetadataChanged,
    required this.onBackupOriginalsChanged,
    required this.onBackgroundBackupChanged,
    required this.onBackgroundRefreshChanged,
    required this.onWifiOnlyChanged,
    required this.onRunWhileChargingChanged,
    required this.onDiagnosticsChanged,
    required this.onLanguageChanged,
  });

  final _SettingsCategory category;
  final TextEditingController rootFolderController;
  final TextEditingController pathTemplateController;
  final _PhotoSize photoSize;
  final double imageQuality;
  final bool keepMetadata;
  final bool backupOriginals;
  final bool backgroundBackup;
  final bool backgroundRefresh;
  final bool wifiOnly;
  final bool runWhileCharging;
  final bool diagnosticsEnabled;
  final String language;
  final ValueChanged<_PhotoSize> onPhotoSizeChanged;
  final ValueChanged<double> onImageQualityChanged;
  final ValueChanged<bool> onKeepMetadataChanged;
  final ValueChanged<bool> onBackupOriginalsChanged;
  final ValueChanged<bool> onBackgroundBackupChanged;
  final ValueChanged<bool> onBackgroundRefreshChanged;
  final ValueChanged<bool> onWifiOnlyChanged;
  final ValueChanged<bool> onRunWhileChargingChanged;
  final ValueChanged<bool> onDiagnosticsChanged;
  final ValueChanged<String> onLanguageChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final title = category.label(l10n);

    return ListView(
      key: const ValueKey('settings_detail_pane'),
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 24),
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        ..._children(context, l10n),
      ],
    );
  }

  List<Widget> _children(BuildContext context, AppLocalizations l10n) {
    return switch (category) {
      _SettingsCategory.status => [
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
      _SettingsCategory.storage => [
        _NavTile(icon: Icons.cloud_outlined, title: l10n.provider),
        _NavTile(
          icon: Icons.alternate_email_outlined,
          title: l10n.connectedAccount,
        ),
        const SizedBox(height: 8),
        _InlineTextField(
          icon: Icons.folder_outlined,
          title: l10n.rootFolder,
          controller: rootFolderController,
        ),
        const SizedBox(height: 12),
        _InlineTextField(
          icon: Icons.account_tree_outlined,
          title: l10n.photoPathTemplate,
          controller: pathTemplateController,
        ),
      ],
      _SettingsCategory.general => [
        _NavTile(icon: Icons.tune_outlined, title: l10n.appPreferences),
      ],
      _SettingsCategory.library => [
        _NavTile(icon: Icons.category_outlined, title: l10n.categories),
        _NavTile(
          icon: Icons.create_new_folder_outlined,
          title: l10n.includedFolders,
        ),
        _NavTile(icon: Icons.refresh_outlined, title: l10n.refreshBehavior),
      ],
      _SettingsCategory.backup => [
        SegmentedButton<_PhotoSize>(
          segments: [
            ButtonSegment(
              value: _PhotoSize.optimized,
              label: Text(l10n.optimizedCopies),
            ),
            ButtonSegment(
              value: _PhotoSize.original,
              label: Text(l10n.originalPhotos),
            ),
          ],
          selected: {photoSize},
          onSelectionChanged: (selection) {
            onPhotoSizeChanged(selection.single);
          },
        ),
        const SizedBox(height: 16),
        _SliderTile(
          title: l10n.imageQuality,
          value: imageQuality,
          onChanged: onImageQualityChanged,
        ),
        SwitchListTile(
          secondary: const Icon(Icons.info_outline),
          title: Text(l10n.keepMetadata),
          value: keepMetadata,
          onChanged: onKeepMetadataChanged,
        ),
        SwitchListTile(
          secondary: const Icon(Icons.image_outlined),
          title: Text(l10n.backupOriginals),
          value: backupOriginals,
          onChanged: onBackupOriginalsChanged,
        ),
      ],
      _SettingsCategory.background => [
        SwitchListTile(
          secondary: const Icon(Icons.cloud_sync_outlined),
          title: Text(l10n.backgroundBackup),
          value: backgroundBackup,
          onChanged: onBackgroundBackupChanged,
        ),
        SwitchListTile(
          secondary: const Icon(Icons.sync_outlined),
          title: Text(l10n.backgroundRefresh),
          value: backgroundRefresh,
          onChanged: onBackgroundRefreshChanged,
        ),
        SwitchListTile(
          secondary: const Icon(Icons.wifi_outlined),
          title: Text(l10n.wifiOnly),
          value: wifiOnly,
          onChanged: onWifiOnlyChanged,
        ),
        SwitchListTile(
          secondary: const Icon(Icons.battery_charging_full_outlined),
          title: Text(l10n.runWhileCharging),
          value: runWhileCharging,
          onChanged: onRunWhileChargingChanged,
        ),
        _NavTile(
          icon: Icons.battery_saver_outlined,
          title: l10n.batteryOptimization,
        ),
      ],
      _SettingsCategory.language => [
        DropdownButtonFormField<String>(
          key: ValueKey('settings_language_$language'),
          initialValue: language,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.language_outlined),
            labelText: l10n.language,
            border: const OutlineInputBorder(),
          ),
          items: [
            DropdownMenuItem(value: 'en', child: Text(l10n.english)),
            DropdownMenuItem(value: 'ru', child: Text(l10n.russian)),
            DropdownMenuItem(value: 'he', child: Text(l10n.hebrewLater)),
          ],
          onChanged: (value) {
            if (value != null) {
              onLanguageChanged(value);
            }
          },
        ),
      ],
      _SettingsCategory.about => [
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
          value: diagnosticsEnabled,
          onChanged: onDiagnosticsChanged,
        ),
      ],
    };
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
      contentPadding: EdgeInsets.zero,
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
      contentPadding: EdgeInsets.zero,
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

class _InlineTextField extends StatelessWidget {
  const _InlineTextField({
    required this.icon,
    required this.title,
    required this.controller,
  });

  final IconData icon;
  final String title;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        labelText: title,
        border: const OutlineInputBorder(),
      ),
    );
  }
}

class _SliderTile extends StatelessWidget {
  const _SliderTile({
    required this.title,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final double value;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    final roundedValue = value.round();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(child: Text(title)),
            Text('$roundedValue%'),
          ],
        ),
        Slider(
          value: value,
          min: 50,
          max: 100,
          divisions: 10,
          label: '$roundedValue%',
          onChanged: onChanged,
        ),
      ],
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
