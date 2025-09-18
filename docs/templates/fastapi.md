# FastAPI Template Hangar

Use this scaffold when a mission needs a lightweight backend that personas can
extend collaboratively.

## Inventory
- `templates/fastapi/app/main.py` — FastAPI application with starter CRUD
  endpoints and an in-memory store.
- `templates/fastapi/requirements.txt` — minimal dependency set (FastAPI and
  Uvicorn).
- `templates/fastapi/tests/` — smoke script that ensures the template imports
  correctly; expand with pytest suites as features land.

## Deployment Flow
1. Clone the template into a working directory on a feature branch.
2. Create a Python virtual environment and install the requirements.
3. Run `uvicorn templates.fastapi.app.main:app --reload` to boot a local server.
4. Coordinate feature development by persona:
   - Hangman implements new routers and domain objects.
   - Goose maintains shared utilities under `templates/fastapi/app/`.
   - Rooster covers pytest scenarios inside `templates/fastapi/tests/`.
5. Maverick reviews PRs and merges the mission branch once the squad signs off.

## Notes for Operators
- Replace the in-memory dictionary with storage that fits the mission (SQLite,
  Postgres, DynamoDB, etc.), and capture unit/integration tests for each change.
- Add authentication middleware as a dedicated router or dependency, wiring
  regression tests so Rooster can certify it.
- Update `Makefile` and `tests/` if the mission introduces new automation; no
  template additions should land without matching verification.
- Integrate the standard mission loop: `make test-unit` before coding and `make verify`
  before merge. Rooster will block changes that skip these steps.

The template intentionally avoids UI boilerplate so teams can plug in whichever
front-end or automation stack they prefer.
