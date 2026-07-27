import '../../domain/entities/media_source.dart';
import '../../domain/entities/photo_index_entry.dart';

enum LibraryCategory { camera, social, downloads, screenshots }

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
}) {
  final sourcesById = {for (final source in sources) source.id: source};
  final photos = [
    for (final entry in entries)
      _mapPhoto(entry, sourcesById[entry.asset.sourceId]),
  ];
  final counts = <LibraryCategory, int>{
    for (final category in LibraryCategory.values) category: 0,
  };

  for (final photo in photos) {
    counts[photo.category] = counts[photo.category]! + 1;
  }

  return PhotoLibrary(
    photos: List.unmodifiable(photos),
    categories: List.unmodifiable(
      LibraryCategory.values.map(
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
    category: _categoryFor(entry, source),
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

LibraryCategory _categoryFor(PhotoIndexEntry entry, MediaSource? source) {
  final asset = entry.asset;
  final value = [
    source?.name,
    source?.pathHint,
    asset.sourceName,
    asset.filename,
  ].whereType<String>().join(' ').toLowerCase();

  if (_hasAny(value, const ['screenshot', 'screen shot', 'screenshots'])) {
    return LibraryCategory.screenshots;
  }

  if (source?.cameraLike == true ||
      _hasAny(value, const ['camera', 'dcim', '100media'])) {
    return LibraryCategory.camera;
  }

  if (_hasAny(value, const [
    'whatsapp',
    'telegram',
    'instagram',
    'facebook',
    'messenger',
    'viber',
    'signal',
    'tiktok',
    'snapchat',
  ])) {
    return LibraryCategory.social;
  }

  return LibraryCategory.downloads;
}

bool _hasAny(String value, List<String> needles) {
  return needles.any(value.contains);
}
