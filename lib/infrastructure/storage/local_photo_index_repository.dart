import '../../application/ports/photo_index_repository.dart';
import '../../domain/entities/photo_index_entry.dart';
import '../../domain/models/protection_summary.dart';
import '../../domain/value_objects/photo_identity.dart';
import 'app_database.dart';
import 'photo_index_mapper.dart';

class LocalPhotoIndexRepository implements PhotoIndexRepository {
  LocalPhotoIndexRepository({
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
  Future<List<PhotoIndexEntry>> findByAssetIds(Set<String> assetIds) async {
    if (assetIds.isEmpty) {
      return const [];
    }

    final rows = await (database.select(
      database.photoIndexEntries,
    )..where((entry) => entry.assetId.isIn(assetIds))).get();

    return rows.map(entryFromRow).toList(growable: false);
  }

  @override
  Future<PhotoIndexEntry?> findByIdentity(PhotoIdentity identity) async {
    final row =
        await (database.select(database.photoIndexEntries)
              ..where((entry) => entry.identityKey.equals(identity.key))
              ..limit(1))
            .getSingleOrNull();

    return row == null ? null : entryFromRow(row);
  }

  @override
  Future<void> upsertEntries(List<PhotoIndexEntry> entries) async {
    if (entries.isEmpty) {
      return;
    }

    await database.batch((batch) {
      batch.insertAllOnConflictUpdate(
        database.photoIndexEntries,
        entries.map(entryToCompanion),
      );
    });
  }

  @override
  Stream<ProtectionSummary> watchProtectionSummary() {
    return database.select(database.photoIndexEntries).watch().map((rows) {
      return ProtectionSummary.fromIndex(rows.map(entryFromRow));
    });
  }
}
