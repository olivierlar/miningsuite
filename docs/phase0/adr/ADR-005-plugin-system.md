# ADR-005: Plugin System and Extension Points

- **Status:** Validated (Phase 0)
- **Date:** 2026-03-05

## Context
The project should be genuinely open source and easy to extend with new analysis modules/modalities.

## Decision
- Define a stable plugin interface for out-of-tree operators.
- Use registration/discovery mechanisms for community extensions.
- Require plugin metadata and minimum test coverage for publication.

## Consequences
- Lower contributor friction.
- Need governance for plugin quality and API changes.

## Open questions
- Will official plugin indexing be repository-based or package-index based?
