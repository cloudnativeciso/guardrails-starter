# Secure by Default Starter

[![Security](https://github.com/cloudnativeciso/secure-by-default-starter/actions/workflows/security.yml/badge.svg)](https://github.com/cloudnativeciso/secure-by-default-starter/actions/workflows/security.yml)
[![Dependabot](https://img.shields.io/badge/Dependabot-enabled-brightgreen.svg)](#)
[![OpenSSF Scorecard](https://api.securityscorecards.dev/projects/github.com/cloudnativeciso/secure-by-default-starter/badge)](https://securityscorecards.dev/viewer/?uri=github.com/cloudnativeciso/secure-by-default-starter)
[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](LICENSE)

---

## Who It’s For

- **Solo founder or Founding Developers** who needs guardrails without slowing down.
- **Fractional/vCISO** who wants a drop-in security baseline for new clients.
- **Executive or board member** who needs proof of good security hygiene, not just promises.

**Outcome:**
Fewer breaches from avoidable mistakes, faster compliance mapping, and provable hygiene for your repos — all with one `git clone` and a few commands.

---

## Executive Summary

This starter makes any repo **secure-by-default in under 5 minutes**:

- **Pre-commit guardrails** prevent secrets from ever leaving laptops.
  > **CISO’s Take:** Secrets are like toothpaste — once they’re out, you can’t put them back.
- **CI security scanning** (Trivy) blocks merges on **HIGH/CRITICAL** risks.
  > **CISO’s Take:** If you can’t ship clean, don’t ship at all.
- **SBOM (SPDX)** is produced on every run for asset inventory and vendor due diligence.
  > **CISO’s Take:** You can’t protect what you don’t know you have.
- **OpenSSF Scorecard** reports secure engineering hygiene to stakeholders.
  > **CISO’s Take:** External validation beats self-assessment every time.
- **Examples** show “good vs bad” configurations with a permanent failing demo tag (main stays green).
  > **CISO’s Take:** Learn by contrast — green is the goal, red is the warning.

---

## Compliance Mapping ()

| Control Theme         | This Repo Provides                                     | Maps to                              |
|-----------------------|--------------------------------------------------------|---------------------------------------|
| Secrets handling      | Pre-commit Gitleaks; blocks tokens pre-push            | SOC2 CC6.1/CC6.6, ISO 27001:8.2       |
| Vulnerability mgmt    | Trivy CI + fail on HIGH/CRIT                            | SOC2 CC7.1, ISO 27001:12.6            |
| Asset transparency    | SBOM (SPDX) artifact per build                          | SOC2 CC8.1, ISO 27001:8.1             |
| IaC hygiene           | Trivy IaC misconfig scan                               | SOC2 CC7.2, ISO 27001:14.2            |

---

## Trust Artifacts

- **Code scanning alerts:** [Security → Code scanning alerts](../../security/code-scanning)
- **SBOM downloads:** [Actions → latest run → Artifacts → `sbom-spdx`](../../actions)
- **Scorecard report:** [View on OpenSSF](https://securityscorecards.dev/viewer/?uri=github.com/cloudnativeciso/secure-by-default-starter)

---

## Current Features

- **Pre-commit secrets scanning** using [Gitleaks](https://github.com/gitleaks/gitleaks)
  Blocks commits that contain API keys, tokens, passwords, or other sensitive strings. Runs locally for instant feedback before code leaves any machine.

- **CI vulnerability and misconfiguration scanning** using [Trivy](https://github.com/aquasecurity/trivy)
  Scans both dependencies and Infrastructure-as-Code files. Fails the build for HIGH/CRITICAL issues. Uploads SARIF results to GitHub's code scanning interface.

- **SBOM generation (SPDX JSON)** via Trivy
  Automatically produced for every build. Downloadable as a workflow artifact.

- **Local parity via Makefile**
  Run the same CI scans locally in Docker, no extra installs needed.

- **Automated dependency updates** via Dependabot
  Weekly PRs for GitHub Actions and Docker base images, labeled `dependencies`.

- **OpenSSF Scorecard** for trust & compliance signals
  Evaluates branch protection, code review, pinned dependencies, token permissions, and more.

---

## Quickstart

### 1. Install Pre-commit
We recommend [`pipx`](https://pypa.github.io/pipx/) for isolated installs:

```sh
brew install pipx
pipx install pre-commit
```

If you've never used pipx before, ensure its bin directory is in your PATH (example for zsh):

```sh
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

### 2. Enable Hooks in This Repo

```sh
pre-commit install
pre-commit autoupdate
```

### 3. Test It Works

```sh
mkdir -p examples
echo "ghp_FAKE_TOKEN_1234567890ABCDEF" > examples/bad_secret.txt
git add examples/bad_secret.txt
git commit -m "test: add fake token (should fail)"
```

**Expected:** the commit fails with a Gitleaks findings report.

---

## CI Results (What to Expect)

- **Vulnerabilities & IaC Findings:**
  Found under [Security → Code scanning alerts](../../security/code-scanning) in the GitHub UI.

- **SBOM (Software Bill of Materials):**
  Downloadable artifact (`sbom-spdx`) from the workflow run.

- **Executive Summary:**
  `security-summary.md` artifact includes counts of HIGH/CRITICAL issues and SBOM status.

---

## Local Parity

Run the same checks locally (requires [Docker](https://docs.docker.com/get-docker/)):

```sh
make scan   # Vulnerability + IaC scan
make sbom   # SBOM generation (SPDX JSON)
```

---

## Secure Examples

- [`examples/Dockerfile.good`](./examples/Dockerfile.good) — UID `10001`, unprivileged port (8080), pinned base image.
- [`examples/pod-secure.yaml`](./examples/pod-secure.yaml) — drop all caps, read-only root FS, no privilege escalation, CPU/memory limits, non-root UID 10001.

---

## Insecure Examples (Failing Demo)

- Dockerfile.bad: https://github.com/cloudnativeciso/secure-by-default-starter/blob/demo-bad-examples-v1/examples/Dockerfile.bad
- pod-insecure.yaml: https://github.com/cloudnativeciso/secure-by-default-starter/blob/demo-bad-examples-v1/examples/pod-insecure.yaml

---

## Security Best Practices in This Repo

| Practice                  | Where                      | Why it matters                                                |
|---------------------------|----------------------------|----------------------------------------------------------------|
| Run as non-root (UID 10001) | Dockerfile + Pod           | Avoids kernel-level privileges; aligns with minimal images.   |
| Unprivileged port (8080)   | Dockerfile + Pod           | Removes need for `NET_BIND_SERVICE`.                          |
| Drop ALL capabilities      | Pod `securityContext`     | Shrinks privilege footprint.                                  |
| Disable privilege escalation| Pod `securityContext`    | Blocks `setuid`/`setgid`-style elevation.                     |
| Read-only root filesystem  | Pod `securityContext`     | Prevents tampering/persistence.                               |
| Resource requests/limits   | Pod `resources`           | Prevents noisy-neighbor/DoS via resource exhaustion.          |
| Pinned base image          | Dockerfile                | Reduces CVE drift from `:latest`.                             |

---

## Roadmap

- [x] Repo scaffolded
- [x] Pre-commit (Gitleaks)
- [x] CI: Trivy vuln + SBOM
- [x] Makefile for local parity
- [x] Secure examples in repo; failing demo via permanent tag
- [x] OpenSSF Scorecard (workflow)
- [x] Compliance mapping & trust artifacts in README
- [ ] “How to download SBOM” screenshots (docs/screenshots)
- [ ] Policy-as-code (Kyverno) in v2
