# ADR-009: Dependency and Version Management Policy

- **Status:** Validated (Phase 0)
- **Date:** 2026-03-17

## Context
Phase 0 raised dependency/version complexity risks for a scientific Python framework.

## Decision
- Define minimal core dependencies and separate optional extras.
- Maintain tested version ranges plus CI matrix checks.
- Use lockfiles for development/CI reproducibility.
- Adopt `uv` as the preferred environment/lock tool (subject to final team validation).

## Justification for core dependencies
The core dependency set should remain intentionally small to keep the first Orpheon release maintainable and reproducible.

### Proposed core set and rationale
- **NumPy**: fundamental n-dimensional array container and numerical primitives for almost all DSP operations.
- **SciPy**: robust signal-processing and FFT/filter utilities needed for core MIR-style operators without re-implementing mature algorithms.
- **SoundFile** (or equivalent stable audio I/O backend): reliable audio file reading/writing with clear format support, keeping I/O concerns separate from DSP logic.

### Why not put more in core?
- Extra dependencies increase version conflicts and maintenance overhead.
- Many packages are convenience-focused (plotting, ML, advanced feature extraction) and better exposed as optional extras.
- A lean core improves long-term API stability and eases onboarding for contributors/users.

### Optional extras (non-core)
- Visualization: matplotlib/seaborn-like stack.
- Advanced MIR convenience: librosa-like helpers.
- Acceleration/ML: numba/torch-like ecosystems.


## Practical implementation recommendation
- Use **dataclasses-first** in core runtime/data internals to keep the core lightweight.
- Use **optional pydantic at boundaries** (for example CLI/config/plugin manifests) when strict parsing/validation gives clear value.
- This preserves minimal core dependencies while improving robustness for user-facing configuration surfaces.

## Consequences
- Reduced dependency drift and onboarding friction.
- Clearer boundaries between required runtime and optional capabilities.

## Open questions
- Should a fallback (pip/venv-only) path be officially documented for contributors?
