enum BackupJobStatus { queued, running, completed, paused, failed, cancelled }

class BackupJob {
  const BackupJob({
    required this.id,
    required this.createdAt,
    required this.status,
  });

  final String id;
  final DateTime createdAt;
  final BackupJobStatus status;
}
