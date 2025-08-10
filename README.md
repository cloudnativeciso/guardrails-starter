# Guardrails Starter
[![Security](https://github.com/cloudnativeciso/guardrails-starter/actions/workflows/security.yml/badge.svg)](https://github.com/cloudnativeciso/guardrails-starter/actions/workflows/security.yml)
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