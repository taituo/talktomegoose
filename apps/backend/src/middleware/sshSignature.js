import crypto from 'node:crypto';

const cachedKey = () => {
  const key = process.env.GOOSE_PUBKEY;
  if (!key) {
    console.warn('GOOSE_PUBKEY env var missing; telemetry verification disabled');
  }
  return key;
};

export function verifySignature(req, res, next) {
  const publicKey = cachedKey();
  if (!publicKey) {
    return res.status(503).json({ error: 'Telemetry signing not configured' });
  }

  const signature = req.headers['x-goose-signature'];
  if (!signature) {
    return res.status(401).json({ error: 'Missing signature header' });
  }

  const verifier = crypto.createVerify('SHA256');
  const payload = JSON.stringify(req.body ?? {});
  verifier.update(payload);
  verifier.end();

  const isValid = verifier.verify(publicKey, signature, 'base64');
  if (!isValid) {
    return res.status(401).json({ error: 'Invalid signature' });
  }

  next();
}
