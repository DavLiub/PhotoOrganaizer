@Tags(<String>['ci-gate', 'pr-gate', 'night'])
library;

import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:photo_organizer/application/models/app_settings.dart';
import 'package:photo_organizer/infrastructure/storage/app_database.dart';
import 'package:photo_organizer/infrastructure/storage/app_settings_store.dart';

void main() {
  group('AppSettingsStore', () {
    late Directory tempDirectory;
    late File databaseFile;

    setUp(() async {
      tempDirectory = await Directory.systemTemp.createTemp(
        'photo_organizer_settings_',
      );
      databaseFile = File(
        '${tempDirectory.path}${Platform.pathSeparator}db.sqlite',
      );
    });

    tearDown(() async {
      if (await tempDirectory.exists()) {
        await tempDirectory.delete(recursive: true);
      }
    });

    test('uses system fallback when no locale override exists', () async {
      final database = AppDatabase(NativeDatabase.memory());
      final repository = AppSettingsStore(database: database);

      final settings = await repository.read();

      expect(settings.selectedLocaleCode, isNull);

      await database.close();
    });

    test('persists selected locale across database reopen', () async {
      var database = AppDatabase(NativeDatabase(databaseFile));
      await AppSettingsStore(
        database: database,
      ).save(const AppSettings(selectedLocaleCode: 'ru'));
      await database.close();

      database = AppDatabase(NativeDatabase(databaseFile));
      final settings = await AppSettingsStore(database: database).read();

      expect(settings.selectedLocaleCode, 'ru');

      await database.close();
    });
  });
}
