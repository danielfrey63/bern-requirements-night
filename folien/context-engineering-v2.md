# Context Engeineering v2

## Inhalt 90’

* 20’ Agenda, Begrüssung, Begrifflichkeiten
* 10’ Setup der Gruppen
* 40’ Working Sessions
* 20’ Präsentation der Resultate, Fragen & Abschluss

## KI & Kontext

- Kontext ist der «Arbeitsraum» der KI: Was nicht drin ist, wird aus dem gelernten allgemeinen Wissen bezogen.
- Ziel: Kontext bewusst formen statt zufällig entstehen lassen.
- Takeaway: Kontextqualität schlägt Kontextmenge.

**Speakernotes**

- «Arbeitsraum» heisst: Prompt + Systemregeln + ausgewählte Quellen. Fehlt etwas im Kontext, greift das Modell auf sein allgemeines Trainingswissen zurück, das je nach Modell sehr unterschiedlich gross bzw. spezialisiert sein kann.
- Kontext formen bedeutet: Quellen definieren (z.B. Repo, Spec, Tickets), Umfang begrenzen und einen klaren Einstiegspunkt bieten.
- Qualität schlägt Menge: 3 relevante Dokumente mit aktueller Version schlagen 30 veraltete PDFs.

## Begrenzung des Kontextfensters

- Fenster hat Kapazität: Relevanz priorisieren.
- Zonen: Blind Zone (zu wenig), Smart Zone (kuratierter Kern), Dumb Zone (überladen).
- Praxis: «Was ist heute entscheidungsrelevant?»
- Quelle: [Dex Horthy, &#34;No Vibes Allowed: Solving Hard Problems in Complex Codebases&#34; (YouTube, 2024)](https://www.youtube.com/watch?v=rmvDxxNubIg)

**Speakernotes**

- Modelle haben harte Token-Grenzen: zu viel Kontext verdrängt das Wichtige («Attention dilution»).
- Blind Zone: zu wenig Kontext → Modell greift auf allgemeines Wissen zurück und rät. Typisch, wenn Specs fehlen.
- Smart Zone: komprimierter Kern (Ziele, Constraints, relevante Files/Abschnitte) → beste Präzision.
- Dumb Zone: überfülltes Fenster → Leistung sinkt; je nach Modell kann die Degradation bereits bei ca. ~40% Auslastung beginnen.
- Referenz: [Dex Horthy, &#34;No Vibes Allowed: Solving Hard Problems in Complex Codebases&#34; (YouTube, 2024)](https://www.youtube.com/watch?v=rmvDxxNubIg), Dumb Zone ~40% Context Window ([5:55](https://www.youtube.com/watch?v=rmvDxxNubIg&t=355s)), Smart Zone ([18:45](https://www.youtube.com/watch?v=rmvDxxNubIg&t=1125s))
- Entscheidungsrelevant ist alles, was die aktuelle Aufgabe beeinflusst (z.B. Definition of Done, Datenmodell, kritische Constraints).

## Kontextmanagement-Strategien

Wie finden wir (Mensch und AI) die relevanten Quellen?

- Manuelles, explizites zitieren von Quellen (typischerweise mit @-Notation).
- Manuell oder automatisch erstellte Rules, Memory.
- Automatisiertes Suchen nach relevanten Quellen (z.B. grep).
- Automatische gezielte Abfrage über Model Context Protocol (MCP).
- Automatische semantische Suche über Retrieval Augmented Generation (RAG).

## RAG als Prinzip

- RAG = Retrieval Augmented Generation.
- Semantische Suche zur gezielten Kontextversorgung zur Laufzeit.
- Verschiedene Ansätze: Versteckt (Tools integriert) vs. explizit (sichtbar gesteuert).
- Nutzen: aktuellere Antworten, weniger Halluzinationen.

**Speakernotes**

- RAG koppelt Modellantworten an externe Quellen; Retrieval bestimmt, was ins Kontextfenster gelangt.
- Versteckt: Agent-Tools ziehen Kontext ohne dass der User es steuert. Explizit: User definiert Quelle und Suchkriterien.
- Aktualität ist der grosse Gewinn: statt Trainingswissen wird Live-Wissen genutzt (z.B. letzter Commit, aktuelle Spec).

## 3.2 Suche als Alternative

- Retrieval ohne Embeddings: schnell, transparent, prüfbar.
- Gut für: klare Schlüsselwörter, feste Begriffe, technische Logs.
- In IDEs: auch deterministisch verfügbar und kombinierbar.

**Speakernotes**

- Klassische Suche ist nachvollziehbar: Trefferlisten sind erklärbar und debugbar.
- Keywords funktionieren besonders gut für Konstanten, IDs, API-Namen oder Fehlermeldungen.
- Search-First: erst Trefferliste, dann gezielt RAG auf die Top-Quellen.

## 3.3 MCP Server & Alternativen

- MCP = Model Context Protocol.
- Standardisierter Zugriff auf externe Wissensquellen (Lesend).
- Outputs direkt in MD/Confluence/Jira → Artefakte bleiben synchron (Schreibend).

**Speakernotes**

- MCP macht Tools austauschbar: Quelle wird zu einem standardisierten «Adapter».
- Direkter Output reduziert Medienbrüche: Spec, Ticket und Code bleiben konsistent, weil die KI in die Zielsysteme schreibt.
- Sicherheit: Tokens scoped vergeben, Zugriffe protokollieren, und nur freigegebene Räume anbinden.

## 3.4 Memory

- Kurzfristiger Speicher für langlebige Projektannahmen.
- Nur das behalten, was zwischen Sessions stabil bleibt.
- Auf verschiedenen Ebenen anwendbar: Projekt, User, Global
- Pflege nötig: veraltete Memories aktiv entfernen.

**Speakernotes**

- Memory ist kein Langzeitarchiv, sondern ein Set stabiler Annahmen (z.B. Architekturprinzipien, Datenquellen).
- Auswahlkriterium: Was brauche ich in 2 Wochen noch zuverlässig?
- Hygiene: veraltete Annahmen löschen, sonst wird das Modell falsch «vorgeprägt».

## 4 Setup

- Eigener API Key
  - Kostenpflichtigi
  - Frei
- Provider: OpenAI, Anthropic, Google
-
