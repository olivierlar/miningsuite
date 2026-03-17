# Phase 0 Architecture Sprint Starter Pack

This folder starts the 1–2 week architecture sprint proposed in `docs/python-port-feasibility.md`.

## Included artifacts
- `adr/ADR-001`..`ADR-010`: initial decision drafts to review and ratify.
- `api-mockups.md`: first-pass high-level API shape.
- `operator-plugin-skeletons.py`: minimal protocol/skeleton examples for operators and plugins.
- `batch-execution-prototype-spec.md`: first executable-thinking spec for large batch workflows.
- `miningsuite-migration-examples.md`: starter migration mappings for common MiningSuite-style tasks.
- `project-naming-options.md`: Python-ecosystem-inspired naming shortlist and recommendation for the new GitHub project.
- `orpheon-validation-checklist.md`: practical validation checks for the selected `Orpheon` name (with environment constraints noted).

- `pypi-reservation-automation.md`: step-by-step PyPI reservation automation guide and publish options.
- `orpheon-bootstrap/`: copy-ready placeholder package, GitHub Action, and local bootstrap helper script for first PyPI release.

## How to use this pack
1. Review ADRs in order (001 → 010).
2. Edit unresolved items and decision options during architecture meetings.
3. Approve ADRs before implementation-heavy coding begins.
4. Use mockups/specs as constraints for first prototype implementation.
