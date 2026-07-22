# 2026-07-22 Project Checks Workflow

## Changed

- Renamed the main validation workflow to `Project Checks`.
- Split validation into separate `Flutter Checks` and `Project Guards` jobs.
- Moved script-based checks into `Project Guards`.
- Updated release tagging to wait for `Project Checks`.
- Updated validation documentation and branch protection guidance.

## Notes

`Project Guards` remains diff-based for custom project scripts. Flutter formatting, analysis, and tests remain in the `Flutter Checks` job.
