abstract interface class ObservabilitySink {
  void recordEvent(String name, Map<String, Object?> attributes);

  void recordError(Object error, StackTrace stackTrace);
}
