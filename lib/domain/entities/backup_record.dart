import '../value_objects/operation_result.dart';

enum BackupRecordStatus {
  queued,
  uploading,
  uploaded,
  confirmed,
  failed,
  cancelled,
}

class BackupRecord {
  const BackupRecord({
    required this.id,
    required this.photoId,
    required this.status,
    this.attemptCount = 0,
    this.cloudObjectId,
    this.uploadedAt,
    this.confirmedAt,
    this.lastAttemptAt,
    this.nextRetryAt,
    this.lastFailureCode,
  }) : assert(attemptCount >= 0),
       assert(
         status != BackupRecordStatus.uploaded || cloudObjectId != null,
         'Uploaded backup records must have a cloud object id.',
       ),
       assert(
         status != BackupRecordStatus.uploaded || uploadedAt != null,
         'Uploaded backup records must have an upload timestamp.',
       ),
       assert(
         status != BackupRecordStatus.confirmed || cloudObjectId != null,
         'Confirmed backup records must have a cloud object id.',
       ),
       assert(
         status != BackupRecordStatus.confirmed || uploadedAt != null,
         'Confirmed backup records must have an upload timestamp.',
       ),
       assert(
         status != BackupRecordStatus.confirmed || confirmedAt != null,
         'Confirmed backup records must have a confirmation timestamp.',
       );

  factory BackupRecord.queued({
    required String id,
    required String photoId,
    DateTime? nextRetryAt,
    String? lastFailureCode,
    int attemptCount = 0,
  }) {
    return BackupRecord(
      id: id,
      photoId: photoId,
      status: BackupRecordStatus.queued,
      attemptCount: attemptCount,
      nextRetryAt: nextRetryAt?.toUtc(),
      lastFailureCode: lastFailureCode,
    );
  }

  final String id;
  final String photoId;
  final BackupRecordStatus status;
  final int attemptCount;
  final String? cloudObjectId;
  final DateTime? uploadedAt;
  final DateTime? confirmedAt;
  final DateTime? lastAttemptAt;
  final DateTime? nextRetryAt;
  final String? lastFailureCode;

  bool get isTerminal {
    return status == BackupRecordStatus.confirmed ||
        status == BackupRecordStatus.cancelled;
  }

  bool isRetryReady(DateTime now) {
    return status == BackupRecordStatus.queued &&
        (nextRetryAt == null || !nextRetryAt!.isAfter(now.toUtc()));
  }

  BackupRecord startUpload({required DateTime startedAt}) {
    if (status == BackupRecordStatus.uploading) {
      return this;
    }

    _requireStatus(BackupRecordStatus.queued, 'start upload');

    if (!isRetryReady(startedAt)) {
      throw StateError('Backup record is queued for a future retry.');
    }

    return _copyWith(
      status: BackupRecordStatus.uploading,
      attemptCount: attemptCount + 1,
      lastAttemptAt: startedAt.toUtc(),
      nextRetryAt: null,
    );
  }

  BackupRecord markUploaded({
    required String cloudObjectId,
    required DateTime uploadedAt,
  }) {
    if (status == BackupRecordStatus.uploaded &&
        this.cloudObjectId == cloudObjectId) {
      return this;
    }

    _requireStatus(BackupRecordStatus.uploading, 'mark uploaded');

    return _copyWith(
      status: BackupRecordStatus.uploaded,
      cloudObjectId: cloudObjectId,
      uploadedAt: uploadedAt.toUtc(),
      lastFailureCode: null,
      nextRetryAt: null,
    );
  }

  BackupRecord confirm({required DateTime confirmedAt}) {
    if (status == BackupRecordStatus.confirmed) {
      return this;
    }

    _requireStatus(BackupRecordStatus.uploaded, 'confirm upload');

    return _copyWith(
      status: BackupRecordStatus.confirmed,
      confirmedAt: confirmedAt.toUtc(),
      nextRetryAt: null,
      lastFailureCode: null,
    );
  }

  BackupRecord markFailure({
    required FailureInfo failure,
    DateTime? nextRetryAt,
  }) {
    _requireStatus(BackupRecordStatus.uploading, 'mark failure');

    return _copyWith(
      status: failure.retryable
          ? BackupRecordStatus.queued
          : BackupRecordStatus.failed,
      nextRetryAt: failure.retryable ? nextRetryAt?.toUtc() : null,
      lastFailureCode: failure.code,
    );
  }

  BackupRecord queueRetry({DateTime? nextRetryAt}) {
    _requireStatus(BackupRecordStatus.failed, 'queue retry');

    return _copyWith(
      status: BackupRecordStatus.queued,
      nextRetryAt: nextRetryAt?.toUtc(),
    );
  }

  BackupRecord cancel() {
    if (status == BackupRecordStatus.cancelled) {
      return this;
    }

    if (status == BackupRecordStatus.confirmed) {
      throw StateError('Confirmed backup record cannot be cancelled.');
    }

    return _copyWith(status: BackupRecordStatus.cancelled, nextRetryAt: null);
  }

  BackupRecord _copyWith({
    BackupRecordStatus? status,
    int? attemptCount,
    Object? cloudObjectId = _unset,
    Object? uploadedAt = _unset,
    Object? confirmedAt = _unset,
    Object? lastAttemptAt = _unset,
    Object? nextRetryAt = _unset,
    Object? lastFailureCode = _unset,
  }) {
    return BackupRecord(
      id: id,
      photoId: photoId,
      status: status ?? this.status,
      attemptCount: attemptCount ?? this.attemptCount,
      cloudObjectId: identical(cloudObjectId, _unset)
          ? this.cloudObjectId
          : cloudObjectId as String?,
      uploadedAt: identical(uploadedAt, _unset)
          ? this.uploadedAt
          : uploadedAt as DateTime?,
      confirmedAt: identical(confirmedAt, _unset)
          ? this.confirmedAt
          : confirmedAt as DateTime?,
      lastAttemptAt: identical(lastAttemptAt, _unset)
          ? this.lastAttemptAt
          : lastAttemptAt as DateTime?,
      nextRetryAt: identical(nextRetryAt, _unset)
          ? this.nextRetryAt
          : nextRetryAt as DateTime?,
      lastFailureCode: identical(lastFailureCode, _unset)
          ? this.lastFailureCode
          : lastFailureCode as String?,
    );
  }

  void _requireStatus(BackupRecordStatus requiredStatus, String action) {
    if (status != requiredStatus) {
      throw StateError(
        'Cannot $action backup record from ${status.name} status.',
      );
    }
  }
}

const Object _unset = Object();
