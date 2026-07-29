import '../../application/models/app_settings.dart';
import '../../domain/value_objects/operation_result.dart';

typedef ReadSettings = Future<OperationResult<AppSettings>> Function();

typedef SaveLocale =
    Future<OperationResult<AppSettings>> Function(String localeCode);

class AppSettingsActions {
  const AppSettingsActions({
    required this.readSettings,
    required this.saveLocale,
  });

  final ReadSettings readSettings;
  final SaveLocale saveLocale;
}
