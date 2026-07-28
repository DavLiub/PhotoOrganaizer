#!/usr/bin/env python3
from __future__ import annotations

import argparse
import re
import sys

from diff_lines import Finding, collect_files, emit_annotation, read_lines


TYPE_TAGS = {"smoke", "ci-gate", "extended", "sanity"}
RUN_TAGS = {"pr-gate", "night"}
TAGS_RE = re.compile(r"@Tags\s*\((.*?)\)\s*library\s*;", re.DOTALL)
STRING_RE = re.compile(r"['\"]([a-z][a-z0-9-]*)['\"]")
DECLARED_TAG_RE = re.compile(r"^\s{2}([a-z][a-z0-9-]*):")


def main() -> int:
    args = parse_args()
    files = collect_files(args.base, args.head, args.all, ["test/**/*_test.dart"])

    if not files:
        print("Test tag guard: no changed test files.")
        return 0

    declared_tags = load_declared_tags()
    findings = find_violations(files, declared_tags)

    print(f"Test tag guard inspected {len(files)} test file(s).")

    if findings:
        print("\nBlocking test tag violations:")
        for finding in findings:
            emit_annotation("error", finding)
            print(f"- {finding.path}:{finding.line}: {finding.message}")
        return 1

    print("Test tag guard: all inspected tests are classified.")
    return 0


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Check test files for required classification tags.")
    parser.add_argument("--base", help="Base git ref for diff-based checks.")
    parser.add_argument("--head", help="Head git ref for diff-based checks.")
    parser.add_argument("--all", action="store_true", help="Inspect all tracked test files.")
    return parser.parse_args()


def load_declared_tags() -> set[str]:
    lines = read_lines("dart_test.yaml")
    if lines is None:
        raise RuntimeError("dart_test.yaml is missing.")

    return {
        match.group(1)
        for line in lines
        if (match := DECLARED_TAG_RE.match(line)) is not None
    }


def find_violations(files: list[str], declared_tags: set[str]) -> list[Finding]:
    findings: list[Finding] = []

    for path in sorted(files):
        lines = read_lines(path)
        if lines is None:
            continue

        text = "\n".join(lines)
        match = TAGS_RE.search(text)
        if match is None:
            findings.append(
                Finding(path, 1, "Test file must declare file-level @Tags before `library;`.")
            )
            continue

        tags = set(STRING_RE.findall(match.group(1)))
        line = text[: match.start()].count("\n") + 1

        unknown_tags = tags - declared_tags
        if unknown_tags:
            findings.append(
                Finding(path, line, f"Unknown test tag(s): {', '.join(sorted(unknown_tags))}.")
            )

        if not tags & TYPE_TAGS:
            findings.append(
                Finding(
                    path,
                    line,
                    "Test file must include one test type tag: smoke, ci-gate, extended, or sanity.",
                )
            )

        if not tags & RUN_TAGS:
            findings.append(
                Finding(path, line, "Test file must include one run profile tag: pr-gate or night.")
            )

    return findings


if __name__ == "__main__":
    try:
        sys.exit(main())
    except RuntimeError as error:
        print(f"Test tag guard failed: {error}", file=sys.stderr)
        sys.exit(2)
