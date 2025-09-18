# API Demo Scenario

## Setup
1. Create a virtual environment and install dependencies: `pip install -r templates/fastapi/requirements.txt`.
2. Run the development server: `uvicorn templates.fastapi.app.main:app --reload`.
3. Open the interactive docs at http://127.0.0.1:8000/docs or use HTTPie/curl to exercise endpoints.

## Personas
- Hangman iterates on the `/items` CRUD routes.
- Goose extracts reusable helpers into `templates/fastapi/app/`.
- Rooster captures pytest cases under `templates/fastapi/tests/`.
- Phoenix prototypes clients against the OpenAPI schema.

## Rollout Strategy
- Document API changes in `docs/templates/fastapi.md` so future missions inherit the improvements.
- Capture daily status in `handoffs/radio-checks/` and signal Maverick when the branch is ready for review.
