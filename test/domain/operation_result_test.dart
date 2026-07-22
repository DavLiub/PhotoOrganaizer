import 'package:flutter_test/flutter_test.dart';
import 'package:photo_organizer/domain/value_objects/operation_result.dart';

void main() {
  group('OperationResult', () {
    test('keeps success value unchanged', () {
      const result = OperationSuccess('ok');

      expect(result.value, 'ok');
    });

    test('keeps typed failure details together', () {
      final result = OperationFailure<void>(
        kind: FailureKind.deviceState,
        code: 'device.low_battery',
        safeMessage: 'Backup will continue when battery conditions improve.',
        retryable: true,
        diagnostics: {'battery_saver': true},
      );

      expect(result.kind, FailureKind.deviceState);
      expect(result.code, 'device.low_battery');
      expect(result.safeMessage, contains('continue'));
      expect(result.retryable, isTrue);
      expect(result.userActionRequired, isFalse);
      expect(result.diagnostics, {'battery_saver': true});
    });

    test('marks failures that require user action', () {
      final result = OperationFailure<void>(
        kind: FailureKind.permission,
        code: 'permission.photos_denied',
        userActionRequired: true,
      );

      expect(result.kind, FailureKind.permission);
      expect(result.retryable, isFalse);
      expect(result.userActionRequired, isTrue);
    });
  });
}
