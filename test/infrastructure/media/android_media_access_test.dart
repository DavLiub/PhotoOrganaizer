import 'package:flutter_test/flutter_test.dart';
import 'package:photo_manager/photo_manager.dart' as pm;
import 'package:photo_organizer/domain/value_objects/media_permission.dart';
import 'package:photo_organizer/domain/value_objects/operation_result.dart';
import 'package:photo_organizer/infrastructure/media/android_media_access.dart';

void main() {
  group('AndroidMediaAccess', () {
    test('maps authorized current status to granted permission', () async {
      final gateway = AndroidMediaAccess(
        readPermission: () async => pm.PermissionState.authorized,
      );

      final result = await gateway.currentStatus();

      expect(result, isA<OperationSuccess<MediaPermission>>());
      final permission = (result as OperationSuccess<MediaPermission>).value;
      expect(permission.state, MediaPermissionState.granted);
      expect(permission.canAskAgain, isFalse);
      expect(permission.detailCode, 'photo_manager.authorized');
    });

    test('maps limited request result to limited permission', () async {
      final gateway = AndroidMediaAccess(
        requestPermission: () async => pm.PermissionState.limited,
      );

      final result = await gateway.requestAccess();

      expect(result, isA<OperationSuccess<MediaPermission>>());
      final permission = (result as OperationSuccess<MediaPermission>).value;
      expect(permission.state, MediaPermissionState.limited);
      expect(permission.canReadPhotos, isTrue);
    });

    test('returns structured failure when plugin status read fails', () async {
      final gateway = AndroidMediaAccess(
        readPermission: () async => throw StateError('plugin failed'),
      );

      final result = await gateway.currentStatus();

      expect(result, isA<OperationFailure<MediaPermission>>());
      final failure = result as OperationFailure<MediaPermission>;
      expect(failure.kind, FailureKind.media);
      expect(failure.code, 'media.permission_check_failed');
      expect(failure.retryable, isTrue);
    });
  });
}
