# SEO — Questions for the developer

Fill in the `Answer:` lines, then tell the agent **"apply"**.
Blank answers use the **Default**. Items marked **REQUIRED** have no safe default.
Short answers are fine. Write "skip" to leave a topic untouched.

## A. Site & infrastructure
1. **Production URL** — REQUIRED (if not detected: `<detected or ?>`)
   Answer:
2. Non-production environments that are publicly reachable (staging, preview)? Should SEO code
   handle them (noindex by host) or ignore them?
   Default: ignore them in SEO code; list in DEVELOPER-TODO.
   Answer:
3. Search Console: property type (Domain / URL-prefix), last 3 months impressions, clicks,
   CTR, avg position, `site:` result.
   Default: baseline recorded as "unknown".
   Answer:

## B. Product facts (used in copy, FAQ, structured data — never guessed)
<!-- One question per unverified claim found in seo/AUDIT.md §13, e.g.: -->
4. Is the product free? Any paid tier or limits?
   Default: don't mention price anywhere new.
   Answer:
5. Platforms: native apps (which stores), web app, iOS?
   Default: keep existing platform text unchanged.
   Answer:
<!-- e.g. offline support, encryption scope, automatic vs manual features, payments,
     notifications, support channels and hours -->

## C. Entity / trust
N. Company behind the product: name, city/country, founding year, type (company/startup/team),
   one-sentence description. Names of people to show (optional).
   Default: no new company facts; About section unchanged.
   Answer:
N. Privacy policy: exists? where? (paste text or URL)
   Default: no /privacy page; listed in DEVELOPER-TODO.
   Answer:
N. Testimonials/reviews on the site — real (with permission) or placeholders?
   Default: leave as-is, never mark up as structured data; flag in DEVELOPER-TODO.
   Answer:

## D. Keyword research (5–30 min, from the target market, incognito google.com)
For each seed term below, paste: autocomplete suggestions, top-5 result types
(app site / store page / article / calculator / forum), "People also ask".
Also: search the core term inside the relevant app stores; copy Search Console → Queries.
Seeds: <core word>, <"app"+word>, <"calculate/online"+word>, <formal synonym>,
<top use case + word>, <current site wording>, <brand>
Default: titles/copy keep current vocabulary; only structural fixes applied.
Answer:

Competitor names to never use in copy (detected + add yours):
Answer:

## E. Preferences
N. Visual changes allowed? (mobile hero order, favicon shape, share image)
   Default: allowed when they fix a measured problem; desktop layout unchanged.
   Answer:
N. Analytics: none / self-hosted (Umami/Plausible) / Google Analytics?
   Default: none (recommendation only).
   Answer:
N. Anything off-limits (files, sections, wording)?
   Answer:
