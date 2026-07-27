import '../../domain/value_objects/operation_result.dart';
import '../models/photo_library.dart';
import '../ports/media_source_repository.dart';
import '../ports/photo_index_repository.dart';

class ListLibraryPhotos {
  const ListLibraryPhotos({
    required PhotoIndexRepository photoIndexRepository,
    required MediaSourceRepository mediaSourceRepository,
  }) : _photoIndexRepository = photoIndexRepository,
       _mediaSourceRepository = mediaSourceRepository;

  final PhotoIndexRepository _photoIndexRepository;
  final MediaSourceRepository _mediaSourceRepository;

  Future<OperationResult<PhotoLibrary>> call() async {
    try {
      final entries = await _photoIndexRepository.findAll();
      final sources = await _mediaSourceRepository.findAll();

      return OperationSuccess(
        buildPhotoLibrary(entries: entries, sources: sources),
      );
    } catch (error) {
      return OperationFailure(
        kind: FailureKind.storage,
        code: 'photo_library.read_failed',
        safeMessage: 'Photo library could not be loaded.',
        retryable: true,
        diagnostics: {'error_type': error.runtimeType.toString()},
      );
    }
  }
}
