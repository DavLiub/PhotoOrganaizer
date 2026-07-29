import '../../domain/value_objects/operation_result.dart';
import '../models/app_settings.dart';
import '../ports/app_settings_repository.dart';

class ReadAppSettings {
  const ReadAppSettings(this._repository);

  final AppSettingsRepository _repository;

  Future<OperationResult<AppSettings>> call() async {
    try {
      return OperationSuccess(await _repository.read());
    } catch (error) {
      return OperationFailure(
        kind: FailureKind.storage,
        code: 'app_settings.read_failed',
        safeMessage: 'App settings could not be loaded.',
        retryable: true,
        diagnostics: {'error_type': error.runtimeType.toString()},
      );
    }
  }
}
