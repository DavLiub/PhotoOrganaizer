import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/models/library_category.dart';
import '../../../application/models/source_selection.dart';
import '../../../domain/entities/media_source.dart';
import '../../localization/app_localizations.dart';
import '../../state/source_selection_controller.dart';
import '../../state/source_selection_state.dart';
import '../../theme/app_status_palette.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/failure_state.dart';
import '../../widgets/status_badge.dart';

class AlbumsScreen extends ConsumerWidget {
  const AlbumsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(sourceSelectionProvider);
    final controller = ref.read(sourceSelectionProvider.notifier);

    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset('assets/images/library_background.png', fit: BoxFit.cover),
        ColoredBox(
          color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.72),
        ),
        SafeArea(
          child: _AlbumsContent(
            state: state,
            onSourceChanged: controller.setSource,
          ),
        ),
      ],
    );
  }
}

class _AlbumsContent extends StatelessWidget {
  const _AlbumsContent({required this.state, required this.onSourceChanged});

  final SourceSelectionState state;
  final Future<void> Function(String sourceId, {required bool enabled})
  onSourceChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    if (state.phase == SourceSelectionPhase.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.errorCode != null) {
      return FailureState(message: state.errorCode!);
    }

    if (state.selection.isEmpty) {
      return EmptyState(
        icon: Icons.folder_off_outlined,
        title: l10n.noMediaSources,
        message: l10n.noMediaSourcesMessage,
      );
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 20),
      children: [
        for (final group in state.selection.groups)
          if (group.sources.isNotEmpty)
            _SourceGroup(group: group, onSourceChanged: onSourceChanged),
      ],
    );
  }
}

class _SourceGroup extends StatelessWidget {
  const _SourceGroup({required this.group, required this.onSourceChanged});

  final MediaSourceGroup group;
  final Future<void> Function(String sourceId, {required bool enabled})
  onSourceChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
              child: Row(
                children: [
                  Icon(
                    _categoryIcon(group.category),
                    color: colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _categoryLabel(l10n, group.category),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  Text(l10n.countPhotos(group.assetCount)),
                ],
              ),
            ),
            const Divider(height: 1),
            for (final source in group.sources)
              _SourceTile(
                item: source,
                onChanged: (enabled) {
                  onSourceChanged(source.source.id, enabled: enabled);
                },
              ),
          ],
        ),
      ),
    );
  }
}

class _SourceTile extends StatelessWidget {
  const _SourceTile({required this.item, required this.onChanged});

  final SelectableSource item;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final source = item.source;
    final metadataParts = [
      if (source.pathHint != null) source.pathHint!,
      l10n.countPhotos(source.assetCount),
      '${l10n.lastSeen}: ${_shortDate(source.lastSeenAt)}',
    ];

    return Material(
      color: Colors.transparent,
      child: SwitchListTile(
        key: ValueKey('media_source_${source.id}'),
        secondary: Icon(_sourceIcon(source)),
        title: Text(source.name, maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                metadataParts.join(' | '),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              StatusBadge(
                label: _statusLabel(l10n, source.availabilityStatus),
                tone: _sourceTone(source.availabilityStatus),
                icon: _sourceStatusIcon(source.availabilityStatus),
              ),
            ],
          ),
        ),
        value: item.enabled,
        onChanged: onChanged,
      ),
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

IconData _categoryIcon(LibraryCategory category) {
  return switch (category) {
    LibraryCategory.camera => Icons.photo_camera_outlined,
    LibraryCategory.social => Icons.people_alt_outlined,
    LibraryCategory.downloads => Icons.download_outlined,
    LibraryCategory.screenshots => Icons.screenshot_outlined,
  };
}

IconData _sourceIcon(MediaSource source) {
  if (source.cameraLike) {
    return Icons.photo_camera_outlined;
  }

  if (source.systemLike) {
    return Icons.collections_outlined;
  }

  return Icons.folder_outlined;
}

String _statusLabel(AppLocalizations l10n, MediaSourceStatus status) {
  return switch (status) {
    MediaSourceStatus.available => l10n.sourceAvailable,
    MediaSourceStatus.missing => l10n.sourceMissing,
    MediaSourceStatus.inaccessible => l10n.sourceInaccessible,
  };
}

AppStatusTone _sourceTone(MediaSourceStatus status) {
  return switch (status) {
    MediaSourceStatus.available => AppStatusTone.neutral,
    MediaSourceStatus.missing => AppStatusTone.ignored,
    MediaSourceStatus.inaccessible => AppStatusTone.failed,
  };
}

IconData _sourceStatusIcon(MediaSourceStatus status) {
  return switch (status) {
    MediaSourceStatus.available => Icons.check_circle_outline,
    MediaSourceStatus.missing => Icons.folder_off_outlined,
    MediaSourceStatus.inaccessible => Icons.lock_outline,
  };
}

String _shortDate(DateTime value) {
  final date = value.toLocal();
  final month = date.month.toString().padLeft(2, '0');
  final day = date.day.toString().padLeft(2, '0');

  return '${date.year}-$month-$day';
}
