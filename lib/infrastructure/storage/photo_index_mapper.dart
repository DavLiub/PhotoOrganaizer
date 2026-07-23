import 'package:drift/drift.dart';

import '../../domain/entities/photo_asset.dart';
import '../../domain/entities/photo_index_entry.dart';
import '../../domain/value_objects/photo_identity.dart';
import 'app_database.dart';

PhotoIndexEntry entryFromRow(PhotoIndexRow row) {
  final identity = PhotoIdentity(
    assetId: row.assetId,
    fileSize: row.fileSize,
    createdAt: _utc(row.createdAt),
    modifiedAt: _utc(row.modifiedAt),
  );

  final asset = PhotoAsset(
    id: row.assetId,
    sourceUri: row.sourceUri,
    sourceProvider: row.sourceProvider,
    filename: row.filename,
    mimeType: row.mimeType,
    fileSize: row.fileSize,
    createdAt: _utc(row.createdAt),
    modifiedAt: _utc(row.modifiedAt),
    discoveredAt: _utc(row.discoveredAt),
    lastSeenAt: _utc(row.lastSeenAt),
    availabilityStatus: PhotoAvailabilityStatus.values.byName(
      row.availabilityStatus,
    ),
    albumId: row.albumId,
    sourceName: row.sourceName,
    width: row.width,
    height: row.height,
    currentIdentity: identity,
  );

  return PhotoIndexEntry(
    id: row.id,
    identity: identity,
    asset: asset,
    status: PhotoIndexStatus.values.byName(row.status),
    indexedAt: _utc(row.indexedAt),
    updatedAt: _utc(row.updatedAt),
  );
}

PhotoIndexEntriesCompanion entryToCompanion(PhotoIndexEntry entry) {
  final asset = entry.asset;
  final identity = entry.identity;

  return PhotoIndexEntriesCompanion(
    id: Value(entry.id),
    assetId: Value(asset.id),
    identityKey: Value(identity.key),
    sourceUri: Value(asset.sourceUri),
    sourceProvider: Value(asset.sourceProvider),
    sourceName: Value(asset.sourceName),
    albumId: Value(asset.albumId),
    filename: Value(asset.filename),
    mimeType: Value(asset.mimeType),
    fileSize: Value(asset.fileSize),
    createdAt: Value(_utc(asset.createdAt)),
    modifiedAt: Value(_utc(asset.modifiedAt)),
    discoveredAt: Value(_utc(asset.discoveredAt)),
    lastSeenAt: Value(_utc(asset.lastSeenAt)),
    availabilityStatus: Value(asset.availabilityStatus.name),
    width: Value(asset.width),
    height: Value(asset.height),
    status: Value(entry.status.name),
    indexedAt: Value(_utc(entry.indexedAt)),
    updatedAt: Value(_utc(entry.updatedAt)),
  );
}

DateTime _utc(DateTime value) => value.toUtc();
