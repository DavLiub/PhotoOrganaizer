from __future__ import annotations

import re
import subprocess
from dataclasses import dataclass
from pathlib import Path


REPO_ROOT = Path(__file__).resolve().parents[2]
HUNK_RE = re.compile(r"@@ -\d+(?:,\d+)? \+(\d+)(?:,(\d+))? @@")


@dataclass(frozen=True)
class Finding:
    path: str
    line: int
    message: str


def collect_lines(
    base: str | None,
    head: str | None,
    scan_all: bool,
    pathspecs: list[str] | None = None,
) -> dict[str, set[int]]:
    pathspecs = pathspecs or []

    if scan_all:
        return all_tracked_lines(pathspecs)

    if base and head and not is_zero_ref(base):
        return changed_lines(["diff", "--unified=0", "--diff-filter=ACMRT", base, head, "--", *pathspecs])

    changed = changed_lines(["diff", "--unified=0", "--diff-filter=ACMRT", "--", *pathspecs])
    staged = changed_lines(["diff", "--cached", "--unified=0", "--diff-filter=ACMRT", "--", *pathspecs])
    untracked = untracked_lines(pathspecs)
    return merge_lines(changed, staged, untracked)


def collect_files(
    base: str | None,
    head: str | None,
    scan_all: bool,
    pathspecs: list[str] | None = None,
) -> list[str]:
    pathspecs = pathspecs or []

    if scan_all:
        return run_git(["ls-files", *pathspecs])

    if base and head and not is_zero_ref(base):
        return run_git(["diff", "--name-only", "--diff-filter=ACMRT", base, head, "--", *pathspecs])

    changed = run_git(["diff", "--name-only", "--diff-filter=ACMRT", "--", *pathspecs])
    staged = run_git(["diff", "--cached", "--name-only", "--diff-filter=ACMRT", "--", *pathspecs])
    untracked = run_git(["ls-files", "--others", "--exclude-standard", *pathspecs])
    return sorted(set(changed + staged + untracked))


def all_tracked_lines(pathspecs: list[str]) -> dict[str, set[int]]:
    result: dict[str, set[int]] = {}
    for path in run_git(["ls-files", *pathspecs]):
        line_count = text_line_count(path)
        if line_count is not None:
            result[path] = set(range(1, line_count + 1))
    return result


def untracked_lines(pathspecs: list[str]) -> dict[str, set[int]]:
    result: dict[str, set[int]] = {}
    for path in run_git(["ls-files", "--others", "--exclude-standard", *pathspecs]):
        line_count = text_line_count(path)
        if line_count is not None:
            result[path] = set(range(1, line_count + 1))
    return result


def changed_lines(args: list[str]) -> dict[str, set[int]]:
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


def selected_lines(path: str, line_numbers: set[int]) -> list[tuple[int, str]]:
    lines = read_lines(path)
    if lines is None:
        return []

    return [
        (line_number, lines[line_number - 1])
        for line_number in sorted(line_numbers)
        if 1 <= line_number <= len(lines)
    ]


def read_lines(path: str) -> list[str] | None:
    full_path = REPO_ROOT / path
    if not full_path.exists():
        return None

    try:
        return full_path.read_text(encoding="utf-8").splitlines()
    except UnicodeDecodeError:
        return None


def text_line_count(path: str) -> int | None:
    lines = read_lines(path)
    return None if lines is None else len(lines)


def merge_lines(*maps: dict[str, set[int]]) -> dict[str, set[int]]:
    result: dict[str, set[int]] = {}
    for line_map in maps:
        for path, lines in line_map.items():
            result.setdefault(path, set()).update(lines)
    return result


def emit_annotation(level: str, finding: Finding) -> None:
    message = finding.message.replace("%", "%25").replace("\n", "%0A").replace("\r", "%0D")
    print(f"::{level} file={finding.path},line={finding.line}::{message}")


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
