# Secure by Default Starter
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

---

## CI Results (What to Expect)

- **Vulnerabilities & IaC Findings:**  
  After each push or pull request, results appear under  
  **Security → Code scanning alerts** in the GitHub UI.

- **SBOM (Software Bill of Materials):**  
  Every CI run publishes an artifact named **sbom-spdx**.  
  Download `sbom.spdx.json` from the workflow run’s artifacts section.


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

---

## Insecure Examples (Failing Demo)

These live on a permanent tag so `main` stays green, but you can always browse them:

- Dockerfile.bad: https://github.com/cloudnativeciso/secure-by-default-starter/blob/demo-bad-examples-v1/examples/Dockerfile.bad
- pod-insecure.yaml: https://github.com/cloudnativeciso/secure-by-default-starter/blob/demo-bad-examples-v1/examples/pod-insecure.yaml
- bad_secrets.txt: https://github.com/cloudnativeciso/secure-by-default-starter/blob/demo-bad-examples-v1/examples/bad_secrets.txt

> These are expected to **fail** CI and are safe to use for testing guardrails.

## Secure Examples

Hardened patterns that should pass our guardrails:

- [`examples/Dockerfile.good`](./examples/Dockerfile.good) — UID `10001`, unprivileged port (8080), pinned base image.
- [`examples/pod-secure.yaml`](./examples/pod-secure.yaml) — drop all caps, read‑only root FS, no privilege escalation, CPU/memory limits, non‑root UID 10001.

> Use these as the baseline; only add privilege with a documented exception.

## Security Best Practices Used in This Repo

Below is a list of the security best practices showcased in our **secure** examples.  
These follow recommendations from:
- CNCF Secure Supply Chain Whitepaper
- NSA Kubernetes Hardening Guide
- NIST 800-190 (Application Container Security Guide)

| Practice | Where | Why it matters |
|---|---|---|
| **Run as non-root (UID 10001)** | Dockerfile + Pod | Avoids kernel-level privileges and common UID collisions; aligns with minimal/distroless images. |
| **Unprivileged port (8080)** | Dockerfile + Pod | Removes need for `NET_BIND_SERVICE`; smaller attack surface. |
| **Drop ALL capabilities** | Pod `securityContext` | Shrinks privilege footprint; nothing extra to abuse if compromised. |
| **Disable privilege escalation** | Pod `securityContext` | Blocks `setuid`/`setgid`-style elevation inside the container. |
| **Read-only root filesystem** | Pod `securityContext` | Prevents tampering/persistence on container root FS. |
| **Resource requests/limits** | Pod `resources` | Prevents noisy-neighbor/DoS via CPU/memory exhaustion. |
| **Pinned base image** | Dockerfile | Deterministic builds; reduces CVE drift from `:latest`. |
| **Health/readiness checks** | Pod probes (optional) | Production readiness; safer rollouts and faster detection of bad deploys. |

> **How to use this:** Start with these defaults in new services.  
> If a workload needs more privilege (e.g., binding to port 80), add only what’s required (e.g., `NET_BIND_SERVICE`) and document the exception.

> **Why UID 10001?**  
> It’s a stable, non-root UID commonly used in minimal/distroless images. It avoids collisions with system users (like `nobody`), plays nicely with file permissions, and keeps privilege low by default.


## Roadmap

## Examples
- `examples/Dockerfile.good` and `examples/pod-secure.yaml` demonstrate a passing configuration.
- For a failing demo, see the "Purposefully Failing PR – Guardrails Demo" branch/PR.

- [x] Repo scaffolded
- [x] Pre-commit (Gitleaks)
- [x] CI: Trivy vuln + SBOM
- [x] Makefile for local parity
- [ ] Examples of bad IaC and insecure Dockerfiles
- [ ] CNCISO "Secure-by-Default" Badge
- [ ] Policy-as-code (Kyverno) in v2
