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
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
      children: [
        _AlbumsHeader(l10n: l10n),
        const SizedBox(height: 20),
        for (final group in state.selection.groups)
          if (group.sources.isNotEmpty)
            _SourceGroup(group: group, onSourceChanged: onSourceChanged),
      ],
    );
  }
}

class _AlbumsHeader extends StatelessWidget {
  const _AlbumsHeader({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.albumSourcesTitle,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 6),
        Text(
          l10n.albumSourcesMessage,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
        ),
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

    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _SectionHeader(label: _categoryLabel(l10n, group.category)),
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (context, constraints) {
              const spacing = 10.0;
              final columnCount = constraints.maxWidth >= 520 ? 3 : 2;
              final tileWidth =
                  (constraints.maxWidth - spacing * (columnCount - 1)) /
                  columnCount;

              return Wrap(
                spacing: spacing,
                runSpacing: 12,
                children: [
                  for (final source in group.sources)
                    SizedBox(
                      width: tileWidth,
                      child: _SourceTile(
                        item: source,
                        onChanged: (enabled) {
                          onSourceChanged(source.source.id, enabled: enabled);
                        },
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Expanded(child: Divider(color: colorScheme.outlineVariant)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            label,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Expanded(child: Divider(color: colorScheme.outlineVariant)),
      ],
    );
  }
}

class _SourceTile extends StatelessWidget {
  const _SourceTile({required this.item, required this.onChanged});

  final SelectableSource item;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final source = item.source;
    final path = source.pathHint ?? source.provider;
    final colorScheme = Theme.of(context).colorScheme;
    final opacity = item.enabled ? 1.0 : 0.54;

    return Semantics(
      button: true,
      selected: item.enabled,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Material(
            key: ValueKey('media_source_${source.id}'),
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () {
                onChanged(!item.enabled);
              },
              child: DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(color: colorScheme.outlineVariant),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SizedBox(
                  height: 108,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Opacity(
                        opacity: opacity,
                        child: _FolderBadge(
                          count: source.assetCount,
                          icon: _sourceIcon(source),
                        ),
                      ),
                      Positioned(
                        right: 8,
                        bottom: 8,
                        child: _SelectionMark(selected: item.enabled),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Opacity(
            opacity: opacity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  source.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Text(
                  path,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FolderBadge extends StatelessWidget {
  const _FolderBadge({required this.count, required this.icon});

  final int count;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Stack(
      alignment: Alignment.center,
      children: [
        Icon(
          Icons.folder_rounded,
          size: 76,
          color: colorScheme.primaryContainer,
        ),
        Positioned(
          top: 33,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16, color: colorScheme.onPrimaryContainer),
              const SizedBox(width: 4),
              Text(
                count.toString(),
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SelectionMark extends StatelessWidget {
  const _SelectionMark({required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: selected ? colorScheme.primary : colorScheme.surface,
        shape: BoxShape.circle,
        border: Border.all(
          color: selected ? colorScheme.primary : colorScheme.outline,
          width: 2,
        ),
      ),
      child: SizedBox.square(
        dimension: 28,
        child: selected
            ? Icon(Icons.check, size: 18, color: colorScheme.onPrimary)
            : const SizedBox.shrink(),
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

IconData _sourceIcon(MediaSource source) {
  if (source.cameraLike) {
    return Icons.photo_camera_outlined;
  }

  if (source.systemLike) {
    return Icons.collections_outlined;
  }

  return Icons.folder_outlined;
}
