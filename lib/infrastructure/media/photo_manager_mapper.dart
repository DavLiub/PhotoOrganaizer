import '../../domain/entities/media_source.dart';
import '../../domain/entities/photo_asset.dart';

const photoManagerProvider = 'photo_manager';

class SourceMeta {
  const SourceMeta({
    required this.albumId,
    required this.name,
    required this.assetCount,
    required this.lastSeenAt,
    this.pathHint,
    this.isAll = false,
  });

  final String albumId;
  final String name;
  final String? pathHint;
  final int assetCount;
  final DateTime lastSeenAt;
  final bool isAll;
}

class AssetMeta {
  const AssetMeta({
    required this.assetId,
    required this.albumId,
    required this.albumName,
    required this.fileSize,
    required this.createdAt,
    required this.modifiedAt,
    required this.discoveredAt,
    required this.width,
    required this.height,
    this.filename,
    this.mimeType,
  });

  final String assetId;
  final String albumId;
  final String albumName;
  final String? filename;
  final String? mimeType;
  final int fileSize;
  final DateTime createdAt;
  final DateTime modifiedAt;
  final DateTime discoveredAt;
  final int width;
  final int height;
}

String mediaSourceId(String albumId) {
  return '$photoManagerProvider:${_textOr(albumId, 'unknown')}';
}

MediaSource mapSource(SourceMeta meta) {
  final name = _textOr(meta.name, 'Unknown');
  final pathHint = _blankToNull(meta.pathHint);

  return MediaSource(
    id: mediaSourceId(meta.albumId),
    provider: photoManagerProvider,
    name: name,
    pathHint: pathHint,
    assetCount: meta.assetCount,
    lastSeenAt: meta.lastSeenAt.toUtc(),
    availabilityStatus: MediaSourceStatus.available,
    cameraLike: _cameraLike(name, pathHint),
    systemLike: meta.isAll || _systemLike(name, pathHint),
  );
}

PhotoAsset mapAsset(AssetMeta meta) {
  final filename = _textOr(meta.filename, '${meta.assetId}.jpg');
  final albumName = _textOr(meta.albumName, 'Unknown');
  final discoveredAt = meta.discoveredAt.toUtc();

  return PhotoAsset(
    id: meta.assetId,
    sourceUri: _assetUri(meta.assetId),
    sourceProvider: photoManagerProvider,
    sourceId: mediaSourceId(meta.albumId),
    albumId: _textOr(meta.albumId, 'unknown'),
    sourceName: albumName,
    filename: filename,
    mimeType: _mimeType(meta.mimeType, filename),
    fileSize: meta.fileSize,
    createdAt: meta.createdAt.toUtc(),
    modifiedAt: meta.modifiedAt.toUtc(),
    discoveredAt: discoveredAt,
    lastSeenAt: discoveredAt,
    availabilityStatus: PhotoAvailabilityStatus.available,
    width: meta.width,
    height: meta.height,
  );
}

String _assetUri(String assetId) {
  return Uri(
    scheme: 'photo-manager',
    host: 'asset',
    pathSegments: [_textOr(assetId, 'unknown')],
  ).toString();
}

String _mimeType(String? mimeType, String filename) {
  final explicit = _blankToNull(mimeType);
  if (explicit != null) {
    return explicit;
  }

  final extension = filename.split('.').last.toLowerCase();
  return switch (extension) {
    'jpg' || 'jpeg' => 'image/jpeg',
    'png' => 'image/png',
    'webp' => 'image/webp',
    'gif' => 'image/gif',
    'heic' => 'image/heic',
    'heif' => 'image/heif',
    'bmp' => 'image/bmp',
    'dng' => 'image/x-adobe-dng',
    'tif' || 'tiff' => 'image/tiff',
    _ => 'application/octet-stream',
  };
}

bool _cameraLike(String name, String? pathHint) {
  final value = '${name.toLowerCase()} ${pathHint?.toLowerCase() ?? ''}'.trim();
  return value.contains('camera') || value.contains('dcim');
}

bool _systemLike(String name, String? pathHint) {
  final value = '${name.toLowerCase()} ${pathHint?.toLowerCase() ?? ''}'.trim();
  return value.contains('screenshot') ||
      value.contains('screenrecord') ||
      value == 'recent' ||
      value == 'recents';
}

String _textOr(String? value, String fallback) {
  return _blankToNull(value) ?? fallback;
}

String? _blankToNull(String? value) {
  final trimmed = value?.trim();
  if (trimmed == null || trimmed.isEmpty) {
    return null;
  }

  return trimmed;
}
