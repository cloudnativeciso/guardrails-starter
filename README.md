# Guardrails Starter
[![Security](https://github.com/cloudnativeciso/secure-by-default-starter/actions/workflows/security.yml/badge.svg)](https://github.com/cloudnativeciso/secure-by-default-starter/actions/workflows/security.yml)

A minimal, security-first kit that drops into any repo to add developer-friendly guardrails:  
pre-commit secret scanning, CI dependency checks, and an SPDX SBOM.

---

## Current Features
- **Pre-commit secrets scanning** using [Gitleaks](https://github.com/gitleaks/gitleaks)
  - Blocks commits that contain API keys, tokens, passwords, or other sensitive strings.
  - Runs locally for instant feedback before code leaves your machine.

---

## Quickstart

### 1. Install Pre-commit
We recommend [`pipx`](https://pypa.github.io/pipx/) for isolated installs:

```sh
brew install pipx
pipx install pre-commit
```

If you've never used pipx before, ensure its bin directory is in your PATH (note this example is for zsh - adjust for bash or fish shell if needed):

```sh
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

### 2. Enable Hooks in This Repo

```sh
pre-commit install
pre-commit autoupdate
```

### 3. Test it works

```sh
mkdir -p examples
echo "ghp_FAKE_TOKEN_1234567890ABCDEF" > examples/bad_secret.txt
git add examples/bad_secret.txt
git commit -m "test: add fake token (should fail)"
```

Expected: Commit fails with a Gitleaks findings report such as:
> note: Make sure to replace the FAKE_GITHUB_TOKEN_123456 with an actual fake token

```sh
❯ git commit -m "test: add fake token (should fail)"
[WARNING] Unstaged files detected.
...
Detect hardcoded secrets.................................................Failed
- hook id: gitleaks
- exit code: 1

○
    │╲
    │ ○
    ○ ░
    ░    gitleaks

Finding:     REDACTED
Secret:      REDACTED
RuleID:      github-pat
Entropy:     4.546439
File:        examples/bad_secrets.txt
Line:        2
Fingerprint: examples/bad_secrets.txt:github-pat:2
```

## CI Results (What to Expect)

- **Vulnerabilities & IaC Findings:**  
  After each push or pull request, results appear under  
  **Security → Code scanning alerts** in the GitHub UI.

- **SBOM (Software Bill of Materials):**  
  Every CI run publishes an artifact named **sbom-spdx**.  
  Download `sbom.spdx.json` from the workflow run’s artifacts section.

---

## Local Parity

You can run the same checks locally without waiting for CI.

Requires [Docker](https://docs.docker.com/get-docker/).

```sh
# Vulnerability + IaC scan
make scan

# SBOM generation (SPDX JSON)
make sbom
```

These command run Trivy in a container, mirroring the CI configuration.
No local installation of Trivy is needed.

## Roadmap

- [x] Repo scaffolded
- [x] Pre-commit (Gitleaks)
- [x] CI: Trivy vuln + SBOM
- [x] Makefile for local parity
- [ ] Examples of bad IaC and insecure Dockerfiles
- [ ] CNCISO "Secure-by-Default" Badge
- [ ] Policy-as-code (Kyverno) in v2