import crypto from 'node:crypto';

const baseUrl = process.env.TEST_BASE_URL ?? 'http://localhost:3001';
const privateKey = process.env.GOOSE_PRIVATE_KEY ?? '';
const shouldRun = process.env.ENABLE_TELEMETRY_TEST === '1';

const payload = {
  altitude: 35000,
  speed: 420,
  status: 'GREEN'
};

function signPayload(data) {
  const signer = crypto.createSign('SHA256');
  signer.update(JSON.stringify(data));
  signer.end();
  return signer.sign(privateKey, 'base64');
}

async function main() {
  if (!shouldRun) {
    console.log('Telemetry test skipped (set ENABLE_TELEMETRY_TEST=1 to enable).');
    return;
  }
  if (!privateKey) {
    console.error('GOOSE_PRIVATE_KEY missing; cannot run telemetry test');
    process.exit(1);
  }
  const signature = signPayload(payload);
  const response = await fetch(`${baseUrl}/api/telemetry`, {
    method: 'POST',
    headers: {
      'content-type': 'application/json',
      'x-goose-signature': signature
    },
    body: JSON.stringify(payload)
  });
  if (response.status !== 202) {
    console.error(`Telemetry handshake failed: ${response.status}`);
    process.exit(1);
  }
  console.log('Telemetry handshake verified');
}

main().catch((error) => {
  console.error('Telemetry test crashed', error);
  process.exit(1);
});
