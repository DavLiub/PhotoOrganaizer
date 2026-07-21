import '../../domain/entities/photo_asset.dart';

abstract interface class MediaLibraryGateway {
  Future<List<PhotoAsset>> scanPhotos();
}
