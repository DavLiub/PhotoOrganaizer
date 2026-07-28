@Tags(<String>['ci-gate', 'pr-gate', 'night'])
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:photo_organizer/infrastructure/media/unsupported_thumbnail_gateway.dart';

void main() {
  group('UnsupportedThumbnailGateway', () {
    test('returns null thumbnail data', () async {
      const gateway = UnsupportedThumbnailGateway();

      final result = await gateway.loadThumbnail('asset-1');

      expect(result, isNull);
    });
  });
}
