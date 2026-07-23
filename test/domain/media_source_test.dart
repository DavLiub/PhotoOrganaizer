import 'package:flutter_test/flutter_test.dart';
import 'package:photo_organizer/domain/entities/media_source.dart';

void main() {
  group('MediaSource', () {
    test('can index available source with assets', () {
      final source = _source(assetCount: 10);

      expect(source.canIndex, isTrue);
    });

    test('does not index unavailable or empty source', () {
      expect(_source(assetCount: 0).canIndex, isFalse);
      expect(
        _source(
          assetCount: 10,
          availabilityStatus: MediaSourceStatus.inaccessible,
        ).canIndex,
        isFalse,
      );
    });

    test('refresh keeps identity and updates scan metadata', () {
      final source = _source(
        assetCount: 10,
        pathHint: 'DCIM/Camera',
        cameraLike: true,
      );
      final refreshedAt = DateTime.utc(2026, 7, 24);

      final refreshed = source.refresh(
        assetCount: 12,
        lastSeenAt: refreshedAt,
        name: 'Camera',
      );

      expect(refreshed.id, source.id);
      expect(refreshed.provider, source.provider);
      expect(refreshed.assetCount, 12);
      expect(refreshed.lastSeenAt, refreshedAt);
      expect(refreshed.pathHint, 'DCIM/Camera');
      expect(refreshed.cameraLike, isTrue);
    });
  });
}

MediaSource _source({
  int assetCount = 1,
  String? pathHint,
  bool cameraLike = false,
  MediaSourceStatus availabilityStatus = MediaSourceStatus.available,
}) {
  return MediaSource(
    id: 'media-store:camera',
    provider: 'media_store',
    name: 'Camera',
    pathHint: pathHint,
    assetCount: assetCount,
    lastSeenAt: DateTime.utc(2026, 7, 23),
    availabilityStatus: availabilityStatus,
    cameraLike: cameraLike,
  );
}
