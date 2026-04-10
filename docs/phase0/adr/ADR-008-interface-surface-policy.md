# ADR-008: Interface Surface Policy (API, CLI, Notebook)

- **Status:** Validated (Phase 0)
- **Date:** 2026-03-17

## Context
Phase 0 identified a cross-cutting question: should Orpheon optimize for notebooks specifically, or remain interface-agnostic.

## Decision
- Treat the Python API as the canonical interface.
- Keep CLI and notebook support as adapters over the same API contracts.
- Avoid notebook-specific behavior in core runtime/data layers.

## Consequences
- Better long-term maintainability and testability.
- Consistent behavior across scripts, notebooks, and CLI usage.

## Open questions
- Which convenience notebook visualizations should be in core vs optional extras?
