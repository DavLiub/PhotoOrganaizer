enum AppMode {
  production,
  debug,
  test;

  static const _environmentName = String.fromEnvironment(
    'APP_MODE',
    defaultValue: 'production',
  );

  static AppMode fromEnvironment() {
    return fromName(_environmentName);
  }

  static AppMode fromName(String name) {
    return switch (name.trim().toLowerCase()) {
      'production' || 'prod' => AppMode.production,
      'debug' || 'development' || 'dev' => AppMode.debug,
      'test' => AppMode.test,
      _ => throw ArgumentError.value(name, 'name', 'Unsupported app mode'),
    };
  }

  bool get allowsTestAccess => this != AppMode.production;
}
