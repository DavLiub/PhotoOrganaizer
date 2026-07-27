import '../../application/ports/media_library_gateway.dart';

class UnsupportedMediaLibrary implements MediaLibraryGateway {
  @override
  Future<LibraryScan> scanLibrary({
    int pageSize = 100,
    LibraryProgressCallback? onProgress,
  }) async {
    onProgress?.call(const LibraryScanProgress(foundPhotos: 0, sourceCount: 0));
    return const LibraryScan.empty();
  }
}
