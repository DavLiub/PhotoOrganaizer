import 'dart:developer' as developer;

import 'package:photo_manager/photo_manager.dart' as pm;

import '../../application/models/scan_signal.dart';
import '../../application/ports/media_library_gateway.dart';
import '../../domain/entities/media_source.dart';
import '../../domain/entities/photo_asset.dart';
import 'photo_manager_mapper.dart';

class AndroidMediaLibraryGateway implements MediaLibraryGateway {
  @override
  Future<LibraryScan> scanLibrary({
    int pageSize = 100,
    LibraryProgressCallback? onProgress,
    LibraryBatchCallback? onBatch,
    ScanSignal? signal,
  }) async {
    final safePageSize = pageSize <= 0 ? 100 : pageSize;
    final discoveredAt = DateTime.now().toUtc();
    signal?.throwIfStopped();
    final paths = await pm.PhotoManager.getAssetPathList(
      hasAll: false,
      type: pm.RequestType.image,
    );
    final sources = <MediaSource>[];
    final photosById = <String, PhotoAsset>{};
    var scannedSources = 0;

    _logScan('started paths=${paths.length} pageSize=$safePageSize');
    _emitProgress(
      onProgress,
      photosById: photosById,
      sources: sources,
      scannedSources: scannedSources,
      totalSources: paths.length,
    );

    for (final path in paths) {
      signal?.throwIfStopped();
      final assetCount = await path.assetCountAsync;
      if (assetCount <= 0) {
        scannedSources++;
        _emitProgress(
          onProgress,
          photosById: photosById,
          sources: sources,
          scannedSources: scannedSources,
          totalSources: paths.length,
        );
        continue;
      }

      final pathHint = await path.relativePathAsync;
      final source = mapSource(
        SourceMeta(
          albumId: path.id,
          name: path.name,
          pathHint: pathHint,
          assetCount: assetCount,
          lastSeenAt: discoveredAt,
          isAll: path.isAll,
        ),
      );
      sources.add(source);
      await onBatch?.call(LibraryBatch(sources: [source]));

      await _scanPath(
        path: path,
        pageSize: safePageSize,
        discoveredAt: discoveredAt,
        photosById: photosById,
        onBatch: onBatch,
        signal: signal,
        onProgress: () {
          _emitProgress(
            onProgress,
            photosById: photosById,
            sources: sources,
            scannedSources: scannedSources,
            totalSources: paths.length,
          );
        },
      );
      scannedSources++;
      _logScan(
        'path scanned name=${path.name} found=${photosById.length} '
        'sources=$scannedSources/${paths.length}',
      );
      _emitProgress(
        onProgress,
        photosById: photosById,
        sources: sources,
        scannedSources: scannedSources,
        totalSources: paths.length,
      );
    }

    _logScan('completed found=${photosById.length} sources=${sources.length}');
    return LibraryScan(
      sources: List.unmodifiable(sources),
      photos: List.unmodifiable(photosById.values),
    );
  }
}

Future<void> _scanPath({
  required pm.AssetPathEntity path,
  required int pageSize,
  required DateTime discoveredAt,
  required Map<String, PhotoAsset> photosById,
  required LibraryBatchCallback? onBatch,
  required ScanSignal? signal,
  required void Function() onProgress,
}) async {
  var page = 0;

  while (true) {
    signal?.throwIfStopped();
    final assets = await path.getAssetListPaged(
      page: page,
      size: pageSize,
      type: pm.RequestType.image,
    );
    if (assets.isEmpty) {
      return;
    }

    final pagePhotos = <PhotoAsset>[];
    for (final asset in assets) {
      signal?.throwIfStopped();
      if (asset.type != pm.AssetType.image) {
        continue;
      }

      final photo = await _mapAsset(
        asset: asset,
        path: path,
        discoveredAt: discoveredAt,
      );
      if (photosById.containsKey(photo.id)) {
        continue;
      }

      photosById[photo.id] = photo;
      pagePhotos.add(photo);

      if (photosById.length % 25 == 0) {
        onProgress();
      }
    }

    if (pagePhotos.isNotEmpty) {
      await onBatch?.call(LibraryBatch(photos: List.unmodifiable(pagePhotos)));
    }
    onProgress();

    if (assets.length < pageSize) {
      return;
    }

    page++;
  }
}

Future<PhotoAsset> _mapAsset({
  required pm.AssetEntity asset,
  required pm.AssetPathEntity path,
  required DateTime discoveredAt,
}) async {
  final title = asset.title?.trim().isNotEmpty == true
      ? asset.title
      : await asset.titleAsync;
  final mimeType = asset.mimeType ?? await asset.mimeTypeAsync;

  return mapAsset(
    AssetMeta(
      assetId: asset.id,
      albumId: path.id,
      albumName: path.name,
      filename: title,
      mimeType: mimeType,
      fileSize: await asset.fileSize,
      createdAt: asset.createDateTime,
      modifiedAt: asset.modifiedDateTime,
      discoveredAt: discoveredAt,
      width: asset.width,
      height: asset.height,
    ),
  );
}

void _emitProgress(
  LibraryProgressCallback? onProgress, {
  required Map<String, PhotoAsset> photosById,
  required List<MediaSource> sources,
  required int scannedSources,
  required int totalSources,
}) {
  onProgress?.call(
    LibraryScanProgress(
      foundPhotos: photosById.length,
      sourceCount: sources.length,
      scannedSources: scannedSources,
      totalSources: totalSources,
    ),
  );
}

void _logScan(String message) {
  developer.log(message, name: 'PhotoOrganizer.Scan');
}
