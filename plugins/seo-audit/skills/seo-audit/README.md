# seo-audit — cheat sheet (for humans)

The agent reads `SKILL.md`. This page is for you.

## Run it
| Step | You do | You get |
|---|---|---|
| 1 | `/seo-audit` (or "run an SEO audit") in the project | `seo/AUDIT.md` (findings + evidence), `seo/QUESTIONS.md` |
| 2 | Fill `seo/QUESTIONS.md` (blank = default; REQUIRED = must answer) | — |
| 3 | Say **"apply"** | All fixes applied on branch `seo/audit-<date>`, **uncommitted**, verified locally |
| 4 | Read the handoff | `seo/CHECKLIST.md`, `seo/prod-check.sh`, `seo/DEVELOPER-TODO.md` |
| 5 | Review `git diff`, commit, deploy, run `bash seo/prod-check.sh` | ✅ / ❌ per check |
| 6 | Work through `DEVELOPER-TODO.md`; re-check at +2 and +4 weeks | — |

Good answers in QUESTIONS = better results. The most valuable ones:
production URL · real product facts (price, platforms, what's automatic, offline, payments) ·
company facts · privacy policy · **keyword research** (autocomplete + top 5 from your market).

## Scripts you can run yourself
```bash
S=~/.claude/skills/seo-audit/scripts
bash $S/prod_check.sh --site https://example.com --index "/ /pricing" --noindex "/share/x"
python3 $S/html_audit.py https://example.com/ --find "a sentence that must be in the HTML"
bash $S/lighthouse.sh https://example.com/          # run 2–3 times, scores vary ±5
```
Local prod build instead of production: add `--base http://127.0.0.1:3000` to prod_check.sh,
or `--host example.com` to html_audit.py.

## SEO in 20 lines
- **Crawled** → robots.txt allows it; it's linked; it's in the sitemap.
- **Rendered** → important text is in the *server* HTML (View Source / curl, not DevTools).
- **Indexed** → 200 status, no noindex, canonical points to itself.
- **One URL per page** → redirect duplicate hosts (www/http); canonical handles `?utm`.
- **robots Disallow ≠ noindex** → to keep a page out, let it be crawled and say noindex.
- **Canonical / og:url per page**, never in a shared layout.
- **Title** = brand + what it is, in words people actually search. **Description** wins the click.
- **Structured data** only for what's true and visible. No fake reviews, ever.
- **LCP**: the hero must be visible at first paint (no JS fade-in), images sized, fonts trimmed.
- **Mobile**: headline + main button in the first screen; tap targets ≥ 48px.
- **Content**: every claim true; answer "what / for whom / price / platforms / who made it".
- **Keywords**: check what Google shows before targeting a word; never use competitor names.
- **Off-site**: your own listings and profiles link to you; earn mentions, never buy links.
- **Patience**: Google needs days–weeks. Request indexing once, then wait.

## Reading Search Console
| You see | Means |
|---|---|
| Page with redirect | ✅ your redirects working |
| Excluded by noindex | ✅ if it's a page you noindexed |
| Alternate page with proper canonical | ✅ `?utm` etc. collapsing |
| Discovered / Crawled – not indexed | ⏳ new site, or ⚠️ low value if it persists on key pages |
| Google chose different canonical | ⚠️ old duplicate remembered → request indexing on the old URL, wait |
| Temporary processing error (sitemap) | Usually clears; resubmit after 1–2 days |

## Where things live
`SKILL.md` workflow · `references/` how-to per section · `references/pitfalls.md` real mistakes ·
`scripts/` checks · `assets/templates/` output files.
