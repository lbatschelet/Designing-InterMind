# ba-emotional-city

- [ ] Proposal
  - [X] ~~Erster Draft~~
  - [X] ~~Risikoanalyse~~
  - [ ] Erstellung Fragenkatalog ausführen
  - [X] ~~Zeitplan erstellen~~

---

- [ ] Nächste Termine
  - [X] ~~20.01.2025 07:30 ZOOM mit Moritz Entwurf besprechen~~
  - [X] ~~20.01.2025 14:45 ZOOM mit Caro Betreuung anfragen und Entwurf präsentieren~~
  - [ ] 31.01.2025 08:00 ZOOM mit Moritz Proposal besprechen
  - [ ] 10.04.2025 TBD Besprechung mit Moritz und Caro (nicht 11 - 12:30)
---

# Zeitplan

```mermaid
---
config:
  theme: neo
  title: Bachelorarbeit
---
gantt
    dateFormat  YYYY-MM-DD
    axisFormat  %d.%m
    tickinterval 2week
    todayMarker on
    section App-Entwicklung
    Frameworks evaluieren       :               2025-01-02, 2025-01-20
    Spezifikation und Design    :               2025-01-20, 2025-02-10
    Entwicklung                 :               2025-02-01, 2025-04-10
    Testentwicklung             :               2025-03-01, 2025-03-21
    Alpha Testing               :               2025-03-21, 2025-04-10
    Feedback umsetzen           :               2025-04-18, 2025-05-20
    section _ 
    section Fragenentwicklung
    Literaturrecherche          :               2025-03-01, 2025-05-01
    Fragen entwickeln           :               2025-03-15, 2025-05-01
    Pre-test                    :               2025-04-20, 2025-05-01
    section _ 
    section Datenanalyse
    Datenerhebung               :               2025-05-10, 2025-05-22
    Datenauswertung             :               2025-05-10, 2025-05-30
    section _ 
    section Abschlussphase
    Arbeit Schreiben            :               2025-04-20, 2025-06-20
    Abgabe Probekapitel         : milestone,    2025-06-01, 
    Korrekturlesen              :               2025-06-15, 2025-06-25
    Layout                      :               2025-06-20, 2025-06-26
    Abgabe                      : milestone,    2025-06-27,
    section Prüfungen
    Prüfungswoche Geographie    :               2025-02-10, 2025-02-14
    Prüfungswoche Data Science  :               2025-06-01, 2025-06-10
```


## Latex compile

```bash
latexmk -verbose -pdf -outdir=Arbeit/out -jobname=main Arbeit/main.tex
```

