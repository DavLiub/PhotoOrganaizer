import '../../domain/value_objects/index_scope.dart';
import '../../domain/value_objects/media_permission.dart';
import '../../domain/value_objects/operation_result.dart';
import '../models/scan_signal.dart';
import '../ports/media_library_gateway.dart';
import '../ports/media_permission_gateway.dart';
import '../ports/media_source_repository.dart';
import 'index_photos.dart';

class LibraryScanResult {
  const LibraryScanResult({required this.scan, required this.index});

  final LibraryScan scan;
  final IndexResult index;
}

class ScanProgress {
  const ScanProgress({
    required this.foundPhotos,
    required this.indexedPhotos,
    required this.updatedPhotos,
    required this.sourceCount,
    this.scannedSources = 0,
    this.totalSources,
  });

  const ScanProgress.empty()
    : foundPhotos = 0,
      indexedPhotos = 0,
      updatedPhotos = 0,
      sourceCount = 0,
      scannedSources = 0,
      totalSources = null;

  final int foundPhotos;
  final int indexedPhotos;
  final int updatedPhotos;
  final int sourceCount;
  final int scannedSources;
  final int? totalSources;

  int get writtenPhotos => indexedPhotos + updatedPhotos;

  ScanProgress copyWith({
    int? foundPhotos,
    int? indexedPhotos,
    int? updatedPhotos,
    int? sourceCount,
    int? scannedSources,
    int? totalSources,
  }) {
    return ScanProgress(
      foundPhotos: foundPhotos ?? this.foundPhotos,
      indexedPhotos: indexedPhotos ?? this.indexedPhotos,
      updatedPhotos: updatedPhotos ?? this.updatedPhotos,
      sourceCount: sourceCount ?? this.sourceCount,
      scannedSources: scannedSources ?? this.scannedSources,
      totalSources: totalSources ?? this.totalSources,
    );
  }
}

typedef ScanProgressCallback = void Function(ScanProgress progress);

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
    ScanProgressCallback? onProgress,
    ScanSignal? signal,
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
    final scanTime = indexedAt ?? DateTime.now().toUtc();
    final sourcesById = <String, Object>{};
    final photosById = <String, Object>{};
    var wroteSourceBatches = false;
    var wrotePhotoBatches = false;
    var indexedPhotos = 0;
    var updatedPhotos = 0;
    var ignoredPhotos = 0;
    var progress = const ScanProgress.empty();

    Future<void> handleBatch(LibraryBatch batch) async {
      if (batch.isEmpty) {
        return;
      }

      signal?.throwIfStopped();

      if (batch.sources.isNotEmpty) {
        try {
          await _sourceRepository.upsertSources(batch.sources);
        } catch (error) {
          throw _ScanWriteFailure(
            FailureInfo(
              kind: FailureKind.storage,
              code: 'media_sources.write_failed',
              safeMessage: 'Media sources could not be updated.',
              retryable: true,
              diagnostics: {'error_type': error.runtimeType.toString()},
            ),
          );
        }

        wroteSourceBatches = true;
        for (final source in batch.sources) {
          sourcesById[source.id] = source;
        }
        progress = progress.copyWith(sourceCount: sourcesById.length);
        onProgress?.call(progress);
      }

      if (batch.photos.isEmpty) {
        return;
      }

      wrotePhotoBatches = true;
      for (final photo in batch.photos) {
        photosById[photo.id] = photo;
      }
      progress = progress.copyWith(foundPhotos: photosById.length);
      onProgress?.call(progress);

      final baseIndexed = indexedPhotos;
      final baseUpdated = updatedPhotos;
      final indexResult = await _indexPhotos(
        batch.photos,
        scope: scope,
        indexedAt: scanTime,
        onProgress: (indexProgress) {
          progress = progress.copyWith(
            indexedPhotos: baseIndexed + indexProgress.indexedPhotos,
            updatedPhotos: baseUpdated + indexProgress.updatedPhotos,
          );
          onProgress?.call(progress);
        },
      );

      switch (indexResult) {
        case OperationFailure<IndexResult>(failure: final failure):
          throw _ScanWriteFailure(failure);
        case OperationSuccess<IndexResult>(value: final value):
          indexedPhotos += value.indexedPhotos;
          updatedPhotos += value.updatedPhotos;
          ignoredPhotos += value.ignoredPhotos;
      }
    }

    try {
      signal?.throwIfStopped();
      onProgress?.call(progress);
      scan = await _libraryGateway.scanLibrary(
        pageSize: pageSize,
        onProgress: (scanProgress) {
          progress = progress.copyWith(
            foundPhotos: scanProgress.foundPhotos,
            sourceCount: scanProgress.sourceCount,
            scannedSources: scanProgress.scannedSources,
            totalSources: scanProgress.totalSources,
          );
          onProgress?.call(progress);
        },
        onBatch: handleBatch,
        signal: signal,
      );
    } on ScanStopped {
      return OperationFailure(
        kind: FailureKind.cancelled,
        code: 'media_scan.stopped',
        safeMessage: 'Photo scan stopped.',
        retryable: true,
      );
    } on _ScanWriteFailure catch (error) {
      return OperationFailure.fromInfo(error.failure);
    } catch (error) {
      return OperationFailure(
        kind: FailureKind.media,
        code: 'media_scan.failed',
        safeMessage: 'Photo library scan failed.',
        retryable: true,
        diagnostics: {'error_type': error.runtimeType.toString()},
      );
    }

    if (!wroteSourceBatches) {
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
    }

    if (wrotePhotoBatches) {
      return OperationSuccess(
        LibraryScanResult(
          scan: scan,
          index: IndexResult(
            seenPhotos: scan.photos.length,
            indexedPhotos: indexedPhotos,
            updatedPhotos: updatedPhotos,
            ignoredPhotos: ignoredPhotos,
          ),
        ),
      );
    }

    final indexResult = await _indexPhotos(
      scan.photos,
      scope: scope,
      indexedAt: scanTime,
      onProgress: (indexProgress) {
        progress = progress.copyWith(
          indexedPhotos: indexProgress.indexedPhotos,
          updatedPhotos: indexProgress.updatedPhotos,
        );
        onProgress?.call(progress);
      },
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

class _ScanWriteFailure implements Exception {
  const _ScanWriteFailure(this.failure);

  final FailureInfo failure;
}
