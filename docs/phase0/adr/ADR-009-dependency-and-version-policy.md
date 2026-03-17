# ADR-009: Dependency and Version Management Policy

- **Status:** Proposed
- **Date:** 2026-03-17

## Context
Phase 0 raised dependency/version complexity risks for a scientific Python framework.

## Decision
- Define minimal core dependencies and separate optional extras.
- Maintain tested version ranges plus CI matrix checks.
- Use lockfiles for development/CI reproducibility.
- Adopt `uv` as the preferred environment/lock tool (subject to final team validation).

## Consequences
- Reduced dependency drift and onboarding friction.
- Clearer boundaries between required runtime and optional capabilities.

## Open questions
- Should a fallback (pip/venv-only) path be officially documented for contributors?
