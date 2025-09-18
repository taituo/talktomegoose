'use client';

import { useEffect, useState } from 'react';

type PersonaEvent = {
  id: string;
  persona: string;
  timestamp: string;
  message: string;
};

type GitActivity = {
  id: string;
  branch: string;
  commit: string;
  persona: string;
  summary: string;
};

type MergeAttempt = {
  id: string;
  branch: string;
  status: string;
  reviewers: string[];
};

type TelemetryMetric = {
  id: string;
  metric: string;
  value: string;
  trend: string;
};

const API_BASE_URL = process.env.NEXT_PUBLIC_API_BASE_URL ?? 'http://localhost:8000';
const API_KEY = process.env.NEXT_PUBLIC_API_KEY;

const SAMPLE_PERSONA_EVENTS: PersonaEvent[] = [
  {
    id: 'evt-001',
    persona: 'Maverick',
    timestamp: '2025-09-18T11:02Z',
    message:
      'Story mission cleared for launch. Phoenix owns chapter-01 on feature/phoenix-ch01.'
  },
  {
    id: 'evt-002',
    persona: 'Phoenix',
    timestamp: '2025-09-18T11:12Z',
    message: 'Drafted cold open hook; handing to Goose for continuity review.'
  }
];

const SAMPLE_GIT_ACTIVITY: GitActivity[] = [
  {
    id: 'git-001',
    branch: 'feature/phoenix-ch01',
    commit: 'c0ffee1',
    persona: 'Phoenix',
    summary: 'Add inciting incident scene and update outline'
  }
];

const SAMPLE_MERGE_QUEUE: MergeAttempt[] = [
  {
    id: 'pr-21',
    branch: 'feature/phoenix-ch01',
    status: 'awaiting review',
    reviewers: ['Goose', 'Rooster']
  }
];

const SAMPLE_TELEMETRY: TelemetryMetric[] = [
  {
    id: 'tele-001',
    metric: 'Words Drafted',
    value: '2,340',
    trend: '+320 since last sync'
  }
];

function Panel({ title, children }: { title: string; children: React.ReactNode }) {
  return (
    <section className="panel">
      <header className="panel-header">
        <span>{title}</span>
        <span className="status">LIVE</span>
      </header>
      <div className="scroll-area">{children}</div>
    </section>
  );
}

export default function MissionDashboard() {
  const [personaEvents, setPersonaEvents] = useState<PersonaEvent[]>(SAMPLE_PERSONA_EVENTS);
  const [gitActivity, setGitActivity] = useState<GitActivity[]>(SAMPLE_GIT_ACTIVITY);
  const [mergeQueue, setMergeQueue] = useState<MergeAttempt[]>(SAMPLE_MERGE_QUEUE);
  const [telemetry, setTelemetry] = useState<TelemetryMetric[]>(SAMPLE_TELEMETRY);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    let cancelled = false;

    async function loadData() {
      try {
        const headers: Record<string, string> = { 'content-type': 'application/json' };
        if (API_KEY) {
          headers['x-mission-key'] = API_KEY;
        }

        const [eventsRes, gitRes, mergeRes, telemetryRes] = await Promise.all([
          fetch(`${API_BASE_URL}/dashboard/persona-events`, { headers }),
          fetch(`${API_BASE_URL}/dashboard/git-activity`, { headers }),
          fetch(`${API_BASE_URL}/dashboard/merge-attempts`, { headers }),
          fetch(`${API_BASE_URL}/dashboard/telemetry`, { headers })
        ]);

        if (cancelled) return;

        if ([eventsRes, gitRes, mergeRes, telemetryRes].some((res) => !res.ok)) {
          throw new Error('One or more dashboard endpoints returned non-200 status');
        }

        const [events, git, merges, tele] = await Promise.all([
          eventsRes.json(),
          gitRes.json(),
          mergeRes.json(),
          telemetryRes.json()
        ]);

        setPersonaEvents(events);
        setGitActivity(git);
        setMergeQueue(merges);
        setTelemetry(tele);
        setError(null);
      } catch (err) {
        if (!cancelled) {
          console.error('Failed to load dashboard data', err);
          setError('Dashboard is showing sample data (API unreachable).');
        }
      }
    }

    loadData();
    const interval = setInterval(loadData, 10_000);

    return () => {
      cancelled = true;
      clearInterval(interval);
    };
  }, []);

  return (
    <main>
      <h1>Talk to Me Goose — Mission Dashboard</h1>
      <p style={{ color: 'var(--muted)', marginBottom: '1.5rem' }}>
        Split-panel view mirroring tmux panes. Configure `NEXT_PUBLIC_API_BASE_URL` and
        `NEXT_PUBLIC_API_KEY` to pull live data from the FastAPI template.
      </p>
      {error && (
        <p style={{ color: '#f97316', marginBottom: '1rem' }}>
          {error} Refresh once the FastAPI mission API is online.
        </p>
      )}

      <div className="panel-grid" style={{ marginBottom: '1rem' }}>
        <Panel title="Persona Comms">
          {personaEvents.map((event) => (
            <article key={event.id} className="event">
              <div className="event-meta">
                {event.timestamp} · {event.persona}
              </div>
              <div className="event-body">{event.message}</div>
            </article>
          ))}
        </Panel>
        <Panel title="Git Activity">
          {gitActivity.map((item) => (
            <article key={item.id} className="event">
              <div className="event-meta">
                {item.persona} · {item.commit}
              </div>
              <div className="event-body">
                <strong>{item.branch}</strong>
                {'\n'}{item.summary}
              </div>
            </article>
          ))}
        </Panel>
      </div>

      <div className="panel-grid">
        <Panel title="Merge Attempts">
          {mergeQueue.map((pr) => (
            <article key={pr.id} className="event">
              <div className="event-meta">{pr.id}</div>
              <div className="event-body">
                <strong>{pr.branch}</strong> — {pr.status}
                {'\n'}Reviewers: {pr.reviewers.join(', ')}
              </div>
            </article>
          ))}
        </Panel>
        <Panel title="Telemetry">
          {telemetry.map((metric) => (
            <article key={metric.id} className="event">
              <div className="event-meta">{metric.metric}</div>
              <div className="event-body">
                <strong>{metric.value}</strong>
                {'\n'}{metric.trend}
              </div>
            </article>
          ))}
        </Panel>
      </div>

      <p className="footer">
        Hook the panels to FastAPI endpoints (`/dashboard/*`) or your own data sources. ASCII borders
        keep the tmux vibe intact while the squad watches commits and comms roll in.
      </p>
    </main>
  );
}
