import '../../domain/value_objects/operation_result.dart';
import '../models/app_settings.dart';
import '../ports/app_settings_repository.dart';

class SaveAppLocale {
  const SaveAppLocale(this._repository);

  final AppSettingsRepository _repository;

  Future<OperationResult<AppSettings>> call(String localeCode) async {
    if (!AppSettings.supportsLocale(localeCode)) {
      return OperationFailure(
        kind: FailureKind.validation,
        code: 'app_settings.unsupported_locale',
        safeMessage: 'Selected language is not supported.',
        userActionRequired: true,
        diagnostics: {'locale_code': localeCode},
      );
    }

    try {
      final settings = AppSettings(selectedLocaleCode: localeCode);
      await _repository.save(settings);
      return OperationSuccess(settings);
    } catch (error) {
      return OperationFailure(
        kind: FailureKind.storage,
        code: 'app_settings.write_failed',
        safeMessage: 'App settings could not be saved.',
        retryable: true,
        diagnostics: {'error_type': error.runtimeType.toString()},
      );
    }
  }
}
