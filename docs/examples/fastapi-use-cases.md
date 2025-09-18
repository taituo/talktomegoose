# FastAPI Use Cases

When extending the template under `templates/fastapi/`, treat these scenarios as
starting points for mission stories.

## 1. Mission Briefing Service
- Endpoint: `GET /briefings/current`
- Personas: Hangman defines service logic, Phoenix consumes data for front-ends.
- Contract: returns mission title, objectives, ETA, and call-sign lead.
- Tests: Rooster verifies response schema and latency budget under 150 ms.

## 2. Flight Logbook CRUD
- Endpoints: `POST /logs`, `GET /logs`, `GET /logs/{id}`, `PUT /logs/{id}`,
  `DELETE /logs/{id}`
- Personas: Goose maintains persistence helpers, Hangman exposes routers.
- Data: log entries capture timestamp, aircraft, crew, and narrative.
- Tests: Rooster seeds fixtures and asserts optimistic concurrency behavior.

## 3. Telemetry Intake
- Endpoint: `POST /telemetry`
- Security: Accepts signed payloads using SSH keys (see `ssh-api-handshake.md`).
- Personas: Iceman ensures validation is hardened; Hondo updates readiness logs.
- Follow-up: Phoenix or other front-ends can stream telemetry via WebSockets or
  SSE once the base endpoint is stable.

Record feature choices and trade-offs in ADRs so Maverick can merge confidently.
