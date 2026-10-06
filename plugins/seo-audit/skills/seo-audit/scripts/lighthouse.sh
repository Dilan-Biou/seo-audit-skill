#!/usr/bin/env bash
# Lighthouse mobile (simulated slow 4G) + compact summary.
# Usage: lighthouse.sh URL [OUT_JSON]
# Needs Chrome/Chromium and network access to npm (runs lighthouse via pnpm dlx / npx).
# Run 2–3 times before trusting a difference: scores vary by ~±5.
set -eu
URL="$1"; OUT="${2:-${TMPDIR:-/tmp}/lh-$(date +%s).json}"
RUN="npx --yes"; command -v pnpm >/dev/null && RUN="pnpm dlx"
$RUN lighthouse@12 "$URL" --quiet --chrome-flags="--headless=new --no-sandbox" \
  --only-categories=performance,seo,accessibility,best-practices \
  --output=json --output-path="$OUT" >/dev/null 2>&1
python3 - "$OUT" <<'EOF'
import json, sys
r = json.load(open(sys.argv[1])); a = r["audits"]
print("scores:", {k: round(v["score"]*100) for k, v in r["categories"].items() if v["score"] is not None})
for k in ["first-contentful-paint","largest-contentful-paint","total-blocking-time","cumulative-layout-shift","speed-index"]:
    print(f"  {k:26} {a[k]['displayValue']}")
try:
    d = a["largest-contentful-paint-element"]["details"]["items"]
    print("  LCP element:", d[0]["items"][0]["node"].get("snippet","")[:100])
    print("  LCP phases (ms):", {p["phase"]: round(p["timing"]) for p in d[1]["items"]})
except Exception: pass
by = {}
for i in a["network-requests"]["details"]["items"]:
    by[i.get("resourceType")] = by.get(i.get("resourceType"), 0) + i.get("transferSize", 0)
print("  KB by type:", {k: round(v/1024) for k, v in sorted(by.items(), key=lambda x: -x[1])})
fails = [(c, a[x["id"]]["title"]) for c in ("seo","accessibility","best-practices")
         for x in r["categories"][c]["auditRefs"]
         if a[x["id"]].get("score") is not None and a[x["id"]]["score"] < 1 and x.get("weight",0) > 0]
print("  failed SEO/a11y/BP audits:", fails or "none")
print("  json:", sys.argv[1])
EOF
