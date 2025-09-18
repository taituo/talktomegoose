# Tmux Read-Only Observation

When the goose cockpit is running, additional teammates can watch persona chatter without risking accidental keystrokes.

## Launch the Session
```bash
make mission-control  # alias: make tmux
```

## Attach as an Observer
```bash
tmux attach -t goose -r
```
- `-t goose` selects the shared session name created by `scripts/start_tmux_codex.sh`.
- `-r` enables read-only mode so the observer cannot send input to any pane.

## Notes
- Observers can still enter copy-mode (`Ctrl+b` then `[`) to scroll through backscroll.
- Detach at any time with `Ctrl+b` then `d`; the primary operators remain connected.
- If no session exists yet, the attach command prints an error—run `make mission-control` (or `make tmux`) first.
