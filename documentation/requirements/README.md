# Requirements

This directory contains English requirement documents derived from the original local source specifications in `documentation/source documentation`.

The original source documents remain the raw input. Files here are the Git-tracked, English working requirements used by implementation and review.

## Structure

| Directory | Content |
|---|---|
| [general](general) | Product overview and release-level requirements. |
| [architecture](architecture) | Intended architecture and layer boundaries. |
| [functional-specification](functional-specification) | MVP workflows and behavior. |
| [data-model](data-model) | Logical entities, relationships, and persistence expectations. |
| [ui](ui) | Screen structure, navigation, states, and UX requirements. |
| [non-functional](non-functional) | Performance, reliability, security, compatibility, and observability. |
| [background-processing](background-processing) | Background jobs, scheduling, retry, and recovery expectations. |
| [error-handling](error-handling) | Error categories, user-facing recovery, and diagnostics. |
| [monetization](monetization) | Free/Premium access model and business constraints. |
| [roadmap](roadmap) | Release boundaries and future product direction. |

## Source Mapping

- `general/product-overview.md` derives from `00. Smart_Photo_Archive_Overview.md`.
- `general/release-1.0-requirements.md` derives from `02 Smart_Photo_Archive_TZ_v1.0_AccessControl_Rev2.md`.
- `architecture/release-1.0-architecture.md` derives from `03-1 Smart_Photo_Archive_PZ-1_Architecture_v1.0_AccessControl_Rev2.md`.
- `functional-specification/release-1.0.md` derives from `03-2. Smart_Photo_Archive_PZ-2_Functional_Release_1.0_v1.0.md`.
- `ui/release-1.0.md` derives from `03-3 ПЗ-3_UI_Release_1.0_Draft_v4.md`.
- `non-functional/release-1.0.md` derives from `03-4 ПЗ-4_Нефункциональные_требования_Release_1.0_Draft_v2.md`.
- `roadmap/product-roadmap.md` derives from `03-5 ПЗ-5_Roadmap_развития_продукта_Release_1.0_Draft.md`.
- `data-model/release-1.0.md` derives from `03-6 Smart_Photo_Archive_PZ-6_Data_Model_Full_Rev3.md`.
- `background-processing/release-1.0.md` derives from `03-7 ПЗ-7_Фоновая_обработка_Background_Processing_Release_1.0_Draft.md`.
- `error-handling/release-1.0.md` derives from `03-8 ПЗ-8_Обработка_ошибок_и_восстановление_Release_1.0_Draft.md`.
- `monetization/release-1.0.md` derives from `03-9 ПЗ-9_Монетизация_и_бизнес_модель_Release_1.0_Rev2.md`.
