import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

@DataClassName('PhotoIndexRow')
class PhotoIndexEntries extends Table {
  TextColumn get id => text()();

  TextColumn get assetId => text()();

  TextColumn get identityKey => text()();

  TextColumn get sourceUri => text()();

  TextColumn get sourceProvider => text()();

  TextColumn get sourceId => text().nullable()();

  TextColumn get sourceName => text().nullable()();

  TextColumn get albumId => text().nullable()();

  TextColumn get filename => text()();

  TextColumn get mimeType => text()();

  IntColumn get fileSize => integer()();

  DateTimeColumn get createdAt => dateTime()();

  DateTimeColumn get modifiedAt => dateTime()();

  DateTimeColumn get discoveredAt => dateTime()();

  DateTimeColumn get lastSeenAt => dateTime()();

  TextColumn get availabilityStatus => text()();

  IntColumn get width => integer().nullable()();

  IntColumn get height => integer().nullable()();

  TextColumn get status => text()();

  DateTimeColumn get indexedAt => dateTime()();

  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('MediaSourceRow')
class MediaSources extends Table {
  TextColumn get id => text()();

  TextColumn get provider => text()();

  TextColumn get name => text()();

  TextColumn get pathHint => text().nullable()();

  IntColumn get assetCount => integer()();

  DateTimeColumn get lastSeenAt => dateTime()();

  TextColumn get availabilityStatus => text()();

  BoolColumn get cameraLike => boolean().withDefault(const Constant(false))();

  BoolColumn get systemLike => boolean().withDefault(const Constant(false))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DriftDatabase(tables: [PhotoIndexEntries, MediaSources])
final class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor);

  AppDatabase.defaults() : super(driftDatabase(name: 'photo_organizer'));

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (migrator) => migrator.createAll(),
      onUpgrade: (migrator, from, to) async {
        if (from < 2) {
          await migrator.createTable(mediaSources);
          await migrator.addColumn(
            photoIndexEntries,
            photoIndexEntries.sourceId,
          );
        }
      },
    );
  }
}
