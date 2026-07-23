import 'package:flutter_test/flutter_test.dart';
import 'package:photo_organizer/domain/value_objects/media_permission.dart';
import 'package:photo_organizer/domain/value_objects/operation_result.dart';
import 'package:photo_organizer/infrastructure/media/android_media_access.dart';

void main() {
  group('AndroidMediaAccess', () {
    test(
      'reports unavailable status until real adapter is implemented',
      () async {
        const gateway = AndroidMediaAccess();

        final result = await gateway.currentStatus();

        expect(result, isA<OperationSuccess<MediaPermission>>());
        final permission = (result as OperationSuccess<MediaPermission>).value;
        expect(permission.state, MediaPermissionState.unavailable);
        expect(permission.canAskAgain, isFalse);
        expect(permission.detailCode, 'media.permission_adapter_deferred');
      },
    );

    test('returns unavailable from request flow', () async {
      const gateway = AndroidMediaAccess();

      final result = await gateway.requestAccess();

      expect(result, isA<OperationSuccess<MediaPermission>>());
      final permission = (result as OperationSuccess<MediaPermission>).value;
      expect(permission.state, MediaPermissionState.unavailable);
    });
  });
}
