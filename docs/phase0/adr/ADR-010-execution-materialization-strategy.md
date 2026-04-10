# ADR-010: Execution Materialization Strategy (Chunking, Memory, Disk)

- **Status:** Validated (Phase 0)
- **Date:** 2026-03-17

## Context
Phase 0 highlighted the need to clarify when Orpheon should process in-memory, by chunks, or via file-backed intermediates.

## Decision
- Benchmark and define explicit rules for:
  - in-memory execution,
  - chunk decomposition,
  - file-backed/intermediate materialization.
- Tie strategy selection to dataset size, memory budget, and recovery/reproducibility needs.
- Evaluate existing Python tooling before custom implementation.

## Consequences
- Better performance predictability on large corpora.
- Clearer reproducibility and failure-recovery behavior.

## Open questions
- Which storage format(s) should be default for file-backed intermediates?
