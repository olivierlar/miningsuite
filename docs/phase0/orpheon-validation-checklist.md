# Orpheon Naming Validation (Updated with confirmed availability checks)

Date: 2026-03-06

## Summary
Chosen candidate: **Orpheon**.

This document records practical checklist items that were verifiable now, including externally confirmed results for GitHub and PyPI.

## Results

| Check | Method | Result | Status |
|---|---|---|---|
| GitHub org availability (`orpheon`) | Direct GitHub check | Name is already taken by an existing user account | ⚠️ Not available for org creation |
| GitHub repo availability (`orpheon/orpheon`) | `GET https://api.github.com/repos/orpheon/orpheon` | Response `404 Not Found` | ✅ Available (repo does not exist) |
| PyPI package availability (`orpheon`) | `https://pypi.org/project/orpheon/` | Page returns `404` | ✅ Likely available (no published package) |
| Domain DNS signal (`orpheon.org`) | `getent hosts orpheon.org` | No DNS record returned in this environment at check time | ⚠️ Inconclusive |
| Domain DNS signal (`orpheon.dev`) | `getent hosts orpheon.dev` | Resolves to `185.158.133.1` | ❗ Likely already registered |
| Domain DNS signal (`orpheon.ai`) | `getent hosts orpheon.ai` | Resolves to `76.76.21.21` | ❗ Likely already registered |
| In-repo naming conflict | `rg -n "Orpheon|orpheon" docs` | Only expected references in Phase 0 naming docs | ✅ Pass |

## Interpretation
- **Orpheon remains viable as software/package name**, even though the `orpheon` GitHub org/account namespace is already taken.
- Domain strategy should not assume `.dev` or `.ai` availability.

## Recommended immediate actions
1. Keep software name **Orpheon**.
2. Use an alternative GitHub namespace (e.g., `orpheon-project`, `orpheon-lab`, or maintainer namespace) and create repo `orpheon`.
3. Reserve the PyPI project name by publishing an initial placeholder package when ready.
4. (Optional) Domain strategy can be deferred for this research project.
