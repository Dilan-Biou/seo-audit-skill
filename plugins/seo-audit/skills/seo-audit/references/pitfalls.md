# Pitfalls (each one happened on a real project)

1. **Canonical or og:url in the shared layout** → every child page (and the 404) declares
   itself the homepage. Origin in layout, paths per page.
2. **Page-level openGraph drops the layout/file-convention image.** Check og:image on an
   inner page, not just home.
3. **Disallowing a page in robots.txt that should be noindex** → Google can't read the
   noindex and may index the bare URL.
4. **Copying framework examples blindly** (`lastModified: new Date()`, changefreq, priority).
5. **Fixed on home, broken elsewhere.** Always verify home + inner + utility + 404.
6. **Stale local server** serving the previous build → "fix doesn't work". Check start time
   vs build time.
7. **Mid-animation screenshots** in a background browser pane look broken (opacity 0,
   menu half-open). Measure computed state instead.
8. **Collapsed UI not in server HTML** (closed accordion panels) → content invisible to
   crawlers despite SSR.
9. **Hero at `opacity:0` waiting for hydration** → seconds of LCP render delay.
10. **Every font weight preloaded**; and the opposite trap: removing preload entirely can
    worsen FCP — measure both.
11. **Content more impressive than the truth** (automatic vs manual, offline, "encrypted",
    implied payments, platforms that don't exist). Verify every claim with the developer.
12. **Competitor names as keywords** (an app called "X & Y" looks like a generic phrase).
    Check phrases against the competitor map before using them.
13. **Fake testimonials / ratings in structured data** → manual action risk. Never mark up.
14. **Proxy vs app confusion**: a host returning plain `404 page not found` is the proxy; no
    app code fixes it.
15. **Google remembers duplicates**: if a www/http duplicate served 200 for months, Google may
    keep it as canonical (and show its old favicon) for weeks after the redirect ships. Tell
    the developer to request indexing on the old host's URL and wait — don't keep changing code.
16. **Removing "unused" dependencies that the repo's conventions mandate** — read the
    architecture docs first.
17. **Typed i18n arrays**: per-item keys may not type-check; don't introduce forbidden casts
    for a nice-to-have (e.g. a link inside an FAQ answer).
18. **Bare keyword belonging to another market** (e.g. "cost splitting" → apartment-building
    fees). Check what Google actually shows before targeting.
