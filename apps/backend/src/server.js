import express from 'express';
import routerBriefings from './routes/briefings.js';
import routerTelemetry from './routes/telemetry.js';
import routerFeatureFlags from './routes/featureFlags.js';
import { verifySignature } from './middleware/sshSignature.js';

const app = express();
app.use(express.json());
app.use('/api/briefings', routerBriefings);
app.use('/api/telemetry', verifySignature, routerTelemetry);
app.use('/api/feature-flags', routerFeatureFlags);

const port = process.env.PORT || 3001;
app.listen(port, () => {
  console.log(`Talk to Me Goose backend listening on ${port}`);
});
