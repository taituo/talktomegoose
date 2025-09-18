# Backend Use Cases

## 1. Mission Briefing Service
- Endpoint: `GET /api/briefings/current`
- Personas: Hangman implements, Phoenix consumes.
- Data Contract: returns mission title, objectives, target ETA.
- Tests: Rooster verifies with snapshot + latency budget under 150ms.

## 2. Flight Telemetry Stream
- Endpoint: `POST /api/telemetry`
- Accepts signed payloads using SSH public-key exchange (see `ssh-api-handshake.md`).
- Goose maintains shared libs for signing; Iceman validates error handling.

## 3. Feature Flag Console
- Endpoint: `PATCH /api/feature-flags/:flag`
- Phoenix surfaces toggles on landing page menu.
- Hondo updates release notes when flags flip.

Each use case includes instrumentation stubs inside `apps/backend/src/routes/` and work items tracked in ADRs.
