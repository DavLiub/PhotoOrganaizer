import '../entities/photo_index_entry.dart';

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

  factory ProtectionSummary.fromIndex(Iterable<PhotoIndexEntry> entries) {
    final visible = entries.where(
      (entry) => entry.status != PhotoIndexStatus.ignored,
    );

    var totalPhotos = 0;
    var protectedPhotos = 0;
    var pendingPhotos = 0;
    var failedPhotos = 0;

    for (final entry in visible) {
      totalPhotos++;

      switch (entry.status) {
        case PhotoIndexStatus.protected:
          protectedPhotos++;
        case PhotoIndexStatus.failed:
          failedPhotos++;
        case PhotoIndexStatus.indexed:
        case PhotoIndexStatus.pendingBackup:
          pendingPhotos++;
        case PhotoIndexStatus.ignored:
          break;
      }
    }

    return ProtectionSummary(
      totalPhotos: totalPhotos,
      protectedPhotos: protectedPhotos,
      pendingPhotos: pendingPhotos,
      failedPhotos: failedPhotos,
    );
  }

  final int totalPhotos;
  final int protectedPhotos;
  final int pendingPhotos;
  final int failedPhotos;
}
