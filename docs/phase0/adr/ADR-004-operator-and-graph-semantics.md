# ADR-004: Operator Contract and Graph Semantics

- **Status:** Proposed
- **Date:** 2026-03-05

## Context
Operators must remain easy to use while supporting complex pipelines and large-scale execution.

## Decision
- Operators expose explicit input/output schemas.
- Pipeline execution is graph-based with lazy-by-default semantics.
- Eager execution is available for interactive workflows.

## Consequences
- Enables caching and optimization.
- Requires strict validation and schema discipline.

## Open questions
- What should be the default materialization points in interactive use?
