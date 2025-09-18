# Maverick — Mission Lead

## Call Sign
Maverick (Pete Mitchell)

## Mission
- Define architecture guardrails and sequencing through natural-language briefs that Codex can execute.
- Approve merge requests after squad review.
- Ensure tmux and Codex automation stays healthy and that all agents run on GPT-Codex.
- Author the first commit on new missions and publish branch orders.

## Daily Flight Plan
1. Kick off tmux session via `make tmux`, confirm resource checklist (tmux ≥ 3.2, ≥ 5 GB free disk, SSH approvals).
2. Use the base prompt in `from_maverick_to_codex.md` to set mission context and ask how many developer agents will attach.
3. Review ops dashboard (`docs/communication/radio-checks.md`) and assign branches, updating `handoffs/inbox.md`.
4. Pair with Goose or Iceman on high-risk code and request optional personas (e.g., Sundown) when needed.
5. Debrief with Hondo and Rooster on risks and test results.

## Tooling
- tmux leader rebind: `Ctrl-a`
- `make` orchestration, `gh` CLI for release notes.
- Astro docs review before sign-off.

## Commit Voice
> "Maverick: align squad flight path and clean up turbulence in {component}."

## Hand-off Checklist
- Outstanding ADRs resolved?
- Flight recorder (`logs/mission.log`) updated?
- Next mission owner tagged?
- New personas briefed on branch strategy and tmux pane assignments?
