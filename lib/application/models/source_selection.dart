import '../../domain/entities/media_source.dart';
import '../../domain/entities/photo_index_entry.dart';
import '../policies/library_category_classifier.dart';
import 'library_category.dart';

class SourceSelectionSettings {
  const SourceSelectionSettings({
    required this.enabledCategories,
    this.sourceOverrides = const {},
  });

  factory SourceSelectionSettings.defaults() {
    return SourceSelectionSettings(
      enabledCategories: Set.unmodifiable(LibraryCategory.values),
    );
  }

  final Set<LibraryCategory> enabledCategories;
  final Map<String, bool> sourceOverrides;

  bool isCategoryEnabled(LibraryCategory category) {
    return enabledCategories.contains(category);
  }

  bool isSourceEnabled(String sourceId) {
    return sourceOverrides[sourceId] ?? true;
  }

  SourceSelectionSettings withCategory(
    LibraryCategory category, {
    required bool enabled,
  }) {
    final nextCategories = {...enabledCategories};
    if (enabled) {
      nextCategories.add(category);
    } else {
      nextCategories.remove(category);
    }

    return SourceSelectionSettings(
      enabledCategories: Set.unmodifiable(nextCategories),
      sourceOverrides: Map.unmodifiable(sourceOverrides),
    );
  }

  SourceSelectionSettings withSource(String sourceId, {required bool enabled}) {
    return SourceSelectionSettings(
      enabledCategories: Set.unmodifiable(enabledCategories),
      sourceOverrides: Map.unmodifiable({
        ...sourceOverrides,
        sourceId: enabled,
      }),
    );
  }
}

class SourceSelectionPolicy {
  const SourceSelectionPolicy(this.settings);

  final SourceSelectionSettings settings;

  bool allowsSource(MediaSource source) {
    final category = classifySource(source);
    return settings.isCategoryEnabled(category) &&
        settings.isSourceEnabled(source.id);
  }

  bool allowsEntry(PhotoIndexEntry entry, MediaSource? source) {
    final category = classifyPhotoEntry(entry, source);
    final sourceId = entry.asset.sourceId;

    return settings.isCategoryEnabled(category) &&
        (sourceId == null || settings.isSourceEnabled(sourceId));
  }
}

class MediaSourceSelection {
  const MediaSourceSelection({required this.groups, required this.settings});

  const MediaSourceSelection.empty()
    : groups = const [],
      settings = const SourceSelectionSettings(
        enabledCategories: {
          LibraryCategory.camera,
          LibraryCategory.social,
          LibraryCategory.downloads,
          LibraryCategory.screenshots,
        },
      );

  final List<MediaSourceGroup> groups;
  final SourceSelectionSettings settings;

  bool get isEmpty {
    return groups.every((group) => group.sources.isEmpty);
  }
}

class MediaSourceGroup {
  const MediaSourceGroup({required this.category, required this.sources});

  final LibraryCategory category;
  final List<SelectableSource> sources;

  int get assetCount {
    return sources.fold(0, (sum, source) => sum + source.source.assetCount);
  }
}

class SelectableSource {
  const SelectableSource({
    required this.source,
    required this.category,
    required this.enabled,
  });

  final MediaSource source;
  final LibraryCategory category;
  final bool enabled;
}

MediaSourceSelection buildMediaSourceSelection({
  required List<MediaSource> sources,
  required SourceSelectionSettings settings,
}) {
  final grouped = <LibraryCategory, List<SelectableSource>>{
    for (final category in LibraryCategory.values) category: [],
  };

  for (final source in sources) {
    final category = classifySource(source);
    if (!settings.isCategoryEnabled(category)) {
      continue;
    }

    grouped[category]!.add(
      SelectableSource(
        source: source,
        category: category,
        enabled: settings.isSourceEnabled(source.id),
      ),
    );
  }

  final groups = [
    for (final category in LibraryCategory.values)
      if (settings.isCategoryEnabled(category))
        MediaSourceGroup(
          category: category,
          sources: List.unmodifiable(
            grouped[category]!..sort((left, right) {
              return left.source.name.toLowerCase().compareTo(
                right.source.name.toLowerCase(),
              );
            }),
          ),
        ),
  ];

  return MediaSourceSelection(
    groups: List.unmodifiable(groups),
    settings: settings,
  );
}
