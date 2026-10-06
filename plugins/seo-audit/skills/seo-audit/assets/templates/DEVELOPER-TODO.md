# SEO — Developer to-do (outside the code)

Ordered. Tick as you go. Dates are suggestions from the run date (<date>).

## 1. Ship it
- [ ] Review the uncommitted changes on `seo/audit-<date>` (`git diff`), commit, push
- [ ] Deploy
- [ ] Run `bash seo/prod-check.sh` → all ✅ (send failures to the agent)

## 2. Infrastructure (agent never touches these)
- [ ] <e.g. reverse proxy / hosting panel: route `www.<site>` to the app so the redirect can run>
- [ ] <e.g. DNS TXT record for a Search Console Domain property>

## 3. Search Console
- [ ] Domain property exists (covers www/http/subdomains)
- [ ] Sitemaps → submit `<site>/sitemap.xml` → status "Success" within a few days
- [ ] URL Inspection → Request indexing: `<site>/`, `<main pages>`
- [ ] If a duplicate host existed (www/http): URL Inspection on `https://www.<site>/` →
      Test live URL → Request indexing (makes Google process the redirect)
- [ ] Don't re-request repeatedly; don't delete/recreate the property

## 4. Bing Webmaster Tools
- [ ] bing.com/webmasters → Import from Google Search Console → sitemap listed

## 5. Validate in browser
- [ ] Rich Results Test + validator.schema.org on `<site>`
- [ ] PageSpeed Insights `/` and `<main pages>` (mobile + desktop)
- [ ] Share preview in the messengers your users use (Telegram: refresh via @WebpageBot)

## 6. Off-site
- [ ] Store listings link to `<site>`; descriptions use the same facts and vocabulary
- [ ] Company site lists the product with a link (server-rendered)
- [ ] Social bios: link + same one-line description
- [ ] Pitch "best <category>" lists in the market; university/incubator pages if relevant
- [ ] Ask happy users for store ratings (never fake reviews)

## 7. Facts / content still needed
- [ ] <each unanswered REQUIRED or product-fact question, and what it unblocks>

## 8. Re-check dates
- [ ] <date+14d>: Pages report (`/`, main pages indexed?), Sitemaps status, Queries
- [ ] <date+28d>: Performance vs baseline; URL Inspection canonical = yours; favicon in results
- [ ] Monthly: Manual actions / Security issues = none

## Proposals (not built — decide later)
- <e.g. tool page for a confirmed tool intent; static rendering refactor for TTFB; analytics>
