# Security Policy

## Supported Versions
This project follows a simple support model appropriate for a starter kit:
- **main**: actively maintained
- Tagged releases `v*`: best effort

If you find a vulnerability on `main`, please report it (see below). For older tags, consider updating to `main` first.

## Reporting a Vulnerability
Please **do not** open a public issue for security reports.

Instead, email: **cnciso@proton.me** with:
- A description of the issue and impact
- Steps to reproduce or proof of concept
- Any relevant logs, configs, or screenshots

We aim to acknowledge reports **within 72 hours** and provide a remediation plan or timeline as soon as reasonably possible.

If you prefer GitHub, you may open a **private** security advisory via:  
**Security → Advisories → Report a vulnerability** (in this repository).

## Disclosure Process
- We will verify the issue and prepare a fix.
- We will coordinate a disclosure date that allows users to update.
- We will credit reporters if desired.

## Hardening Scope (What this repo covers)
This starter provides:
- **Pre-commit** secret scanning (Gitleaks)
- **CI** vulnerability + IaC scanning (Trivy)
- **SBOM** artifact (SPDX JSON)

It does **not** replace full threat modeling, runtime controls, or a team of trained security professionals. For production workloads, pair this with:
- Image signing & provenance (Sigstore/SLSA)
- Admission controls / policy-as-code (e.g., Kyverno)
- Runtime hardening (e.g., seccomp, apparmor, eBPF)