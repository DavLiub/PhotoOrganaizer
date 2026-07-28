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

enum _FolderLayout { root, albums }

enum _PhotoMode { optimized, original }

enum _ThemeMode { system, light, dark }

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _rootFolderController = TextEditingController(text: '/PhotoOrganizer');

  _SettingsCategory _selectedCategory = _SettingsCategory.status;
  _FolderLayout _folderLayout = _FolderLayout.albums;
  _PhotoMode _photoMode = _PhotoMode.optimized;
  _ThemeMode _themeMode = _ThemeMode.system;
  double _imageQuality = 85;
  double _maxPhotoSizeMb = 8;
  double _minBatteryPercent = 30;
  bool _groupByDate = true;
  bool _confirmActions = true;
  bool _showBackupBadges = true;
  bool _indexCamera = true;
  bool _indexSocial = true;
  bool _indexDownloads = true;
  bool _indexScreenshots = true;
  bool _keepMetadata = true;
  bool _backgroundBackup = false;
  bool _backgroundRefresh = false;
  bool _wifiOnly = true;
  bool _diagnosticsEnabled = false;
  String _language = 'en';

  @override
  void dispose() {
    _rootFolderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: SafeArea(
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerLowest,
          ),
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
              VerticalDivider(
                width: 1,
                color: Theme.of(context).colorScheme.outlineVariant,
              ),
              Expanded(
                child: _SettingsDetailPane(
                  category: _selectedCategory,
                  rootFolderController: _rootFolderController,
                  folderLayout: _folderLayout,
                  photoMode: _photoMode,
                  themeMode: _themeMode,
                  imageQuality: _imageQuality,
                  maxPhotoSizeMb: _maxPhotoSizeMb,
                  minBatteryPercent: _minBatteryPercent,
                  groupByDate: _groupByDate,
                  confirmActions: _confirmActions,
                  showBackupBadges: _showBackupBadges,
                  indexCamera: _indexCamera,
                  indexSocial: _indexSocial,
                  indexDownloads: _indexDownloads,
                  indexScreenshots: _indexScreenshots,
                  keepMetadata: _keepMetadata,
                  backgroundBackup: _backgroundBackup,
                  backgroundRefresh: _backgroundRefresh,
                  wifiOnly: _wifiOnly,
                  diagnosticsEnabled: _diagnosticsEnabled,
                  language: _language,
                  onFolderLayoutChanged: (value) {
                    setState(() {
                      _folderLayout = value;
                    });
                  },
                  onPhotoModeChanged: (value) {
                    setState(() {
                      _photoMode = value;
                    });
                  },
                  onThemeModeChanged: (value) {
                    setState(() {
                      _themeMode = value;
                    });
                  },
                  onImageQualityChanged: (value) {
                    setState(() {
                      _imageQuality = value;
                    });
                  },
                  onMaxPhotoSizeChanged: (value) {
                    setState(() {
                      _maxPhotoSizeMb = value;
                    });
                  },
                  onMinBatteryChanged: (value) {
                    setState(() {
                      _minBatteryPercent = value;
                    });
                  },
                  onGroupByDateChanged: (value) {
                    setState(() {
                      _groupByDate = value;
                    });
                  },
                  onConfirmActionsChanged: (value) {
                    setState(() {
                      _confirmActions = value;
                    });
                  },
                  onShowBackupBadgesChanged: (value) {
                    setState(() {
                      _showBackupBadges = value;
                    });
                  },
                  onIndexCameraChanged: (value) {
                    setState(() {
                      _indexCamera = value;
                    });
                  },
                  onIndexSocialChanged: (value) {
                    setState(() {
                      _indexSocial = value;
                    });
                  },
                  onIndexDownloadsChanged: (value) {
                    setState(() {
                      _indexDownloads = value;
                    });
                  },
                  onIndexScreenshotsChanged: (value) {
                    setState(() {
                      _indexScreenshots = value;
                    });
                  },
                  onKeepMetadataChanged: (value) {
                    setState(() {
                      _keepMetadata = value;
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
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: 112,
      child: ColoredBox(
        color: colorScheme.surface,
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
        ? colorScheme.primaryContainer
        : Colors.transparent;
    final foreground = selected
        ? colorScheme.onPrimaryContainer
        : colorScheme.onSurfaceVariant;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Material(
        color: background,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          key: ValueKey('settings_category_${category.name}'),
          borderRadius: BorderRadius.circular(8),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 9),
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
    required this.folderLayout,
    required this.photoMode,
    required this.themeMode,
    required this.imageQuality,
    required this.maxPhotoSizeMb,
    required this.minBatteryPercent,
    required this.groupByDate,
    required this.confirmActions,
    required this.showBackupBadges,
    required this.indexCamera,
    required this.indexSocial,
    required this.indexDownloads,
    required this.indexScreenshots,
    required this.keepMetadata,
    required this.backgroundBackup,
    required this.backgroundRefresh,
    required this.wifiOnly,
    required this.diagnosticsEnabled,
    required this.language,
    required this.onFolderLayoutChanged,
    required this.onPhotoModeChanged,
    required this.onThemeModeChanged,
    required this.onImageQualityChanged,
    required this.onMaxPhotoSizeChanged,
    required this.onMinBatteryChanged,
    required this.onGroupByDateChanged,
    required this.onConfirmActionsChanged,
    required this.onShowBackupBadgesChanged,
    required this.onIndexCameraChanged,
    required this.onIndexSocialChanged,
    required this.onIndexDownloadsChanged,
    required this.onIndexScreenshotsChanged,
    required this.onKeepMetadataChanged,
    required this.onBackgroundBackupChanged,
    required this.onBackgroundRefreshChanged,
    required this.onWifiOnlyChanged,
    required this.onDiagnosticsChanged,
    required this.onLanguageChanged,
  });

  final _SettingsCategory category;
  final TextEditingController rootFolderController;
  final _FolderLayout folderLayout;
  final _PhotoMode photoMode;
  final _ThemeMode themeMode;
  final double imageQuality;
  final double maxPhotoSizeMb;
  final double minBatteryPercent;
  final bool groupByDate;
  final bool confirmActions;
  final bool showBackupBadges;
  final bool indexCamera;
  final bool indexSocial;
  final bool indexDownloads;
  final bool indexScreenshots;
  final bool keepMetadata;
  final bool backgroundBackup;
  final bool backgroundRefresh;
  final bool wifiOnly;
  final bool diagnosticsEnabled;
  final String language;
  final ValueChanged<_FolderLayout> onFolderLayoutChanged;
  final ValueChanged<_PhotoMode> onPhotoModeChanged;
  final ValueChanged<_ThemeMode> onThemeModeChanged;
  final ValueChanged<double> onImageQualityChanged;
  final ValueChanged<double> onMaxPhotoSizeChanged;
  final ValueChanged<double> onMinBatteryChanged;
  final ValueChanged<bool> onGroupByDateChanged;
  final ValueChanged<bool> onConfirmActionsChanged;
  final ValueChanged<bool> onShowBackupBadgesChanged;
  final ValueChanged<bool> onIndexCameraChanged;
  final ValueChanged<bool> onIndexSocialChanged;
  final ValueChanged<bool> onIndexDownloadsChanged;
  final ValueChanged<bool> onIndexScreenshotsChanged;
  final ValueChanged<bool> onKeepMetadataChanged;
  final ValueChanged<bool> onBackgroundBackupChanged;
  final ValueChanged<bool> onBackgroundRefreshChanged;
  final ValueChanged<bool> onWifiOnlyChanged;
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
        const SizedBox(height: 4),
        Text(
          _subtitle(l10n),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 14),
        ..._children(context, l10n),
      ],
    );
  }

  String _subtitle(AppLocalizations l10n) {
    return switch (category) {
      _SettingsCategory.status => l10n.statusSubtitle,
      _SettingsCategory.storage => l10n.storageSubtitle,
      _SettingsCategory.general => l10n.generalSubtitle,
      _SettingsCategory.library => l10n.mediaLibrarySubtitle,
      _SettingsCategory.backup => l10n.backupSubtitle,
      _SettingsCategory.background => l10n.backgroundSubtitle,
      _SettingsCategory.language => l10n.languageSubtitle,
      _SettingsCategory.about => l10n.aboutSubtitle,
    };
  }

  List<Widget> _children(BuildContext context, AppLocalizations l10n) {
    return switch (category) {
      _SettingsCategory.status => [
        _SettingsGroup(
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
      ],
      _SettingsCategory.storage => [
        _SettingsGroup(
          children: [
            _NavTile(icon: Icons.cloud_outlined, title: l10n.provider),
            _NavTile(
              icon: Icons.alternate_email_outlined,
              title: l10n.connectedAccount,
            ),
          ],
        ),
        const SizedBox(height: 12),
        _SettingsGroup(
          children: [
            _InlineTextField(
              icon: Icons.folder_outlined,
              title: l10n.rootFolder,
              controller: rootFolderController,
            ),
            const SizedBox(height: 14),
            _RadioTile<_FolderLayout>(
              icon: Icons.folder_copy_outlined,
              title: l10n.storageFolderLayout,
              value: folderLayout,
              options: [
                _Option(value: _FolderLayout.root, label: l10n.allInRootFolder),
                _Option(
                  value: _FolderLayout.albums,
                  label: l10n.keepAlbumStructure,
                ),
              ],
              onChanged: onFolderLayoutChanged,
            ),
            CheckboxListTile(
              secondary: const Icon(Icons.calendar_month_outlined),
              title: Text(l10n.groupByYearMonth),
              value: groupByDate,
              onChanged: (value) {
                if (value != null) {
                  onGroupByDateChanged(value);
                }
              },
            ),
          ],
        ),
      ],
      _SettingsCategory.general => [
        _SettingsGroup(
          children: [
            _RadioTile<_ThemeMode>(
              icon: Icons.contrast_outlined,
              title: l10n.theme,
              value: themeMode,
              options: [
                _Option(value: _ThemeMode.system, label: l10n.systemTheme),
                _Option(value: _ThemeMode.light, label: l10n.lightTheme),
                _Option(value: _ThemeMode.dark, label: l10n.darkTheme),
              ],
              onChanged: onThemeModeChanged,
            ),
            SwitchListTile(
              secondary: const Icon(Icons.verified_user_outlined),
              title: Text(l10n.confirmImportantActions),
              value: confirmActions,
              onChanged: onConfirmActionsChanged,
            ),
            SwitchListTile(
              secondary: const Icon(Icons.privacy_tip_outlined),
              title: Text(l10n.showBackupBadges),
              value: showBackupBadges,
              onChanged: onShowBackupBadgesChanged,
            ),
          ],
        ),
      ],
      _SettingsCategory.library => [
        _SettingsGroup(
          children: [
            _NavTile(icon: Icons.category_outlined, title: l10n.categories),
            CheckboxListTile(
              secondary: const Icon(Icons.photo_camera_outlined),
              title: Text(l10n.categoryCamera),
              value: indexCamera,
              onChanged: (value) {
                if (value != null) {
                  onIndexCameraChanged(value);
                }
              },
            ),
            CheckboxListTile(
              secondary: const Icon(Icons.people_alt_outlined),
              title: Text(l10n.categorySocial),
              value: indexSocial,
              onChanged: (value) {
                if (value != null) {
                  onIndexSocialChanged(value);
                }
              },
            ),
            CheckboxListTile(
              secondary: const Icon(Icons.download_outlined),
              title: Text(l10n.categoryDownloads),
              value: indexDownloads,
              onChanged: (value) {
                if (value != null) {
                  onIndexDownloadsChanged(value);
                }
              },
            ),
            CheckboxListTile(
              secondary: const Icon(Icons.screenshot_outlined),
              title: Text(l10n.categoryScreenshots),
              value: indexScreenshots,
              onChanged: (value) {
                if (value != null) {
                  onIndexScreenshotsChanged(value);
                }
              },
            ),
            _NavTile(
              icon: Icons.create_new_folder_outlined,
              title: l10n.includedFolders,
            ),
            _NavTile(icon: Icons.refresh_outlined, title: l10n.refreshBehavior),
          ],
        ),
      ],
      _SettingsCategory.backup => [
        _SettingsGroup(
          children: [
            _RadioTile<_PhotoMode>(
              icon: Icons.photo_size_select_large,
              title: l10n.photoSize,
              value: photoMode,
              options: [
                _Option(
                  value: _PhotoMode.optimized,
                  label: l10n.optimizedCopies,
                ),
                _Option(value: _PhotoMode.original, label: l10n.originalPhotos),
              ],
              onChanged: onPhotoModeChanged,
            ),
            _SliderTile(
              title: l10n.imageQuality,
              value: imageQuality,
              min: 50,
              max: 100,
              divisions: 10,
              suffix: '%',
              enabled: photoMode == _PhotoMode.optimized,
              disabledText: l10n.disabledForOriginals,
              onChanged: onImageQualityChanged,
            ),
            _SliderTile(
              title: l10n.maxPhotoSize,
              value: maxPhotoSizeMb,
              min: 1,
              max: 20,
              divisions: 19,
              suffix: ' MB',
              enabled: photoMode == _PhotoMode.optimized,
              disabledText: l10n.disabledForOriginals,
              onChanged: onMaxPhotoSizeChanged,
            ),
            SwitchListTile(
              secondary: const Icon(Icons.info_outline),
              title: Text(l10n.keepMetadata),
              value: keepMetadata,
              onChanged: onKeepMetadataChanged,
            ),
          ],
        ),
      ],
      _SettingsCategory.background => [
        _SettingsGroup(
          children: [
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
            _SliderTile(
              title: l10n.minBatteryLevel,
              value: minBatteryPercent,
              min: 10,
              max: 90,
              divisions: 8,
              suffix: '%',
              onChanged: onMinBatteryChanged,
            ),
          ],
        ),
      ],
      _SettingsCategory.language => [
        _LanguageCard(
          flag: '🇺🇸',
          title: l10n.english,
          subtitle: 'English',
          selected: language == 'en',
          onTap: () => onLanguageChanged('en'),
        ),
        const SizedBox(height: 10),
        _LanguageCard(
          flag: '🇷🇺',
          title: l10n.russian,
          subtitle: 'Русский',
          selected: language == 'ru',
          onTap: () => onLanguageChanged('ru'),
        ),
        const SizedBox(height: 10),
        _LanguageCard(
          flag: '🇮🇱',
          title: l10n.hebrew,
          subtitle: l10n.hebrewLater,
          selected: language == 'he',
          onTap: () => onLanguageChanged('he'),
        ),
      ],
      _SettingsCategory.about => [
        _SettingsGroup(
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
              value: diagnosticsEnabled,
              onChanged: onDiagnosticsChanged,
            ),
          ],
        ),
      ],
    };
  }
}

