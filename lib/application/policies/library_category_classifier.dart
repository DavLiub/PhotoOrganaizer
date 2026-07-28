import '../../domain/entities/media_source.dart';
import '../../domain/entities/photo_index_entry.dart';
import '../models/library_category.dart';

LibraryCategory classifySource(MediaSource source) {
  final value = [
    source.name,
    source.pathHint,
  ].whereType<String>().join(' ').toLowerCase();

  if (_hasAny(value, const ['screenshot', 'screen shot', 'screenshots'])) {
    return LibraryCategory.screenshots;
  }

  if (source.cameraLike ||
      _hasAny(value, const ['camera', 'dcim', '100media'])) {
    return LibraryCategory.camera;
  }

  if (_hasAny(value, _socialMarkers)) {
    return LibraryCategory.social;
  }

  return LibraryCategory.downloads;
}

LibraryCategory classifyPhotoEntry(PhotoIndexEntry entry, MediaSource? source) {
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

  if (_hasAny(value, _socialMarkers)) {
    return LibraryCategory.social;
  }

  return LibraryCategory.downloads;
}

const _socialMarkers = [
  'whatsapp',
  'telegram',
  'instagram',
  'facebook',
  'messenger',
  'viber',
  'signal',
  'tiktok',
  'snapchat',
];

bool _hasAny(String value, List<String> needles) {
  return needles.any(value.contains);
}
