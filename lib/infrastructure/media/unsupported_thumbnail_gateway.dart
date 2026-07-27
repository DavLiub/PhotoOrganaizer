import 'dart:typed_data';

import '../../application/ports/photo_thumbnail_gateway.dart';

class UnsupportedThumbnailGateway implements PhotoThumbnailGateway {
  const UnsupportedThumbnailGateway();

  @override
  Future<Uint8List?> loadThumbnail(String assetId, {int size = 200}) async {
    return null;
  }
}
