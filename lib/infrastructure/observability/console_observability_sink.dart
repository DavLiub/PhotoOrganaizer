import '../../application/observability/safe_attributes.dart';
import '../../application/ports/observability_sink.dart';
import '../../domain/value_objects/operation_result.dart';

typedef ObservabilityWriter = void Function(String line);

class ConsoleObservabilitySink implements ObservabilitySink {
  const ConsoleObservabilitySink({ObservabilityWriter? writer})
    : _writer = writer;

  final ObservabilityWriter? _writer;

  @override
  void recordEvent(String name, Map<String, Object?> attributes) {
    _write(name, safeAttributes(attributes));
  }

  @override
  void recordFailure(
    FailureInfo failure, {
    Map<String, Object?> attributes = const {},
  }) {
    recordEvent('operation.failure', {
      ...attributes,
      ...failure.diagnostics,
      'failure_kind': failure.kind.name,
      'failure_code': failure.code,
      'retryable': failure.retryable,
      'user_action_required': failure.userActionRequired,
    });
  }

  void _write(String name, Map<String, Object?> attributes) {
    final writer = _writer;
    if (writer == null) {
      return;
    }

    writer('$name $attributes');
  }
}
