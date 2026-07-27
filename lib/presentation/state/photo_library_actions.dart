import 'dart:typed_data';

import '../../application/models/photo_library.dart';
import '../../application/use_cases/scan_media_library.dart';
import '../../domain/value_objects/operation_result.dart';

typedef ListPhotos = Future<OperationResult<PhotoLibrary>> Function();

typedef LoadThumbnail = Future<Uint8List?> Function(String assetId, {int size});

typedef RefreshLibrary =
    Future<OperationResult<LibraryScanResult>> Function({int pageSize});

class PhotoLibraryActions {
  const PhotoLibraryActions({
    required this.listPhotos,
    required this.loadThumbnail,
    required this.refreshLibrary,
  });

  final ListPhotos listPhotos;
  final LoadThumbnail loadThumbnail;
  final RefreshLibrary refreshLibrary;
}
