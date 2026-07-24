import 'package:photo_manager/photo_manager.dart' as pm;

import '../../application/ports/media_library_gateway.dart';
import '../../domain/entities/media_source.dart';
import '../../domain/entities/photo_asset.dart';
import 'photo_manager_mapper.dart';

class AndroidMediaLibraryGateway implements MediaLibraryGateway {
  @override
  Future<LibraryScan> scanLibrary({int pageSize = 100}) async {
    final safePageSize = pageSize <= 0 ? 100 : pageSize;
    final discoveredAt = DateTime.now().toUtc();
    final paths = await pm.PhotoManager.getAssetPathList(
      hasAll: false,
      type: pm.RequestType.image,
    );
    final sources = <MediaSource>[];
    final photosById = <String, PhotoAsset>{};

    for (final path in paths) {
      final assetCount = await path.assetCountAsync;
      if (assetCount <= 0) {
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

      await _scanPath(
        path: path,
        pageSize: safePageSize,
        discoveredAt: discoveredAt,
        photosById: photosById,
      );
    }

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
}) async {
  var page = 0;

  while (true) {
    final assets = await path.getAssetListPaged(
      page: page,
      size: pageSize,
      type: pm.RequestType.image,
    );
    if (assets.isEmpty) {
      return;
    }

    for (final asset in assets) {
      if (asset.type != pm.AssetType.image) {
        continue;
      }

      final photo = await _mapAsset(
        asset: asset,
        path: path,
        discoveredAt: discoveredAt,
      );
      photosById[photo.id] = photo;
    }

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
