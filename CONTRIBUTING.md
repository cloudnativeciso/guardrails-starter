# Contributing

Thanks for helping make security the default.

## Branch & Commit Style
- Create feature branches from `main`: `type/short-desc` (e.g., `docs/readme-polish`, `ci/trivy-tune`).
- Use **Conventional Commits**:
  - `feat: ...`, `fix: ...`, `docs: ...`, `chore/ci: ...`, `test: ...`
- Keep PRs small and focused.

## PR Requirements
- CI green (`security` workflow passes).
- No secrets (Gitleaks pre-commit must pass).
- Update docs (README/docs/) when behavior changes.

## Running Locally
```bash
pre-commit install && pre-commit autoupdate
make scan    # vuln + IaC
make sbom    # generates sbom.spdx.json
```

## Code of Conduct
By participating, you agree to the [Code of Conduct](./CODE_OF_CONDUCT.md).

## Security Issues
Please follow the [Security Policy](./SECURITY.md).
