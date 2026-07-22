import 'package:flutter_test/flutter_test.dart';
import 'package:photo_organizer/domain/value_objects/operation_result.dart';
import 'package:photo_organizer/infrastructure/observability/console_observability_sink.dart';

void main() {
  group('ConsoleObservabilitySink', () {
    test('writes sanitized events', () {
      final lines = <String>[];
      final sink = ConsoleObservabilitySink(writer: lines.add);

      sink.recordEvent('backup.started', {
        'photo_count': 10,
        'photo_path': r'C:\Users\David\Pictures\IMG_001.jpg',
      });

      expect(lines, hasLength(1));
      expect(lines.single, contains('backup.started'));
      expect(lines.single, contains('photo_count: 10'));
      expect(lines.single, isNot(contains('IMG_001')));
    });

    test('writes sanitized failures', () {
      final lines = <String>[];
      final sink = ConsoleObservabilitySink(writer: lines.add);
      const failure = FailureInfo(
        kind: FailureKind.deviceState,
        code: 'device.low_battery',
        retryable: true,
        diagnostics: {
          'battery_saver': true,
          'photo_path': r'C:\Users\David\Pictures\IMG_001.jpg',
        },
      );

      sink.recordFailure(failure);

      expect(lines, hasLength(1));
      expect(lines.single, contains('operation.failure'));
      expect(lines.single, contains('failure_kind: deviceState'));
      expect(lines.single, contains('failure_code: device.low_battery'));
      expect(lines.single, contains('retryable: true'));
      expect(lines.single, isNot(contains('IMG_001')));
    });
  });
}
