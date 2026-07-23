enum AppPlatform { android, ios, unsupported }

extension AppPlatformName on AppPlatform {
  String get name {
    return switch (this) {
      AppPlatform.android => 'android',
      AppPlatform.ios => 'ios',
      AppPlatform.unsupported => 'unsupported',
    };
  }
}

AppPlatform appPlatformFromName(String? name) {
  return switch (name?.trim().toLowerCase()) {
    'android' => AppPlatform.android,
    'ios' => AppPlatform.ios,
    _ => AppPlatform.unsupported,
  };
}
