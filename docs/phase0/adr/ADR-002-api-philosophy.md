# ADR-002: API Philosophy (Guided Familiarity)

- **Status:** Validated (Phase 0)
- **Date:** 2026-03-05

## Context
MiningSuite users should onboard quickly, but legacy compatibility must not degrade architecture quality.

## Decision
- Adopt guided familiarity: recognizable concepts and names where useful.
- Prefer consistent Pythonic API patterns over historical quirks.
- Provide migration mappings and examples.

## Consequences
- Easier migration for existing users.
- Some legacy commands will require small rewrites.

## Open questions
- Define final naming conventions and deprecation policy language.
