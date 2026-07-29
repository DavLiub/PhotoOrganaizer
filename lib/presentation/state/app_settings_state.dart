import '../../application/models/app_settings.dart';

enum AppSettingsPhase { loading, loaded, saving, failure }

class AppSettingsState {
  const AppSettingsState({
    required this.phase,
    required this.settings,
    this.errorCode,
  });

  const AppSettingsState.initial()
    : this(phase: AppSettingsPhase.loading, settings: const AppSettings());

  final AppSettingsPhase phase;
  final AppSettings settings;
  final String? errorCode;

  String? get selectedLocaleCode {
    return settings.selectedLocaleCode;
  }

  AppSettingsState copyWith({
    AppSettingsPhase? phase,
    AppSettings? settings,
    String? errorCode,
    bool clearError = false,
  }) {
    return AppSettingsState(
      phase: phase ?? this.phase,
      settings: settings ?? this.settings,
      errorCode: clearError ? null : errorCode ?? this.errorCode,
    );
  }
}
