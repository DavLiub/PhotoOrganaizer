import 'dart:typed_data';

import 'package:photo_manager/photo_manager.dart' as pm;

import '../../application/ports/photo_thumbnail_gateway.dart';

class PhotoThumbnailAdapter implements PhotoThumbnailGateway {
  const PhotoThumbnailAdapter();

  @override
  Future<Uint8List?> loadThumbnail(String assetId, {int size = 200}) async {
    final asset = await pm.AssetEntity.fromId(assetId);
    if (asset == null) {
      return null;
    }

    final safeSize = size <= 0 ? 200 : size;
    return asset.thumbnailDataWithSize(
      pm.ThumbnailSize.square(safeSize),
      quality: 80,
    );
  }
}
