# Security Exceptions (Process)

**Goal:** allow strictly controlled, temporary exceptions with business justification and a fixed expiry.

## When to use
- A Trivy HIGH/CRITICAL finding cannot be fixed immediately.
- A secret-scanning false positive blocks a doc/example.
- A policy-as-code rule (future: Kyverno) needs a narrow exception for a specific path.

## How to request
1. Open **New issue → Security Exception Request** and fill all required fields.
2. Keep scope minimal (specific CVE/AVD ID and path).
3. Set an **expiry date (YYYY-MM-DD)** and provide **compensating controls**.

## How to implement (examples)
- **Trivy:** add a CVE to `.trivyignore` with the **issue number and expiry** in a comment. Keep it *scoped* by path if possible.
```text
SEC-EXCEPTION # 123 expires 2025-09-30: upstream fix pending; scope: examples/Dockerfile.good

CVE-2024-12345
```
- **Gitleaks:** use **sentinel-marked** fake secrets in examples; do **not** blanket-whitelist directories. See `.gitleaks.toml` and include `CNCISO_FAKE_SECRET` on the same line.
- **Kyverno (future):** use a namespaced exception policy targeting only the affected workload.

## Approval & tracking
- Label issues `security` and `exception`. Assign an **owner**.
- Close the issue when the exception is removed.

> Future automation (nice-to-have): a scheduled workflow that flags **expired** exceptions by parsing issue bodies for `expiry:` and commenting/labeling.
