import 'package:flutter_test/flutter_test.dart';
import 'package:photo_organizer/domain/entities/backup_record.dart';
import 'package:photo_organizer/domain/value_objects/operation_result.dart';

void main() {
  group('BackupRecord', () {
    test('moves from queued to uploading', () {
      final startedAt = DateTime.utc(2026, 7, 23, 10);
      final record = BackupRecord.queued(id: 'record-1', photoId: 'photo-1');

      final uploading = record.startUpload(startedAt: startedAt);

      expect(uploading.status, BackupRecordStatus.uploading);
      expect(uploading.attemptCount, 1);
      expect(uploading.lastAttemptAt, startedAt);
      expect(uploading.nextRetryAt, isNull);
    });

    test('does not start before retry time', () {
      final retryAt = DateTime.utc(2026, 7, 23, 11);
      final record = BackupRecord.queued(
        id: 'record-1',
        photoId: 'photo-1',
        nextRetryAt: retryAt,
      );

      expect(
        () => record.startUpload(
          startedAt: retryAt.subtract(const Duration(minutes: 1)),
        ),
        throwsStateError,
      );
    });

    test('marks uploaded and confirmed', () {
      final startedAt = DateTime.utc(2026, 7, 23, 10);
      final confirmedAt = DateTime.utc(2026, 7, 23, 10, 1);
      final record = BackupRecord.queued(
        id: 'record-1',
        photoId: 'photo-1',
      ).startUpload(startedAt: startedAt);

      final uploaded = record.markUploaded(
        cloudObjectId: 'drive-object-1',
        uploadedAt: confirmedAt,
      );
      final confirmed = uploaded.confirm(confirmedAt: confirmedAt);

      expect(uploaded.status, BackupRecordStatus.uploaded);
      expect(uploaded.cloudObjectId, 'drive-object-1');
      expect(uploaded.uploadedAt, confirmedAt);
      expect(confirmed.status, BackupRecordStatus.confirmed);
      expect(confirmed.confirmedAt, confirmedAt);
      expect(confirmed.isTerminal, isTrue);
    });

    test('keeps repeated upload confirmation idempotent', () {
      final startedAt = DateTime.utc(2026, 7, 23, 10);
      final uploadedAt = DateTime.utc(2026, 7, 23, 10, 1);
      final uploaded = BackupRecord.queued(id: 'record-1', photoId: 'photo-1')
          .startUpload(startedAt: startedAt)
          .markUploaded(
            cloudObjectId: 'drive-object-1',
            uploadedAt: uploadedAt,
          );

      expect(
        uploaded.markUploaded(
          cloudObjectId: 'drive-object-1',
          uploadedAt: uploadedAt,
        ),
        same(uploaded),
      );
    });

    test('requeues retryable failures', () {
      final retryAt = DateTime.utc(2026, 7, 23, 11);
      final uploading = BackupRecord.queued(
        id: 'record-1',
        photoId: 'photo-1',
      ).startUpload(startedAt: DateTime.utc(2026, 7, 23, 10));

      final queued = uploading.markFailure(
        failure: const FailureInfo(
          kind: FailureKind.network,
          code: 'network.offline',
          retryable: true,
        ),
        nextRetryAt: retryAt,
      );

      expect(queued.status, BackupRecordStatus.queued);
      expect(queued.lastFailureCode, 'network.offline');
      expect(queued.nextRetryAt, retryAt);
      expect(queued.attemptCount, 1);
      expect(
        queued.isRetryReady(retryAt.subtract(const Duration(seconds: 1))),
        isFalse,
      );
      expect(queued.isRetryReady(retryAt), isTrue);
    });

    test('keeps non retryable failures failed', () {
      final uploading = BackupRecord.queued(
        id: 'record-1',
        photoId: 'photo-1',
      ).startUpload(startedAt: DateTime.utc(2026, 7, 23, 10));

      final failed = uploading.markFailure(
        failure: const FailureInfo(
          kind: FailureKind.cloudQuota,
          code: 'cloud.quota_exceeded',
        ),
      );

      expect(failed.status, BackupRecordStatus.failed);
      expect(failed.lastFailureCode, 'cloud.quota_exceeded');
      expect(failed.nextRetryAt, isNull);
    });

    test('allows manual retry from failed', () {
      final failed = BackupRecord(
        id: 'record-1',
        photoId: 'photo-1',
        status: BackupRecordStatus.failed,
        lastFailureCode: 'cloud.quota_exceeded',
      );
      final retryAt = DateTime.utc(2026, 7, 24);

      final queued = failed.queueRetry(nextRetryAt: retryAt);

      expect(queued.status, BackupRecordStatus.queued);
      expect(queued.nextRetryAt, retryAt);
      expect(queued.lastFailureCode, 'cloud.quota_exceeded');
    });

    test('does not cancel confirmed records', () {
      final confirmed = BackupRecord(
        id: 'record-1',
        photoId: 'photo-1',
        status: BackupRecordStatus.confirmed,
        cloudObjectId: 'drive-object-1',
        uploadedAt: DateTime.utc(2026, 7, 23),
        confirmedAt: DateTime.utc(2026, 7, 23),
      );

      expect(confirmed.cancel, throwsStateError);
    });
  });
}
