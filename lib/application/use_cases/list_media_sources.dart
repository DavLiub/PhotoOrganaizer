import '../../domain/value_objects/operation_result.dart';
import '../models/source_selection.dart';
import '../ports/media_source_repository.dart';
import '../ports/source_selection_repository.dart';

class ListMediaSources {
  const ListMediaSources({
    required MediaSourceRepository mediaSourceRepository,
    required SourceSelectionRepository sourceSelectionRepository,
  }) : _mediaSourceRepository = mediaSourceRepository,
       _sourceSelectionRepository = sourceSelectionRepository;

  final MediaSourceRepository _mediaSourceRepository;
  final SourceSelectionRepository _sourceSelectionRepository;

  Future<OperationResult<MediaSourceSelection>> call() async {
    try {
      final sources = await _mediaSourceRepository.findAll();
      final settings = await _sourceSelectionRepository.read();

      return OperationSuccess(
        buildMediaSourceSelection(sources: sources, settings: settings),
      );
    } catch (error) {
      return OperationFailure(
        kind: FailureKind.storage,
        code: 'media_sources.read_failed',
        safeMessage: 'Media sources could not be loaded.',
        retryable: true,
        diagnostics: {'error_type': error.runtimeType.toString()},
      );
    }
  }
}
