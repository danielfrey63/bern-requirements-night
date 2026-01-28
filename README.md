# BäRN Requirements Night 2026

## Context-Engineering v2 – Anforderungen und Lösung endlich auf einer Linie

Dieses Repository enthält Materialien für den Workshop **"Context-Engineering v2"** von [Daniel Frey](https://www.linkedin.com/in/danielfrey63/) an der BäRN Requirements Night 2026.

---

## Überblick

In vielen Projekten laufen Realität (Code) und Dokumentation (Requirements) schnell auseinander. Klassische Prompts reichen nicht mehr aus, um diese Lücke zu schliessen. Dieser 90-minütige Hands-On-Workshop zeigt, wie modernes Context-Engineering funktioniert: Wie man KI-Modelle so führt, dass sie konsistente, kontinuierlich synchronisierte Artefakte erzeugen – von Code über Spezifikationen bis zu Testfällen.

---

## Repository-Struktur

```
2026/
├── ausschreibung/                   # Workshop-Ausschreibung und Proposal
│   ├── ausschreibung.md             # Kurzbeschreibung des Workshops
│   ├── proposal.md                  # Detailliertes Workshop-Konzept
│   └── proposal.pdf                 # PDF-Version des Proposals
├── folien/                          # Präsentationsmaterialien
│   ├── context-engineering-v2.md    # Folien als Markdown
│   ├── context-engineering-v2.pdf   # Folien als PDF
│   ├── process.svg                  # Prozess-Diagramm (Vektor)
│   ├── process.png                  # Prozess-Diagramm (PNG)
│   ├── process-2.png                # Prozess-Diagramm Variante
│   ├── google-ai-studio.png         # Screenshot: Google AI Studio
│   ├── openrouter-settings.png      # Screenshot: OpenRouter Settings
│   ├── kilo-kimi-k2.5.png           # Screenshot: Kilo Code + Kimi
│   ├── kilo-openrouter-gpt-oss.png  # Screenshot: OpenRouter GPT
│   └── kilo-qdrant.png              # Screenshot: Qdrant Integration
├── projects/                        # Beispielprojekte für die Übungen
│   ├── barcode-reader-app/          # Barcode-Scanner App
│   ├── EnergyInfoSwiss-MobileApp/   # Energie-Info App
│   └── sonnendach-ui/               # Sonnendach UI
├── secrets/                         # Verschlüsselte Zugangsdaten
│   ├── decrypt.ps1                  # Entschlüsselungsskript (PowerShell)
│   ├── decrypt.sh                   # Entschlüsselungsskript (Bash)
│   ├── encrypt.ps1                  # Verschlüsselungsskript (PowerShell)
│   └── zugaenge.zip.aes             # Verschlüsselte Zugangsdaten
├── system-prompt/                   # System-Prompt Dokumentation
│   ├── system-prompt.md             # Ausführlicher System-Prompt
│   └── system-prompt.pdf            # PDF-Version
└── .gitignore                       # Git Ignore-Regeln
```

---

## Workshop-Agenda

### Teil 1: Das Fundament (Alle gemeinsam)

- **Setup:** VS Code als Cockpit für alle Projekt-Artefakte einrichten
- **Mindset:** Unterschied zwischen einfachem Prompting und echtem Context-Engineering
- **Die Basis:** Erste Schritte mit der KI-Extension im eigenen Projekt-Kontext

### Teil 2: Die Deep-Dives (Parallele Sessions)

#### Track A: Die Verbindung (MCP & RAG)

- **Model Context Protocol (MCP):** Externe Datenquellen standardisiert anbinden
- **RAG (Retrieval-Augmented Generation):** Kontext iterativ formen für präzise Ergebnisse

#### Track B: Die Zeitreise (Memory & History)

- **Long-Term Memory:** Persistent Context für nachhaltige Weiterentwicklung
- **Kontext-Komprimierung:** Rauschen ausblenden, auf die Essenz fokussieren

#### Track C: Das Ergebnis (Structured Output)

- **Struktur & Schema:** Schema Enforcement für validierbare Formate
- **Use Case:** User Stories in Gherkin-Feature-Files transformieren

### Teil 3: Wrap-Up & Takeaway

- Zusammenfassung der Erkenntnisse
- Nächste Schritte für die praktische Anwendung

---

## Voraussetzungen

- **Eigener Laptop**
- **Visual Studio Code** (Installation oder bestehende Installation)

---

## Zielgruppe

- Business Analysts (BAs)
- Requirements Engineers (REs)
- Product Owner
- Product Manager

---

## Kernthemen

1. **VS Code als zentrales Cockpit** – Alle Projekt-Artefakte (Specs, Docs, Code) an einem Ort
2. **Model Context Protocol (MCP)** – Standardisierter Zugriff auf externe Wissensquellen
3. **RAG (Retrieval-Augmented Generation)** – Präzise Kontextversorgung aus der eigenen Doku
4. **Memory-Techniken** – "Amnesie" bei der Weiterentwicklung verhindern
5. **Structured Output** – Von Prosa zu validierbaren, automatisiert testbaren Formaten

---

## Lernziel

Am Ende des Workshops verstehst du die **Mechanik hinter der Magie**. Du weisst, wie du deine IDE und Context-Engineering nutzt, um Schritt für Schritt die Brücke zwischen Business und Tech zu bauen – für konsistente, synchronisierte Artefakte über den gesamten Projektverlauf.

---

## Autor

**Daniel Frey, Beat Hildebrand, Adrian Thürig**

---

*BäRN Requirements Night 2026*
