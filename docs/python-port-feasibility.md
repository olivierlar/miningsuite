# MiningSuite Python Redesign — Phase 0 Product & Architecture Charter

## Decision summary
This should be a **new Python-native framework**, not a strict compatibility clone.

Working name for the software and package ecosystem: **Orpheon**.

- Do **not** target MATLAB/MiningSuite/toolbox compatibility as a hard requirement.
- Do preserve a **low-friction path for MiningSuite users** where it does not compromise architecture quality.
- Keep the core user promise: **simple commands can build simple or complex analyses**.
- Optimize for **throughput and scalability** (especially large batch processing), not real-time constraints.
- Design the project as a true open-source platform where contributors can add modules easily.
- Commit to **API stability** after the initial core maturation window.
- Treat multimodality as a first-class direction (audio, symbolic, motion capture, biosignals, and other modalities).

## Phase 0 goals (finalized)

### 1) Product goals
1. **Usability:** one-line and short-pipeline commands for common analyses.
2. **Composability:** complex analysis graphs remain readable and declarative.
3. **Scalability:** native support for large corpus analysis and resumable jobs.
4. **Extensibility:** external contributors can add operators/modalities without editing core internals.
5. **Stability:** clear versioned API policy once v1.0 is declared.

### 2) Non-goals (for v1)
- Real-time/live DSP guarantees.
- Full behavioral parity with MATLAB implementation.
- Full backward-compatibility with every historical default.

### 3) User migration principle
Adopt **guided familiarity**, not strict compatibility:
- Keep recognizable operator naming patterns where useful to MiningSuite users.
- Provide concise migration docs and command mapping examples.
- Prefer better API design over legacy quirks when they conflict.

## Proposed architecture principles

### A. "Simple command" experience as a design constraint
- Build a high-level front API that supports concise calls (single function / fluent pipeline / config recipe).
- Make defaults meaningful and safe.
- Ensure every result embeds enough metadata/provenance for reproducibility.

### B. Layered architecture
1. **Core data layer:** typed containers (`Signal`, `Sequence`, etc.) with units, axes, provenance.
2. **Operator layer:** pure transforms with explicit input/output contracts.
3. **Execution layer:** graph planner + scheduler for single file, batch, and distributed execution.
4. **Interface layer:** simple user API + CLI + notebook-friendly display.
5. **Plugin layer:** registration and discovery for community operators.

### C. Performance model (non-real-time)
- Optimize for offline throughput:
  - chunked processing,
  - parallel batch execution,
  - caching/intermediate reuse,
  - resumable failed runs,
  - deterministic outputs.

### D. Modality-first extensibility
- Define a modality abstraction early (audio, symbolic/MIDI, MoCap, video, biosignals).
- Enforce a common operator contract while allowing modality-specific adapters.
- Ensure cross-modality fusion is possible via shared time/index alignment primitives.

## Governance and open-source model (Phase 0 deliverables)
1. **Contributor workflow:** module template, tests template, docs template.
2. **Plugin policy:** what can live out-of-tree vs in core.
3. **Review standards:** API review checklist + performance checklist + reproducibility checklist.
4. **Versioning policy:** semantic versioning and explicit deprecation windows.
5. **RFC/ADR process:** architecture changes require lightweight recorded decisions.

## Concrete Phase 0 deliverables
Current ADR set for Phase 0:
- `ADR-001`: Scope and non-goals.
- `ADR-002`: API philosophy (guided familiarity vs strict compatibility).
- `ADR-003`: Core data model and provenance requirements.
- `ADR-004`: Operator contract and execution graph semantics.
- `ADR-005`: Plugin system and extension points.
- `ADR-006`: Batch execution and caching strategy (including in-memory vs chunked vs file-backed tradeoffs).
- `ADR-007`: API stability and deprecation policy.
- `ADR-008`: Interface surface policy (API-first, CLI/notebook adapters).
- `ADR-009`: Dependency and version management policy.
- `ADR-010`: Execution materialization strategy (chunking/memory/disk rules + benchmarking criteria).
- Initial "MiningSuite user migration guide" skeleton.

