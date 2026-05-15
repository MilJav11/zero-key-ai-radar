# Zero-Key AI Radar (Executive Dashboard)

A serverless, client-side intelligence dashboard designed for speed, privacy, and autonomous daily briefings. Hosted on the edge via Vercel. This architecture utilizes a "Zero-Key" philosophy, meaning it relies entirely on public APIs and keyless AI extraction engines without requiring user registration or backend infrastructure.

## Core Architecture
- **Frontend Engine:** HTML5, Tailwind CSS (via CDN), and Vanilla JavaScript (Handles asynchronous API data fetching directly in the browser).
- **AI Extraction Engine:** [Jina AI Reader](https://jina.ai/reader/) (Converts target URLs into clean Markdown).
- **Persistent Storage:** Browser-native `localStorage` (Zero external database dependency).
- **Hosting / CI/CD:** Deployed on **Vercel** with automatic continuous deployment linked to the `main` GitHub branch.

## Key Features
1. **AI Radar:** Real-time tech news aggregation directly from the Hacker News API.
2. **GitHub Trends:** Dynamic 7-day rolling window identifying top-trending open-source repositories.
3. **Live AI Scraper:** Interactive UI element allowing real-time, on-demand data extraction from any URL using Jina AI, bypassing standard bot protections.
4. **Persistent Vault:** Save, tag, and permanently store crucial links locally within the browser instance.

## Deployment & Usage
The application is fully hosted and autonomous. Simply visit the Vercel deployment URL to access the live dashboard. The JavaScript engine fetches the latest intelligence in real-time upon page load.

*(Note: The legacy `Refresh_My_Day.ps1` script is kept in the repository for archival purposes and local generation testing, but is no longer required for the primary web app).*

---
*Built for the Agent-First Development Era.*
