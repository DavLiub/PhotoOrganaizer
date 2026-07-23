class PhotoIdentity {
  const PhotoIdentity({
    required this.assetId,
    required this.fileSize,
    required this.createdAt,
    required this.modifiedAt,
  });

  final String assetId;
  final int fileSize;
  final DateTime createdAt;

  final DateTime modifiedAt;

  String get key {
    return [
      assetId,
      fileSize,
      createdAt.toUtc().microsecondsSinceEpoch,
      modifiedAt.toUtc().microsecondsSinceEpoch,
    ].join('|');
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is PhotoIdentity &&
            other.assetId == assetId &&
            other.fileSize == fileSize &&
            other.createdAt.toUtc() == createdAt.toUtc() &&
            other.modifiedAt.toUtc() == modifiedAt.toUtc();
  }

  @override
  int get hashCode {
    return Object.hash(
      assetId,
      fileSize,
      createdAt.toUtc(),
      modifiedAt.toUtc(),
    );
  }
}
