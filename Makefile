SHELL := /usr/bin/env bash

.PHONY: help tmux clean-docs

help: ## Show available targets
	@grep -E '^[a-zA-Z_-]+:.*?##' Makefile | sort | awk 'BEGIN {FS = ":.*?##"} {printf "\033[36m%-12s\033[0m %s\n", $$1, $$2}'

tmux: ## Print instructions for launching tmux manually
	scripts/start_tmux_codex.sh

clean-docs: ## Stub: no cleanup available in archived repo
	@echo "Nothing to clean. This repository is archived."
