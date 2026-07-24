import '../../domain/value_objects/index_scope.dart';
import '../../domain/value_objects/media_permission.dart';
import '../../domain/value_objects/operation_result.dart';
import '../ports/media_library_gateway.dart';
import '../ports/media_permission_gateway.dart';
import '../ports/media_source_repository.dart';
import 'index_photos.dart';

class LibraryScanResult {
  const LibraryScanResult({required this.scan, required this.index});

  final LibraryScan scan;
  final IndexResult index;
}

class ScanMediaLibrary {
  const ScanMediaLibrary({
    required MediaLibraryGateway libraryGateway,
    required MediaPermissionGateway permissionGateway,
    required MediaSourceRepository sourceRepository,
    required IndexPhotos indexPhotos,
  }) : _libraryGateway = libraryGateway,
       _permissionGateway = permissionGateway,
       _sourceRepository = sourceRepository,
       _indexPhotos = indexPhotos;

  final MediaLibraryGateway _libraryGateway;
  final MediaPermissionGateway _permissionGateway;
  final MediaSourceRepository _sourceRepository;
  final IndexPhotos _indexPhotos;

  Future<OperationResult<LibraryScanResult>> call({
    IndexScope scope = const IndexScope.allPhotos(),
    DateTime? indexedAt,
    int pageSize = 100,
  }) async {
    if (pageSize <= 0) {
      return OperationFailure(
        kind: FailureKind.validation,
        code: 'media_scan.invalid_page_size',
        safeMessage: 'Media scan page size must be positive.',
      );
    }

    final permission = await _permissionGateway.currentStatus();
    switch (permission) {
      case OperationFailure<MediaPermission>(failure: final failure):
        return OperationFailure.fromInfo(failure);
      case OperationSuccess<MediaPermission>(value: final value):
        if (!value.canReadPhotos) {
          return OperationFailure(
            kind: FailureKind.permission,
            code: 'media.permission_required',
            safeMessage: 'Photo access is required before scanning.',
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

    final LibraryScan scan;
    try {
      scan = await _libraryGateway.scanLibrary(pageSize: pageSize);
    } catch (error) {
      return OperationFailure(
        kind: FailureKind.media,
        code: 'media_scan.failed',
        safeMessage: 'Photo library scan failed.',
        retryable: true,
        diagnostics: {'error_type': error.runtimeType.toString()},
      );
    }

    try {
      await _sourceRepository.upsertSources(scan.sources);
    } catch (error) {
      return OperationFailure(
        kind: FailureKind.storage,
        code: 'media_sources.write_failed',
        safeMessage: 'Media sources could not be updated.',
        retryable: true,
        diagnostics: {'error_type': error.runtimeType.toString()},
      );
    }

    final indexResult = await _indexPhotos(
      scan.photos,
      scope: scope,
      indexedAt: indexedAt,
    );

    return switch (indexResult) {
      OperationFailure<IndexResult>(failure: final failure) =>
        OperationFailure.fromInfo(failure),
      OperationSuccess<IndexResult>(value: final value) => OperationSuccess(
        LibraryScanResult(scan: scan, index: value),
      ),
    };
  }
}
