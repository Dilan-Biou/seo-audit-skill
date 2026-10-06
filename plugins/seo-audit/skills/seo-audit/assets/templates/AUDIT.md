# SEO Audit — <site> (<date>)

Stack: <framework + version, router, rendering mode>. Production: <origin>.
Routes: indexable <list> · utility <list> · API <list>.

## Baseline
| Metric | Value |
|---|---|
| Search Console impressions / clicks / CTR / position (3 mo) | |
| Indexed pages (`site:`) | |
| Lighthouse mobile perf / SEO / a11y / BP — `/` | |
| LCP / CLS / TBT — `/` | |
| Page weight by type — `/` | |

## Findings
<!-- One block per checklist item that is not OK. OK items: one line each. -->

### 1.2 URL structure — ❌
- **Evidence:** `curl https://www.<site>/x` → 200, same content as apex
- **Problem:** duplicate host
- **Fix:** permanent host redirect in <file>; proxy must route www (TODO if not)
- **Needs data:** no

### <section> — ✅ OK — <one line>

## Planned changes (Phase 2)
| # | Section | Change | Files | Needs answer |
|---|---|---|---|---|

## Out of code (will go to DEVELOPER-TODO)
-
