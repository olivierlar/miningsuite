# ADR-006: Batch Execution and Caching Strategy

- **Status:** Proposed
- **Date:** 2026-03-05

## Context
Primary performance goal is efficient offline analysis at corpus scale.

## Decision
- First-class batch executor with resumable jobs.
- Content-addressed caching of intermediate node outputs.
- Deterministic job manifests and run summaries.

## Consequences
- Major throughput gains on large corpora.
- Requires careful cache invalidation/versioning design.

## Open questions
- Which cache backend(s) should be supported in v1?
