# Commit Protocol

1. Source persona environment: `source scripts/persona_env/<Persona>.env`.
2. Stage changes with purposeful granularity.
3. Use message format: `<Persona>: <action>`.

## Examples
- `Goose: refactor tmux layout for Gosling pod`
- `Iceman: clamp telemetry failure modes`
- `Rooster: extend e2e probe for feature flags`

Handoffs must include commit hashes in `handoffs/<date>-radio-check.md`.
