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

## If workflow is not set up yet (your current state)
If you do **not** yet have `.github/workflows/publish-pypi.yml` in `olivierlar/orpheon`, this is expected:
- GitHub Actions cannot run yet.
- `https://pypi.org/project/orpheon/` will not exist yet.

Do these first:
1. Copy bootstrap files into your local `orpheon` repository.
2. Commit and push to GitHub (`main`).
3. In PyPI, add Trusted Publisher for `olivierlar/orpheon` + `publish-pypi.yml`.
4. Push tag `v0.0.1` to trigger first publish.

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

## Troubleshooting checklist
- If Actions tab shows no workflow:
  - Confirm file exists at `.github/workflows/publish-pypi.yml` on GitHub default branch.
- If tag push does not start workflow:
  - Confirm tag matches `v*` (for example `v0.0.1`).
- If publish step fails with trusted publishing error:
  - Re-check Trusted Publisher owner/repo/workflow values in PyPI.
- If package page still 404 after successful publish:
  - Wait 1–2 minutes and refresh `https://pypi.org/project/orpheon/`.
