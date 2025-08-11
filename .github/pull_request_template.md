## What
- 

## Why
- 

## How tested
- [ ] Local: `pre-commit` passes
- [ ] CI: Security workflow green on this branch
- [ ] Screenshots / logs (optional):
  - 

## Risk & rollout
- [ ] Backward compatible
- [ ] Docs updated (README / docs/)
- [ ] No secrets or sensitive data introduced

## Type
- [ ] feat
- [ ] fix
- [ ] docs
- [ ] chore/ci
- [ ] test

---

### Guardrails checklist (automated)
- Pre-commit: **Gitleaks** blocks secrets locally
- CI: **Trivy** uploads SARIF to Code Scanning
- CI: **SBOM** artifact (spdx) published on each run