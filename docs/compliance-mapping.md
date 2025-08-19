# Compliance Mapping (Starter 80/20)

This repo provides a starter mapping between security guardrails and compliance frameworks.

| Control Theme         | What this repo provides                          | Maps to                          |
|-----------------------|--------------------------------------------------|----------------------------------|
| **Secrets handling**  | Pre-commit Gitleaks; blocks tokens pre-push      | SOC2 CC6.1/CC6.6, ISO 27001 8.2  |
| **Vulnerability mgmt**| Trivy CI + fail on HIGH/CRIT findings            | SOC2 CC7.1, ISO 27001 12.6       |
| **Asset transparency**| SBOM (SPDX) artifact per build                   | SOC2 CC8.1, ISO 27001 8.1        |
| **IaC hygiene**       | Trivy IaC misconfiguration scan                  | SOC2 CC7.2, ISO 27001 14.2       |

> Note: This is a pragmatic starter. Extend with NIST CSF, CIS Benchmarks, and org-specific controls as needed.
