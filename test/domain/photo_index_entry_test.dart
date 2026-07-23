import 'package:flutter_test/flutter_test.dart';
import 'package:photo_organizer/domain/entities/photo_asset.dart';
import 'package:photo_organizer/domain/entities/photo_index_entry.dart';
import 'package:photo_organizer/domain/models/protection_summary.dart';

void main() {
  group('PhotoIndexEntry', () {
    test('creates index entry from local asset', () {
      final now = DateTime.utc(2026, 7, 1);
      final asset = _asset(id: 'asset-1', fileSize: 100);

      final entry = PhotoIndexEntry.fromAsset(asset, indexedAt: now);

      expect(entry.id, asset.identity.key);
      expect(entry.identity, asset.identity);
      expect(entry.asset, asset);
      expect(entry.status, PhotoIndexStatus.indexed);
      expect(entry.indexedAt, now);
      expect(entry.updatedAt, now);
    });

    test('refresh keeps stable index id and status', () {
      final indexedAt = DateTime.utc(2026, 7, 1);
      final updatedAt = DateTime.utc(2026, 7, 2);
      final original = PhotoIndexEntry.fromAsset(
        _asset(id: 'asset-1', fileSize: 100),
        indexedAt: indexedAt,
        status: PhotoIndexStatus.protected,
      );
      final changedAsset = _asset(id: 'asset-1', fileSize: 200);

      final refreshed = original.refresh(changedAsset, updatedAt: updatedAt);

      expect(refreshed.id, original.id);
      expect(refreshed.status, PhotoIndexStatus.protected);
      expect(refreshed.indexedAt, indexedAt);
      expect(refreshed.updatedAt, updatedAt);
      expect(refreshed.identity, changedAsset.identity);
    });
  });

  group('ProtectionSummary', () {
    test('aggregates visible index statuses', () {
      final now = DateTime.utc(2026, 7, 1);
      final entries = [
        PhotoIndexEntry.fromAsset(
          _asset(id: 'indexed'),
          indexedAt: now,
          status: PhotoIndexStatus.indexed,
        ),
        PhotoIndexEntry.fromAsset(
          _asset(id: 'pending'),
          indexedAt: now,
          status: PhotoIndexStatus.pendingBackup,
        ),
        PhotoIndexEntry.fromAsset(
          _asset(id: 'protected'),
          indexedAt: now,
          status: PhotoIndexStatus.protected,
        ),
        PhotoIndexEntry.fromAsset(
          _asset(id: 'failed'),
          indexedAt: now,
          status: PhotoIndexStatus.failed,
        ),
        PhotoIndexEntry.fromAsset(
          _asset(id: 'ignored'),
          indexedAt: now,
          status: PhotoIndexStatus.ignored,
        ),
      ];

      final summary = ProtectionSummary.fromIndex(entries);

      expect(summary.totalPhotos, 4);
      expect(summary.pendingPhotos, 2);
      expect(summary.protectedPhotos, 1);
      expect(summary.failedPhotos, 1);
    });
  });
}

PhotoAsset _asset({required String id, int fileSize = 100}) {
  final now = DateTime.utc(2026, 7, 1);

  return PhotoAsset(
    id: id,
    sourceUri: 'content://media/$id',
    sourceProvider: 'camera',
    filename: '$id.jpg',
    mimeType: 'image/jpeg',
    fileSize: fileSize,
    createdAt: now,
    modifiedAt: now.add(Duration(seconds: fileSize)),
    discoveredAt: now,
    lastSeenAt: now,
    availabilityStatus: PhotoAvailabilityStatus.available,
  );
}
