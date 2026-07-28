import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/models/library_category.dart';
import '../../../application/models/source_selection.dart';
import '../../../domain/entities/media_source.dart';
import '../../localization/app_localizations.dart';
import '../../state/source_selection_controller.dart';
import '../../state/source_selection_state.dart';

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
      return _ErrorBanner(message: state.errorCode!);
    }

    if (state.selection.isEmpty) {
      return _EmptySources(l10n: l10n);
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
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          border: Border.all(color: colorScheme.outlineVariant),
          borderRadius: BorderRadius.circular(8),
        ),
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
    final subtitleParts = [
      if (source.pathHint != null) source.pathHint!,
      l10n.countPhotos(source.assetCount),
      _statusLabel(l10n, source.availabilityStatus),
      '${l10n.lastSeen}: ${_shortDate(source.lastSeenAt)}',
    ];

    return Material(
      color: Colors.transparent,
      child: SwitchListTile(
        key: ValueKey('media_source_${source.id}'),
        secondary: Icon(_sourceIcon(source)),
        title: Text(source.name, maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Text(
          subtitleParts.join(' | '),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        value: item.enabled,
        onChanged: onChanged,
      ),
    );
  }
}

class _EmptySources extends StatelessWidget {
  const _EmptySources({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.folder_off_outlined,
              size: 48,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.noMediaSources,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(l10n.noMediaSourcesMessage, textAlign: TextAlign.center),
          ],
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

    return Padding(
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

String _shortDate(DateTime value) {
  final date = value.toLocal();
  final month = date.month.toString().padLeft(2, '0');
  final day = date.day.toString().padLeft(2, '0');

  return '${date.year}-$month-$day';
}
