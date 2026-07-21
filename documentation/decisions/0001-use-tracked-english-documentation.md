# ADR 0001: Use Tracked English Documentation

## Context

The project has original Russian source specifications and local AI working notes. The repository also needs stable documentation that can be reviewed in GitHub together with source code.

## Decision

Track English working documentation under:

```text
documentation/requirements
documentation/actual
documentation/decisions
documentation/changelog
```

Keep these local directories ignored:

```text
documentation/source documentation
documentation/feature planning
documentation/AI log
```

## Consequences

- GitHub contains reviewable project documentation.
- Original source documents remain local raw input.
- Requirements can be reorganized into implementation-friendly English files.
- PR plans and AI logs remain local unless explicitly promoted.

## Alternatives Considered

- Track all original documentation directly. Rejected for now because UX assets and raw source files should not be part of this PR.
- Keep all documentation ignored. Rejected because implementation and review need tracked project documentation.
