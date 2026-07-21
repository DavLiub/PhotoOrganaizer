class ProtectionSummary {
  const ProtectionSummary({
    required this.totalPhotos,
    required this.protectedPhotos,
    required this.pendingPhotos,
    required this.failedPhotos,
  });

  factory ProtectionSummary.empty() {
    return const ProtectionSummary(
      totalPhotos: 0,
      protectedPhotos: 0,
      pendingPhotos: 0,
      failedPhotos: 0,
    );
  }

  final int totalPhotos;
  final int protectedPhotos;
  final int pendingPhotos;
  final int failedPhotos;
}
