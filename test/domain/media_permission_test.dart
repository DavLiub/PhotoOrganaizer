import 'package:flutter_test/flutter_test.dart';
import 'package:photo_organizer/domain/value_objects/media_permission.dart';

void main() {
  group('MediaPermission', () {
    test('allows reading photos when granted or limited', () {
      const granted = MediaPermission(state: MediaPermissionState.granted);
      const limited = MediaPermission(state: MediaPermissionState.limited);

      expect(granted.canReadPhotos, isTrue);
      expect(limited.canReadPhotos, isTrue);
    });

    test('requires user action for denied states', () {
      const denied = MediaPermission(state: MediaPermissionState.denied);
      const blocked = MediaPermission(
        state: MediaPermissionState.permanentlyDenied,
        canAskAgain: false,
      );
      const unavailable = MediaPermission(
        state: MediaPermissionState.unavailable,
      );

      expect(denied.needsUserAction, isTrue);
      expect(blocked.needsUserAction, isTrue);
      expect(unavailable.needsUserAction, isTrue);
      expect(blocked.canAskAgain, isFalse);
    });

    test('treats unknown as unreadable but not actionable yet', () {
      const permission = MediaPermission.unknown();

      expect(permission.state, MediaPermissionState.unknown);
      expect(permission.canReadPhotos, isFalse);
      expect(permission.needsUserAction, isFalse);
    });
  });
}
