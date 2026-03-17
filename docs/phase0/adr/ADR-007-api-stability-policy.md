# ADR-007: API Stability and Deprecation Policy

- **Status:** Proposed
- **Date:** 2026-03-05

## Context
After initial development, users need a stable API and predictable evolution.

## Decision
- Semantic versioning from v1.0 onward.
- Public API surface explicitly documented.
- Deprecations require warning period and migration notes.

## Consequences
- Higher trust and adoption.
- Requires discipline in release management.

## Open questions
- Define exact deprecation window duration (e.g., 1 minor, 2 minors).
