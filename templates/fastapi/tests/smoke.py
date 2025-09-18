"""Simple import smoke test for the FastAPI template.

Runs as part of `make test-unit` to ensure the scaffold loads without requiring
third-party dependencies at runtime. If FastAPI is not installed, the script
exits successfully with a skip message so missions can opt in when ready.
"""

from __future__ import annotations

import importlib
import sys

MODULE = "fastapi"


def main() -> None:
    try:
        importlib.import_module(MODULE)
    except ModuleNotFoundError:
        print("fastapi not installed; skipping template smoke test", file=sys.stderr)
        sys.exit(0)

    app_module = importlib.import_module("templates.fastapi.app.main")
    app = getattr(app_module, "app", None)
    if app is None:
        raise SystemExit("FastAPI template missing `app` instance")

    response = app_module.status()
    if response.get("status") != "ok":
        raise SystemExit("Status endpoint did not return expected payload")

    print("FastAPI template smoke test passed")


if __name__ == "__main__":
    main()
