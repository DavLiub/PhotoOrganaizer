import '../../domain/entities/photo_index_entry.dart';
import '../../domain/value_objects/operation_result.dart';
import '../../domain/value_objects/photo_identity.dart';
import '../ports/photo_index_repository.dart';

class ResolvePhotoIdentity {
  const ResolvePhotoIdentity(this._repository);

  final PhotoIndexRepository _repository;

  Future<OperationResult<PhotoIndexEntry?>> call(PhotoIdentity identity) async {
    try {
      return OperationSuccess(await _repository.findByIdentity(identity));
    } catch (error) {
      return OperationFailure(
        kind: FailureKind.storage,
        code: 'photo_index.lookup_failed',
        safeMessage: 'Photo identity could not be resolved.',
        retryable: true,
        diagnostics: {'error_type': error.runtimeType.toString()},
      );
    }
  }
}
