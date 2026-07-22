#!/usr/bin/env python3
from __future__ import annotations

import argparse
import posixpath
import re
import subprocess
import sys
from dataclasses import dataclass
from pathlib import Path


REPO_ROOT = Path(__file__).resolve().parents[2]
PROJECT_PACKAGE = "photo_organizer"
LAYER_NAMES = {"domain", "application", "infrastructure", "presentation", "bootstrap"}
GENERIC_NAMES = {"utils", "helper", "helpers", "manager", "managers", "common"}

IMPORT_RE = re.compile(r"^\s*import\s+['\"]([^'\"]+)['\"]")
HUNK_RE = re.compile(r"@@ -\d+(?:,\d+)? \+(\d+)(?:,(\d+))? @@")
TYPE_DECL_RE = re.compile(
    r"\b(?:abstract\s+interface\s+class|class|enum|mixin|extension|typedef)\s+([A-Za-z_]\w*)"
)
FUNCTION_DECL_RE = re.compile(
    r"^\s*(?:static\s+)?(?:Future|Stream|void|bool|int|double|String|Object|Map|List|Set|Iterable)"
    r"(?:<[^>]+>)?\??\s+([a-zA-Z_]\w*)\s*\("
)


@dataclass(frozen=True)
class Finding:
  path: str
  line: int
  message: str


def main() -> int:
  args = parse_args()
  changed_lines = collect_changed_lines(args.base, args.head, args.all)
  dart_lines = {
      path: lines
      for path, lines in changed_lines.items()
      if path.startswith("lib/") and path.endswith(".dart")
  }

  if not dart_lines:
    print("Architecture guard: no changed Dart lines under lib/.")
    return 0

  violations = find_layer_violations(dart_lines)
  naming = find_naming_recommendations(dart_lines)

  print(
      f"Architecture guard inspected {sum(len(lines) for lines in dart_lines.values())} "
      f"changed line(s) in {len(dart_lines)} Dart file(s)."
  )

  if naming:
    print("\nAdvisory naming report:")
    for finding in naming:
      emit_annotation("warning", finding)
      print(f"- {finding.path}:{finding.line}: {finding.message}")
  else:
    print("Advisory naming report: no findings.")

  if violations:
    print("\nBlocking architecture violations:")
    for finding in violations:
      emit_annotation("error", finding)
      print(f"- {finding.path}:{finding.line}: {finding.message}")
    return 1

  print("Blocking architecture guard: no violations.")
  return 0


def parse_args() -> argparse.Namespace:
  parser = argparse.ArgumentParser(
      description="Check changed Dart lines for layer violations and naming recommendations."
  )
  parser.add_argument("--base", help="Base git ref for diff-based checks.")
  parser.add_argument("--head", help="Head git ref for diff-based checks.")
  parser.add_argument(
      "--all",
      action="store_true",
      help="Inspect all tracked Dart files instead of only changed lines.",
  )
  return parser.parse_args()


def collect_changed_lines(base: str | None, head: str | None, scan_all: bool) -> dict[str, set[int]]:
  if scan_all:
    return all_tracked_dart_lines()

  if base and head and not is_zero_ref(base):
    return changed_lines_from_diff(["diff", "--unified=0", "--diff-filter=ACMRT", base, head, "--"])

  changed = changed_lines_from_diff(["diff", "--unified=0", "--diff-filter=ACMRT", "--"])
  staged = changed_lines_from_diff(["diff", "--cached", "--unified=0", "--diff-filter=ACMRT", "--"])
  untracked = untracked_file_lines()
  return merge_line_maps(changed, staged, untracked)


def all_tracked_dart_lines() -> dict[str, set[int]]:
  result: dict[str, set[int]] = {}
  for path in run_git(["ls-files", "lib/**/*.dart"]):
    full_path = REPO_ROOT / path
    if full_path.exists():
      line_count = len(full_path.read_text(encoding="utf-8").splitlines())
      result[path] = set(range(1, line_count + 1))
  return result


def untracked_file_lines() -> dict[str, set[int]]:
  result: dict[str, set[int]] = {}
  for path in run_git(["ls-files", "--others", "--exclude-standard", "lib/**/*.dart"]):
    full_path = REPO_ROOT / path
    if full_path.exists():
      line_count = len(full_path.read_text(encoding="utf-8").splitlines())
      result[path] = set(range(1, line_count + 1))
  return result


