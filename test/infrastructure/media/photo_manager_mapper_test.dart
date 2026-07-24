import 'package:flutter_test/flutter_test.dart';
import 'package:photo_organizer/domain/entities/photo_asset.dart';
import 'package:photo_organizer/infrastructure/media/photo_manager_mapper.dart';

void main() {
  group('photo_manager mapper', () {
    test('maps album metadata to media source', () {
      final source = mapSource(
        SourceMeta(
          albumId: 'camera-id',
          name: 'Camera',
          pathHint: 'DCIM/Camera',
          assetCount: 12,
          lastSeenAt: DateTime.utc(2026, 7, 24),
        ),
      );

      expect(source.id, 'photo_manager:camera-id');
      expect(source.provider, photoManagerProvider);
      expect(source.name, 'Camera');
      expect(source.pathHint, 'DCIM/Camera');
      expect(source.assetCount, 12);
      expect(source.cameraLike, isTrue);
      expect(source.systemLike, isFalse);
    });

    test('marks screenshot-like source as system source', () {
      final source = mapSource(
        SourceMeta(
          albumId: 'screenshots',
          name: 'Screenshots',
          assetCount: 3,
          lastSeenAt: DateTime.utc(2026, 7, 24),
        ),
      );

      expect(source.cameraLike, isFalse);
      expect(source.systemLike, isTrue);
    });

    test('maps asset metadata to project photo asset', () {
      final createdAt = DateTime.utc(2026, 7, 1);
      final modifiedAt = DateTime.utc(2026, 7, 2);
      final discoveredAt = DateTime.utc(2026, 7, 24);

      final asset = mapAsset(
        AssetMeta(
          assetId: 'asset-1',
          albumId: 'camera-id',
          albumName: 'Camera',
          filename: 'IMG_0001.HEIC',
          fileSize: 2048,
          createdAt: createdAt,
          modifiedAt: modifiedAt,
          discoveredAt: discoveredAt,
          width: 4000,
          height: 3000,
        ),
      );

      expect(asset.id, 'asset-1');
      expect(asset.sourceProvider, photoManagerProvider);
      expect(asset.sourceUri, 'photo-manager://asset/asset-1');
      expect(asset.sourceId, 'photo_manager:camera-id');
      expect(asset.albumId, 'camera-id');
      expect(asset.sourceName, 'Camera');
      expect(asset.filename, 'IMG_0001.HEIC');
      expect(asset.mimeType, 'image/heic');
      expect(asset.fileSize, 2048);
      expect(asset.createdAt, createdAt);
      expect(asset.modifiedAt, modifiedAt);
      expect(asset.discoveredAt, discoveredAt);
      expect(asset.lastSeenAt, discoveredAt);
      expect(asset.availabilityStatus, PhotoAvailabilityStatus.available);
      expect(asset.width, 4000);
      expect(asset.height, 3000);
      expect(asset.identity.assetId, 'asset-1');
      expect(asset.identity.fileSize, 2048);
    });
  });
}
