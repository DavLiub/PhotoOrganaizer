#!/usr/bin/env python3
from __future__ import annotations

import argparse
import re
import sys

from diff_lines import Finding, collect_lines, emit_annotation, selected_lines


PROJECT_PACKAGE = "photo_organizer"
IMPORT_RE = re.compile(r"^\s*import\s+['\"]([^'\"]+)['\"]")
PLATFORM_DART_LIBS = {
    "dart:ffi",
    "dart:html",
    "dart:io",
    "dart:js",
    "dart:js_interop",
    "dart:ui",
}
APPLICATION_BLOCKED_PACKAGES = {
    "drift",
    "drift_flutter",
    "extension_google_sign_in_as_googleapis_auth",
    "firebase_core",
    "firebase_crashlytics",
    "flutter",
    "flutter_secure_storage",
    "flutter_test",
    "google_sign_in",
    "googleapis",
    "googleapis_auth",
    "in_app_purchase",
    "path_provider",
    "permission_handler",
    "photo_manager",
    "sqflite",
    "sqlite3",
    "sqlite3_flutter_libs",
    "workmanager",
}


def main() -> int:
    args = parse_args()
    changed = collect_lines(args.base, args.head, args.all, ["lib/domain/**/*.dart", "lib/application/**/*.dart"])

    if not changed:
        print("SDK leak guard: no changed Domain/Application Dart lines.")
        return 0

    findings = find_leaks(changed)
    print(
        f"SDK leak guard inspected {sum(len(lines) for lines in changed.values())} "
        f"changed line(s) in {len(changed)} Dart file(s)."
    )

    if findings:
        print("\nBlocking SDK/plugin leaks:")
        for finding in findings:
            emit_annotation("error", finding)
            print(f"- {finding.path}:{finding.line}: {finding.message}")
        return 1

    print("SDK leak guard: no leaks.")
    return 0


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Block SDK/plugin leaks into Domain and Application.")
    parser.add_argument("--base", help="Base git ref for diff-based checks.")
    parser.add_argument("--head", help="Head git ref for diff-based checks.")
    parser.add_argument("--all", action="store_true", help="Inspect all tracked target files.")
    return parser.parse_args()


def find_leaks(changed: dict[str, set[int]]) -> list[Finding]:
    findings: list[Finding] = []

    for path, lines in sorted(changed.items()):
        layer = layer_for_path(path)
        if layer not in {"domain", "application"}:
            continue

        for line_number, line in selected_lines(path, lines):
            match = IMPORT_RE.match(line)
            if match is None:
                continue

            message = leak_message(layer, match.group(1))
            if message is not None:
                findings.append(Finding(path, line_number, message))

    return findings


def leak_message(layer: str, uri: str) -> str | None:
    if uri in PLATFORM_DART_LIBS:
        return f"{layer.title()} must not import platform library `{uri}`."

    if not uri.startswith("package:"):
        return None

    package_name = uri.removeprefix("package:").split("/", maxsplit=1)[0]

    if package_name == PROJECT_PACKAGE:
        return None

    if layer == "domain":
        return f"Domain must not import external package `{package_name}`."

    if layer == "application" and package_name in APPLICATION_BLOCKED_PACKAGES:
        return f"Application must not import SDK/plugin package `{package_name}`."

    return None


def layer_for_path(path: str) -> str | None:
    parts = path.replace("\\", "/").split("/")
    if len(parts) < 2 or parts[0] != "lib":
        return None
    return parts[1]


if __name__ == "__main__":
    try:
        sys.exit(main())
    except RuntimeError as error:
        print(f"SDK leak guard failed: {error}", file=sys.stderr)
        sys.exit(2)
