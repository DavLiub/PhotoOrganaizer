import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/models/photo_library.dart';
import '../../../domain/value_objects/media_permission.dart';
import '../../localization/app_localizations.dart';
import '../../navigation/main_destination.dart';
import '../../state/first_scan_controller.dart';
import '../../state/first_scan_state.dart';
import '../../state/main_destination_controller.dart';
import '../../state/photo_library_controller.dart';
import '../../state/photo_library_state.dart';

class PhotosScreen extends ConsumerWidget {
  const PhotosScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accessState = ref.watch(firstScanProvider);
    final libraryState = ref.watch(photoLibraryProvider);
    final accessController = ref.read(firstScanProvider.notifier);
    final libraryController = ref.read(photoLibraryProvider.notifier);

    if (!accessState.canReadPhotos) {
      return _AccessGate(
        state: accessState,
        onGrantAccess: accessController.requestAccess,
      );
    }

    return _LibraryScreen(
      state: libraryState,
      controller: libraryController,
      onScan: accessController.scan,
      onBackup: () => _showBackupDialog(context, ref),
    );
  }

  Future<void> _showBackupDialog(BuildContext context, WidgetRef ref) async {
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

    if (goToSettings == true) {
      ref
          .read(mainDestinationProvider.notifier)
          .select(MainDestination.settings);
    }
  }
}

class _AccessGate extends StatelessWidget {
  const _AccessGate({required this.state, required this.onGrantAccess});

  final FirstScanState state;
  final VoidCallback onGrantAccess;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return _PageBackground(
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const SizedBox(height: 24),
            Icon(
              Icons.photo_library_outlined,
              size: 56,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.welcomeTitle,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(l10n.welcomeSubtitle),
            const SizedBox(height: 24),
            Card(
              child: ListTile(
                leading: Icon(_permissionIcon(state.permission)),
                title: Text(l10n.photoAccess),
                subtitle: Text(_permissionText(l10n, state.permission)),
              ),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: state.canRequestAccess ? onGrantAccess : null,
              icon: const Icon(Icons.lock_open_outlined),
              label: Text(l10n.grantAccess),
            ),
            if (state.isBusy) ...[
              const SizedBox(height: 16),
              const LinearProgressIndicator(),
            ],
          ],
        ),
      ),
    );
  }

  IconData _permissionIcon(MediaPermission? permission) {
    return switch (permission?.state) {
      MediaPermissionState.denied => Icons.lock_outline,
      MediaPermissionState.permanentlyDenied => Icons.block,
      MediaPermissionState.unavailable => Icons.error_outline,
      _ => Icons.hourglass_empty,
    };
  }

  String _permissionText(AppLocalizations l10n, MediaPermission? permission) {
    if (permission == null) {
      return l10n.checkingAccess;
    }

    return switch (permission.state) {
      MediaPermissionState.granted => l10n.permissionGranted,
      MediaPermissionState.limited => l10n.permissionLimited,
      MediaPermissionState.denied => l10n.photoAccessRequired,
      MediaPermissionState.permanentlyDenied => l10n.permissionBlocked,
      MediaPermissionState.unavailable => l10n.permissionUnavailable,
      MediaPermissionState.unknown => l10n.permissionUnknown,
    };
  }
}

class _LibraryScreen extends StatelessWidget {
  const _LibraryScreen({
    required this.state,
    required this.controller,
    required this.onScan,
    required this.onBackup,
  });

  final PhotoLibraryState state;
  final PhotoLibraryController controller;
  final VoidCallback onScan;
  final VoidCallback onBackup;

  @override
  Widget build(BuildContext context) {
    return _PageBackground(
      child: SafeArea(
        child: Column(
          children: [
            _LibraryControls(state: state, controller: controller),
            if (state.errorCode != null)
              _ErrorBanner(message: state.errorCode!)
            else if (!state.hasPhotos)
              Expanded(child: _EmptyLibrary(isBusy: state.isBusy))
            else
              Expanded(
                child: _PhotoGrid(
                  photos: state.visiblePhotos,
                  selectedCategory: state.selectedCategory,
                ),
              ),
            _BottomActions(
              isScanning: state.phase == PhotoLibraryPhase.refreshing,
              backupPercent: _backupPercent(state.library),
              onScan: onScan,
              onStop: controller.stopScan,
              onBackup: onBackup,
            ),
          ],
        ),
      ),
    );
  }
}

