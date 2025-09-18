SHELL := /usr/bin/env bash

.PHONY: help clone-template bootstrap tmux tmux-observe mission-control docs-install docs-dev docs-build lint test-unit verify fetch-deps venv venv-clean

help: ## Show available ground operations
	@grep -E '^[a-zA-Z_-]+:.*?##' Makefile | sort | awk 'BEGIN {FS = ":.*?##"} {printf "\033[36m%-16s\033[0m %s\n", $$1, $$2}'

clone-template: ## Clone or update the shared test repo (taituo/talktomegoose_test)
	@if [ -d talktomegoose_test ]; then \
		git -C talktomegoose_test pull --rebase; \
	else \
		git clone git@github.com:taituo/talktomegoose_test.git; \
	fi

bootstrap: ## Install tmux, Node.js, pnpm, and Astro globally
	sudo scripts/bootstrap_vm.sh

tmux: ## Launch multi-pane Codex tmux session
	scripts/start_tmux_codex.sh

mission-control: ## Alias for launching the tmux mission control layout
	$(MAKE) tmux

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

venv: ## Create or update Python virtualenv for FastAPI missions
	python3 -m venv .venv
	. .venv/bin/activate && pip install --upgrade pip && pip install -r templates/fastapi/requirements.txt

venv-clean: ## Remove local Python virtualenv
	rm -rf .venv

verify: ## Run full verification suite (lint + e2e telemetry probe)
	pnpm lint
	pnpm test

fetch-deps: ## Resolve npm/pnpm dependencies without building
	pnpm install --lockfile-only
