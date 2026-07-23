import 'package:drift/drift.dart';

import '../../domain/entities/media_source.dart';
import 'app_database.dart';

MediaSource sourceFromRow(MediaSourceRow row) {
  return MediaSource(
    id: row.id,
    provider: row.provider,
    name: row.name,
    pathHint: row.pathHint,
    assetCount: row.assetCount,
    lastSeenAt: row.lastSeenAt.toUtc(),
    availabilityStatus: MediaSourceStatus.values.byName(row.availabilityStatus),
    cameraLike: row.cameraLike,
    systemLike: row.systemLike,
  );
}

MediaSourcesCompanion sourceToCompanion(MediaSource source) {
  return MediaSourcesCompanion(
    id: Value(source.id),
    provider: Value(source.provider),
    name: Value(source.name),
    pathHint: Value(source.pathHint),
    assetCount: Value(source.assetCount),
    lastSeenAt: Value(source.lastSeenAt.toUtc()),
    availabilityStatus: Value(source.availabilityStatus.name),
    cameraLike: Value(source.cameraLike),
    systemLike: Value(source.systemLike),
  );
}
