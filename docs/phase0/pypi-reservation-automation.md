# Automating PyPI Reservation for `orpheon`

This document provides a ready workflow to reserve the `orpheon` package name on PyPI with a minimal placeholder release.

## Recommended flow
1. Bootstrap a minimal package from `docs/phase0/orpheon-bootstrap/` into your new repo (`olivierlar/orpheon`).
2. Choose one publish method:
   - **Trusted Publishing** (preferred), or
   - **PyPI API token secret** (`PYPI_API_TOKEN`).
3. Trigger the workflow by pushing a tag (for example `v0.0.1`).

## Quick start commands (run inside your new `orpheon` repo)
```bash
cp -R /path/to/miningsuite/docs/phase0/orpheon-bootstrap/* .
git add .
git commit -m "Bootstrap placeholder package and PyPI publish workflow"
git tag v0.0.1
git push origin main --tags
```

## One-command local bootstrap (new)
If you are inside this `miningsuite` workspace, you can generate a ready-to-run helper script:

```bash
bash docs/phase0/orpheon-bootstrap/bootstrap-local.sh
```

Then run the printed `git add/commit/tag/push` commands from your actual `olivierlar/orpheon` repository clone.

## GitHub Actions secrets/setup
### Option A — Trusted Publishing (preferred)
- Configure PyPI "Trusted Publisher" for `olivierlar/orpheon` and workflow `.github/workflows/publish-pypi.yml`.
- No API token is needed.

### Option B — API token
- Create a PyPI token with scope for project `orpheon` (or account-scoped for first publish).
- Add repository secret: `PYPI_API_TOKEN`.
- Workflow will use `__token__` as username and this secret as password.

## Verifying reservation
After a successful workflow run, confirm:
- `https://pypi.org/project/orpheon/` is live.
- `pip index versions orpheon` shows version `0.0.1` (or chosen version).

## What still requires you (PI)
- Pushing to `https://github.com/olivierlar/orpheon` (this environment cannot authenticate/push to your GitHub).
- Configuring PyPI Trusted Publishing or adding `PYPI_API_TOKEN` in GitHub repository secrets.
