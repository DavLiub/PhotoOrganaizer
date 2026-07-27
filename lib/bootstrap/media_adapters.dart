import '../application/ports/media_library_gateway.dart';
import '../application/ports/media_permission_gateway.dart';
import '../application/ports/photo_thumbnail_gateway.dart';
import '../infrastructure/media/android_media_access.dart';
import '../infrastructure/media/android_media_library_gateway.dart';
import '../infrastructure/media/ios_media_access.dart';
import '../infrastructure/media/ios_media_library_gateway.dart';
import '../infrastructure/media/photo_thumbnail_adapter.dart';
import '../infrastructure/media/unsupported_media_access.dart';
import '../infrastructure/media/unsupported_media_library_gateway.dart';
import '../infrastructure/media/unsupported_thumbnail_gateway.dart';
import 'app_platform.dart';

class MediaAdapters {
  const MediaAdapters({
    required this.libraryGateway,
    required this.permissionGateway,
    required this.thumbnailGateway,
  });

  factory MediaAdapters.forPlatform(AppPlatform platform) {
    return switch (platform) {
      AppPlatform.android => MediaAdapters(
        libraryGateway: AndroidMediaLibraryGateway(),
        permissionGateway: const AndroidMediaAccess(),
        thumbnailGateway: const PhotoThumbnailAdapter(),
      ),
      AppPlatform.ios => MediaAdapters(
        libraryGateway: IosMediaLibrary(),
        permissionGateway: const IosMediaAccess(),
        thumbnailGateway: const PhotoThumbnailAdapter(),
      ),
      AppPlatform.unsupported => MediaAdapters(
        libraryGateway: UnsupportedMediaLibrary(),
        permissionGateway: const UnsupportedMediaAccess(),
        thumbnailGateway: const UnsupportedThumbnailGateway(),
      ),
    };
  }

  final MediaLibraryGateway libraryGateway;
  final MediaPermissionGateway permissionGateway;
  final PhotoThumbnailGateway thumbnailGateway;
}
