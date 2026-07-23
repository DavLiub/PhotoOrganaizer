# Actual Backup State

## Current Scope

The current implementation defines the Domain backup state machine. It does not persist backup records, upload to cloud storage, schedule real background work, or delete local photos.

## Per-Photo Records

`BackupRecord` tracks backup state for one indexed photo.

Statuses:

- `queued`
- `uploading`
- `uploaded`
- `confirmed`
- `failed`
- `cancelled`

Main transitions:

```text
queued -> uploading -> uploaded -> confirmed
queued -> uploading -> queued    retryable failure
queued -> uploading -> failed    non-retryable failure
queued/uploading/uploaded/failed -> cancelled
```

`confirmed` and `cancelled` are terminal per-photo states. Confirmed records cannot be cancelled.

## Retry Metadata

`BackupRecord` stores:

- attempt count;
- last attempt timestamp;
- next retry timestamp;
- last failure code.

Retryable failures requeue the record with retry metadata. A future retry time blocks `startUpload` until the retry is ready.

## Process Jobs

`BackupJob` tracks backup process state.

Statuses:

- `queued`
- `running`
- `completed`
- `paused`
- `failed`
- `cancelled`

Main transitions:

```text
queued -> running -> completed
running -> paused -> running
queued/running/paused -> failed
queued/running/paused -> cancelled
```

`paused` is only a job/process state. Individual photo records are not paused.

## Idempotency

Repeated calls that represent the same completed step are idempotent where useful:

- starting an already running job returns the same job;
- starting an already uploading record returns the same record;
- marking the same uploaded cloud object returns the same record;
- confirming an already confirmed record returns the same record;
- cancelling an already cancelled job or record returns the same value.

Conflicting or invalid transitions throw `StateError`.

## Known Limitations

- Backup records are not persisted yet.
- No Drive upload adapter uses this state machine yet.
- No Workmanager process uses this state machine yet.
- No local deletion or retention policy is implemented.
