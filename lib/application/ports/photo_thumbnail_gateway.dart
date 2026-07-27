import 'dart:typed_data';

abstract interface class PhotoThumbnailGateway {
  Future<Uint8List?> loadThumbnail(String assetId, {int size = 200});
}
