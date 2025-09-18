import { Router } from 'express';

const router = Router();

router.post('/', (req, res) => {
  const { altitude, speed, status } = req.body ?? {};
  if (typeof altitude !== 'number' || typeof speed !== 'number') {
    return res.status(400).json({ error: 'Invalid telemetry payload' });
  }

  console.log('[telemetry]', { altitude, speed, status });
  res.status(202).json({ acknowledged: true });
});

export default router;
