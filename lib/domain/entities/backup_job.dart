enum BackupJobStatus { queued, running, completed, paused, failed, cancelled }

class BackupJob {
  const BackupJob({
    required this.id,
    required this.createdAt,
    required this.status,
    DateTime? updatedAt,
    this.lastFailureCode,
  }) : updatedAt = updatedAt ?? createdAt;

  final String id;
  final DateTime createdAt;
  final BackupJobStatus status;
  final DateTime updatedAt;
  final String? lastFailureCode;

  bool get isTerminal {
    return status == BackupJobStatus.completed ||
        status == BackupJobStatus.failed ||
        status == BackupJobStatus.cancelled;
  }

  BackupJob start({required DateTime startedAt}) {
    if (status == BackupJobStatus.running) {
      return this;
    }

    _requireAny({BackupJobStatus.queued, BackupJobStatus.paused}, 'start');

    return _copyWith(
      status: BackupJobStatus.running,
      updatedAt: startedAt.toUtc(),
      lastFailureCode: null,
    );
  }

  BackupJob pause({required DateTime pausedAt}) {
    if (status == BackupJobStatus.paused) {
      return this;
    }

    _requireAny({BackupJobStatus.running}, 'pause');

    return _copyWith(
      status: BackupJobStatus.paused,
      updatedAt: pausedAt.toUtc(),
    );
  }

  BackupJob complete({required DateTime completedAt}) {
    if (status == BackupJobStatus.completed) {
      return this;
    }

    _requireAny({BackupJobStatus.running}, 'complete');

    return _copyWith(
      status: BackupJobStatus.completed,
      updatedAt: completedAt.toUtc(),
      lastFailureCode: null,
    );
  }

  BackupJob fail({required String failureCode, required DateTime failedAt}) {
    _requireAny({
      BackupJobStatus.queued,
      BackupJobStatus.running,
      BackupJobStatus.paused,
    }, 'fail');

    return _copyWith(
      status: BackupJobStatus.failed,
      updatedAt: failedAt.toUtc(),
      lastFailureCode: failureCode,
    );
  }

  BackupJob cancel({required DateTime cancelledAt}) {
    if (status == BackupJobStatus.cancelled) {
      return this;
    }

    _requireAny({
      BackupJobStatus.queued,
      BackupJobStatus.running,
      BackupJobStatus.paused,
    }, 'cancel');

    return _copyWith(
      status: BackupJobStatus.cancelled,
      updatedAt: cancelledAt.toUtc(),
    );
  }

  BackupJob _copyWith({
    required BackupJobStatus status,
    required DateTime updatedAt,
    Object? lastFailureCode = _unset,
  }) {
    return BackupJob(
      id: id,
      createdAt: createdAt,
      status: status,
      updatedAt: updatedAt,
      lastFailureCode: identical(lastFailureCode, _unset)
          ? this.lastFailureCode
          : lastFailureCode as String?,
    );
  }

  void _requireAny(Set<BackupJobStatus> allowedStatuses, String action) {
    if (!allowedStatuses.contains(status)) {
      throw StateError('Cannot $action backup job from ${status.name} status.');
    }
  }
}

const Object _unset = Object();
