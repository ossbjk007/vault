---
type: project
date: 2026-08-06
status: actief, repo gedeeld, fase 2 volgt
tags: [project, trading, python]
project: trading-signals
---

Paper-trading signaalsysteem gebouwd met [[Giuseppe-Geukes]], gedeelde privé-repo op GitHub. Combineert IBKR-executie (paper account) met nieuws/macro-data voor aandelen, opties en forex. Geen betaalde data-API's: nieuws/sentiment via Alpha Vantage gratis tier, macro/Fed-data via FRED. X/Twitter-sentiment bewust uitgesteld, geen gratis legale weg zonder ToS-risico.

Kanttekening bij de originele ambitie: echte latency-arbitrage is niet haalbaar op retailschaal (HFT met colocatie wint altijd op snelheid). Gebouwd wordt in plaats daarvan put-call-parity-detectie als informatief signaal, geen geautomatiseerde arbitrage-executie.

Status 6 augustus 2026: repo-skeleton staat lokaal (`~/dev/trading-signals`, buiten de vault) en gepusht naar `github.com/ossbjk007/trading-signals` (privé). Fase 0 (bootstrap, uv, CI) en Fase 1 (IBKR paper-verbinding met paper/live-mode-guard) klaar en getest — lint schoon, 6 unit tests slagen. [[Giuseppe-Geukes]] (`giuseppegks`) heeft push-toegang geaccepteerd, repo is nu echt gedeeld.

Volgende stap: beiden clonen de repo en draaien `scripts/check_ibkr_connection.py` tegen hun eigen IBKR paper-account (zie README). Daarna Fase 2: Alpha Vantage news-sentiment en FRED macro-data-ingestie, parallel te bouwen door beiden.

Volledig architectuurplan (fases 0 t/m 6, risk-limits, libraries): zie `PLAN.md` in de repo zelf.
