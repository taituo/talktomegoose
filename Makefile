SHELL := /usr/bin/env bash

.PHONY: help clone-template bootstrap tmux tmux-observe mission-control mission-all mission-story-check demotime inbox mission-log mission-status mission-summary docs-install docs-dev docs-build lint test-unit verify fetch-deps venv venv-clean

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

mission-all: ## Full first-flight prep (clone template, deps, optional venv, checks)
	$(MAKE) clone-template
	pnpm install
	@if [ "$(SKIP_VENV)" != "1" ]; then \
		echo "[mission-all] Creating/updating .venv (set SKIP_VENV=1 to skip)"; \
		$(MAKE) venv; \
	else \
		echo "[mission-all] Skipping venv because SKIP_VENV=1"; \
	fi
	$(MAKE) test-unit
	$(MAKE) verify

mission-story-check: ## Validate storyteller outline vs chapter templates
	node scripts/story/check_chapters.mjs

demotime: ## Prepare demo deps (FastAPI + dashboard) and print launch tips
	$(MAKE) mission-all SKIP_VENV=$(SKIP_VENV)
	pnpm --dir templates/mission-dashboard install
	@echo "---"
	@echo "Mission demo ready." \
	 && echo "1. API key (optional): export TALKTO_API_KEY=demo-mission" \
	 && echo "2. Start FastAPI: source .venv/bin/activate && uvicorn templates.fastapi.app.main:app --reload" \
	 && echo "3. Start dashboard: cd templates/mission-dashboard && NEXT_PUBLIC_API_BASE_URL=http://127.0.0.1:8000 NEXT_PUBLIC_API_KEY=demo-mission pnpm dev" \
	 && echo "4. Open http://localhost:3000 to view panels." \
	 && echo "Use SKIP_VENV=1 make demotime to skip Python venv creation."

inbox: ## Show current mission inbox tasks (handoffs/inbox.md)
	@if [ -f handoffs/inbox.md ]; then \
		cat handoffs/inbox.md; \
	else \
		echo "handoffs/inbox.md not found"; \
	fi

mission-log: ## Tail recent mission log entries
	@if [ -f logs/mission.log ]; then \
		tail -n 40 logs/mission.log; \
	else \
		echo "logs/mission.log not found"; \
	fi

mission-status: ## Compact git graph (last 12 commits)
	git --no-pager log --oneline --decorate --graph -12

mission-summary: ## Fetch dashboard summary from FastAPI (requires server)
	@if command -v curl >/dev/null 2>&1; then \
		API_BASE_URL=$${API_BASE_URL:-http://127.0.0.1:8000}; \
		HEADER=""; \
		if [ -n "$$TALKTO_API_KEY" ]; then HEADER="-H x-mission-key:$$TALKTO_API_KEY"; fi; \
		curl -fsSL $$HEADER "$$API_BASE_URL/dashboard/summary" || echo "Dashboard summary unavailable (is FastAPI running?)"; \
	else \
		echo "curl not available"; \
	fi

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
