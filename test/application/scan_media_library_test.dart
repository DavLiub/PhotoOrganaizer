import 'package:flutter_test/flutter_test.dart';
import 'package:photo_organizer/application/ports/media_library_gateway.dart';
import 'package:photo_organizer/application/ports/media_permission_gateway.dart';
import 'package:photo_organizer/application/ports/media_source_repository.dart';
import 'package:photo_organizer/application/ports/photo_index_repository.dart';
import 'package:photo_organizer/application/use_cases/index_photos.dart';
import 'package:photo_organizer/application/use_cases/scan_media_library.dart';
import 'package:photo_organizer/domain/entities/media_source.dart';
import 'package:photo_organizer/domain/entities/photo_asset.dart';
import 'package:photo_organizer/domain/entities/photo_index_entry.dart';
import 'package:photo_organizer/domain/models/protection_summary.dart';
import 'package:photo_organizer/domain/value_objects/media_permission.dart';
import 'package:photo_organizer/domain/value_objects/operation_result.dart';
import 'package:photo_organizer/domain/value_objects/photo_identity.dart';
import 'package:photo_organizer/infrastructure/media/photo_manager_mapper.dart';

void main() {
  group('ScanMediaLibrary', () {
    test('persists sources and indexes scanned photos', () async {
      final source = _source(id: 'photo_manager:camera');
      final photo = _asset(id: 'asset-1', sourceId: source.id);
      final library = _FakeLibrary(
        LibraryScan(sources: [source], photos: [photo]),
      );
      final sourceRepository = _FakeSources();
      final indexRepository = _FakeIndex();
      final useCase = _useCase(
        library: library,
        sourceRepository: sourceRepository,
        indexRepository: indexRepository,
      );

      final result = await useCase(
        indexedAt: DateTime.utc(2026, 7, 24),
        pageSize: 100,
      );

      expect(result, isA<OperationSuccess<LibraryScanResult>>());
      final value = (result as OperationSuccess<LibraryScanResult>).value;
      expect(value.scan.sources, [source]);
      expect(value.index.indexedPhotos, 1);
      expect(library.pageSize, 100);
      expect(sourceRepository.sources, [source]);
      expect(indexRepository.entries, hasLength(1));
      expect(indexRepository.entries.single.asset.id, 'asset-1');
    });

    test('does not scan when permission is denied', () async {
      final library = _FakeLibrary(const LibraryScan.empty());
      final useCase = _useCase(
        library: library,
        permission: const MediaPermission(state: MediaPermissionState.denied),
      );

      final result = await useCase();

      expect(result, isA<OperationFailure<LibraryScanResult>>());
      expect(library.calls, 0);
    });

    test('returns storage failure when sources cannot be written', () async {
      final source = _source(id: 'photo_manager:camera');
      final library = _FakeLibrary(LibraryScan(sources: [source], photos: []));
      final sourceRepository = _FakeSources(failWrites: true);
      final indexRepository = _FakeIndex();
      final useCase = _useCase(
        library: library,
        sourceRepository: sourceRepository,
        indexRepository: indexRepository,
      );

      final result = await useCase();

      expect(result, isA<OperationFailure<LibraryScanResult>>());
      final failure = result as OperationFailure<LibraryScanResult>;
      expect(failure.kind, FailureKind.storage);
      expect(indexRepository.entries, isEmpty);
    });

    test('rejects invalid page size', () async {
      final useCase = _useCase(
        library: _FakeLibrary(const LibraryScan.empty()),
      );

      final result = await useCase(pageSize: 0);

      expect(result, isA<OperationFailure<LibraryScanResult>>());
      expect(
        (result as OperationFailure<LibraryScanResult>).kind,
        FailureKind.validation,
      );
    });
  });
}

