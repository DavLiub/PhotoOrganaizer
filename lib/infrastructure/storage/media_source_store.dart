import '../../application/ports/media_source_repository.dart';
import '../../domain/entities/media_source.dart';
import 'app_database.dart';
import 'media_source_mapper.dart';

class MediaSourceStore implements MediaSourceRepository {
  MediaSourceStore({
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
  Future<List<MediaSource>> findAll() async {
    final rows = await database.select(database.mediaSources).get();

    return rows.map(sourceFromRow).toList(growable: false);
  }

  @override
  Future<MediaSource?> findById(String id) async {
    final row =
        await (database.select(database.mediaSources)
              ..where((source) => source.id.equals(id))
              ..limit(1))
            .getSingleOrNull();

    return row == null ? null : sourceFromRow(row);
  }

  @override
  Future<void> upsertSources(List<MediaSource> sources) async {
    if (sources.isEmpty) {
      return;
    }

    await database.batch((batch) {
      batch.insertAllOnConflictUpdate(
        database.mediaSources,
        sources.map(sourceToCompanion),
      );
    });
  }

  @override
  Stream<List<MediaSource>> watchSources() {
    return database.select(database.mediaSources).watch().map((rows) {
      return rows.map(sourceFromRow).toList(growable: false);
    });
  }
}