class _LibraryControls extends StatelessWidget {
  const _LibraryControls({required this.state, required this.controller});

  final PhotoLibraryState state;
  final PhotoLibraryController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SegmentedButton<LibraryFilter>(
              showSelectedIcon: false,
              segments: [
                ButtonSegment(value: LibraryFilter.all, label: Text(l10n.all)),
                ButtonSegment(
                  value: LibraryFilter.camera,
                  label: Text(l10n.categoryCamera),
                ),
                ButtonSegment(
                  value: LibraryFilter.social,
                  label: Text(l10n.categorySocial),
                ),
                ButtonSegment(
                  value: LibraryFilter.downloads,
                  label: Text(l10n.categoryDownloads),
                ),
                ButtonSegment(
                  value: LibraryFilter.screenshots,
                  label: Text(l10n.categoryScreenshots),
                ),
              ],
              selected: {state.filter},
              onSelectionChanged: (selection) {
                controller.selectFilter(selection.single);
              },
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              PopupMenuButton<LibrarySort>(
                tooltip: l10n.sort,
                initialValue: state.sort,
                onSelected: controller.selectSort,
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                      value: LibrarySort.dateDesc,
                      child: Text(l10n.sortDateDesc),
                    ),
                    PopupMenuItem(
                      value: LibrarySort.dateAsc,
                      child: Text(l10n.sortDateAsc),
                    ),
                    PopupMenuItem(
                      value: LibrarySort.nameAsc,
                      child: Text(l10n.sortNameAsc),
                    ),
                    PopupMenuItem(
                      value: LibrarySort.nameDesc,
                      child: Text(l10n.sortNameDesc),
                    ),
                  ];
                },
                child: _SortChip(label: _sortLabel(l10n, state.sort)),
              ),
              const Spacer(),
              Text(
                l10n.countPhotos(state.visiblePhotos.length),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SortChip extends StatelessWidget {
  const _SortChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: ShapeDecoration(
        color: colorScheme.surface,
        shape: StadiumBorder(
          side: BorderSide(color: colorScheme.outlineVariant),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.sort_outlined, size: 18),
            const SizedBox(width: 6),
            Text(label),
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
      padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
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
  const _EmptyLibrary({required this.isBusy});

  final bool isBusy;

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
              isBusy ? l10n.scanningLibrary : l10n.emptyLibraryTitle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              isBusy ? l10n.emptyScanMessage : l10n.emptyLibraryMessage,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
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
    required this.isScanning,
    required this.backupPercent,
    required this.onScan,
    required this.onStop,
    required this.onBackup,
  });

  final bool isScanning;
  final int backupPercent;
  final VoidCallback onScan;
  final VoidCallback onStop;
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
                child: FilledButton.icon(
                  onPressed: isScanning ? onStop : onScan,
                  icon: Icon(
                    isScanning
                        ? Icons.stop_circle_outlined
                        : Icons.search_outlined,
                  ),
                  label: Text(
                    isScanning ? l10n.stop : l10n.scan,
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
                    l10n.backupPercent(backupPercent),
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

class _PageBackground extends StatelessWidget {
  const _PageBackground({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset('assets/images/library_background.png', fit: BoxFit.cover),
        ColoredBox(
          color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.72),
        ),
        child,
      ],
    );
  }
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

String _sortLabel(AppLocalizations l10n, LibrarySort sort) {
  return switch (sort) {
    LibrarySort.dateDesc => l10n.sortDateDesc,
    LibrarySort.dateAsc => l10n.sortDateAsc,
    LibrarySort.nameAsc => l10n.sortNameAsc,
    LibrarySort.nameDesc => l10n.sortNameDesc,
  };
}

int _backupPercent(PhotoLibrary library) {
  if (library.photos.isEmpty) {
    return 0;
  }

  final protectedCount = library.photos.where((photo) {
    return photo.backupStatus == LibraryBackupStatus.protected;
  }).length;

  return (protectedCount * 100 / library.photos.length).round();
}
