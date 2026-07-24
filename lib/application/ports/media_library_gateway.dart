import '../../domain/entities/media_source.dart';
import '../../domain/entities/photo_asset.dart';

class LibraryScan {
  const LibraryScan({required this.sources, required this.photos});

  const LibraryScan.empty() : sources = const [], photos = const [];

  final List<MediaSource> sources;
  final List<PhotoAsset> photos;

  bool get isEmpty => sources.isEmpty && photos.isEmpty;
}

abstract interface class MediaLibraryGateway {
  Future<LibraryScan> scanLibrary({int pageSize = 100});
}
