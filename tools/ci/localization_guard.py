#!/usr/bin/env python3
from __future__ import annotations

import argparse
import re
import sys

from diff_lines import Finding, collect_files, emit_annotation, read_lines


LOCALIZATION_PATH = "lib/presentation/localization/app_localizations.dart"
LOCALE_RE = re.compile(r"Locale\(['\"]([a-z]{2})['\"]\)")
MAP_DECL_RE = re.compile(r"const\s+_([a-z]{2})\s*=\s*\{")
KEY_RE = re.compile(r"^\s*['\"]([^'\"]+)['\"]\s*:", re.MULTILINE)
MOJIBAKE_MARKERS = [
    "Ã",
    "Ã‘",
    "Ã°",
    "Ã¢",
    "Ð",
    "Ñ",
    "ðŸ",
    "â†",
    "â€",
]


def main() -> int:
    args = parse_args()
    files = collect_files(args.base, args.head, args.all, [LOCALIZATION_PATH])

    if not files and not args.all:
        print("Localization guard: localization file was not changed.")
        return 0

    lines = read_lines(LOCALIZATION_PATH)
    if lines is None:
        raise RuntimeError(f"{LOCALIZATION_PATH} is missing.")

    text = "\n".join(lines)
    findings = find_violations(text)

    print("Localization guard inspected app localization keys.")

    if findings:
        print("\nBlocking localization violations:")
        for finding in findings:
            emit_annotation("error", finding)
            print(f"- {finding.path}:{finding.line}: {finding.message}")
        return 1

    print(
        "Localization guard: supported locales, translation keys, and string encoding are valid."
    )
    return 0


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Check app localization maps for synchronized keys.")
    parser.add_argument("--base", help="Base git ref for diff-based checks.")
    parser.add_argument("--head", help="Head git ref for diff-based checks.")
    parser.add_argument("--all", action="store_true", help="Inspect localization files.")
    return parser.parse_args()


def find_violations(text: str) -> list[Finding]:
    findings: list[Finding] = []
    locales = supported_locales(text)
    maps = translation_maps(text)

    if not locales:
        findings.append(Finding(LOCALIZATION_PATH, 1, "No supported locales were found."))
        return findings

    missing_maps = locales - set(maps)
    extra_maps = set(maps) - locales

    if missing_maps:
        findings.append(
            Finding(
                LOCALIZATION_PATH,
                1,
                f"Missing translation map(s): {', '.join('_' + item for item in sorted(missing_maps))}.",
            )
        )

    if extra_maps:
        findings.append(
            Finding(
                LOCALIZATION_PATH,
                1,
                f"Translation map(s) not listed in supportedLocales: {', '.join(sorted(extra_maps))}.",
            )
        )

    shared_locales = sorted(locales & set(maps))
    if not shared_locales:
        return findings

    base_locale = "en" if "en" in maps else shared_locales[0]
    base_keys = maps[base_locale]

    for locale in shared_locales:
        keys = maps[locale]
        missing_keys = base_keys - keys
        extra_keys = keys - base_keys

        if missing_keys:
            findings.append(
                Finding(
                    LOCALIZATION_PATH,
                    line_for_map(text, locale),
                    f"Locale `{locale}` is missing key(s): {', '.join(sorted(missing_keys))}.",
                )
            )

        if extra_keys:
            findings.append(
                Finding(
                    LOCALIZATION_PATH,
                    line_for_map(text, locale),
                    f"Locale `{locale}` has extra key(s): {', '.join(sorted(extra_keys))}.",
                )
            )

    findings.extend(mojibake_findings(text))

    return findings


def supported_locales(text: str) -> set[str]:
    prefix = text.split("static const List<LocalizationsDelegate", maxsplit=1)[0]
    return set(LOCALE_RE.findall(prefix))


def translation_maps(text: str) -> dict[str, set[str]]:
    result: dict[str, set[str]] = {}

    for match in MAP_DECL_RE.finditer(text):
        locale = match.group(1)
        start = match.end() - 1
        end = matching_brace(text, start)
        result[locale] = set(KEY_RE.findall(text[start:end]))

    return result


def matching_brace(text: str, start: int) -> int:
    depth = 0
    quote: str | None = None
    escaped = False

    for index in range(start, len(text)):
        char = text[index]

        if quote is not None:
            if escaped:
                escaped = False
            elif char == "\\":
                escaped = True
            elif char == quote:
                quote = None
            continue

        if char in {"'", '"'}:
            quote = char
        elif char == "{":
            depth += 1
        elif char == "}":
            depth -= 1
            if depth == 0:
                return index

    raise RuntimeError("Could not parse localization map braces.")


def line_for_map(text: str, locale: str) -> int:
    match = re.search(rf"const\s+_{re.escape(locale)}\s*=\s*\{{", text)
    if match is None:
        return 1
    return text[: match.start()].count("\n") + 1


def mojibake_findings(text: str) -> list[Finding]:
    findings: list[Finding] = []

    for line_number, line in enumerate(text.splitlines(), start=1):
        marker = next((item for item in MOJIBAKE_MARKERS if item in line), None)
        if marker is None:
            continue

        findings.append(
            Finding(
                LOCALIZATION_PATH,
                line_number,
                f"Localization value appears to contain mojibake marker `{marker}`.",
            )
        )

    return findings


if __name__ == "__main__":
    try:
        sys.exit(main())
    except RuntimeError as error:
        print(f"Localization guard failed: {error}", file=sys.stderr)
        sys.exit(2)