class _SettingsGroup extends StatelessWidget {
  const _SettingsGroup({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border.all(color: colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(children: children),
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
      leading: _IconBox(icon: icon),
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
      leading: _IconBox(icon: icon),
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

class _Option<T> {
  const _Option({required this.value, required this.label});

  final T value;
  final String label;
}

class _RadioTile<T> extends StatelessWidget {
  const _RadioTile({
    required this.icon,
    required this.title,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  final IconData icon;
  final String title;
  final T value;
  final List<_Option<T>> options;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: _IconBox(icon: icon),
      title: Text(title),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final option in options)
              ChoiceChip(
                label: Text(option.label),
                selected: value == option.value,
                onSelected: (_) {
                  onChanged(option.value);
                },
              ),
          ],
        ),
      ),
      contentPadding: EdgeInsets.zero,
    );
  }
}

class _SliderTile extends StatelessWidget {
  const _SliderTile({
    required this.title,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.suffix,
    required this.onChanged,
    this.enabled = true,
    this.disabledText,
  });

  final String title;
  final double value;
  final double min;
  final double max;
  final int divisions;
  final String suffix;
  final ValueChanged<double> onChanged;
  final bool enabled;
  final String? disabledText;

  @override
  Widget build(BuildContext context) {
    final roundedValue = value.round();
    final disabledMessage = disabledText;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(child: Text(title)),
              Text('$roundedValue$suffix'),
            ],
          ),
          Slider(
            value: value,
            min: min,
            max: max,
            divisions: divisions,
            label: '$roundedValue$suffix',
            onChanged: enabled ? onChanged : null,
          ),
          if (!enabled && disabledMessage != null)
            Text(
              disabledMessage,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
        ],
      ),
    );
  }
}

class _LanguageCard extends StatelessWidget {
  const _LanguageCard({
    required this.flag,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  final String flag;
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: selected ? colorScheme.primaryContainer : colorScheme.surface,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: selected
                  ? colorScheme.primary
                  : colorScheme.outlineVariant,
              width: selected ? 2 : 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Text(flag, style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  selected ? Icons.check_circle : Icons.radio_button_unchecked,
                  color: selected ? colorScheme.primary : colorScheme.outline,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _IconBox extends StatelessWidget {
  const _IconBox({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withValues(alpha: 0.65),
        borderRadius: BorderRadius.circular(8),
      ),
      child: SizedBox(
        width: 40,
        height: 40,
        child: Icon(icon, color: colorScheme.primary),
      ),
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
