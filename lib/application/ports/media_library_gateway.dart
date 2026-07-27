import '../../domain/entities/media_source.dart';
import '../../domain/entities/photo_asset.dart';
import '../models/scan_signal.dart';

class LibraryScan {
  const LibraryScan({required this.sources, required this.photos});

  const LibraryScan.empty() : sources = const [], photos = const [];

  final List<MediaSource> sources;
  final List<PhotoAsset> photos;

  bool get isEmpty => sources.isEmpty && photos.isEmpty;
}

class LibraryScanProgress {
  const LibraryScanProgress({
    required this.foundPhotos,
    required this.sourceCount,
    this.scannedSources = 0,
    this.totalSources,
  });

  final int foundPhotos;
  final int sourceCount;
  final int scannedSources;
  final int? totalSources;
}

typedef LibraryProgressCallback = void Function(LibraryScanProgress progress);

class LibraryBatch {
  const LibraryBatch({this.sources = const [], this.photos = const []});

  final List<MediaSource> sources;
  final List<PhotoAsset> photos;

  bool get isEmpty => sources.isEmpty && photos.isEmpty;
}

typedef LibraryBatchCallback = Future<void> Function(LibraryBatch batch);

abstract interface class MediaLibraryGateway {
  Future<LibraryScan> scanLibrary({
    int pageSize = 100,
    LibraryProgressCallback? onProgress,
    LibraryBatchCallback? onBatch,
    ScanSignal? signal,
  });
}
