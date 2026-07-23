import 'package:flutter_test/flutter_test.dart';
import 'package:photo_organizer/domain/entities/photo_asset.dart';
import 'package:photo_organizer/domain/value_objects/index_scope.dart';

void main() {
  group('IndexScope', () {
    test('allows all non-excluded photos by default', () {
      const scope = IndexScope.allPhotos();

      expect(scope.allows(_asset(sourceName: 'WhatsApp')), isTrue);
    });

    test('excludes configured albums and source names', () {
      const scope = IndexScope.allPhotos(
        excludedAlbumIds: {'social'},
        excludedSourceNames: {'whatsapp'},
      );

      expect(scope.allows(_asset(albumId: 'social')), isFalse);
      expect(scope.allows(_asset(sourceName: 'WhatsApp')), isFalse);
      expect(scope.allows(_asset(albumId: 'camera')), isTrue);
    });

    test('camera only accepts camera sources and excludes screenshots', () {
      const scope = IndexScope.cameraOnly();

      expect(scope.allows(_asset(sourceName: 'Camera')), isTrue);
      expect(scope.allows(_asset(sourceProvider: 'DCIM')), isTrue);
      expect(scope.allows(_asset(sourceName: 'Screenshots')), isFalse);
      expect(scope.allows(_asset(sourceName: 'Downloads')), isFalse);
    });

    test('custom albums require included album id', () {
      const scope = IndexScope.customAlbums(includedAlbumIds: {'camera'});

      expect(scope.allows(_asset(albumId: 'camera')), isTrue);
      expect(scope.allows(_asset(albumId: 'downloads')), isFalse);
      expect(scope.allows(_asset()), isFalse);
    });
  });
}

PhotoAsset _asset({
  String id = 'asset-1',
  String sourceProvider = 'media_store',
  String? sourceName,
  String? albumId,
}) {
  final now = DateTime.utc(2026, 7, 1);

  return PhotoAsset(
    id: id,
    sourceUri: 'content://media/$id',
    sourceProvider: sourceProvider,
    sourceName: sourceName,
    albumId: albumId,
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
