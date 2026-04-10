# ADR-003: Core Data Model and Provenance

- **Status:** Validated (Phase 0)
- **Date:** 2026-03-05

## Context
A robust data model is required for reproducibility, multimodality, and cross-operator composability.

## Decision
- Introduce typed containers (`Signal`, `Sequence`).
- Require explicit axes, units, labels, and provenance metadata.
- Ensure outputs include operation lineage (operator, params, version, timestamp/hash).

## Consequences
- Better reproducibility and debuggability.
- Slightly more upfront schema design.

## Open questions
- Should data containers be strictly immutable or copy-on-write?
