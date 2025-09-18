# Sundown — UI Test Ace (Optional)

## Mission Proposal
Evaluate whether a dedicated Selenium-powered persona should join the squad when UI regression pressure increases.

## Signals to Activate
- Phoenix’s landing page gains complex interactions beyond static content.
- Rooster’s Playwright coverage hits performance ceilings or lacks cross-browser assurance.
- Stakeholders request nightly headless browser sweeps with video capture.

## Pros
- Automates full-stack flows (landing page ↔ backend) with high fidelity.
- Offers reusable page-object library for future feature pods.
- Can run destructive tests in isolated tmux panes without blocking developers.

## Cons
- Selenium grid setup adds resource overhead (consider separate VM or containers).
- Slower feedback loop; needs coordination to avoid locking the shared flightline.
- Maintenance costs: selectors drift, visual diffs require curation.

## Recommendation
Start with Playwright scripts owned by Rooster. Introduce Sundown only if:
1. Mission-critical flows require real-browser validation, and
2. VM resources can support additional panes and headless browsers, and
3. Hondo approves the schedule impact.

If activated, clone `scripts/persona_env/Rooster.env`, rename to `Sundown.env`, extend `scripts/start_tmux_codex.sh` with a QA sub-pane, and log ADR before rollout.
