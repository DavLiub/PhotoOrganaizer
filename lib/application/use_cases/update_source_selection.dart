import '../../domain/value_objects/operation_result.dart';
import '../models/library_category.dart';
import '../models/source_selection.dart';
import '../ports/source_selection_repository.dart';

class UpdateSourceSelection {
  const UpdateSourceSelection(this._repository);

  final SourceSelectionRepository _repository;

  Future<OperationResult<SourceSelectionSettings>> setCategory(
    LibraryCategory category, {
    required bool enabled,
  }) async {
    try {
      await _repository.setCategory(category, enabled: enabled);
      return OperationSuccess(await _repository.read());
    } catch (error) {
      return _failure(error);
    }
  }

  Future<OperationResult<SourceSelectionSettings>> setSource(
    String sourceId, {
    required bool enabled,
  }) async {
    try {
      await _repository.setSource(sourceId, enabled: enabled);
      return OperationSuccess(await _repository.read());
    } catch (error) {
      return _failure(error);
    }
  }

  OperationFailure<SourceSelectionSettings> _failure(Object error) {
    return OperationFailure(
      kind: FailureKind.storage,
      code: 'source_selection.write_failed',
      safeMessage: 'Media source settings could not be saved.',
      retryable: true,
      diagnostics: {'error_type': error.runtimeType.toString()},
    );
  }
}
