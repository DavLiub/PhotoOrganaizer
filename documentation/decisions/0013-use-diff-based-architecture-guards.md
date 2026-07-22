# ADR 0013: Use Diff-Based Architecture Guards

## Context

The project uses layered architecture and AI review is advisory-only because external AI quota is not guaranteed. Layering rules still need deterministic enforcement in pull requests and on `main`.

Running every custom check across the full repository on every PR can become noisy and slow. Naming guidance is useful, but it should not block delivery by itself.

## Decision

Add a script-based architecture guard in `tools/ci/architecture_guard.py`.

The guard inspects changed Dart lines from the Git diff by default. In CI it receives base and head SHAs from GitHub Actions. Local runs without arguments inspect unstaged and staged changes. A manual `--all` mode can inspect all tracked Dart files.

Blocking checks:

- Domain must not import other layers.
- Application must not import Presentation, Infrastructure, or Bootstrap.
- Presentation must not import Infrastructure.

Advisory checks:

- suspicious generic names such as `Utils`, `Helpers`, `Managers`, and `Common`;
- file, class, and function names that usually contain more than three words.

## Consequences

- Layer violations can block PRs without depending on AI review.
- Naming feedback is visible in CI without becoming a merge gate.
- Existing code is not re-litigated on unrelated PRs because CI checks changed lines.
- A full repository scan remains available for audits.

## Alternatives Considered

- Rely on AI review: rejected because OpenAI API quota can be unavailable.
- Run custom checks over the full repository on every PR: rejected because this would create stale noise and unnecessary work.
- Make naming checks blocking: rejected because naming is useful guidance but needs engineering judgment.
