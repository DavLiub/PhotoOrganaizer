# Actual Documentation Layout

## Tracked Documentation

```text
documentation/
  Readme.md
  requirements/
  actual/
  decisions/
  changelog/
```

## Local Ignored Documentation

```text
documentation/
  source documentation/
  feature planning/
  AI log/
```

## Rationale

Original Russian source documents, local planning notes, and local AI logs remain untracked. The repository tracks English working requirements, actual implementation documentation, ADRs, and changelog entries.

## Maintenance Rule

When a tracked requirement is derived from an original source document, keep the source mapping in `documentation/requirements/README.md`.
