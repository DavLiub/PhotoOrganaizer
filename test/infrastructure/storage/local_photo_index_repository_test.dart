import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:photo_organizer/domain/entities/photo_asset.dart';
import 'package:photo_organizer/domain/entities/photo_index_entry.dart';
import 'package:photo_organizer/infrastructure/storage/app_database.dart';
import 'package:photo_organizer/infrastructure/storage/local_photo_index_repository.dart';

void main() {
  group('LocalPhotoIndexRepository', () {
    late AppDatabase database;
    late LocalPhotoIndexRepository repository;

    setUp(() {
      database = AppDatabase(NativeDatabase.memory());
      repository = LocalPhotoIndexRepository(database: database);
    });

    tearDown(() async {
      await database.close();
    });

    test('upserts and finds entries by asset ids', () async {
      final first = _entry(id: 'asset-1');
      final second = _entry(id: 'asset-2');

      await repository.upsertEntries([first, second]);

      final result = await repository.findByAssetIds({'asset-2'});

      expect(result, hasLength(1));
      expect(result.single.id, second.id);
      expect(result.single.asset.id, 'asset-2');
      expect(result.single.asset.sourceId, 'media-store:camera');
    });

    test('finds entry by photo identity', () async {
      final entry = _entry(id: 'asset-1');
      await repository.upsertEntries([entry]);

      final result = await repository.findByIdentity(entry.identity);

      expect(result, isNotNull);
      expect(result!.id, entry.id);
      expect(result.identity, entry.identity);
    });

    test('upsert refreshes existing entry by stable id', () async {
      final indexedAt = DateTime.utc(2026, 7, 23);
      final original = _entry(
        id: 'asset-1',
        fileSize: 100,
        indexedAt: indexedAt,
      );
      final changed = original.refresh(
        _asset(id: 'asset-1', fileSize: 200),
        updatedAt: DateTime.utc(2026, 7, 24),
      );

      await repository.upsertEntries([original]);
      await repository.upsertEntries([changed]);

      final result = await repository.findByAssetIds({'asset-1'});

      expect(result, hasLength(1));
      expect(result.single.id, original.id);
      expect(result.single.identity, changed.identity);
      expect(result.single.indexedAt, indexedAt);
      expect(result.single.updatedAt, DateTime.utc(2026, 7, 24));
    });

    test('returns empty list for empty asset lookup', () async {
      final result = await repository.findByAssetIds({});

      expect(result, isEmpty);
    });

    test('streams protection summary from stored entries', () async {
      await repository.upsertEntries([
        _entry(id: 'indexed', status: PhotoIndexStatus.indexed),
        _entry(id: 'pending', status: PhotoIndexStatus.pendingBackup),
        _entry(id: 'protected', status: PhotoIndexStatus.protected),
        _entry(id: 'failed', status: PhotoIndexStatus.failed),
        _entry(id: 'ignored', status: PhotoIndexStatus.ignored),
      ]);

      final summary = await repository.watchProtectionSummary().first;

      expect(summary.totalPhotos, 4);
      expect(summary.pendingPhotos, 2);
      expect(summary.protectedPhotos, 1);
      expect(summary.failedPhotos, 1);
    });
  });
}

PhotoIndexEntry _entry({
  required String id,
  int fileSize = 100,
  DateTime? indexedAt,
  PhotoIndexStatus status = PhotoIndexStatus.indexed,
}) {
  final timestamp = indexedAt ?? DateTime.utc(2026, 7, 23);

  return PhotoIndexEntry.fromAsset(
    _asset(id: id, fileSize: fileSize),
    indexedAt: timestamp,
    status: status,
  );
}

PhotoAsset _asset({required String id, required int fileSize}) {
  final createdAt = DateTime.utc(2026, 7, 1);
  final modifiedAt = DateTime.utc(2026, 7, 2).add(Duration(seconds: fileSize));

  return PhotoAsset(
    id: id,
    sourceUri: 'content://media/$id',
    sourceProvider: 'media_store',
    sourceId: 'media-store:camera',
    sourceName: 'Camera',
    albumId: 'camera',
    filename: '$id.jpg',
    mimeType: 'image/jpeg',
    fileSize: fileSize,
    createdAt: createdAt,
    modifiedAt: modifiedAt,
    discoveredAt: createdAt,
    lastSeenAt: modifiedAt,
    availabilityStatus: PhotoAvailabilityStatus.available,
    width: 4000,
    height: 3000,
  );
}
