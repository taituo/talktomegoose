# SSH-Based API Handshake Example

1. Generate service key (performed by Hondo):
   ```bash
   ssh-keygen -t ed25519 -f ops/ssh/mission_api -C "talktomegoose-mission"
   ```
2. Distribute the public key to the FastAPI service host and keep the private key
   secured on the VM.
3. Hangman adds signature verification to the FastAPI router:
   ```py
   # templates/fastapi/app/security.py
   import base64
   import json
   from pathlib import Path
   from typing import Any

   from fastapi import Depends, HTTPException, Request

   PUBKEY_PATH = Path("ops/ssh/mission_api.pub")


   def verify_signature(request: Request) -> None:
       signature = request.headers.get("x-goose-signature")
       if not signature:
           raise HTTPException(status_code=401, detail="Missing signature")

       payload = json.dumps(request.state.body, separators=(",", ":"))
       public_key = PUBKEY_PATH.read_bytes()

       import cryptography.hazmat.primitives.serialization as serialization
       import cryptography.hazmat.primitives.asymmetric.ed25519 as ed25519

       key = serialization.load_ssh_public_key(public_key)
       assert isinstance(key, ed25519.Ed25519PublicKey)
       try:
           key.verify(base64.b64decode(signature), payload.encode())
       except Exception as exc:  # pragma: no cover
           raise HTTPException(status_code=401, detail="Invalid signature") from exc
   ```
4. Rooster exercises the handshake in `tests/e2e/telemetry.spec.mjs` or Python
   equivalents before approving the mission branch.
5. Maverick merges once telemetry messages pass verification and documentation
   reflects the new security flow.

> ⚠️ The snippet uses the `cryptography` package, which should be added to
> `templates/fastapi/requirements.txt` when the mission implements this pattern.
