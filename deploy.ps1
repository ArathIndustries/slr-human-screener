# deploy.ps1 — sync deployable artifacts from the canonical SLR_Screener
# source, commit, and push (GitHub Pages redeploys automatically).
#
# Source of truth: the OneDrive SLR_Screener folder. Never edit index.html or
# the *_current.json files here directly — edit human_screener.html /
# regenerate the JSONs there, then run this script.
#
# Usage:  powershell -File deploy.ps1

$ErrorActionPreference = "Stop"
$src = "C:\Users\Arath\OneDrive - Texas State University\Digital Twin Lit Review\SLR_Screener"
$dst = $PSScriptRoot

$manifest = Get-ChildItem "$src\rules_manifest_*.json" |
            Sort-Object LastWriteTime | Select-Object -Last 1
if (-not $manifest) { throw "no rules_manifest_*.json found in $src" }
if (-not (Test-Path "$src\human_screener.html")) { throw "human_screener.html missing in $src" }
if (-not (Test-Path "$src\corpus_833-1664.json")) { throw "corpus_833-1664.json missing in $src" }

Copy-Item "$src\human_screener.html"  "$dst\index.html" -Force
Copy-Item $manifest.FullName          "$dst\rules_manifest_current.json" -Force
Copy-Item "$src\corpus_833-1664.json" "$dst\corpus_current.json" -Force

Set-Location $dst
git add -A
git diff --cached --quiet
if ($LASTEXITCODE -eq 0) { Write-Output "nothing changed - no commit"; exit 0 }
git commit -m ("sync from SLR_Screener (" + $manifest.Name + ")")
git push
Write-Output ("deployed: " + $manifest.Name)
