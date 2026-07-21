import '../../application/ports/media_library_gateway.dart';
import '../../domain/entities/photo_asset.dart';

class AndroidMediaLibraryGateway implements MediaLibraryGateway {
  @override
  Future<List<PhotoAsset>> scanPhotos() async {
    return const [];
  }
}
