import '../../domain/value_objects/operation_result.dart';

abstract interface class ObservabilitySink {
  void recordEvent(String name, Map<String, Object?> attributes);

  void recordFailure(
    FailureInfo failure, {
    Map<String, Object?> attributes = const {},
  });
}
