#!/usr/bin/env python3
"""Post an advisory AI review comment for a GitHub pull request."""

from __future__ import annotations

import json
import os
import sys
import urllib.error
import urllib.request


COMMENT_MARKER = "<!-- photo-organaizer-ai-review -->"
MAX_DIFF_CHARS = 60000
OPENAI_URL = "https://api.openai.com/v1/responses"
GITHUB_API = "https://api.github.com"


def main() -> int:
    repo = require_env("GITHUB_REPOSITORY")
    pr_number = require_env("PR_NUMBER")
    pr_title = os.environ.get("PR_TITLE", "")
    github_token = require_env("GITHUB_TOKEN")
    openai_key = os.environ.get("OPENAI_API_KEY", "").strip()

    if not openai_key:
        print("OPENAI_API_KEY is not configured; skipping advisory AI review.")
        return 0

    diff = get_pull_request_diff(repo, pr_number, github_token)
    if not diff.strip():
        post_or_update_comment(
            repo,
            pr_number,
            github_token,
            build_comment("No file changes were found in this pull request."),
        )
        return 0

    review = request_review(
        openai_key=openai_key,
        model=os.environ.get("OPENAI_MODEL", "gpt-5-mini"),
        pr_title=pr_title,
        diff=truncate_diff(diff),
    )

    post_or_update_comment(repo, pr_number, github_token, build_comment(review))
    return 0


def require_env(name: str) -> str:
    value = os.environ.get(name, "").strip()
    if not value:
        raise RuntimeError(f"Missing required environment variable: {name}")
    return value


def get_pull_request_diff(repo: str, pr_number: str, github_token: str) -> str:
    diff = http_text(
        f"{GITHUB_API}/repos/{repo}/pulls/{pr_number}",
        method="GET",
        token=github_token,
        accept="application/vnd.github.v3.diff",
    )
    return filter_diff(diff)


def filter_diff(diff: str) -> str:
    ignored_prefixes = (
        "documentation/source documentation/",
        "documentation/feature planning/",
        "documentation/AI log/",
        ".dart_tool/",
        "build/",
    )
    blocks: list[list[str]] = []
    current: list[str] = []
    current_path = ""

    for line in diff.splitlines():
        if line.startswith("diff --git "):
            if current and not is_ignored_path(current_path, ignored_prefixes):
                blocks.append(current)
            current = [line]
            parts = line.split(" ")
            current_path = parts[2][2:] if len(parts) >= 3 and parts[2].startswith("a/") else ""
            continue
        current.append(line)

    if current and not is_ignored_path(current_path, ignored_prefixes):
        blocks.append(current)

    return "\n".join("\n".join(block) for block in blocks)


def is_ignored_path(path: str, ignored_prefixes: tuple[str, ...]) -> bool:
    return any(path.startswith(prefix) for prefix in ignored_prefixes)


def truncate_diff(diff: str) -> str:
    if len(diff) <= MAX_DIFF_CHARS:
        return diff
    return (
        diff[:MAX_DIFF_CHARS]
        + "\n\n[Diff truncated by ai_review.py because it exceeded "
        + f"{MAX_DIFF_CHARS} characters.]"
    )


def request_review(openai_key: str, model: str, pr_title: str, diff: str) -> str:
    instructions = """You are an advisory pull request reviewer for a Flutter Android repository.
Focus on concrete risks, not praise or summary.

Review checks:
- architecture layer violations;
- direct presentation -> infrastructure dependencies;
- duplicated project-specific logic;
- poor file/function/class names, especially names containing more than three words;
- potential bugs and behavioral regressions;
- optimization opportunities;
- missing or weak automated tests;
- missing documentation updates for significant changes;
- mismatch between PR plan, code changes, and actual documentation.

Output concise Markdown with these sections:
1. Findings
2. Architecture
3. Tests
4. Documentation
5. Optimization

If there are no issues in a section, say "No issues found." Do not invent files or line numbers."""

    payload = {
        "model": model,
        "instructions": instructions,
        "input": (
            f"PR title: {pr_title}\n\n"
            "Review this git diff:\n\n"
            "```diff\n"
            f"{diff}\n"
            "```"
        ),
    }
    response = http_json(
        OPENAI_URL,
        method="POST",
        token=openai_key,
        payload=payload,
        api="openai",
    )
    text = extract_response_text(response)
    if not text:
        return "AI review completed, but the response did not contain review text."
    return text.strip()


def extract_response_text(response: dict) -> str:
    output_text = response.get("output_text")
    if isinstance(output_text, str):
        return output_text

    parts: list[str] = []
    for item in response.get("output", []):
        for content in item.get("content", []):
            if content.get("type") in {"output_text", "text"}:
                text = content.get("text")
                if isinstance(text, str):
                    parts.append(text)
    return "\n".join(parts)


def build_comment(review: str) -> str:
    return (
        f"{COMMENT_MARKER}\n"
        "## Advisory AI Review\n\n"
        "This review is advisory-only. Required merge checks remain formatter, analyzer, and tests.\n\n"
        f"{review}\n"
    )


def post_or_update_comment(
    repo: str, pr_number: str, github_token: str, body: str
) -> None:
    comments = http_json(
        f"{GITHUB_API}/repos/{repo}/issues/{pr_number}/comments",
        method="GET",
        token=github_token,
        api="github",
    )
    existing_id = None
    for comment in comments:
        if COMMENT_MARKER in comment.get("body", ""):
            existing_id = comment["id"]
            break

    if existing_id:
        http_json(
            f"{GITHUB_API}/repos/{repo}/issues/comments/{existing_id}",
            method="PATCH",
            token=github_token,
            payload={"body": body},
            api="github",
        )
    else:
        http_json(
            f"{GITHUB_API}/repos/{repo}/issues/{pr_number}/comments",
            method="POST",
            token=github_token,
            payload={"body": body},
            api="github",
        )


def http_json(
    url: str,
    *,
    method: str,
    token: str,
    api: str,
    payload: dict | None = None,
) -> dict | list:
    data = None if payload is None else json.dumps(payload).encode("utf-8")
    headers = {
        "Accept": "application/vnd.github+json" if api == "github" else "application/json",
        "Authorization": f"Bearer {token}",
    }
    if api == "github":
        headers["X-GitHub-Api-Version"] = "2022-11-28"
    if data is not None:
        headers["Content-Type"] = "application/json"

    request = urllib.request.Request(url, data=data, headers=headers, method=method)
    try:
        with urllib.request.urlopen(request, timeout=120) as response:
            body = response.read().decode("utf-8")
    except urllib.error.HTTPError as error:
        detail = error.read().decode("utf-8", errors="replace")
        raise RuntimeError(f"{api} request failed: {error.code} {detail}") from error

    return json.loads(body) if body else {}


def http_text(
    url: str,
    *,
    method: str,
    token: str,
    accept: str,
) -> str:
    request = urllib.request.Request(
        url,
        headers={
            "Accept": accept,
            "Authorization": f"Bearer {token}",
            "X-GitHub-Api-Version": "2022-11-28",
        },
        method=method,
    )
    try:
        with urllib.request.urlopen(request, timeout=120) as response:
            return response.read().decode("utf-8", errors="replace")
    except urllib.error.HTTPError as error:
        detail = error.read().decode("utf-8", errors="replace")
        raise RuntimeError(f"github diff request failed: {error.code} {detail}") from error


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except Exception as exc:
        print(f"AI review failed: {exc}", file=sys.stderr)
        raise SystemExit(1)
