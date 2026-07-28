# SLR Human Screener

Browser tool for human abstract screening in the systematic literature review
*Toward Edge-Intelligent Digital Twins in Smart Manufacturing*. It shows one
article at a time (title + abstract, no machine decisions) and walks the
screener through the locked include/exclude criteria step by step, so every
human decision comes out in the same structured form the screening engine
produces.

**Live tool:** https://arathindustries.github.io/slr-human-screener/

## For screeners

1. Open the link. The article set and rulebook load automatically.
2. Type your name, then click **Start screening**.
3. For each article, read the abstract and answer the questions on screen.
   Include → pick the include code and tier. Exclude → answer yes/no down the
   exclusion ladder; a short reason is required for the code that applies.
   Pending → state what the full text must answer.
4. Your progress saves in the browser automatically — you can close the tab
   and come back later on the same computer.
5. When finished (or any time in between), click **Export results** and email
   the downloaded Excel file to Arath (sergioarathguzman@gmail.com).

If you were sent a link containing `?batch=...` or `?rows=...`, the tool
screens only your assigned articles.

## For maintainers

- **Source of truth** is the OneDrive project folder
  `Digital Twin Lit Review\SLR_Screener\` — `human_screener.html` plus the
  generated `rules_manifest_*.json` (from `export_rules_manifest.py`) and
  `corpus_833-1664.json` (from `export_corpus.py`). This repo holds deploy
  copies only; `deploy.ps1` re-syncs, commits, and pushes.
- **Rules changes** are made in `slr_screener.py`, exported with
  `py export_rules_manifest.py` (which verifies the export against the live
  engine and refuses to write on any mismatch), then published with
  `deploy.ps1`. Every recorded decision is stamped with the rulebook version
  it was made under.
- **Batches**: edit `batches.json` here (repo-owned, not synced). A batch is
  a named row spec, e.g. `"block3": { "rows": "983-1042" }`, reachable as
  `.../?batch=block3&screener=Name`. Ad-hoc assignments work without the
  registry: `.../?rows=983-1042,1100-1105`.
- The exported Excel has two sheets: **Decisions** (human-readable) and
  **machine_data** (the exact decision journal as JSON, one object per row —
  the comparison/scoring script reads this; do not edit it).
- The corpus file contains bibliographic fields and abstracts only — no draft
  or confirmed decisions — so screening stays blind by construction.
