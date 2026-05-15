# Zero-Key AI Radar (Executive Dashboard)

A local-first, serverless intelligence dashboard designed for speed, privacy, and autonomous daily briefings. This architecture utilizes a "Zero-Key" philosophy, meaning it relies entirely on public APIs and keyless AI extraction engines without requiring user registration or API tokens.

## Core Architecture
- **Backend / Orchestrator:** PowerShell Core (Handles data fetching and static site generation).
- **Frontend UI:** HTML5, Tailwind CSS (via CDN), and Vanilla JavaScript.
- **AI Extraction Engine:** [Jina AI Reader](https://jina.ai/reader/) (Converts target URLs into clean Markdown).
- **Persistent Storage:** Browser-native `localStorage` (Zero external database dependency).

## Key Features
1. **AI Radar:** Real-time tech news aggregation directly from the Hacker News API.
2. **GitHub Trends:** Dynamic 7-day rolling window identifying top-trending open-source repositories.
3. **Live AI Scraper:** Interactive UI element allowing real-time, on-demand data extraction from any URL using Jina AI, bypassing standard bot protections.
4. **Persistent Vault:** Save, tag, and permanently store crucial links locally.

## Deployment & Usage
Simply execute the `Refresh_My_Day.ps1` script. The script autonomously fetches the latest intelligence, compiles a standalone HTML dashboard, and serves it instantly.

---
*Built for the Agent-First Development Era.*
