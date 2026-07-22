#!/usr/bin/env python3
from __future__ import annotations

import argparse
import re
import sys
from pathlib import Path

from diff_lines import Finding, collect_lines, emit_annotation, selected_lines


GENERIC_NAMES = {"utils", "helper", "helpers", "manager", "managers", "common"}
TYPE_DECL_RE = re.compile(
    r"\b(?:abstract\s+interface\s+class|class|enum|mixin|extension|typedef)\s+([A-Za-z_]\w*)"
)
FUNCTION_DECL_RE = re.compile(
    r"^\s*(?:static\s+)?(?:Future|Stream|void|bool|int|double|String|Object|Map|List|Set|Iterable)"
    r"(?:<[^>]+>)?\??\s+([a-zA-Z_]\w*)\s*\("
)


def main() -> int:
    args = parse_args()
    changed = collect_lines(args.base, args.head, args.all, ["**/*.dart"])

    if not changed:
        print("Naming report: no changed Dart lines.")
        return 0

    findings = find_recommendations(changed, include_file_names=args.all)
    print(
        f"Naming report inspected {sum(len(lines) for lines in changed.values())} "
        f"changed line(s) in {len(changed)} Dart file(s)."
    )

    if not findings:
        print("Naming report: no findings.")
        return 0

    print("\nAdvisory naming findings:")
    for finding in findings:
        emit_annotation("warning", finding)
        print(f"- {finding.path}:{finding.line}: {finding.message}")

    return 0


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Report suspicious names in changed Dart lines.")
    parser.add_argument("--base", help="Base git ref for diff-based checks.")
    parser.add_argument("--head", help="Head git ref for diff-based checks.")
    parser.add_argument("--all", action="store_true", help="Inspect all tracked Dart files.")
    return parser.parse_args()


def find_recommendations(changed: dict[str, set[int]], include_file_names: bool) -> list[Finding]:
    findings: list[Finding] = []

    for path, lines in sorted(changed.items()):
        if include_file_names:
            file_name = Path(path).stem
            normalized = file_name.removesuffix("_test")
            message = naming_message(normalized)
            if message is not None:
                findings.append(Finding(path, 1, f"Review file name `{file_name}`: {message}"))

        for line_number, line in selected_lines(path, lines):
            for name in names_from_line(line):
                message = naming_message(name)
                if message is not None:
                    findings.append(Finding(path, line_number, f"Review `{name}`: {message}"))

    return deduplicate(findings)


def names_from_line(line: str) -> list[str]:
    names = [match.group(1) for match in TYPE_DECL_RE.finditer(line)]
    function_match = FUNCTION_DECL_RE.match(line)
    if function_match is not None:
        names.append(function_match.group(1))
    return names


def naming_message(name: str) -> str | None:
    words = split_words(name)
    lowered = {word.lower() for word in words}

    if lowered & GENERIC_NAMES:
        return "generic names should be replaced with purpose-specific names."

    if len(words) > 3:
        return "names should usually contain no more than three words."

    return None


def split_words(name: str) -> list[str]:
    words: list[str] = []
    for part in re.split(r"[_\-\s]+", name):
        if not part:
            continue
        words.extend(
            match.group(0)
            for match in re.finditer(r"[A-Z]+(?=[A-Z][a-z]|$)|[A-Z]?[a-z]+|\d+", part)
        )
    return words


def deduplicate(findings: list[Finding]) -> list[Finding]:
    seen: set[Finding] = set()
    result: list[Finding] = []
    for finding in findings:
        if finding in seen:
            continue
        seen.add(finding)
        result.append(finding)
    return result


if __name__ == "__main__":
    try:
        sys.exit(main())
    except RuntimeError as error:
        print(f"Naming report failed: {error}", file=sys.stderr)
        sys.exit(2)
