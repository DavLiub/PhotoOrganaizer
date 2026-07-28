@Tags(<String>['ci-gate', 'pr-gate', 'night'])
library;

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:photo_organizer/application/models/photo_library.dart';
import 'package:photo_organizer/infrastructure/storage/app_database.dart';
import 'package:photo_organizer/infrastructure/storage/source_selection_store.dart';

void main() {
  group('SourceSelectionStore', () {
    late AppDatabase database;
    late SourceSelectionStore repository;

    setUp(() {
      database = AppDatabase(NativeDatabase.memory());
      repository = SourceSelectionStore(database: database);
    });

    tearDown(() async {
      await database.close();
    });

    test('uses all categories and sources by default', () async {
      final settings = await repository.read();

      expect(settings.isCategoryEnabled(LibraryCategory.camera), isTrue);
      expect(settings.isCategoryEnabled(LibraryCategory.screenshots), isTrue);
      expect(settings.isSourceEnabled('source-id'), isTrue);
    });

    test('persists disabled category', () async {
      await repository.setCategory(LibraryCategory.screenshots, enabled: false);

      final settings = await repository.read();

      expect(settings.isCategoryEnabled(LibraryCategory.camera), isTrue);
      expect(settings.isCategoryEnabled(LibraryCategory.screenshots), isFalse);
    });

    test('persists disabled source', () async {
      await repository.setSource('source-screenshots', enabled: false);

      final settings = await repository.read();

      expect(settings.isSourceEnabled('source-screenshots'), isFalse);
      expect(settings.isSourceEnabled('source-camera'), isTrue);
    });
  });
}
