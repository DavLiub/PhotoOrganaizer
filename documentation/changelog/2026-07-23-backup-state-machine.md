# 2026-07-23 Backup State Machine

## Changed

- Added Domain transition rules for per-photo backup records.
- Added Domain transition rules for backup jobs.
- Added retry metadata for backup records.
- Defined retryable failures as requeued per-photo records.
- Documented that `paused` is only a backup job/process state.
- Added tests for valid, invalid, idempotent, and retry transitions.

## Validation

- `dart analyze lib/domain test/domain`
- `flutter test --reporter compact test/domain/backup_record_test.dart test/domain/backup_job_test.dart`
