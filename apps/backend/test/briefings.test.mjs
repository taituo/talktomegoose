import { describe, it } from 'node:test';
import assert from 'node:assert/strict';
import { getCurrentBriefing } from '../src/lib/briefings.js';

describe('getCurrentBriefing', () => {
  it('returns mission metadata', () => {
    const briefing = getCurrentBriefing();
    assert.equal(briefing.mission, 'Night Fury');
    assert.equal(briefing.objectives.length, 3);
    assert.match(briefing.eta, /T/);
  });
});
