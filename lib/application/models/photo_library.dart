import '../../domain/entities/media_source.dart';
import '../../domain/entities/photo_index_entry.dart';
import '../policies/library_category_classifier.dart';
import 'library_category.dart';
import 'source_selection.dart';
export 'library_category.dart';

enum LibraryBackupStatus { noBackup, queued, protected, failed, ignored }

class PhotoLibrary {
  const PhotoLibrary({required this.photos, required this.categories});

  const PhotoLibrary.empty() : photos = const [], categories = const [];

  final List<LibraryPhoto> photos;
  final List<LibraryCategorySummary> categories;

  bool get isEmpty => photos.isEmpty;
}

class LibraryPhoto {
  const LibraryPhoto({
    required this.id,
    required this.assetId,
    required this.displayName,
    required this.sourceName,
    required this.category,
    required this.backupStatus,
    required this.createdAt,
    required this.fileSize,
    this.width,
    this.height,
  });

  final String id;
  final String assetId;
  final String displayName;
  final String sourceName;
  final LibraryCategory category;
  final LibraryBackupStatus backupStatus;
  final DateTime createdAt;
  final int fileSize;
  final int? width;
  final int? height;
}

class LibraryCategorySummary {
  const LibraryCategorySummary({required this.category, required this.count});

  final LibraryCategory category;
  final int count;
}

PhotoLibrary buildPhotoLibrary({
  required List<PhotoIndexEntry> entries,
  required List<MediaSource> sources,
  SourceSelectionPolicy? selectionPolicy,
}) {
  final sourcesById = {for (final source in sources) source.id: source};
  final photos = [
    for (final entry in entries)
      if (selectionPolicy?.allowsEntry(
            entry,
            sourcesById[entry.asset.sourceId],
          ) ??
          true)
        _mapPhoto(entry, sourcesById[entry.asset.sourceId]),
  ];
  final counts = <LibraryCategory, int>{
    for (final category in _visibleCategories(selectionPolicy)) category: 0,
  };

  for (final photo in photos) {
    counts[photo.category] = counts[photo.category]! + 1;
  }

  return PhotoLibrary(
    photos: List.unmodifiable(photos),
    categories: List.unmodifiable(
      _visibleCategories(selectionPolicy).map(
        (category) => LibraryCategorySummary(
          category: category,
          count: counts[category] ?? 0,
        ),
      ),
    ),
  );
}

LibraryPhoto _mapPhoto(PhotoIndexEntry entry, MediaSource? source) {
  final asset = entry.asset;
  final sourceName = asset.sourceName ?? source?.name ?? 'Unknown';

  return LibraryPhoto(
    id: entry.id,
    assetId: asset.id,
    displayName: asset.filename,
    sourceName: sourceName,
    category: classifyPhotoEntry(entry, source),
    backupStatus: _backupStatus(entry.status),
    createdAt: asset.createdAt,
    fileSize: asset.fileSize,
    width: asset.width,
    height: asset.height,
  );
}

LibraryBackupStatus _backupStatus(PhotoIndexStatus status) {
  return switch (status) {
    PhotoIndexStatus.indexed => LibraryBackupStatus.noBackup,
    PhotoIndexStatus.pendingBackup => LibraryBackupStatus.queued,
    PhotoIndexStatus.protected => LibraryBackupStatus.protected,
    PhotoIndexStatus.failed => LibraryBackupStatus.failed,
    PhotoIndexStatus.ignored => LibraryBackupStatus.ignored,
  };
}

Iterable<LibraryCategory> _visibleCategories(
  SourceSelectionPolicy? selectionPolicy,
) {
  final settings = selectionPolicy?.settings;
  if (settings == null) {
    return LibraryCategory.values;
  }

  return LibraryCategory.values.where(settings.isCategoryEnabled);
}
