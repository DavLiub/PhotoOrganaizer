# ADR 0020: Use Unified Library Screen

## Status

Accepted

## Context

The initial UI separated Home as a scanner screen and Photos as the indexed library. During device testing this made the main flow unclear: users expect to open the app, see their photo library, start or stop scanning from the same place, and watch thumbnails appear while indexing continues.

The UI also exposed technical counters such as indexed photos and source count. These are useful for diagnostics but not for the primary user workflow.

## Decision

Use one unified Library screen as the primary app screen after media permission is available.

The Library screen owns:

- category filtering: All, Camera, Social, Downloads, Screenshots;
- sort selection UI, starting with Date descending;
- visible photo count;
- live thumbnail grid with backup status;
- primary actions: Scan/Stop and Backup with percentage.

The Home destination is removed from the main bottom navigation. Settings becomes a bottom navigation destination.

`Scan` means continue discovering and indexing currently accessible photos. `Stop` cancels further discovery but allows already delivered batches to finish indexing.

Full `Rescan` is a separate heavier workflow for reconciling deleted, changed, or permission-limited media. It should not be a primary bottom action. It will be planned as a Settings/overflow workflow later.

## Consequences

- Presentation becomes simpler for phone testing: one screen shows library state and scan control.
- Technical counters remain available internally but are not shown in the main UI.
- Sorting can be introduced incrementally: the UI state exists before repository ordering changes.
- Future source include/exclude settings and full rescan should be added without overloading the main action row.
