@Tags(<String>['ci-gate', 'pr-gate', 'night'])
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:photo_organizer/application/models/app_settings.dart';
import 'package:photo_organizer/application/ports/app_settings_repository.dart';
import 'package:photo_organizer/application/use_cases/read_app_settings.dart';
import 'package:photo_organizer/application/use_cases/save_app_locale.dart';
import 'package:photo_organizer/domain/value_objects/operation_result.dart';

void main() {
  group('App settings use cases', () {
    test('reads absent locale override as system fallback', () async {
      final repository = _FakeRepository(const AppSettings());
      final result = await ReadAppSettings(repository)();

      expect(result, isA<OperationSuccess<AppSettings>>());
      expect(
        (result as OperationSuccess<AppSettings>).value.selectedLocaleCode,
        isNull,
      );
      expect(result.value.hasLocaleOverride, isFalse);
    });

    test('saves supported locale override', () async {
      final repository = _FakeRepository(const AppSettings());
      final result = await SaveAppLocale(repository)('ru');

      expect(result, isA<OperationSuccess<AppSettings>>());
      expect(
        (result as OperationSuccess<AppSettings>).value.selectedLocaleCode,
        'ru',
      );
      expect(repository.settings.selectedLocaleCode, 'ru');
    });

    test('rejects unsupported locale override', () async {
      final repository = _FakeRepository(const AppSettings());
      final result = await SaveAppLocale(repository)('he');

      expect(result, isA<OperationFailure<AppSettings>>());
      expect(
        (result as OperationFailure<AppSettings>).code,
        'app_settings.unsupported_locale',
      );
      expect(repository.saveCalls, 0);
    });
  });
}

class _FakeRepository implements AppSettingsRepository {
  _FakeRepository(this.settings);

  AppSettings settings;
  int saveCalls = 0;

  @override
  Future<AppSettings> read() async {
    return settings;
  }

  @override
  Future<void> save(AppSettings settings) async {
    saveCalls++;
    this.settings = settings;
  }
}
