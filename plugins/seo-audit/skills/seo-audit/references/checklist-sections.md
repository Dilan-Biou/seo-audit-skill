# Checklist sections (Phase 1 backbone)

Audit in this order. Each item: state → evidence → problem/OK → fix → needs data?
Detailed checks and fixes live in the section guides named in brackets.

## 0. Baseline [verification.md]
- Production origin, framework, rendering mode (SSR / SSG / ISR / CSR / mixed)
- Public routes, utility routes, API routes, error pages
- Where metadata is defined; existing robots.txt, sitemap.xml, JSON-LD, analytics
- Search Console: indexed pages, impressions, clicks, CTR, avg position (ask if unknown)
- Lighthouse mobile per page type; page weight by resource type

## 1. Technical [technical.md]
1.1 HTTPS — cert valid; http→https permanent; no mixed content; canonicals https
1.2 URL structure — one URL per page; www vs apex; trailing slash; case; params; locales
1.3 Status codes — 200 / 301-308 / 404 / 5xx correct; no soft 404; no chains or loops
1.4 Canonicals — absolute, production origin, per page, params collapse to clean URL
1.5 robots.txt — exists, allows assets, blocks API/private, sitemap line, non-prod safety
1.6 Sitemap — only canonical 200 indexable URLs, correct origin, valid XML
1.7 Indexing controls — decision table per page type; noindex where right; prod indexable

## 2. Metadata [metadata-and-markup.md]
2.1 Titles — unique, descriptive, brand + real search words, not stuffed
2.2 Descriptions — unique, accurate, ~120–155 chars, written for the click
2.3 Open Graph / social — per-page og:title/description/url/image 1200×630, twitter card, favicons

## 3. Semantic HTML [metadata-and-markup.md]
- One clear h1, logical hierarchy, landmarks (`main` especially), real links/buttons
- Important content present in server HTML (accordions/tabs/modals often drop it)

## 4. Rendering [metadata-and-markup.md]
- What the server returns before JS; metadata in `<head>` for bots (test several UAs)
- Links discoverable; no client-only data for important content; content hidden by
  animation at `opacity:0` (indexable, but delays LCP)

## 5. Structured data [metadata-and-markup.md]
- Only types that describe the real entity; data visible on the page; absolute URLs
- Typical: Organization, WebSite, SoftwareApplication/MobileApplication, FAQPage (only if
  answers are accurate), BreadcrumbList (only with real hierarchy). Never fake reviews.

## 6. Internal linking [content-and-keywords.md]
- Important pages linked from relevant pages with descriptive anchors; no orphans;
  no nameless links (icon-only links need aria-label)

## 7. Site architecture [content-and-keywords.md]
- Depth, hierarchy, one page per search intent (no doorway pages), slug style

## 8. Images [performance-and-mobile.md]
- Formats, compression, responsive sizes, lazy below fold, eager + high priority for LCP,
  meaningful alt / empty alt for decorative

## 9. Performance / Core Web Vitals [performance-and-mobile.md]
- LCP (and its phases), CLS, INP/TBT, bytes by type, fonts, JS, caching, TTFB

## 10. Mobile [performance-and-mobile.md]
- 320/375/414 widths: overflow, text size, tap targets ≥ 44–48px, menu works,
  hero headline + CTA above the fold

## 11. Search intent [content-and-keywords.md]
- Per page: offer, audience, problem, queries, intent; does the page answer what that
  searcher needs first (price? platform? trust?)

## 12. Keyword research [content-and-keywords.md]
- Developer-supplied autocomplete + top-5 data; spelling variants; modifiers; intents;
  competitor map; terms that look relevant but belong to another market

## 13. Content quality [content-and-keywords.md]
- Every claim checked against reality (features, offline, security, automation, payments,
  platforms); outdated strings; testimonials real?

## 14. AI search [content-and-keywords.md]
- Entity facts (who made it, where, since when), direct Q&A, consistent facts,
  crawlable by AI bots, Bing (ChatGPT search) coverage

## 15. External authority [content-and-keywords.md] — developer actions only
## 16. Search Console [content-and-keywords.md] — developer actions + reading guide
## 17. Analytics [content-and-keywords.md] — recommend; implement only if requested in answers
