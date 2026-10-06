# Linking, architecture, content, keywords, AI search, off-site (6–7, 11–17)

## 6. Internal linking
Extract all `<a>` with zone (header/main/footer), href, text/aria-label. Check: the main
conversion page is linked from home with descriptive anchors; no orphans; no nameless links;
links to large files sit under robots-blocked paths.

## 7. Architecture
Flat sites are fine. Propose new pages only per **distinct search intent** backed by keyword
answers (tool, guide, comparison…); never one page per synonym (doorway pages). Short English
slugs share better than non-Latin slugs (percent-encoding). New-page ideas go to
DEVELOPER-TODO as proposals — do not build them unless the answers request it.

## 11. Search intent
Per indexable page fill: offers / audience / problem / likely queries / intent
(commercial, navigational, transactional, informational, tool). Then check the page answers
that searcher's first questions above the fold: what is it, is it free, does it work on my
device, can I trust it, where do I get it. Typical gaps: price never stated on home; platform
claims wrong; iOS users with a web-only app get no "add to home screen" steps.

## 12. Keyword research (developer task — always in QUESTIONS)
Ask the developer to collect, from the target market in an incognito window, for 5–8 seed
terms: Google autocomplete, top-5 result *types*, People-also-ask / related searches; plus
app-store search for the core term; plus Search Console Queries. Seeds: core everyday word,
"app/tool + word", "calculate/online + word", formal synonym, top use-case modifier, the
site's current wording, the brand name.
Analyse: spelling variants (use naturally, once or twice), top modifiers (e.g. a use case),
tool intent (calculators ranking → suggest a tool page as a proposal), bare terms that belong
to another market (avoid), current #1 rankings on zero-volume terms, brand ambiguity
(pair brand with a descriptor), competitor map (**never** use their names in copy).

## 13. Content quality
Dump every user-facing string (i18n files or templates). For each factual claim build a row:
claim | where | needs verification? Typical risky claims: "all data encrypted", "works
offline", "automatic reminders/notifications", "instant notifications", "one tap settles"
(implies payments), "unlimited", platform lists, support hours without a channel. Put each in
QUESTIONS with default "soften to the verifiable minimum". Also: outdated strings, unused
keys (verify zero references incl. dynamic keys before deleting), inconsistent domains (www),
placeholder testimonials (ask; if fake, recommend removal; never mark them up).

## 14. AI search
Ensure direct, self-contained answers exist for: what is it, who is it for, is it free,
which platforms, who made it (entity: company, city, year), how is it different (only true
differentiators), is it trustworthy (privacy policy page, contact). Keep facts identical
everywhere (copy, FAQ, structured data, store listings). robots must not block AI crawlers
unless the developer opts out. Don't add `llms.txt` by default (not used by Google).

## 15. External authority (DEVELOPER-TODO only)
Own properties first: store listings link to the site; company site lists the product with a
link (and is server-rendered); social bios link + identical one-line description. Then:
editorial "best apps" lists in the market, university/incubator pages, real store reviews.
Never: bought links, link exchanges, fake reviews.

## 16. Search Console (DEVELOPER-TODO + guide)
Steps: Domain property (DNS TXT) covering all hosts; submit sitemap; URL Inspection →
Request indexing for changed pages **and for the old duplicate host's homepage** (e.g.
`https://www.example.com/`) so Google re-processes the redirect; Bing Webmaster Tools
(import from GSC — ChatGPT search relies on Bing). Explain expected "not indexed" reasons
(redirect, noindex, alternate canonical, robots-blocked) vs worrying ones (crawled – not
indexed, Google chose different canonical). Favicon in results follows the page Google
treats as the homepage — it lags until canonical consolidation.

## 17. Analytics
Ranking-neutral. Recommend only; implement only if the answers ask for it. For markets where
Google services are unreliable (e.g. Iran), prefer self-hosted cookieless Umami/Plausible on
the developer's own domain; track conversion clicks via data attributes. Defer when traffic is
tiny (< ~50–100 search clicks/month).
