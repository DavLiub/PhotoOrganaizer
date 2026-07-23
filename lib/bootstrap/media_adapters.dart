import '../application/ports/media_library_gateway.dart';
import '../application/ports/media_permission_gateway.dart';
import '../infrastructure/media/android_media_access.dart';
import '../infrastructure/media/android_media_library_gateway.dart';
import '../infrastructure/media/ios_media_access.dart';
import '../infrastructure/media/ios_media_library_gateway.dart';
import '../infrastructure/media/unsupported_media_access.dart';
import '../infrastructure/media/unsupported_media_library_gateway.dart';
import 'app_platform.dart';

class MediaAdapters {
  const MediaAdapters({
    required this.libraryGateway,
    required this.permissionGateway,
  });

  factory MediaAdapters.forPlatform(AppPlatform platform) {
    return switch (platform) {
      AppPlatform.android => MediaAdapters(
        libraryGateway: AndroidMediaLibraryGateway(),
        permissionGateway: const AndroidMediaAccess(),
      ),
      AppPlatform.ios => MediaAdapters(
        libraryGateway: IosMediaLibraryGateway(),
        permissionGateway: const IosMediaAccess(),
      ),
      AppPlatform.unsupported => MediaAdapters(
        libraryGateway: UnsupportedMediaLibraryGateway(),
        permissionGateway: const UnsupportedMediaAccess(),
      ),
    };
  }

  final MediaLibraryGateway libraryGateway;
  final MediaPermissionGateway permissionGateway;
}
