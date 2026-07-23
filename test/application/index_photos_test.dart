import 'package:flutter_test/flutter_test.dart';
import 'package:photo_organizer/application/ports/media_permission_gateway.dart';
import 'package:photo_organizer/application/ports/photo_index_repository.dart';
import 'package:photo_organizer/application/use_cases/index_photos.dart';
import 'package:photo_organizer/application/use_cases/resolve_photo_identity.dart';
import 'package:photo_organizer/domain/entities/photo_asset.dart';
import 'package:photo_organizer/domain/entities/photo_index_entry.dart';
import 'package:photo_organizer/domain/models/protection_summary.dart';
import 'package:photo_organizer/domain/value_objects/index_scope.dart';
import 'package:photo_organizer/domain/value_objects/media_permission.dart';
import 'package:photo_organizer/domain/value_objects/operation_result.dart';
import 'package:photo_organizer/domain/value_objects/photo_identity.dart';

void main() {
  group('IndexPhotos', () {
    test('returns permission failure when media access is denied', () async {
      final repository = _FakeIndex();
      final useCase = IndexPhotos(
        repository: repository,
        permissionGateway: _FakePermission(
          const MediaPermission(state: MediaPermissionState.denied),
        ),
      );

      final result = await useCase([_asset(id: 'asset-1')]);

      expect(result, isA<OperationFailure<IndexResult>>());
      final failure = result as OperationFailure<IndexResult>;
      expect(failure.kind, FailureKind.permission);
      expect(failure.userActionRequired, isTrue);
      expect(repository.entries, isEmpty);
    });

    test('indexes scoped photos and ignores excluded sources', () async {
      final now = DateTime.utc(2026, 7, 23);
      final repository = _FakeIndex();
      final useCase = _buildUseCase(repository);

      final result = await useCase(
        [
          _asset(id: 'camera', sourceName: 'Camera'),
          _asset(id: 'social', sourceName: 'WhatsApp'),
        ],
        scope: const IndexScope.allPhotos(excludedSourceNames: {'whatsapp'}),
        indexedAt: now,
      );

      expect(result, isA<OperationSuccess<IndexResult>>());
      final value = (result as OperationSuccess<IndexResult>).value;
      expect(value.seenPhotos, 2);
      expect(value.indexedPhotos, 1);
      expect(value.updatedPhotos, 0);
      expect(value.ignoredPhotos, 1);
      expect(repository.entries, hasLength(1));
      expect(repository.entries.single.asset.id, 'camera');
      expect(repository.entries.single.indexedAt, now);
    });

    test('is idempotent for repeated scan results', () async {
      final repository = _FakeIndex();
      final useCase = _buildUseCase(repository);
      final asset = _asset(id: 'asset-1');

      await useCase([asset], indexedAt: DateTime.utc(2026, 7, 23));
      final result = await useCase([
        asset,
      ], indexedAt: DateTime.utc(2026, 7, 24));

      expect(result, isA<OperationSuccess<IndexResult>>());
      final value = (result as OperationSuccess<IndexResult>).value;
      expect(value.indexedPhotos, 0);
      expect(value.updatedPhotos, 1);
      expect(repository.entries, hasLength(1));
    });

    test('deduplicates repeated assets in the same scan', () async {
      final repository = _FakeIndex();
      final useCase = _buildUseCase(repository);
      final asset = _asset(id: 'asset-1');

      final result = await useCase([asset, asset]);

      expect(result, isA<OperationSuccess<IndexResult>>());
      final value = (result as OperationSuccess<IndexResult>).value;
      expect(value.seenPhotos, 2);
      expect(value.indexedPhotos, 1);
      expect(value.writtenPhotos, 1);
      expect(repository.entries, hasLength(1));
    });

    test('updates identity for changed asset metadata by asset id', () async {
      final repository = _FakeIndex();
      final useCase = _buildUseCase(repository);
      final original = _asset(id: 'asset-1', fileSize: 100);
      final changed = _asset(id: 'asset-1', fileSize: 200);

      await useCase([original], indexedAt: DateTime.utc(2026, 7, 23));
      repository.entries[0] = repository.entries.single.withStatus(
        PhotoIndexStatus.protected,
      );
      await useCase([changed], indexedAt: DateTime.utc(2026, 7, 24));

      expect(repository.entries, hasLength(1));
      expect(repository.entries.single.identity, changed.identity);
      expect(repository.entries.single.status, PhotoIndexStatus.protected);
    });

    test('returns storage failure when repository write fails', () async {
      final repository = _FakeIndex(failWrites: true);
      final useCase = _buildUseCase(repository);

      final result = await useCase([_asset(id: 'asset-1')]);

      expect(result, isA<OperationFailure<IndexResult>>());
      final failure = result as OperationFailure<IndexResult>;
      expect(failure.kind, FailureKind.storage);
      expect(failure.retryable, isTrue);
    });
  });

  group('ResolvePhotoIdentity', () {
    test('returns matching indexed photo', () async {
      final repository = _FakeIndex();
      final entry = PhotoIndexEntry.fromAsset(
        _asset(id: 'asset-1'),
        indexedAt: DateTime.utc(2026, 7, 23),
      );
      await repository.upsertEntries([entry]);
      final useCase = ResolvePhotoIdentity(repository);

      final result = await useCase(entry.identity);

      expect(result, isA<OperationSuccess<PhotoIndexEntry?>>());
      expect((result as OperationSuccess<PhotoIndexEntry?>).value, same(entry));
    });
  });
}

IndexPhotos _buildUseCase(_FakeIndex repository) {
  return IndexPhotos(
    repository: repository,
    permissionGateway: _FakePermission(
      const MediaPermission(state: MediaPermissionState.granted),
    ),
  );
}

PhotoAsset _asset({
  required String id,
  int fileSize = 100,
  String sourceName = 'Camera',
}) {
  final createdAt = DateTime.utc(2026, 7, 1);
  final modifiedAt = DateTime.utc(2026, 7, 2).add(Duration(seconds: fileSize));

  return PhotoAsset(
    id: id,
    sourceUri: 'content://media/$id',
    sourceProvider: 'media_store',
    sourceName: sourceName,
    albumId: sourceName.toLowerCase(),
    filename: '$id.jpg',
    mimeType: 'image/jpeg',
    fileSize: fileSize,
    createdAt: createdAt,
    modifiedAt: modifiedAt,
    discoveredAt: createdAt,
    lastSeenAt: modifiedAt,
    availabilityStatus: PhotoAvailabilityStatus.available,
  );
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

class _FakeIndex implements PhotoIndexRepository {
  _FakeIndex({this.failWrites = false});

  final bool failWrites;
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
    if (failWrites) {
      throw StateError('write failed');
    }

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
