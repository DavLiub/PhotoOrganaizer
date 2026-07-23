import '../../domain/entities/photo_asset.dart';
import '../../domain/entities/photo_index_entry.dart';
import '../../domain/value_objects/index_scope.dart';
import '../../domain/value_objects/media_permission.dart';
import '../../domain/value_objects/operation_result.dart';
import '../ports/media_permission_gateway.dart';
import '../ports/photo_index_repository.dart';

class IndexResult {
  const IndexResult({
    required this.seenPhotos,
    required this.indexedPhotos,
    required this.updatedPhotos,
    required this.ignoredPhotos,
  });

  final int seenPhotos;
  final int indexedPhotos;
  final int updatedPhotos;
  final int ignoredPhotos;

  int get writtenPhotos => indexedPhotos + updatedPhotos;
}

class IndexPhotos {
  const IndexPhotos({
    required PhotoIndexRepository repository,
    required MediaPermissionGateway permissionGateway,
  }) : _repository = repository,
       _permissionGateway = permissionGateway;

  final PhotoIndexRepository _repository;
  final MediaPermissionGateway _permissionGateway;

  Future<OperationResult<IndexResult>> call(
    List<PhotoAsset> photos, {
    IndexScope scope = const IndexScope.allPhotos(),
    DateTime? indexedAt,
  }) async {
    final permission = await _permissionGateway.currentStatus();
    switch (permission) {
      case OperationFailure<MediaPermission>(failure: final failure):
        return OperationFailure.fromInfo(failure);
      case OperationSuccess<MediaPermission>(value: final value):
        if (!value.canReadPhotos) {
          return OperationFailure(
            kind: FailureKind.permission,
            code: 'media.permission_required',
            safeMessage: 'Photo access is required before indexing.',
            retryable: value.state == MediaPermissionState.unknown,
            userActionRequired: value.needsUserAction,
            diagnostics: {
              'permission_state': value.state.name,
              if (value.detailCode != null)
                'permission_detail': value.detailCode,
            },
          );
        }
    }

    final now = indexedAt ?? DateTime.now().toUtc();
    final scopedAssets = <String, PhotoAsset>{};
    var ignoredPhotos = 0;

    for (final photo in photos) {
      if (scope.allows(photo)) {
        scopedAssets[photo.id] = photo;
      } else {
        ignoredPhotos++;
      }
    }

    if (scopedAssets.isEmpty) {
      return OperationSuccess(
        IndexResult(
          seenPhotos: photos.length,
          indexedPhotos: 0,
          updatedPhotos: 0,
          ignoredPhotos: ignoredPhotos,
        ),
      );
    }

    try {
      final existingEntries = await _repository.findByAssetIds(
        scopedAssets.keys.toSet(),
      );
      final existingByAssetId = {
        for (final entry in existingEntries) entry.asset.id: entry,
      };

      final entries = <PhotoIndexEntry>[];
      var indexedPhotos = 0;
      var updatedPhotos = 0;

      for (final photo in scopedAssets.values) {
        final existing = existingByAssetId[photo.id];
        if (existing == null) {
          entries.add(PhotoIndexEntry.fromAsset(photo, indexedAt: now));
          indexedPhotos++;
        } else {
          entries.add(existing.refresh(photo, updatedAt: now));
          updatedPhotos++;
        }
      }

      await _repository.upsertEntries(entries);

      return OperationSuccess(
        IndexResult(
          seenPhotos: photos.length,
          indexedPhotos: indexedPhotos,
          updatedPhotos: updatedPhotos,
          ignoredPhotos: ignoredPhotos,
        ),
      );
    } catch (error) {
      return OperationFailure(
        kind: FailureKind.storage,
        code: 'photo_index.write_failed',
        safeMessage: 'Photo index could not be updated.',
        retryable: true,
        diagnostics: {'error_type': error.runtimeType.toString()},
      );
    }
  }
}
