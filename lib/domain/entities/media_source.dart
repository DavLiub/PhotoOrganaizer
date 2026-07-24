enum MediaSourceStatus { available, missing, inaccessible }

class MediaSource {
  const MediaSource({
    required this.id,
    required this.provider,
    required this.name,
    required this.assetCount,
    required this.lastSeenAt,
    required this.availabilityStatus,
    this.pathHint,
    this.cameraLike = false,
    this.systemLike = false,
  }) : assert(id.length > 0),
       assert(provider.length > 0),
       assert(name.length > 0),
       assert(assetCount >= 0);

  final String id;
  final String provider;
  final String name;
  final String? pathHint;
  final int assetCount;
  final DateTime lastSeenAt;
  final MediaSourceStatus availabilityStatus;
  final bool cameraLike;
  final bool systemLike;

  bool get canIndex {
    return availabilityStatus == MediaSourceStatus.available && assetCount > 0;
  }

  MediaSource refresh({
    required int assetCount,
    required DateTime lastSeenAt,
    MediaSourceStatus availabilityStatus = MediaSourceStatus.available,
    String? name,
    String? pathHint,
    bool? cameraLike,
    bool? systemLike,
  }) {
    return MediaSource(
      id: id,
      provider: provider,
      name: name ?? this.name,
      pathHint: pathHint ?? this.pathHint,
      assetCount: assetCount,
      lastSeenAt: lastSeenAt.toUtc(),
      availabilityStatus: availabilityStatus,
      cameraLike: cameraLike ?? this.cameraLike,
      systemLike: systemLike ?? this.systemLike,
    );
  }
}
