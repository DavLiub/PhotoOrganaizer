import 'package:drift/drift.dart';

import '../../application/models/app_settings.dart';
import '../../application/ports/app_settings_repository.dart';
import 'app_database.dart';

class AppSettingsStore implements AppSettingsRepository {
  AppSettingsStore({
    AppDatabase? database,
    AppDatabase Function()? createDatabase,
  }) : _database = database,
       _createDatabase = createDatabase ?? AppDatabase.defaults;

  static const _localeKey = 'selected_locale';

  AppDatabase? _database;
  final AppDatabase Function() _createDatabase;

  AppDatabase get database {
    return _database ??= _createDatabase();
  }

  @override
  Future<AppSettings> read() async {
    final row = await database
        .customSelect(
          '''
              SELECT setting_value
              FROM app_settings
              WHERE setting_key = ?
              LIMIT 1
              ''',
          variables: [const Variable<String>(_localeKey)],
        )
        .getSingleOrNull();

    return AppSettings(selectedLocaleCode: row?.read<String>('setting_value'));
  }

  @override
  Future<void> save(AppSettings settings) async {
    final localeCode = settings.selectedLocaleCode;
    if (localeCode == null) {
      await database.customStatement(
        'DELETE FROM app_settings WHERE setting_key = ?',
        [_localeKey],
      );
      return;
    }

    await database.customStatement(
      '''
      INSERT INTO app_settings (setting_key, setting_value, updated_at)
      VALUES (?, ?, ?)
      ON CONFLICT(setting_key) DO UPDATE SET
        setting_value = excluded.setting_value,
        updated_at = excluded.updated_at
      ''',
      [_localeKey, localeCode, DateTime.now().toUtc().millisecondsSinceEpoch],
    );
  }
}
