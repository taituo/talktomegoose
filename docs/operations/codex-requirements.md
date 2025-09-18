# Codex Access Requirements

Running the Talk to Me Goose stack assumes the operator has:

- **ChatGPT Plus (or higher) account** with Codex (e.g., `gpt-codex`) available.
- **Valid session token** for the Codex CLI; renew before each mission if expiration is near.
- **Quota awareness**: monitor OpenAI rate limits for Codex traffic to avoid pane stalls.
- **Reference briefing**: review the shared chat recap at https://chatgpt.com/share/68cbadca-7c64-8006-b614-9524f4df7447 before onboarding new agents.

## Preflight Checklist Addendum
1. Confirm the account tier still grants Codex access.
2. Load the session token into the environment before launching tmux (`export CODEX_SESSION=<token>` or CLI equivalent).
3. Brief the squad on remaining daily quota so Rooster can stage tests accordingly.
4. If quotas look tight, prioritize critical panes (Maverick, Goose, Hangman) and defer optional personas.

Document any quota incidents in `docs/communication/radio-checks.md` and adjust mission scope accordingly.
