import '../value_objects/photo_identity.dart';

enum PhotoAvailabilityStatus { available, missing, inaccessible }

class PhotoAsset {
  const PhotoAsset({
    required this.id,
    required this.sourceUri,
    required this.sourceProvider,
    required this.filename,
    required this.mimeType,
    required this.fileSize,
    required this.discoveredAt,
    required this.lastSeenAt,
    required this.availabilityStatus,
    this.width,
    this.height,
    this.currentIdentity,
  });

  final String id;
  final String sourceUri;
  final String sourceProvider;
  final String filename;
  final String mimeType;
  final int fileSize;
  final DateTime discoveredAt;
  final DateTime lastSeenAt;
  final PhotoAvailabilityStatus availabilityStatus;
  final int? width;
  final int? height;
  final PhotoIdentity? currentIdentity;
}
