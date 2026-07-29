class AppSettings {
  const AppSettings({this.selectedLocaleCode});

  static const supportedLocaleCodes = {'en', 'ru'};

  final String? selectedLocaleCode;

  bool get hasLocaleOverride {
    return selectedLocaleCode != null;
  }

  AppSettings withSelectedLocale(String localeCode) {
    if (!supportsLocale(localeCode)) {
      throw ArgumentError.value(localeCode, 'localeCode', 'Unsupported locale');
    }

    return AppSettings(selectedLocaleCode: localeCode);
  }

  static bool supportsLocale(String localeCode) {
    return supportedLocaleCodes.contains(localeCode);
  }
}
