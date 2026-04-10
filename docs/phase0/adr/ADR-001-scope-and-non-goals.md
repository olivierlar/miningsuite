# ADR-001: Scope and Non-goals

- **Status:** Validated (Phase 0)
- **Date:** 2026-03-05

## Context
MiningSuite is being redesigned as a Python-native framework focused on simplicity, scalability, and extensibility.

## Decision
- Build a new Python-native framework.
- Prioritize simple command UX, batch analysis, and extensibility.
- Treat real-time processing and strict MATLAB parity as non-goals for v1.

## Consequences
- Faster design evolution and cleaner architecture.
- Need migration guides for legacy users.

## Open questions
- Which legacy features are mandatory in v1 vs v1.x?