def changed_lines_from_diff(args: list[str]) -> dict[str, set[int]]:
  result: dict[str, set[int]] = {}
  current_path: str | None = None

  for line in run_git(args):
    if line.startswith("+++ b/"):
      current_path = line.removeprefix("+++ b/")
      result.setdefault(current_path, set())
      continue

    if current_path is None:
      continue

    match = HUNK_RE.match(line)
    if match is None:
      continue

    start = int(match.group(1))
    count = int(match.group(2) or "1")
    if count == 0:
      continue

    result[current_path].update(range(start, start + count))

  return result


def merge_line_maps(*maps: dict[str, set[int]]) -> dict[str, set[int]]:
  result: dict[str, set[int]] = {}
  for line_map in maps:
    for path, lines in line_map.items():
      result.setdefault(path, set()).update(lines)
  return result


def find_layer_violations(changed_lines: dict[str, set[int]]) -> list[Finding]:
  findings: list[Finding] = []

  for path, lines in sorted(changed_lines.items()):
    source_layer = layer_for_path(path)
    if source_layer is None:
      continue

    for line_number, line in selected_lines(path, lines):
      match = IMPORT_RE.match(line)
      if match is None:
        continue

      target_layer = layer_for_import(path, match.group(1))
      if target_layer is None:
        continue

      message = layer_violation(source_layer, target_layer)
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


def find_naming_recommendations(changed_lines: dict[str, set[int]]) -> list[Finding]:
  findings: list[Finding] = []

  for path, lines in sorted(changed_lines.items()):
    file_name = Path(path).stem
    normalized_file_name = file_name.removesuffix("_test")
    file_message = naming_message(normalized_file_name)
    if file_message is not None:
      findings.append(Finding(path, 1, f"Review file name `{file_name}`: {file_message}"))

    for line_number, line in selected_lines(path, lines):
      for name in names_from_line(line):
        message = naming_message(name)
        if message is not None:
          findings.append(Finding(path, line_number, f"Review `{name}`: {message}"))

  return deduplicate_findings(findings)


def names_from_line(line: str) -> list[str]:
  names: list[str] = []
  names.extend(match.group(1) for match in TYPE_DECL_RE.finditer(line))

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


def selected_lines(path: str, line_numbers: set[int]) -> list[tuple[int, str]]:
  full_path = REPO_ROOT / path
  if not full_path.exists():
    return []

  lines = full_path.read_text(encoding="utf-8").splitlines()
  return [
      (line_number, lines[line_number - 1])
      for line_number in sorted(line_numbers)
      if 1 <= line_number <= len(lines)
  ]


def layer_for_import(source_path: str, import_uri: str) -> str | None:
  if import_uri.startswith(("dart:", "package:flutter/", "package:flutter_test/")):
    return None

  package_prefix = f"package:{PROJECT_PACKAGE}/"
  if import_uri.startswith(package_prefix):
    package_path = import_uri.removeprefix(package_prefix)
    return layer_for_path(f"lib/{package_path}")

  if import_uri.startswith("package:"):
    return None

  resolved_path = posixpath.normpath(posixpath.join(posixpath.dirname(source_path), import_uri))
  return layer_for_path(resolved_path)


def layer_for_path(path: str) -> str | None:
  parts = path.replace("\\", "/").split("/")
  if len(parts) < 2 or parts[0] != "lib":
    return None

  layer = parts[1]
  return layer if layer in LAYER_NAMES else None


def deduplicate_findings(findings: list[Finding]) -> list[Finding]:
  seen: set[Finding] = set()
  result: list[Finding] = []
  for finding in findings:
    if finding in seen:
      continue
    seen.add(finding)
    result.append(finding)
  return result


def emit_annotation(level: str, finding: Finding) -> None:
  escaped_message = finding.message.replace("%", "%25").replace("\n", "%0A").replace("\r", "%0D")
  print(f"::{level} file={finding.path},line={finding.line}::{escaped_message}")


def run_git(args: list[str]) -> list[str]:
  completed = subprocess.run(
      ["git", *args],
      cwd=REPO_ROOT,
      check=False,
      capture_output=True,
      text=True,
  )
  if completed.returncode != 0:
    raise RuntimeError(completed.stderr.strip() or completed.stdout.strip())
  return completed.stdout.splitlines()


def is_zero_ref(ref: str) -> bool:
  return bool(re.fullmatch(r"0{40}", ref.strip()))


if __name__ == "__main__":
  try:
    sys.exit(main())
  except RuntimeError as error:
    print(f"Architecture guard failed: {error}", file=sys.stderr)
    sys.exit(2)
