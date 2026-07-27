import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/models/photo_library.dart';
import '../../localization/app_localizations.dart';
import '../../state/main_destination_controller.dart';
import '../../state/photo_library_controller.dart';
import '../../state/photo_library_state.dart';
import '../../navigation/main_destination.dart';
import '../settings/settings_screen.dart';

class PhotosScreen extends ConsumerWidget {
  const PhotosScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(photoLibraryProvider);
    final controller = ref.read(photoLibraryProvider.notifier);

    return Column(
      children: [
        _LibraryHeader(
          state: state,
          onRefresh: () => _showRefreshDialog(context, ref),
          onStop: controller.stopScan,
        ),
        if (state.errorCode != null)
          _ErrorBanner(message: state.errorCode!)
        else if (state.isBusy && !state.hasPhotos)
          Expanded(
            child: _LibraryProgress(state: state, onStop: controller.stopScan),
          )
        else if (!state.hasPhotos)
          Expanded(
            child: _EmptyLibrary(
              onScan: () {
                ref
                    .read(mainDestinationProvider.notifier)
                    .select(MainDestination.home);
              },
            ),
          )
        else
          Expanded(
            child: _PhotoGrid(
              photos: state.visiblePhotos,
              selectedCategory: state.selectedCategory,
            ),
          ),
        _BottomActions(
          onCatalogs: () => _showCatalogSheet(context, state, controller),
          onSettings: () => _openSettings(context),
          onBackup: () => _showBackupDialog(context),
        ),
      ],
    );
  }

  Future<void> _showRefreshDialog(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final controller = ref.read(photoLibraryProvider.notifier);

    final action = await showDialog<_RefreshAction>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(l10n.refreshLibrary),
          content: Text(l10n.refreshLibraryMessage),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(_RefreshAction.settings);
              },
              child: Text(l10n.configureAutoRefresh),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(context).pop(_RefreshAction.manual);
              },
              child: Text(l10n.runNow),
            ),
          ],
        );
      },
    );

    if (!context.mounted) {
      return;
    }

    switch (action) {
      case _RefreshAction.manual:
        await controller.refreshNow();
      case _RefreshAction.settings:
        _openSettings(context);
      case null:
        return;
    }
  }

  Future<void> _showBackupDialog(BuildContext context) async {
    final l10n = AppLocalizations.of(context);

    final goToSettings = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(l10n.backupTargetMissing),
          content: Text(l10n.backupTargetMessage),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text(l10n.goToSettings),
            ),
          ],
        );
      },
    );

    if (goToSettings == true && context.mounted) {
      _openSettings(context);
    }
  }

  Future<void> _showCatalogSheet(
    BuildContext context,
    PhotoLibraryState state,
    PhotoLibraryController controller,
  ) async {
    final l10n = AppLocalizations.of(context);

    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: ListView(
            shrinkWrap: true,
            children: [
              ListTile(
                leading: const Icon(Icons.all_inclusive),
                title: Text(l10n.allPhotos),
                trailing: Text(state.library.photos.length.toString()),
                selected: state.selectedCategory == null,
                onTap: () {
                  controller.selectCategory(null);
                  Navigator.of(context).pop();
                },
              ),
              for (final summary in state.library.categories)
                ListTile(
                  leading: Icon(_categoryIcon(summary.category)),
                  title: Text(_categoryLabel(l10n, summary.category)),
                  trailing: Text(summary.count.toString()),
                  selected: state.selectedCategory == summary.category,
                  onTap: () {
                    controller.selectCategory(summary.category);
                    Navigator.of(context).pop();
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  void _openSettings(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const SettingsScreen()));
  }
}

class _LibraryHeader extends StatelessWidget {
  const _LibraryHeader({
    required this.state,
    required this.onRefresh,
    required this.onStop,
  });

  final PhotoLibraryState state;
  final VoidCallback onRefresh;
  final VoidCallback onStop;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final count = state.visiblePhotos.length;
    final subtitle = state.phase == PhotoLibraryPhase.refreshing
        ? _progressText(l10n, state)
        : state.selectedCategory == null
        ? l10n.countPhotos(count)
        : '${_categoryLabel(l10n, state.selectedCategory!)} - ${l10n.countPhotos(count)}';

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 8, 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.library,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          if (state.phase == PhotoLibraryPhase.refreshing)
            IconButton(
              tooltip: l10n.stop,
              onPressed: onStop,
              icon: const Icon(Icons.stop_circle_outlined),
            )
          else
            IconButton(
              tooltip: l10n.refresh,
              onPressed: state.isBusy ? null : onRefresh,
              icon: const Icon(Icons.refresh_outlined),
            ),
        ],
      ),
    );
  }
}

class _LibraryProgress extends StatelessWidget {
  const _LibraryProgress({required this.state, required this.onStop});

  final PhotoLibraryState state;
  final VoidCallback onStop;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const LinearProgressIndicator(),
            const SizedBox(height: 16),
            Text(
              l10n.scanningLibrary,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              _progressText(l10n, state),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: onStop,
              icon: const Icon(Icons.stop_circle_outlined),
              label: Text(l10n.stop),
            ),
          ],
        ),
      ),
    );
  }
}

