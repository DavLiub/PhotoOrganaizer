# Actual Validation

## CI Validation

GitHub Actions runs Flutter checks for pull requests and pushes to `main` or `master`.

Workflow:

```text
.github/workflows/flutter-checks.yml
```

Checks:

- `flutter pub get`
- `dart format --set-exit-if-changed .`
- `flutter analyze`
- `flutter test`

## Main Branch Tags

Successful push validation on `main` or `master` triggers:

```text
.github/workflows/release-tag.yml
```

The release tag workflow creates a patch tag for the checked commit:

```text
v0.0.1
v0.0.2
v0.0.3
```

Tags are created only for successful push events on `main` or `master`. Pull request branches are not tagged.

## Branch Protection

Configure GitHub branch protection for `main`:

- require pull requests before merging;
- require `Flutter Checks / Format, Analyze, Test`;
- block direct pushes;
- keep tag creation limited to the release workflow.

## AI Review

Pull requests run an advisory AI review workflow:

```text
.github/workflows/ai-review.yml
```

Implementation:

```text
tools/ci/ai_review.py
```

The workflow uses:

- `GITHUB_TOKEN` to create or update a pull request comment;
- `OPENAI_API_KEY` repository secret to call the OpenAI Responses API;
- optional `OPENAI_REVIEW_MODEL` repository variable to override the default model.

The default model is `gpt-5-mini`. The workflow is advisory-only. If `OPENAI_API_KEY` is not configured, or if OpenAI returns quota, billing, or rate-limit errors, the workflow skips review and exits successfully.

The `Run AI review` step uses `continue-on-error: true`. Comment publishing is best-effort: if GitHub denies comment creation, the review result is written to workflow logs and the job remains nonblocking.

The workflow runs on `pull_request_target`, checks out the base commit, and gets the PR diff through the GitHub REST API. It must not execute code from the pull request branch.

The review comment is updated on each PR push using a stable marker instead of creating duplicate comments.

Review scope:

- architecture layer violations;
- direct `presentation -> infrastructure` dependencies;
- duplicated project-specific logic;
- poor file/function/class names, especially names containing more than three words;
- potential bugs and behavioral regressions;
- optimization opportunities;
- missing or weak automated tests;
- missing documentation updates for significant changes;
- mismatch between PR plan, code changes, and actual documentation.

Ignored local documentation is excluded from review context:

- `documentation/source documentation/**`
- `documentation/feature planning/**`
- `documentation/AI log/**`

Security notes:

- `OPENAI_API_KEY` is an OpenAI API credential. ChatGPT subscription access and OpenAI API billing are managed separately.
- `insufficient_quota` means OpenAI API billing/quota must be fixed in the OpenAI Platform account, not in GitHub.
- Do not print `OPENAI_API_KEY`.
- Do not include repository secrets in prompts.
- Treat PR diffs as data sent to the configured AI provider.
- Keep the workflow advisory-only until review quality is proven.
- Do not configure `AI Review / Advisory AI Review` as a required branch protection check.

## Local Validation

Preferred local commands:

```powershell
flutter pub get
dart format --set-exit-if-changed .
flutter analyze
flutter test
```

## Codex Shell Note

In the current Codex sandbox on Windows, `dart.bat` and `flutter.bat` may time out because Flutter SDK cache access under `C:\tools\flutter` requires permissions outside the repository sandbox.

For diagnostics from Codex, use the Dart executable directly where possible:

```powershell
& 'C:\tools\flutter\bin\cache\dart-sdk\bin\dart.exe' analyze lib test
```

For Flutter commands, run with access to the Flutter SDK cache.
