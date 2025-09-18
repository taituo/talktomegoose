SHELL := /usr/bin/env bash

.PHONY: help tmux clean-docs

help: ## Näytä saatavilla olevat komennot
	@grep -E '^[a-zA-Z_-]+:.*?##' Makefile | sort | awk 'BEGIN {FS = ":.*?##"} {printf "\033[36m%-12s\033[0m %s\n", $$1, $$2}'

tmux: ## Tulosta ohje tmux-ympäristön käynnistämiseen käsin
	scripts/start_tmux_codex.sh

clean-docs: ## Siivoa mahdolliset väliaikaiset dokut (stub)
	@echo "Nothing to clean. Repo on arkistoitu."
