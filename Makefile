SHELL := /usr/bin/env bash

.PHONY: help bootstrap tmux tmux-observe docs-install docs-dev docs-build lint test-unit verify fetch-deps

help: ## Show available ground operations
	@grep -E '^[a-zA-Z_-]+:.*?##' Makefile | sort | awk 'BEGIN {FS = ":.*?##"} {printf "\033[36m%-16s\033[0m %s\n", $$1, $$2}'

bootstrap: ## Install tmux, Node.js, pnpm, and Astro globally
	sudo scripts/bootstrap_vm.sh

tmux: ## Launch multi-pane Codex tmux session
	scripts/start_tmux_codex.sh

tmux-observe: ## Attach to running tmux session in read-only mode
	tmux attach -t goose -r || { echo "tmux session 'goose' not running. Start it with make tmux."; exit 1; }

docs-install: ## Install Astro site dependencies via pnpm
	pnpm --dir site install

docs-dev: docs-install ## Run Astro dev server with live reload
	pnpm --dir site run dev --host 0.0.0.0

docs-build: docs-install ## Build static docs site to site/dist
	pnpm --dir site run build

lint: ## Run Biome lint/format checks
	pnpm lint

test-unit: ## Execute FastAPI template smoke test
	python3 templates/fastapi/tests/smoke.py

verify: ## Run full verification suite (lint + e2e telemetry probe)
	pnpm lint
	pnpm test

fetch-deps: ## Resolve npm/pnpm dependencies without building
	pnpm install --lockfile-only
