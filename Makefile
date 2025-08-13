# Makefile: local parity with CI
# ------------------------------------------------------------
# Usage:
#   make hooks      # install/refresh pre-commit hooks
#   make scan       # Trivy vuln + IaC scan (fails on HIGH/CRITICAL)
#   make sbom       # Generate SPDX JSON to sbom.spdx.json
#   make ci         # run scan + sbom (what CI does, locally)
#
# Bump this to track the CI version in one place.
TRIVY_VERSION ?= 0.65.0
TRIVY_IMAGE   ?= aquasec/trivy:$(TRIVY_VERSION)

SRC_DIR       := /src
CACHE_DIR     := $(HOME)/.cache/trivy
DOCKER_RUN    := docker run --rm \
                   -v $(PWD):$(SRC_DIR) \
                   -v $(CACHE_DIR):/root/.cache/ \
                   $(TRIVY_IMAGE)

.PHONY: hooks scan sbom ci help

help:
	@echo "Targets:"
	@echo "  make hooks   - install/update pre-commit hooks (gitleaks + hygiene)"
	@echo "  make scan    - run Trivy vuln + IaC scan (HIGH/CRITICAL gate)"
	@echo "  make sbom    - generate SPDX SBOM (sbom.spdx.json)"
	@echo "  make ci      - run scan + sbom (local parity with CI)"

hooks:
	pre-commit install
	pre-commit autoupdate

# Mirrors CI: vuln + config scanners, ignore unfixed, HIGH/CRITICAL gate
scan:
	$(DOCKER_RUN) fs \
	  --scanners vuln,config \
	  --ignore-unfixed \
	  --severity HIGH,CRITICAL \
	  --exit-code 1 \
	  $(SRC_DIR)

# Mirrors CI: SPDX JSON SBOM artifact
sbom:
	$(DOCKER_RUN) fs \
	  --format spdx-json \
	  --output sbom.spdx.json \
	  $(SRC_DIR)
	@echo "SBOM written to sbom.spdx.json"

ci: scan sbom
