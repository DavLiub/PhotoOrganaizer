class PhotoIdentity {
  const PhotoIdentity({
    required this.id,
    required this.photoId,
    required this.fileSize,
    required this.createdAt,
    this.checksum,
    this.checksumAlgorithm,
    this.modifiedAt,
    this.perceptualHash,
  });

  final String id;
  final String photoId;
  final int fileSize;
  final DateTime createdAt;
  final String? checksum;
  final String? checksumAlgorithm;
  final DateTime? modifiedAt;
  final String? perceptualHash;
}
