# ADR 0010: Avoid DI and Model Codegen in Foundation

## Context

The current skeleton already has a Bootstrap composition root. The project does not yet have enough concrete dependencies or model complexity to justify dependency injection containers or model code generators.

## Decision

Do not add a DI container, `freezed`, or general model code generation during foundation work.

Use explicit constructors and the existing composition root until duplication or complexity proves that an added tool is worth its maintenance cost.

## Consequences

- Dependency wiring stays easy to inspect.
- Domain models remain plain Dart while requirements are still evolving.
- Build tooling remains simpler until storage and state management require generators.
- The decision can be revisited after the first real feature slices.

## Alternatives Considered

- `get_it`: mature and useful for service location, but unnecessary while the composition root is small.
- `freezed`: useful for rich immutable models, but adds generator workflow before model stability.
- Riverpod generator: deferred until provider count and repeated boilerplate justify it.

## Research Notes

`build_runner`, `freezed`, and Riverpod generator are mature packages, but they add generated files and tooling complexity. Current project size does not justify them yet.
