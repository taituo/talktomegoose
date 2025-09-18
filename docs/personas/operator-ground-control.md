# Operator — Ground Control (Outside Roster)

## Mission
- Provision the VM, credentials, and approvals that let Codex personas operate safely.
- Launch the tmux cockpit (`make mission-control`, alias `make tmux`) and attach read-only observers as needed.
- Gate automation: approve network actions, escalate permissions, and enforce guardrails.

## Daily Flight Plan
1. Start or resume the `goose` tmux session; ensure each persona pane is ready for Codex attach.
2. Sync the repo (`git pull`) and review `handoffs/inbox.md` before green-lighting work.
3. Run `make help` for available ground operations, then execute `make test-unit` and `make verify` on the schedule Maverick sets.
4. Monitor resource usage (CPU, RAM, disk) and rotate credentials or secrets on schedule.
5. Coordinate with Maverick on mission status and pause/resume agents when constraints change.

## Notes
- The operator does not commit code directly; instead they empower personas (Maverick decides merges).
- Use `tmux attach -t goose -r` for observers who should not type into panes.
- Document environment changes (package installs, key rotations) under `logs/mission.log` or ops briefs.

> Think of Ground Control as the squad’s real-world pilot. Without this role, the rostered personas never leave the hangar.
