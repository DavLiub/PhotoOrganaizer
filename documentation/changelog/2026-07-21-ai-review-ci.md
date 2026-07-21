# 2026-07-21 AI Review CI

## Changed

- Added advisory AI review workflow for pull requests.
- Added a dependency-free Python script that sends PR diffs to the OpenAI Responses API.
- The workflow runs from the base commit with `pull_request_target` and reads PR diffs through the GitHub REST API.
- AI review comments are updated in place using a stable marker.
- OpenAI API quota, billing, and rate-limit failures are treated as advisory skips rather than required check failures.
- Documented required `OPENAI_API_KEY` secret and optional `OPENAI_REVIEW_MODEL` variable.
- Documented AI review scope and security limitations.

## Notes

The workflow is advisory-only and does not block merge. If `OPENAI_API_KEY` is not configured or OpenAI API quota is unavailable, the review is skipped successfully.