ScanMediaLibrary _useCase({
  required MediaLibraryGateway library,
  MediaPermission permission = const MediaPermission(
    state: MediaPermissionState.granted,
  ),
  MediaSourceRepository? sourceRepository,
  PhotoIndexRepository? indexRepository,
}) {
  final permissionGateway = _FakePermission(permission);
  final photoIndex = indexRepository ?? _FakeIndex();

  return ScanMediaLibrary(
    libraryGateway: library,
    permissionGateway: permissionGateway,
    sourceRepository: sourceRepository ?? _FakeSources(),
    indexPhotos: IndexPhotos(
      repository: photoIndex,
      permissionGateway: permissionGateway,
    ),
  );
}

class _FakeLibrary implements MediaLibraryGateway {
  _FakeLibrary(this.scan);

  final LibraryScan scan;
  int calls = 0;
  int? pageSize;

  @override
  Future<LibraryScan> scanLibrary({int pageSize = 100}) async {
    calls++;
    this.pageSize = pageSize;
    return scan;
  }
}

class _FakePermission implements MediaPermissionGateway {
  const _FakePermission(this.permission);

  final MediaPermission permission;

  @override
  Future<OperationResult<MediaPermission>> currentStatus() async {
    return OperationSuccess(permission);
  }

  @override
  Future<OperationResult<MediaPermission>> requestAccess() async {
    return OperationSuccess(permission);
  }
}

class _FakeSources implements MediaSourceRepository {
  _FakeSources({this.failWrites = false});

  final bool failWrites;
  final sources = <MediaSource>[];

  @override
  Future<List<MediaSource>> findAll() async {
    return sources;
  }

  @override
  Future<MediaSource?> findById(String id) async {
    for (final source in sources) {
      if (source.id == id) {
        return source;
      }
    }

    return null;
  }

  @override
  Future<void> upsertSources(List<MediaSource> nextSources) async {
    if (failWrites) {
      throw StateError('write failed');
    }

    sources
      ..clear()
      ..addAll(nextSources);
  }

  @override
  Stream<List<MediaSource>> watchSources() {
    return Stream.value(sources);
  }
}

class _FakeIndex implements PhotoIndexRepository {
  final entries = <PhotoIndexEntry>[];

  @override
  Future<List<PhotoIndexEntry>> findByAssetIds(Set<String> assetIds) async {
    return entries
        .where((entry) => assetIds.contains(entry.asset.id))
        .toList(growable: false);
  }

  @override
  Future<PhotoIndexEntry?> findByIdentity(PhotoIdentity identity) async {
    for (final entry in entries) {
      if (entry.identity == identity) {
        return entry;
      }
    }

    return null;
  }

  @override
  Future<void> upsertEntries(List<PhotoIndexEntry> nextEntries) async {
    for (final entry in nextEntries) {
      final index = entries.indexWhere((current) => current.id == entry.id);
      if (index == -1) {
        entries.add(entry);
      } else {
        entries[index] = entry;
      }
    }
  }

  @override
  Stream<ProtectionSummary> watchProtectionSummary() {
    return Stream.value(ProtectionSummary.fromIndex(entries));
  }
}

MediaSource _source({required String id}) {
  return MediaSource(
    id: id,
    provider: photoManagerProvider,
    name: 'Camera',
    pathHint: 'DCIM/Camera',
    assetCount: 1,
    lastSeenAt: DateTime.utc(2026, 7, 24),
    availabilityStatus: MediaSourceStatus.available,
    cameraLike: true,
  );
}

PhotoAsset _asset({required String id, required String sourceId}) {
  final now = DateTime.utc(2026, 7, 24);

  return PhotoAsset(
    id: id,
    sourceUri: 'photo-manager://asset/$id',
    sourceProvider: photoManagerProvider,
    sourceId: sourceId,
    albumId: 'camera',
    sourceName: 'Camera',
    filename: '$id.jpg',
    mimeType: 'image/jpeg',
    fileSize: 100,
    createdAt: now,
    modifiedAt: now,
    discoveredAt: now,
    lastSeenAt: now,
    availabilityStatus: PhotoAvailabilityStatus.available,
  );
}
