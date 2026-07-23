# Actual Validation

## CI Validation

GitHub Actions runs project checks for pull requests and pushes to `main` or `master`.

Workflow:

```text
.github/workflows/project-checks.yml
```

Jobs:

- `Project Checks / Flutter Format`
- `Project Checks / Flutter Analyze`
- `Project Checks / Flutter Test`
- `Project Checks / Architecture Layers`
- `Project Checks / Test Import Guard`
- `Project Checks / SDK Leak Guard`
- `Project Checks / Secret Guard`
- `Project Checks / Naming Report`

Flutter Format:

- `dart format --set-exit-if-changed .`

Flutter Analyze:

- `flutter pub get`
- `flutter analyze`

Flutter Test:

- `flutter pub get`
- `flutter test`

Architecture Layers:

- `python tools/ci/architecture_guard.py --base <base-sha> --head <head-sha>`

Test Import Guard:

- `python tools/ci/test_import_guard.py --base <base-sha> --head <head-sha>`

SDK Leak Guard:

- `python tools/ci/sdk_leak_guard.py --base <base-sha> --head <head-sha>`

Secret Guard:

- `python tools/ci/secret_guard.py --base <base-sha> --head <head-sha>`

Naming Report:

- `python tools/ci/naming_report.py --base <base-sha> --head <head-sha>`

## Project Guards

Project guard scripts are implemented in:

```text
tools/ci/architecture_guard.py
tools/ci/test_import_guard.py
tools/ci/sdk_leak_guard.py
tools/ci/secret_guard.py
tools/ci/naming_report.py
```

Default behavior is diff-based:

- GitHub pull requests are checked against the PR base and head SHAs.
- Pushes to `main` or `master` are checked against the previous and current commit SHAs.
- Local runs without arguments inspect unstaged and staged changes.
- `--all` performs a full tracked Dart file scan for manual audits.

Blocking checks:

- Domain must not import other layers.
- Application must not import Presentation, Infrastructure, or Bootstrap.
- Presentation must not import Infrastructure.
- Production code must not import test/debug packages or files.
- Domain/Application must not import blocked SDK/plugin packages.
- Changed files and lines must not contain common secret files or secret assignments.

Advisory checks:

- suspicious generic names such as `Utils`, `Helpers`, `Managers`, and `Common`;
- file, class, and function names that usually contain more than three words.

Advisory naming findings are emitted as warnings and do not fail CI by themselves. In normal diff mode, naming checks inspect declarations in changed lines. File-name recommendations are part of manual `--all` audits.

Generated Dart files such as `*.g.dart`, `*.freezed.dart`, and `*.mocks.dart` are excluded from advisory naming reports because their identifiers are produced by tools.

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

The source app version in `pubspec.yaml` follows the matching pre-release line:

```text
0.0.x+build
```

Flutter maps this value to Android `versionName` and `versionCode`. Keep the source version aligned with the expected next `v0.0.x` tag before merging release-affecting changes.

## Branch Protection

Configure GitHub branch protection for `main`:

- require pull requests before merging;
- require `Project Checks / Flutter Format`;
- require `Project Checks / Flutter Analyze`;
- require `Project Checks / Flutter Test`;
- require `Project Checks / Architecture Layers`;
- require `Project Checks / Test Import Guard`;
- require `Project Checks / SDK Leak Guard`;
- require `Project Checks / Secret Guard`;
- require `Project Checks / Naming Report`;
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
python tools/ci/architecture_guard.py
python tools/ci/test_import_guard.py
python tools/ci/sdk_leak_guard.py
python tools/ci/secret_guard.py
python tools/ci/naming_report.py
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
