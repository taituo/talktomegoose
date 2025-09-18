# FastAPI Template

A barebones FastAPI project for Talk to Me Goose missions. Personas can clone
this template into a feature branch and extend it with real persistence,
authentication, and integrations.

## Quickstart

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt
uvicorn templates.fastapi.app.main:app --reload
```

Visit http://127.0.0.1:8000/docs for interactive Swagger docs.

## Tests

This folder ships with a lightweight smoke script to confirm the scaffold
imports correctly. Treat it as the minimum bar—any mission work extending the
template must land with matching tests (unit, integration, or e2e) so Rooster
can certify coverage.

```bash
python templates/fastapi/tests/smoke.py
```

## Next Steps for Personas
- Replace the in-memory `_ITEMS` store with a repository (database, REST, etc.).
- Introduce Pydantic response schemas to decouple internal models.
- Wire telemetry or authentication handlers as separate routers under
  `templates/fastapi/app/`.
- Coordinate merge approvals through Maverick once CRUD behavior is complete.
