#!/usr/bin/env python3
from __future__ import annotations

import argparse
import re
import sys

from diff_lines import Finding, collect_files, collect_lines, emit_annotation, selected_lines


SECRET_FILE_RE = re.compile(
    r"(?i)(^|/)(key\.properties|google-services\.json|googleservice-info\.plist|.*\.(jks|keystore|p12|pem|key|env))$"
)
SECRET_VALUE_RE = re.compile(
    r"(?i)\b(api[_-]?key|client[_-]?secret|private[_-]?key|storepassword|keypassword|keystore[_-]?password)\b"
    r"\s*[:=]\s*['\"]?([^'\"\s]+)"
)
SAFE_VALUE_RE = re.compile(
    r"(?i)(replace|placeholder|example|dummy|todo|changeme|your_|<|\$\{\{|keystoreproperties|system\.getenv|process\.env)"
)


def main() -> int:
    args = parse_args()
    changed_files = collect_files(args.base, args.head, args.all)
    changed_lines = collect_lines(args.base, args.head, args.all)
    findings = find_secret_files(changed_files) + find_secret_values(changed_lines)

    print(
        f"Secret guard inspected {len(changed_files)} changed file(s) and "
        f"{sum(len(lines) for lines in changed_lines.values())} changed line(s)."
    )

    if findings:
        print("\nBlocking secret findings:")
        for finding in findings:
            emit_annotation("error", finding)
            print(f"- {finding.path}:{finding.line}: {finding.message}")
        return 1

    print("Secret guard: no findings.")
    return 0


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Block common secret files and secret assignments.")
    parser.add_argument("--base", help="Base git ref for diff-based checks.")
    parser.add_argument("--head", help="Head git ref for diff-based checks.")
    parser.add_argument("--all", action="store_true", help="Inspect all tracked files.")
    return parser.parse_args()


def find_secret_files(paths: list[str]) -> list[Finding]:
    findings: list[Finding] = []
    for path in paths:
        normalized = path.replace("\\", "/")
        if normalized.endswith(".example"):
            continue
        if SECRET_FILE_RE.search(normalized):
            findings.append(Finding(path, 1, "Secret-like file must not be committed."))
    return findings


def find_secret_values(changed_lines: dict[str, set[int]]) -> list[Finding]:
    findings: list[Finding] = []
    for path, lines in sorted(changed_lines.items()):
        for line_number, line in selected_lines(path, lines):
            match = SECRET_VALUE_RE.search(line)
            if match is None:
                continue

            value = match.group(2)
            if SAFE_VALUE_RE.search(value):
                continue

            findings.append(
                Finding(path, line_number, f"Possible secret assignment for `{match.group(1)}`.")
            )
    return findings


if __name__ == "__main__":
    try:
        sys.exit(main())
    except RuntimeError as error:
        print(f"Secret guard failed: {error}", file=sys.stderr)
        sys.exit(2)
