# SEO Checklist — <site>

Run: <date> · branch `seo/audit-<date>` (uncommitted) · stack <…>
Defaults applied (unanswered questions): <list or "none">

## Baseline → after (local production build, Lighthouse mobile, median of N runs)
| | Before | After |
|---|---|---|
| Performance score `/` | | |
| LCP `/` | | |
| CLS `/` | | |
| Page weight `/` (first load) | | |
| SEO / a11y score | | |

Legend: `[x]` done · `[ ]` open (reason) · `[-]` not applicable · `[~]` deferred/declined (by whom, why)

## 0. Before starting
- [ ] Framework and rendering strategy —
- [ ] Production domain —
- [ ] Public / private / API routes mapped —
- [ ] Existing metadata, robots, sitemap, JSON-LD, analytics identified —
- [ ] Baseline recorded —

## 1. Technical SEO
### 1.1 HTTPS
- [ ] HTTPS everywhere — 
- [ ] http → https permanent —
- [ ] No mixed content —
- [ ] Canonicals use https —
### 1.2 URL structure
- [ ] One clear URL per page (host, slash, case, params) —
### 1.3 Status codes
- [ ] 200 / 30x / 404 / 5xx correct; no soft 404; no chains —
### 1.4 Canonicals
- [ ] Per page, absolute, production origin; params collapse —
### 1.5 robots.txt
- [ ] Exists; assets allowed; API blocked; sitemap line; noindex pages crawlable —
### 1.6 Sitemap
- [ ] Only canonical indexable URLs; valid; correct origin —
### 1.7 Indexing controls
| Page type | Index? | Why |
|---|---|---|
- [ ] noindex where appropriate; production indexable —

## 2. Metadata
- [ ] 2.1 Unique, descriptive titles —
- [ ] 2.2 Unique, accurate descriptions —
- [ ] 2.3 OG/Twitter per page, share image, favicons —

## 3. Semantic HTML
- [ ] One h1, logical hierarchy, landmarks, named links, content in server HTML —

## 4. Rendering
- [ ] Content + metadata in initial HTML for all UAs; no client-only important content —

## 5. Structured data
- [ ] Appropriate types, visible-matching data, absolute URLs, validated —

## 6. Internal linking
- [ ] Important pages linked with descriptive anchors; no nameless links —

## 7. Architecture
- [ ] Shallow, one page per intent; proposals listed —

## 8. Images
- [ ] Modern formats, responsive, lazy below fold, LCP prioritized, alt text —

## 9. Performance
- [ ] LCP / CLS / INP; fonts; JS; caching; TTFB —

## 10. Mobile
- [ ] 320/375/414: overflow, text, tap targets, menu, headline + CTA above fold —

## 11. Search intent
| Page | Offers | Queries | Intent |
|---|---|---|---|
- [ ] Each page answers its searcher's first questions —

## 12. Keywords
- [ ] Research analysed; vocabulary applied; competitor names avoided —

## 13. Content quality
| Claim | Truth | Now says |
|---|---|---|
- [ ] All claims verified —

## 14. AI search
- [ ] Entity facts, direct answers, consistent facts, AI crawlers allowed —

## 15–17. Off-site, Search Console, analytics
See `seo/DEVELOPER-TODO.md`.

## Production test
After deploy: `bash seo/prod-check.sh` — all checks must pass.
