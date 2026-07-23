import 'package:flutter_test/flutter_test.dart';
import 'package:photo_organizer/domain/entities/photo_asset.dart';
import 'package:photo_organizer/domain/value_objects/photo_identity.dart';

void main() {
  group('PhotoIdentity', () {
    test('uses asset id, size, creation time, and modification time', () {
      final createdAt = DateTime.utc(2026, 7, 1);
      final modifiedAt = DateTime.utc(2026, 7, 2);
      final identity = PhotoIdentity(
        assetId: 'asset-1',
        fileSize: 100,
        createdAt: createdAt,
        modifiedAt: modifiedAt,
      );

      expect(identity.assetId, 'asset-1');
      expect(identity.fileSize, 100);
      expect(identity.createdAt, createdAt);
      expect(identity.modifiedAt, modifiedAt);
      expect(identity.key, contains('asset-1'));
    });

    test('changes when file size changes', () {
      final createdAt = DateTime.utc(2026, 7, 1);
      final modifiedAt = DateTime.utc(2026, 7, 2);
      final original = PhotoIdentity(
        assetId: 'asset-1',
        fileSize: 100,
        createdAt: createdAt,
        modifiedAt: modifiedAt,
      );
      final changed = PhotoIdentity(
        assetId: 'asset-1',
        fileSize: 200,
        createdAt: createdAt,
        modifiedAt: modifiedAt,
      );

      expect(original, isNot(changed));
      expect(original.key, isNot(changed.key));
    });

    test('can be derived from photo asset metadata', () {
      final createdAt = DateTime.utc(2026, 7, 1);
      final modifiedAt = DateTime.utc(2026, 7, 2);
      final asset = _asset(
        id: 'asset-1',
        fileSize: 100,
        createdAt: createdAt,
        modifiedAt: modifiedAt,
      );

      expect(
        asset.identity,
        PhotoIdentity(
          assetId: 'asset-1',
          fileSize: 100,
          createdAt: createdAt,
          modifiedAt: modifiedAt,
        ),
      );
    });
  });
}

PhotoAsset _asset({
  required String id,
  required int fileSize,
  required DateTime createdAt,
  required DateTime modifiedAt,
}) {
  return PhotoAsset(
    id: id,
    sourceUri: 'content://media/$id',
    sourceProvider: 'camera',
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
