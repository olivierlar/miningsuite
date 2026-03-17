# Batch Execution Prototype Spec (Phase 0)

## Objectives
- Analyze very large collections of files.
- Resume from partial failures.
- Reuse cached intermediates when pipeline and inputs match.

## Prototype scope
1. Input expansion (`glob`, manifest file, or directory scan).
2. Pipeline fingerprint/hash from operator graph + parameters + version.
3. Per-file execution records with status (`ok`, `failed`, `cached`, `skipped`).
4. Resume mode that only executes missing/invalidated nodes.
5. Summary report export (JSON + CSV).

## Minimal CLI sketch
```bash
ms batch run --inputs "/data/**/*.wav" --pipeline pipeline.yml --cache .ms_cache --workers 8 --resume
```

## Success criteria
- Re-run on unchanged corpus is mostly cache hits.
- Single-file failures do not invalidate whole job.
- Summary output can be consumed in notebook/statistics workflows.
