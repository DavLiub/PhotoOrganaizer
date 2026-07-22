# 2026-07-22 Project Checks Workflow

## Changed

- Renamed the main validation workflow to `Project Checks`.
- Split validation into separate check jobs for Flutter formatting, analysis, tests, architecture layers, test imports, SDK leaks, secrets, and naming.
- Moved script-based checks into dedicated project guard jobs.
- Updated release tagging to wait for `Project Checks`.
- Updated validation documentation and branch protection guidance.

## Notes

Project guard jobs remain diff-based for custom scripts. Naming is advisory. Layering, test import, SDK leak, and secret checks are blocking.
