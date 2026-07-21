enum BackupRecordStatus { pending, uploaded, confirmed, failed, skipped }

class BackupRecord {
  const BackupRecord({
    required this.id,
    required this.photoId,
    required this.status,
    this.cloudObjectId,
    this.confirmedAt,
  });

  final String id;
  final String photoId;
  final BackupRecordStatus status;
  final String? cloudObjectId;
  final DateTime? confirmedAt;
}