class _PhotoGrid extends StatelessWidget {
  const _PhotoGrid({required this.photos, required this.selectedCategory});

  final List<LibraryPhoto> photos;
  final LibraryCategory? selectedCategory;

  @override
  Widget build(BuildContext context) {
    if (photos.isEmpty && selectedCategory != null) {
      return _EmptyFilter(category: selectedCategory!);
    }

    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 150,
        mainAxisExtent: 216,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: photos.length,
      itemBuilder: (context, index) {
        return _PhotoTile(photo: photos[index]);
      },
    );
  }
}

class _PhotoTile extends ConsumerWidget {
  const _PhotoTile({required this.photo});

  final LibraryPhoto photo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final thumbnail = ref.watch(photoThumbnailProvider(photo.assetId));

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: thumbnail.when(
              data: (bytes) => _ThumbnailView(bytes: bytes),
              error: (_, _) => const _ThumbnailView(bytes: null),
              loading: () => const ColoredBox(
                color: Color(0xFFE7EAF0),
                child: Center(
                  child: SizedBox.square(
                    dimension: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 2),
            child: Text(
              photo.displayName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 2, 8, 8),
            child: _StatusBadge(label: _backupLabel(l10n, photo.backupStatus)),
          ),
        ],
      ),
    );
  }
}

class _ThumbnailView extends StatelessWidget {
  const _ThumbnailView({required this.bytes});

  final Uint8List? bytes;

  @override
  Widget build(BuildContext context) {
    final data = bytes;
    if (data != null) {
      return Image.memory(data, fit: BoxFit.cover);
    }

    return ColoredBox(
      color: const Color(0xFFE7EAF0),
      child: Icon(
        Icons.image_outlined,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: colorScheme.onSecondaryContainer,
          ),
        ),
      ),
    );
  }
}

class _EmptyLibrary extends StatelessWidget {
  const _EmptyLibrary({required this.onScan});

  final VoidCallback onScan;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.photo_library_outlined,
              size: 48,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.emptyLibraryTitle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.emptyLibraryMessage,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onScan,
              icon: const Icon(Icons.search_outlined),
              label: Text(l10n.scanPhotos),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyFilter extends StatelessWidget {
  const _EmptyFilter({required this.category});

  final LibraryCategory category;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          l10n.emptyCategory(_categoryLabel(l10n, category)),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          color: colorScheme.errorContainer,
          child: ListTile(
            leading: Icon(
              Icons.error_outline,
              color: colorScheme.onErrorContainer,
            ),
            title: Text(
              message,
              style: TextStyle(color: colorScheme.onErrorContainer),
            ),
          ),
        ),
      ),
    );
  }
}

class _BottomActions extends StatelessWidget {
  const _BottomActions({
    required this.onCatalogs,
    required this.onSettings,
    required this.onBackup,
  });

  final VoidCallback onCatalogs;
  final VoidCallback onSettings;
  final VoidCallback onBackup;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final borderColor = Theme.of(context).colorScheme.outlineVariant;

    return SafeArea(
      top: false,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          border: Border(top: BorderSide(color: borderColor)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onCatalogs,
                  icon: const Icon(Icons.folder_outlined),
                  label: Text(
                    l10n.catalogs,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onSettings,
                  icon: const Icon(Icons.tune_outlined),
                  label: Text(
                    l10n.settings,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: FilledButton.icon(
                  onPressed: onBackup,
                  icon: const Icon(Icons.cloud_upload_outlined),
                  label: Text(
                    l10n.startBackup,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum _RefreshAction { manual, settings }

IconData _categoryIcon(LibraryCategory category) {
  return switch (category) {
    LibraryCategory.camera => Icons.photo_camera_outlined,
    LibraryCategory.social => Icons.people_alt_outlined,
    LibraryCategory.downloads => Icons.download_outlined,
    LibraryCategory.screenshots => Icons.screenshot_outlined,
  };
}

String _categoryLabel(AppLocalizations l10n, LibraryCategory category) {
  return switch (category) {
    LibraryCategory.camera => l10n.categoryCamera,
    LibraryCategory.social => l10n.categorySocial,
    LibraryCategory.downloads => l10n.categoryDownloads,
    LibraryCategory.screenshots => l10n.categoryScreenshots,
  };
}

String _backupLabel(AppLocalizations l10n, LibraryBackupStatus status) {
  return switch (status) {
    LibraryBackupStatus.noBackup => l10n.noBackup,
    LibraryBackupStatus.queued => l10n.backupQueued,
    LibraryBackupStatus.protected => l10n.protected,
    LibraryBackupStatus.failed => l10n.failed,
    LibraryBackupStatus.ignored => l10n.ignored,
  };
}

String _progressText(AppLocalizations l10n, PhotoLibraryState state) {
  return '${l10n.foundPhotos}: ${state.foundPhotos} - '
      '${l10n.indexedPhotos}: ${state.indexedPhotos} - '
      '${l10n.discoveredSources}: ${state.sourceCount}';
}
