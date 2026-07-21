import '../../application/ports/observability_sink.dart';

class DebugObservabilitySink implements ObservabilitySink {
  @override
  void recordEvent(String name, Map<String, Object?> attributes) {}

  @override
  void recordError(Object error, StackTrace stackTrace) {}
}
