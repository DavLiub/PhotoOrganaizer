import '../../application/ports/media_library_gateway.dart';

class IosMediaLibrary implements MediaLibraryGateway {
  @override
  Future<LibraryScan> scanLibrary({int pageSize = 100}) async {
    return const LibraryScan.empty();
  }
}
