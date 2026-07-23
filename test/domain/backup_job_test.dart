import 'package:flutter_test/flutter_test.dart';
import 'package:photo_organizer/domain/entities/backup_job.dart';

void main() {
  group('BackupJob', () {
    test('starts and pauses a queued job', () {
      final createdAt = DateTime.utc(2026, 7, 23, 10);
      final startedAt = DateTime.utc(2026, 7, 23, 10, 1);
      final pausedAt = DateTime.utc(2026, 7, 23, 10, 2);
      final job = BackupJob(
        id: 'job-1',
        createdAt: createdAt,
        status: BackupJobStatus.queued,
      );

      final running = job.start(startedAt: startedAt);
      final paused = running.pause(pausedAt: pausedAt);

      expect(running.status, BackupJobStatus.running);
      expect(running.updatedAt, startedAt);
      expect(paused.status, BackupJobStatus.paused);
      expect(paused.updatedAt, pausedAt);
    });

    test('resumes paused job', () {
      final createdAt = DateTime.utc(2026, 7, 23, 10);
      final resumedAt = DateTime.utc(2026, 7, 23, 10, 3);
      final paused = BackupJob(
        id: 'job-1',
        createdAt: createdAt,
        status: BackupJobStatus.paused,
      );

      final running = paused.start(startedAt: resumedAt);

      expect(running.status, BackupJobStatus.running);
      expect(running.updatedAt, resumedAt);
    });

    test('completes running job', () {
      final completedAt = DateTime.utc(2026, 7, 23, 10, 4);
      final running = BackupJob(
        id: 'job-1',
        createdAt: DateTime.utc(2026, 7, 23, 10),
        status: BackupJobStatus.running,
      );

      final completed = running.complete(completedAt: completedAt);

      expect(completed.status, BackupJobStatus.completed);
      expect(completed.updatedAt, completedAt);
      expect(completed.isTerminal, isTrue);
    });

    test('records process failure code', () {
      final failedAt = DateTime.utc(2026, 7, 23, 10, 5);
      final running = BackupJob(
        id: 'job-1',
        createdAt: DateTime.utc(2026, 7, 23, 10),
        status: BackupJobStatus.running,
      );

      final failed = running.fail(
        failureCode: 'battery.low',
        failedAt: failedAt,
      );

      expect(failed.status, BackupJobStatus.failed);
      expect(failed.lastFailureCode, 'battery.low');
      expect(failed.updatedAt, failedAt);
    });

    test('does not pause completed job', () {
      final completed = BackupJob(
        id: 'job-1',
        createdAt: DateTime.utc(2026, 7, 23),
        status: BackupJobStatus.completed,
      );

      expect(
        () => completed.pause(pausedAt: DateTime.utc(2026, 7, 23, 10)),
        throwsStateError,
      );
    });
  });
}
