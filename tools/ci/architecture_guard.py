#!/usr/bin/env python3
from __future__ import annotations

import argparse
import posixpath
import re
import sys

from diff_lines import Finding, collect_lines, emit_annotation, selected_lines


PROJECT_PACKAGE = "photo_organizer"
LAYERS = {"domain", "application", "infrastructure", "presentation", "bootstrap"}
IMPORT_RE = re.compile(r"^\s*import\s+['\"]([^'\"]+)['\"]")


def main() -> int:
    args = parse_args()
    changed = collect_lines(args.base, args.head, args.all, ["lib/**/*.dart"])

    if not changed:
        print("Architecture layers: no changed Dart lines under lib/.")
        return 0

    findings = find_violations(changed)
    print(
        f"Architecture layers inspected {sum(len(lines) for lines in changed.values())} "
        f"changed line(s) in {len(changed)} Dart file(s)."
    )

    if findings:
        print("\nBlocking architecture layer violations:")
        for finding in findings:
            emit_annotation("error", finding)
            print(f"- {finding.path}:{finding.line}: {finding.message}")
        return 1

    print("Architecture layers: no violations.")
    return 0


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Check changed Dart imports for layer violations.")
    parser.add_argument("--base", help="Base git ref for diff-based checks.")
    parser.add_argument("--head", help="Head git ref for diff-based checks.")
    parser.add_argument("--all", action="store_true", help="Inspect all tracked Dart files.")
    return parser.parse_args()


def find_violations(changed: dict[str, set[int]]) -> list[Finding]:
    findings: list[Finding] = []

    for path, lines in sorted(changed.items()):
        source = layer_for_path(path)
        if source is None:
            continue

        for line_number, line in selected_lines(path, lines):
            match = IMPORT_RE.match(line)
            if match is None:
                continue

            target = layer_for_import(path, match.group(1))
            if target is None:
                continue

            message = layer_violation(source, target)
            if message is not None:
                findings.append(Finding(path, line_number, message))

    return findings


def layer_violation(source: str, target: str) -> str | None:
    if source == "domain" and target != "domain":
        return f"Domain must not import {target}."

    if source == "application" and target not in {"application", "domain"}:
        return f"Application must not import {target}."

    if source == "presentation" and target == "infrastructure":
        return "Presentation must not import Infrastructure."

    return None


def layer_for_import(source_path: str, import_uri: str) -> str | None:
    if import_uri.startswith(("dart:", "package:flutter/", "package:flutter_test/")):
        return None

    package_prefix = f"package:{PROJECT_PACKAGE}/"
    if import_uri.startswith(package_prefix):
        package_path = import_uri.removeprefix(package_prefix)
        return layer_for_path(f"lib/{package_path}")

    if import_uri.startswith("package:"):
        return None

    resolved = posixpath.normpath(posixpath.join(posixpath.dirname(source_path), import_uri))
    return layer_for_path(resolved)


def layer_for_path(path: str) -> str | None:
    parts = path.replace("\\", "/").split("/")
    if len(parts) < 2 or parts[0] != "lib":
        return None

    layer = parts[1]
    return layer if layer in LAYERS else None


if __name__ == "__main__":
    try:
        sys.exit(main())
    except RuntimeError as error:
        print(f"Architecture layers failed: {error}", file=sys.stderr)
        sys.exit(2)
