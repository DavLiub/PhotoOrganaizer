#!/usr/bin/env python3
from __future__ import annotations

import argparse
import posixpath
import re
import sys

from diff_lines import Finding, collect_lines, emit_annotation, selected_lines


PROJECT_PACKAGE = "photo_organizer"
IMPORT_RE = re.compile(r"^\s*import\s+['\"]([^'\"]+)['\"]")
TEST_PACKAGES = {"flutter_test", "test", "mockito", "mocktail"}


def main() -> int:
    args = parse_args()
    changed = collect_lines(args.base, args.head, args.all, ["lib/**/*.dart"])

    if not changed:
        print("Test import guard: no changed Dart lines under lib/.")
        return 0

    findings = find_imports(changed)
    print(
        f"Test import guard inspected {sum(len(lines) for lines in changed.values())} "
        f"changed line(s) in {len(changed)} Dart file(s)."
    )

    if findings:
        print("\nBlocking test/debug imports:")
        for finding in findings:
            emit_annotation("error", finding)
            print(f"- {finding.path}:{finding.line}: {finding.message}")
        return 1

    print("Test import guard: no violations.")
    return 0


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Block test/debug imports from production code.")
    parser.add_argument("--base", help="Base git ref for diff-based checks.")
    parser.add_argument("--head", help="Head git ref for diff-based checks.")
    parser.add_argument("--all", action="store_true", help="Inspect all tracked lib Dart files.")
    return parser.parse_args()


def find_imports(changed: dict[str, set[int]]) -> list[Finding]:
    findings: list[Finding] = []

    for path, lines in sorted(changed.items()):
        for line_number, line in selected_lines(path, lines):
            match = IMPORT_RE.match(line)
            if match is None:
                continue

            message = import_message(path, match.group(1))
            if message is not None:
                findings.append(Finding(path, line_number, message))

    return findings


def import_message(source_path: str, uri: str) -> str | None:
    if uri.startswith("package:"):
        package_path = uri.removeprefix("package:")
        package_name = package_path.split("/", maxsplit=1)[0]
        if package_name in TEST_PACKAGES:
            return f"Production code must not import test package `{package_name}`."

        if package_name == PROJECT_PACKAGE:
            parts = package_path.split("/", maxsplit=1)
            if len(parts) < 2:
                return None
            target = f"lib/{parts[1]}"
            return local_import_message(target)

        return None

    if uri.startswith("dart:"):
        return None

    target = posixpath.normpath(posixpath.join(posixpath.dirname(source_path), uri))
    return local_import_message(target)


def local_import_message(target: str) -> str | None:
    normalized = target.replace("\\", "/")
    parts = normalized.split("/")
    basename = parts[-1] if parts else normalized

    if normalized.startswith("test/") or "/test/" in normalized:
        return "Production code must not import files from test directories."

    if basename.startswith(("test_", "debug_")):
        return "Production code must not import test/debug-only files."

    return None


if __name__ == "__main__":
    try:
        sys.exit(main())
    except RuntimeError as error:
        print(f"Test import guard failed: {error}", file=sys.stderr)
        sys.exit(2)
