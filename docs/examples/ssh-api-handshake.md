# SSH-Based API Handshake Example

1. Generate service key (performed by Hondo):
   ```bash
   ssh-keygen -t ed25519 -f ops/ssh/mission_api -C "talktomegoose-mission"
   ```
2. Distribute public key to backend server and store private key securely on the VM.
3. Hangman configures Express middleware to require signed headers:
   ```ts
   // apps/backend/src/middleware/sshSignature.ts
   import crypto from 'node:crypto';

   export function verifySignature(req, res, next) {
     const signature = req.headers['x-goose-signature'];
     const payload = JSON.stringify(req.body ?? {});
     const verifier = crypto.createVerify('SHA256');
     verifier.update(payload);
     if (!signature || !verifier.verify(process.env.GOOSE_PUBKEY!, signature, 'base64')) {
       return res.status(401).json({ error: 'Invalid signature' });
     }
     next();
   }
   ```
4. Rooster maintains regression tests under `tests/e2e/telemetry.spec.mjs` using the same keypair.
5. Maverick approves deployment once telemetry messages pass verification.
