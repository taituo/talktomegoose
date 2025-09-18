import { Router } from 'express';

const router = Router();

const featureFlags = new Map([
  ['enhanced-menu', { enabled: true, owner: 'Phoenix' }],
  ['telemetry-stream', { enabled: false, owner: 'Hangman' }]
]);

router.get('/', (_req, res) => {
  res.json(Object.fromEntries(featureFlags));
});

router.patch('/:flag', (req, res) => {
  const flagName = req.params.flag;
  if (!featureFlags.has(flagName)) {
    return res.status(404).json({ error: 'Unknown feature flag' });
  }
  const { enabled } = req.body ?? {};
  if (typeof enabled !== 'boolean') {
    return res.status(400).json({ error: 'enabled must be boolean' });
  }
  const entry = featureFlags.get(flagName);
  const updated = { ...entry, enabled };
  featureFlags.set(flagName, updated);
  res.json({ flag: flagName, ...updated });
});

export default router;
