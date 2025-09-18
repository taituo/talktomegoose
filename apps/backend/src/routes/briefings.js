import { Router } from 'express';
import { getCurrentBriefing } from '../lib/briefings.js';

const router = Router();

router.get('/current', (_req, res) => {
  res.json(getCurrentBriefing());
});

export default router;
