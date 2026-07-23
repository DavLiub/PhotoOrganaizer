import '../entities/photo_asset.dart';

enum IndexScopeMode { allPhotos, cameraOnly, customAlbums }

class IndexScope {
  const IndexScope({
    required this.mode,
    this.includedAlbumIds = const {},
    this.excludedAlbumIds = const {},
    this.excludedSourceNames = const {},
    this.includeScreenshots = true,
  });

  const IndexScope.allPhotos({
    Set<String> excludedAlbumIds = const {},
    Set<String> excludedSourceNames = const {},
    bool includeScreenshots = true,
  }) : this(
         mode: IndexScopeMode.allPhotos,
         excludedAlbumIds: excludedAlbumIds,
         excludedSourceNames: excludedSourceNames,
         includeScreenshots: includeScreenshots,
       );

  const IndexScope.cameraOnly({
    Set<String> excludedAlbumIds = const {},
    Set<String> excludedSourceNames = const {},
    bool includeScreenshots = false,
  }) : this(
         mode: IndexScopeMode.cameraOnly,
         excludedAlbumIds: excludedAlbumIds,
         excludedSourceNames: excludedSourceNames,
         includeScreenshots: includeScreenshots,
       );

  const IndexScope.customAlbums({
    required Set<String> includedAlbumIds,
    Set<String> excludedAlbumIds = const {},
    Set<String> excludedSourceNames = const {},
    bool includeScreenshots = true,
  }) : this(
         mode: IndexScopeMode.customAlbums,
         includedAlbumIds: includedAlbumIds,
         excludedAlbumIds: excludedAlbumIds,
         excludedSourceNames: excludedSourceNames,
         includeScreenshots: includeScreenshots,
       );

  final IndexScopeMode mode;
  final Set<String> includedAlbumIds;
  final Set<String> excludedAlbumIds;
  final Set<String> excludedSourceNames;
  final bool includeScreenshots;

  bool allows(PhotoAsset asset) {
    if (_isExcluded(asset)) {
      return false;
    }

    return switch (mode) {
      IndexScopeMode.allPhotos => true,
      IndexScopeMode.cameraOnly => _isCameraAsset(asset),
      IndexScopeMode.customAlbums =>
        asset.albumId != null && includedAlbumIds.contains(asset.albumId),
    };
  }

  bool _isExcluded(PhotoAsset asset) {
    final albumId = asset.albumId;
    if (albumId != null && excludedAlbumIds.contains(albumId)) {
      return true;
    }

    final source = _sourceText(asset);
    final excludedSource = excludedSourceNames.any(
      (name) => source.contains(name.toLowerCase()),
    );
    if (excludedSource) {
      return true;
    }

    return !includeScreenshots && source.contains('screenshot');
  }

  bool _isCameraAsset(PhotoAsset asset) {
    final source = _sourceText(asset);
    return source.contains('camera') || source.contains('dcim');
  }

  String _sourceText(PhotoAsset asset) {
    return [
      asset.sourceProvider,
      asset.sourceName,
      asset.albumId,
    ].whereType<String>().join(' ').toLowerCase();
  }
}
