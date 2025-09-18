# Rebuild Roadmap

## Phase 1 – Barebones Multi-Agent Loop
- Roolit: Lead Developer + Coder.
- Yksi tmux-sessio, kaksi Codex-paneelia.
- Lead hallinnoi päähaaraa, Coder tekee työn feature-haarassa.
- Tavoite: todeta, että pienin mahdollinen agenttipari toimii ilman manuaalista korjailua.

## Phase 2 – Täysi "Talk to Me Goose" -kokoonpano
- Persoonat: Maverick, Goose, Iceman, Phoenix, Hangman, Rooster, Hondo.
- Käytä `git worktree` -työpuita: `git worktree add personas/Goose feature/goose-core`, jne.
- tmux-käynnistysskripti luo ikkunat ja paneelit ja avaa kunkin worktreen `codex`-paneeliin.
- Jaetut kanavat: `handoffs/inbox.md`, `logs/<persona>.md`.
- Commit-muoto: `[Persona][Task#] Lyhyt kuvaus`.
- Lisää seurantapaneeli logien tai git-statuksen tarkkailuun.

## Periaatteet jatkoon
1. Pidä skriptit pieninä ja testattavina.
2. Dokumentoi päätökset ennen laajennuksia (ADR:t).
3. Automatisoi tmux-git-kytkös worktree-tekniikalla – ei enää tuplaklooneja.
4. Vahvista jokainen askel testillä ennen seuraavaa vaihetta.
