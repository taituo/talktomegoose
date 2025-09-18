# Talk to Me Goose (Archived)

> This repository is no longer maintained. It remains public as a reference snapshot for the next iteration of multi-agent tooling.

## Miksi arkistoitiin?
- Projekti oli hauska kokeilu, mutta ympäristöstä kehittyi vaikeasti ylläpidettävä: paneelit kaatuivat usein, automatisaatio hajosi, ja dokumentaatio vanheni nopeammin kuin sitä ehdittiin päivittää.
- README ja skriptit ohjasivat jokaista personaa käyttämään erillistä repo-kloonia. Se eristi työn, mutta johti jatkuviin sync-ongelmiin ja tuplattuun historiaan.
- Nykyiset käytännöt suosivat `git worktree` ‑tekniikkaa: useita työpuita yhdestä repositorystä, kukin omalla branchillaan. Se minimoi ylimääräiset kloonit ja helpottaa merge-prosessia.
- Näiden “best practice” ‑aukkojen ja haurastuneen koodipohjan vuoksi on järkevämpää aloittaa alusta kuin yrittää paikkailla kaikkea.

## Mitä on jäljellä?
Tämä repo on siivottu minimiin. Jäljelle jäi vain seuraavaa:
- `docs/` – lyhyt suunnitelma seuraavan kierroksen rakentamiseksi.
- `handoffs/` – esimerkki inbox-taulukosta (tyhjä runko).
- `scripts/` – satunnaisia apureita, mutta mitään ei luvata toimivaksi sellaisenaan.
- `Makefile` – sisältää vain kevyet toiminnot (tmux, siivous). Moni komentorivin tavoite on nyt stub.

Kaikki demot, templaatit, Astro-sivusto, FastAPI-kokeilut ja muut raskaat kansiot on irrotettu.

## Suunnitelma 1: Barebones-moniagentti (minimitoimiva)
Tavoite on todistaa prosessi mahdollisimman pienesti ennen kuin teema viedään “Top Gun” ‑tasolle.

- **Roolit**: kaksi agenttia – Lead Developer ja Coder.
- **Työjako**: Lead pilkkoo tehtävän, antaa ohjeet ja hyväksyy työn. Coder toteuttaa muutokset.
- **Tekniikka**: yksi repo, yksi tmux-sessio, kaksi `codex`-paneelia.
- **Git**: Lead työskentelee päähaarassa, Coder omalla feature-haarallaan (`feature/coder-…`), vetää/pushaa pienissä sykleissä.
- **Valmiuden kriteeri**: kun tämä looppi toimii vakaasti (ilman jatkuvia käsijahtauksia), voidaan laajentaa seuraavaan suunnitelmaan.

## Suunnitelma 2: Täysi “Talk to Me Goose” ‑kehys (laajennettu versio)
Kun minimialusta on kunnossa, rakennetaan uusi versio seuraavilla parannuksilla:

- **Persoonat**: Maverick (lead), Goose (core-dev), Iceman (stability/review), Phoenix (frontend), Hangman (backend), Rooster (QA), Hondo (PM).
- **Git worktreet**: `git worktree add personas/Goose feature/goose-core`, jne. Jokainen persona saa oman työpuun, mutta jakaa saman repositorion historian.
- **tmux-orkestrointi**: Skripti, joka luo session, ikkunat ja paneelit sekä cd:ää oikeaan worktreehen ja käynnistää AI-CLI:n persona-prompteilla.
- **Jaetut kanavat**: `handoffs/inbox.md` tehtäville ja kysymyksille, `logs/<persona>.md` tiivistelmille ja radio-checkeille.
- **Commit-muoto**: `[Persona][Task#] Lyhyt viesti`, joka helpottaa Maverickin review’ta ja auditointia.
- **Lisänäkymä**: valinnainen kontrollipaneeli, joka näyttää haarojen tilan tai tailaa logeja.

## Miten tätä voi vielä hyödyntää
Vaikka repo on arkistoitu, voit käyttää sitä pohjana:

1. Forkkaa tai kloonaa.
2. Siivoa loputkin legacy-scriptit ja rakenna Suunnitelma 1:n mukainen looppi.
3. Kirjaa havaintoja `docs/`-kansioon ja tee ADR:ä ennen kuin laajennat Suunnitelma 2:een.

> ⚠️ **Varoitus**: mitään nykyisestä skriptistä tai Makefile-komennosta ei tueta virallisesti. Käytä omalla vastuulla ja mieluiten eristetyssä ympäristössä.

Lisenssi ja aiemmat materiaalit pysyvät CC0-ehdoilla. Onnistuneita lentoja seuraavalle miehistölle!
