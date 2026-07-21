# 2026-07-21 Foundation Validation and CI

## Changed

- Added GitHub Actions workflow for Flutter validation.
- Added `.gitattributes` for line ending normalization.
- Documented local and CI validation commands.

## Notes

The CI workflow checks formatting, analyzer results, and tests. Android debug APK packaging is not part of this initial workflow to keep PR validation fast.
