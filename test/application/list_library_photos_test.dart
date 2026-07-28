@Tags(<String>['ci-gate', 'pr-gate', 'night'])
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:photo_organizer/application/models/photo_library.dart';
import 'package:photo_organizer/application/ports/media_source_repository.dart';
import 'package:photo_organizer/application/ports/photo_index_repository.dart';
import 'package:photo_organizer/application/use_cases/list_library_photos.dart';
import 'package:photo_organizer/domain/entities/media_source.dart';
import 'package:photo_organizer/domain/entities/photo_asset.dart';
import 'package:photo_organizer/domain/entities/photo_index_entry.dart';
import 'package:photo_organizer/domain/models/protection_summary.dart';
import 'package:photo_organizer/domain/value_objects/operation_result.dart';
import 'package:photo_organizer/domain/value_objects/photo_identity.dart';

void main() {
  group('ListLibraryPhotos', () {
    test('maps indexed photos to library read model', () async {
      final sources = _FakeSources([
        _source(id: 'source-camera', name: 'Camera', cameraLike: true),
        _source(id: 'source-social', name: 'WhatsApp Images'),
        _source(id: 'source-downloads', name: 'Download'),
        _source(id: 'source-screenshots', name: 'Screenshots'),
      ]);
      final photos = _FakePhotos([
        _entry(id: 'camera', sourceId: 'source-camera'),
        _entry(id: 'social', sourceId: 'source-social'),
        _entry(id: 'downloads', sourceId: 'source-downloads'),
        _entry(id: 'screenshots', sourceId: 'source-screenshots'),
      ]);
      final useCase = ListLibraryPhotos(
        photoIndexRepository: photos,
        mediaSourceRepository: sources,
      );

      final result = await useCase();

      expect(result, isA<OperationSuccess<PhotoLibrary>>());
      final library = (result as OperationSuccess<PhotoLibrary>).value;
      expect(library.photos.map((photo) => photo.category), [
        LibraryCategory.camera,
        LibraryCategory.social,
        LibraryCategory.downloads,
        LibraryCategory.screenshots,
      ]);
      expect(library.photos.map((photo) => photo.backupStatus).toSet(), {
        LibraryBackupStatus.noBackup,
      });
      expect(library.categories.map((summary) => summary.count), [1, 1, 1, 1]);
    });

    test('returns storage failure when repository read fails', () async {
      final useCase = ListLibraryPhotos(
        photoIndexRepository: _FakePhotos(const [], failRead: true),
        mediaSourceRepository: _FakeSources(const []),
      );

      final result = await useCase();

      expect(result, isA<OperationFailure<PhotoLibrary>>());
      expect(
        (result as OperationFailure<PhotoLibrary>).kind,
        FailureKind.storage,
      );
    });
  });
}

class _FakePhotos implements PhotoIndexRepository {
  const _FakePhotos(this.entries, {this.failRead = false});

  final List<PhotoIndexEntry> entries;
  final bool failRead;

  @override
  Future<List<PhotoIndexEntry>> findAll() async {
    if (failRead) {
      throw StateError('read failed');
    }

    return entries;
  }

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
  Future<void> upsertEntries(List<PhotoIndexEntry> entries) async {}

  @override
  Stream<ProtectionSummary> watchProtectionSummary() {
    return Stream.value(ProtectionSummary.fromIndex(entries));
  }
}

class _FakeSources implements MediaSourceRepository {
  const _FakeSources(this.sources);

  final List<MediaSource> sources;

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
  Future<void> upsertSources(List<MediaSource> sources) async {}

  @override
  Stream<List<MediaSource>> watchSources() {
    return Stream.value(sources);
  }
}

MediaSource _source({
  required String id,
  required String name,
  bool cameraLike = false,
}) {
  return MediaSource(
    id: id,
    provider: 'photo_manager',
    name: name,
    assetCount: 1,
    lastSeenAt: DateTime.utc(2026, 7, 27),
    availabilityStatus: MediaSourceStatus.available,
    cameraLike: cameraLike,
  );
}

PhotoIndexEntry _entry({required String id, required String sourceId}) {
  final now = DateTime.utc(2026, 7, 27);

  return PhotoIndexEntry.fromAsset(
    PhotoAsset(
      id: id,
      sourceUri: 'photo-manager://asset/$id',
      sourceProvider: 'photo_manager',
      sourceId: sourceId,
      sourceName: sourceId,
      albumId: sourceId,
      filename: '$id.jpg',
      mimeType: 'image/jpeg',
      fileSize: 100,
      createdAt: now,
      modifiedAt: now,
      discoveredAt: now,
      lastSeenAt: now,
      availabilityStatus: PhotoAvailabilityStatus.available,
      width: 100,
      height: 100,
    ),
    indexedAt: now,
  );
}
