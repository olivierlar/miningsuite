#!/usr/bin/env bash
set -euo pipefail

# Bootstraps the current repository as the minimal Orpheon placeholder package
# so the first PyPI reservation release can be created quickly.

if [[ ! -f "pyproject.toml" ]]; then
  echo "[info] No pyproject.toml found in current directory; proceeding."
fi

mkdir -p src/orpheon .github/workflows

cp -f docs/phase0/orpheon-bootstrap/pyproject.toml pyproject.toml
cp -f docs/phase0/orpheon-bootstrap/README.md README.md
cp -f docs/phase0/orpheon-bootstrap/src/orpheon/__init__.py src/orpheon/__init__.py
cp -f docs/phase0/orpheon-bootstrap/.github/workflows/publish-pypi.yml .github/workflows/publish-pypi.yml

echo "[ok] Orpheon placeholder package files copied into current repository."
echo "[next] Review files, then run:"
echo "       git add pyproject.toml README.md src/orpheon .github/workflows/publish-pypi.yml"
echo "       git commit -m 'Bootstrap placeholder package for PyPI reservation'"
echo "       git tag v0.0.1"
echo "       git push origin main --tags"
