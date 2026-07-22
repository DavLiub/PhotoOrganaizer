import 'package:flutter_test/flutter_test.dart';
import 'package:photo_organizer/application/observability/safe_attributes.dart';
import 'package:photo_organizer/domain/value_objects/operation_result.dart';

void main() {
  group('safeAttributes', () {
    test('keeps safe scalar diagnostics', () {
      final attributes = safeAttributes({
        'photo_count': 12,
        'retryable': true,
        'failure_kind': FailureKind.network,
        'started_at': DateTime.utc(2026, 7, 22),
      });

      expect(attributes['photo_count'], 12);
      expect(attributes['retryable'], isTrue);
      expect(attributes['failure_kind'], FailureKind.network);
      expect(attributes['started_at'], DateTime.utc(2026, 7, 22));
    });

    test('drops sensitive keys', () {
      final attributes = safeAttributes({
        'photo_path': r'C:\Users\David\Pictures\IMG_001.jpg',
        'email': 'user@example.com',
        'access_token': 'token',
        'private_key': 'key',
        'cloudObjectId': 'drive-object',
        'exif_location': 'geo',
        'photo_count': 1,
      });

      expect(attributes, {'photo_count': 1});
    });

    test('drops sensitive string values', () {
      final attributes = safeAttributes({
        'detail': r'C:\Users\David\Pictures\IMG_001.jpg',
        'message': 'client_secret was rejected',
        'owner': 'user@example.com',
        'safe_code': 'network.timeout',
      });

      expect(attributes, {'safe_code': 'network.timeout'});
    });

    test('drops unsupported object values', () {
      final attributes = safeAttributes({'raw_error': Object()});

      expect(attributes, isEmpty);
    });
  });
}