## Recommended implementation sequencing
1. **Phase 0 (charter + ADR approval)**
2. **Phase 1 (core contracts)**
3. **Phase 2 (compatibility/migration aids)**
4. **Phase 3 (vertical slice)**
5. **Phase 4 (package rollout)**
6. **Phase 5 (hardening and API stabilization)**


## Phase 0 cross-cutting design questions (recommended decisions)

### 1) Interface focus: notebook-first, script-first, or both?
Recommendation: support both from day one, with a stable Python API as the source of truth.
- Keep the **core API environment-agnostic** (usable from scripts, notebooks, and CLI).
- Provide notebook-friendly display helpers, but avoid notebook-only design decisions in core layers.
- Treat CLI as an adapter over the same underlying API.

### 2) Dependency strategy and version management
Recommendation: keep the core dependency set minimal and explicit, and enforce reproducible environments.
- Define two dependency tiers:
  - **Core runtime** (strictly required),
  - **Optional extras** (audio I/O, plotting, acceleration, etc.).
- Use tested version ranges and CI matrix checks across supported Python/library versions.
- Pin lockfiles for development/CI reproducibility, while keeping install metadata range-based for users.
- Using **uv** is a strong option for fast, reproducible environment and lock management; it can simplify contributor onboarding and CI speed.

### 3) Execution strategy: chunking, intermediate files, and existing Python tools
Recommendation: this discussion is captured in ADR-006 and ADR-010 and should be finalized with benchmark-backed thresholds during Phase 0.
- Compare in-memory pipelines vs chunk decomposition vs file-backed intermediates on real workloads.
- Define when to use chunking (large files / bounded memory), and when to materialize intermediates to disk.
- Evaluate existing Python tooling pragmatically (task orchestration, caching, columnar storage, memory mapping) before custom implementation.
- Add benchmark-driven acceptance criteria (throughput, memory ceiling, reproducibility, failure recovery).


## Execution schedule (April 10–14, 2026)
Planned sequence for the next 4 days:
- **Day 1 (April 10, 2026):** finalize decisions for high-priority ADRs and freeze Core Track scope.
- **Day 2 (April 11, 2026):** implement core data/runtime scaffolding and first operator path.
- **Day 3 (April 12, 2026):** implement additional core operators and initial batch/chunk flow.
- **Day 4 (April 13, 2026):** integrate CLI/notebook adapters, basic tests, and documentation updates.
- **Day 5 (April 14, 2026):** stabilize proof-of-concept, run validation checks, and prepare review snapshot.

Expected proof-of-concept outcome by April 14, 2026:
- runnable core package prototype,
- minimal but usable Core Track API surface,
- initial reproducibility and performance sanity checks,
- updated ADR status notes where decisions were finalized.


## Phase 0 starter artifacts
The initial sprint artifacts are now scaffolded under `docs/phase0/` for review and iteration before implementation-heavy coding.


## Glossary
- **gate implementation**: do not begin broad implementation work until the core ADRs are reviewed and accepted.
- **operator/plugin skeletons**: lightweight prototype code stubs that validate API shape and extension points before production implementation.
- **migration examples**: practical examples (documentation and optional small prototype snippets) showing how existing MiningSuite analyses map to the new Orpheon API.
- **safe**: defaults that avoid surprising/destructive behavior, prevent silent failures, and favor robust results (for example explicit warnings, sane parameter bounds, and reproducible settings).
- **CLI**: Command-Line Interface, i.e., running Orpheon from a terminal with commands and flags.
- **RFC**: Request for Comments, a lightweight design proposal document used to discuss significant changes before implementation.
- **ADR**: Architecture Decision Record, a short document that captures an architectural decision, context, and consequences.
- **deterministic outputs**: same inputs + same code/version + same parameters should produce the same outputs, enabling reproducibility and easier debugging/validation; this complements (but does not replace) correctness and accuracy validation.
