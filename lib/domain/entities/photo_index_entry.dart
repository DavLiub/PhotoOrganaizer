import '../value_objects/photo_identity.dart';
import 'photo_asset.dart';

enum PhotoIndexStatus { indexed, pendingBackup, protected, failed, ignored }

class PhotoIndexEntry {
  const PhotoIndexEntry({
    required this.id,
    required this.identity,
    required this.asset,
    required this.status,
    required this.indexedAt,
    required this.updatedAt,
  });

  factory PhotoIndexEntry.fromAsset(
    PhotoAsset asset, {
    required DateTime indexedAt,
    PhotoIndexStatus status = PhotoIndexStatus.indexed,
    String? id,
  }) {
    final identity = asset.identity;

    return PhotoIndexEntry(
      id: id ?? identity.key,
      identity: identity,
      asset: asset,
      status: status,
      indexedAt: indexedAt,
      updatedAt: indexedAt,
    );
  }

  final String id;
  final PhotoIdentity identity;
  final PhotoAsset asset;
  final PhotoIndexStatus status;
  final DateTime indexedAt;
  final DateTime updatedAt;

  PhotoIndexEntry refresh(PhotoAsset asset, {required DateTime updatedAt}) {
    return PhotoIndexEntry(
      id: id,
      identity: asset.identity,
      asset: asset,
      status: status,
      indexedAt: indexedAt,
      updatedAt: updatedAt,
    );
  }

  PhotoIndexEntry withStatus(PhotoIndexStatus status) {
    return PhotoIndexEntry(
      id: id,
      identity: identity,
      asset: asset,
      status: status,
      indexedAt: indexedAt,
      updatedAt: updatedAt,
    );
  }
}
