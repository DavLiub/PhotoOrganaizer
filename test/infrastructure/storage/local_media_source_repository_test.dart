import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:photo_organizer/domain/entities/media_source.dart';
import 'package:photo_organizer/infrastructure/storage/app_database.dart';
import 'package:photo_organizer/infrastructure/storage/local_media_source_repository.dart';

void main() {
  group('LocalMediaSourceRepository', () {
    late AppDatabase database;
    late LocalMediaSourceRepository repository;

    setUp(() {
      database = AppDatabase(NativeDatabase.memory());
      repository = LocalMediaSourceRepository(database: database);
    });

    tearDown(() async {
      await database.close();
    });

    test('upserts and finds source by id', () async {
      final source = _source(id: 'media-store:camera');

      await repository.upsertSources([source]);

      final result = await repository.findById(source.id);

      expect(result, isNotNull);
      expect(result!.id, source.id);
      expect(result.provider, 'media_store');
      expect(result.name, 'Camera');
      expect(result.pathHint, 'DCIM/Camera');
      expect(result.assetCount, 42);
      expect(result.lastSeenAt, source.lastSeenAt);
      expect(result.cameraLike, isTrue);
      expect(result.systemLike, isFalse);
    });

    test('returns all persisted sources', () async {
      await repository.upsertSources([
        _source(id: 'media-store:camera', name: 'Camera'),
        _source(id: 'media-store:screenshots', name: 'Screenshots'),
      ]);

      final result = await repository.findAll();

      expect(result.map((source) => source.id), {
        'media-store:camera',
        'media-store:screenshots',
      });
    });

    test('updates existing source by id', () async {
      final source = _source(id: 'media-store:camera', assetCount: 10);
      final refreshed = source.refresh(
        assetCount: 12,
        lastSeenAt: DateTime.utc(2026, 7, 24),
      );

      await repository.upsertSources([source]);
      await repository.upsertSources([refreshed]);

      final result = await repository.findById(source.id);

      expect(result, isNotNull);
      expect(result!.assetCount, 12);
      expect(result.lastSeenAt, DateTime.utc(2026, 7, 24));
    });

    test('streams persisted sources', () async {
      await repository.upsertSources([_source(id: 'media-store:camera')]);

      final sources = await repository.watchSources().first;

      expect(sources, hasLength(1));
      expect(sources.single.id, 'media-store:camera');
    });
  });
}

MediaSource _source({
  required String id,
  String name = 'Camera',
  int assetCount = 42,
}) {
  return MediaSource(
    id: id,
    provider: 'media_store',
    name: name,
    pathHint: 'DCIM/Camera',
    assetCount: assetCount,
    lastSeenAt: DateTime.utc(2026, 7, 23),
    availabilityStatus: MediaSourceStatus.available,
    cameraLike: name == 'Camera',
  );
}
