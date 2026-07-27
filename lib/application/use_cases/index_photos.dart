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

typedef IndexProgressCallback = void Function(IndexResult progress);

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
    IndexProgressCallback? onProgress,
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
      onProgress?.call(
        IndexResult(
          seenPhotos: photos.length,
          indexedPhotos: 0,
          updatedPhotos: 0,
          ignoredPhotos: ignoredPhotos,
        ),
      );
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
      final newAssetIds = <String>{};
      var indexedPhotos = 0;
      var updatedPhotos = 0;

      for (final photo in scopedAssets.values) {
        final existing = existingByAssetId[photo.id];
        if (existing == null) {
          entries.add(PhotoIndexEntry.fromAsset(photo, indexedAt: now));
          newAssetIds.add(photo.id);
          indexedPhotos++;
        } else {
          entries.add(existing.refresh(photo, updatedAt: now));
          updatedPhotos++;
        }
      }

      const batchSize = 100;
      var writtenIndexed = 0;
      var writtenUpdated = 0;

      for (var start = 0; start < entries.length; start += batchSize) {
        final end = start + batchSize > entries.length
            ? entries.length
            : start + batchSize;
        final batch = entries.sublist(start, end);
        await _repository.upsertEntries(batch);

        for (final entry in batch) {
          if (newAssetIds.contains(entry.asset.id)) {
            writtenIndexed++;
          } else {
            writtenUpdated++;
          }
        }

        onProgress?.call(
          IndexResult(
            seenPhotos: photos.length,
            indexedPhotos: writtenIndexed,
            updatedPhotos: writtenUpdated,
            ignoredPhotos: ignoredPhotos,
          ),
        );
      }

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
