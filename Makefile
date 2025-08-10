SHELL := /bin/zsh

.PHONY: scan sbom

# Runs the same Trivy vuln+config scan as the Github Action
scan:
	@echo "==> Trivy filesystem scan (vuln + config)"
	docker run --rm -v $$PWD:/repo aquasec/trivy:latest fs --scanners vuln,config /repo

# Generates an SPDX SBOM locally (same format as CI artifact)
sbom:
	@echo "==> Trivy SBOM (SPDX JSON)"
	docker run --rm -v $$PWD:/repo aquasec/trivy:latest fs --format spdx-json /repo > sbom.spdx.json && \
	echo "SBOM written to ./sbom.spdx.json"