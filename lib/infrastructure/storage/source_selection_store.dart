import 'package:drift/drift.dart';

import '../../application/models/library_category.dart';
import '../../application/models/source_selection.dart';
import '../../application/ports/source_selection_repository.dart';
import 'app_database.dart';

class SourceSelectionStore implements SourceSelectionRepository {
  SourceSelectionStore({
    AppDatabase? database,
    AppDatabase Function()? createDatabase,
  }) : _database = database,
       _createDatabase = createDatabase ?? AppDatabase.defaults;

  AppDatabase? _database;
  final AppDatabase Function() _createDatabase;

  AppDatabase get database {
    return _database ??= _createDatabase();
  }

  @override
  Future<SourceSelectionSettings> read() async {
    final categoryRows = await _readCategoryRows();
    final sourceRows = await _readSourceRows();

    return _settingsFromRows(categoryRows, sourceRows);
  }

  @override
  Stream<SourceSelectionSettings> watch() async* {
    yield await read();
  }

  @override
  Future<void> setCategory(
    LibraryCategory category, {
    required bool enabled,
  }) async {
    await database.customStatement(
      '''
      INSERT INTO source_category_selections (category, enabled, updated_at)
      VALUES (?, ?, ?)
      ON CONFLICT(category) DO UPDATE SET
        enabled = excluded.enabled,
        updated_at = excluded.updated_at
      ''',
      [
        category.name,
        enabled ? 1 : 0,
        DateTime.now().toUtc().millisecondsSinceEpoch,
      ],
    );
  }

  @override
  Future<void> setSource(String sourceId, {required bool enabled}) async {
    await database.customStatement(
      '''
      INSERT INTO media_source_selections (source_id, enabled, updated_at)
      VALUES (?, ?, ?)
      ON CONFLICT(source_id) DO UPDATE SET
        enabled = excluded.enabled,
        updated_at = excluded.updated_at
      ''',
      [
        sourceId,
        enabled ? 1 : 0,
        DateTime.now().toUtc().millisecondsSinceEpoch,
      ],
    );
  }

  Future<List<_CategoryRow>> _readCategoryRows() {
    return database
        .customSelect(
          'SELECT category, enabled FROM source_category_selections',
        )
        .get()
        .then((rows) {
          return rows.map(_categoryFromRow).toList(growable: false);
        });
  }

  Future<List<_SourceRow>> _readSourceRows() {
    return database
        .customSelect('SELECT source_id, enabled FROM media_source_selections')
        .get()
        .then((rows) {
          return rows.map(_sourceFromRow).toList(growable: false);
        });
  }
}

SourceSelectionSettings _settingsFromRows(
  List<_CategoryRow> categoryRows,
  List<_SourceRow> sourceRows,
) {
  final categoryValues = {
    for (final row in categoryRows) row.category: row.enabled,
  };
  final enabledCategories = LibraryCategory.values.where((category) {
    return categoryValues[category.name] ?? true;
  }).toSet();
  final sourceOverrides = {
    for (final row in sourceRows) row.sourceId: row.enabled,
  };

  return SourceSelectionSettings(
    enabledCategories: Set.unmodifiable(enabledCategories),
    sourceOverrides: Map.unmodifiable(sourceOverrides),
  );
}

_CategoryRow _categoryFromRow(QueryRow row) {
  return _CategoryRow(
    category: row.read<String>('category'),
    enabled: row.read<int>('enabled') == 1,
  );
}

_SourceRow _sourceFromRow(QueryRow row) {
  return _SourceRow(
    sourceId: row.read<String>('source_id'),
    enabled: row.read<int>('enabled') == 1,
  );
}

class _CategoryRow {
  const _CategoryRow({required this.category, required this.enabled});

  final String category;
  final bool enabled;
}

class _SourceRow {
  const _SourceRow({required this.sourceId, required this.enabled});

  final String sourceId;
  final bool enabled;
}
