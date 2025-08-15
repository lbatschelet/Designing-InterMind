# Designing InterMind



## Abstract

Affektives Wohlbefinden entsteht situativ im Zusammenspiel materieller Umgebungen, sozialer Dynamiken und sozialer Positionierungen. Aus einer intersektionalen, an *affective geographies* orientierten und kritisch-digitalen Perspektive entwickle ich in dieser Arbeit einen Zugang, der nicht nur das \emph{Was} der Erhebung, sondern auch das *Wie* und *Womit* reflektiert. Ziel ist es, ein offenes, nachvollziehbares Setup für wiederholte, kontextnahe Erhebungen zu konzipieren, technisch umzusetzen und in einer explorativen Pilotstudie hinsichtlich seiner Praxistauglichkeit und Dateneignung für intersektionale Mehrebenenanalysen zu prüfen.

Methodisch kombiniere ich (i) eine theoretische Fundierung in Intersektionalität und *affective geographies* mit (ii) einer kritisch-digitalen Anforderungsanalyse (Transparenz, Datensparsamkeit, Nachvollziehbarkeit), (iii) der Entwicklung einer offenen GEMA-Infrastruktur (*InterMind*) und (iv) der Konstruktion eines kompakten Fragebogens für wiederholte \textit{in situ}-Erhebungen. Die Pilotierung demonstriert die prinzipielle Durchführbarkeit des Gesamt-Setups (Erhebung, Aufbereitung und intersektionales Modell) und ermöglicht eine erste Beurteilung von Teilnahmebelastung, Antwortverteilungen und Varianz sowie der Eignung der Datenstruktur für intersektionale Mehrebenenmodellierung (Identifizierbarkeit, Konvergenz, Unsicherheit).

Die Arbeit leistet drei Beiträge: Erstens integriere ich Intersektionalität, *affective geographies* und kritisch-digitale Perspektiven zu einem kohärenten methodischen Rahmen. Zweitens stelle ich mit *InterMind* eine quelloffene, anpassbare und prüfbare Infrastruktur bereit. Drittens liefere ich Evidenz zur Machbarkeit und Grenzen einer intersektional auswertbaren Datenerhebung im Feld. Die Pilotstudie beansprucht keine inhaltlichen Effektschätzungen oder Generalisierungen; sie markiert einen methodischen Ausgangspunkt für weiterführende, grössere Studien -- mit längeren Erhebungsfenstern, diverseren Stichproben und engerer Co-Kreation mit betroffenen Communities.






## Zeitplan

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


To use the custom build script, that compiles the document, names it with a timestamp, moves it to the top level directory and moves older versions to the archive, run:

```bash
./build_ba.sh
```

To compile the document with latexmk, run:

```bash
latexmk -pdf -outdir=Arbeit/out -jobname=main Arbeit/main.tex
```

