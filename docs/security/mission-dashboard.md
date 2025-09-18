# Mission Dashboard Security Notes

The FastAPI + Next.js demo runs locally, but the same patterns apply when you
expose them beyond the VM. Harden the stack with the following controls:

1. **API key header** — The FastAPI template now reads `TALKTO_API_KEY`. When
   set, every dashboard route enforces `x-mission-key` and CORS is restricted to
   `http://localhost:3000`. Rotate the key per mission; store it in `.env` or a
   secrets manager.
2. **Least privilege** — Keep `/dashboard/*` read-only. If you add mutating
   endpoints, split them under `/api/admin/` with stronger auth.
3. **Rate limiting** — Use FastAPI middlewares such as `slowapi` when the API is
   reachable over the network. Locally, tmux panes are enough, but in shared
   environments you may want to prevent polling abuse.
4. **Process isolation** — Run the dashboard in a restricted user or container.
   `make demotime` prints commands; wrap them in systemd units or Docker Compose
   for deployment.
5. **Data provenance** — Persist telemetry as JSONL (`logs/events/*.jsonl`) so
   you can audit merges and replay missions. This reduces the risk of tampering
   or hallucinated status updates.
6. **Input sanitization** — When streaming persona messages, escape Markdown or
   HTML before rendering in the dashboard to avoid XSS in the browser.

For deeper hardening add OAuth, signed webhooks from your git host, and mutual-TLS
between services. Keep these notes close to the mission brief so operators can
flip security toggles as soon as the demo graduates to a shared environment.
