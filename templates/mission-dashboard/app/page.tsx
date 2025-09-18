const personaEvents = [
  {
    id: 'evt-001',
    persona: 'Maverick',
    timestamp: '2025-09-18T11:02Z',
    message: 'Story mission cleared for launch. Phoenix owns chapter-01 on feature/phoenix-ch01.'
  },
  {
    id: 'evt-002',
    persona: 'Phoenix',
    timestamp: '2025-09-18T11:12Z',
    message: 'Drafted cold open hook; handing to Goose for continuity review.'
  },
  {
    id: 'evt-003',
    persona: 'Goose',
    timestamp: '2025-09-18T11:20Z',
    message: 'Timeline synced with outline. Flagged minor character alias for chapter-02 owner.'
  }
];

const gitActivity = [
  {
    id: 'git-001',
    branch: 'feature/phoenix-ch01',
    commit: 'c0ffee1',
    persona: 'Phoenix',
    summary: 'Add inciting incident scene and update outline'
  },
  {
    id: 'git-002',
    branch: 'feature/goose-ch02',
    commit: 'baddad2',
    persona: 'Goose',
    summary: 'Continuity polish + glossary entry'
  }
];

const mergeQueue = [
  {
    id: 'pr-21',
    branch: 'feature/phoenix-ch01',
    status: 'awaiting review',
    reviewers: ['Goose', 'Rooster']
  },
  {
    id: 'pr-22',
    branch: 'feature/maverick-epilogue',
    status: 'draft',
    reviewers: ['Phoenix']
  }
];

const telemetry = [
  {
    id: 'tele-001',
    metric: 'Words Drafted',
    value: '2,340',
    trend: '+320 since last sync'
  },
  {
    id: 'tele-002',
    metric: 'Chapters Ready',
    value: '1 / 4',
    trend: 'Phoenix ready for merge'
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
  return (
    <main>
      <h1>Talk to Me Goose — Mission Dashboard</h1>
      <p style={{ color: 'var(--muted)', marginBottom: '1.5rem' }}>
        Split-panel view mirroring tmux panes. Replace the sample arrays with
        real data from the FastAPI template when ready.
      </p>

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
        Hook the panels to your FastAPI template (e.g., `/api/events`, `/api/commits`) to stream live
        mission data. ASCII-inspired borders keep the tmux vibe intact.
      </p>
    </main>
  );
}
