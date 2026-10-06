# Technical SEO (sections 1.1–1.7)

Decide which **layer** owns each problem before fixing it: proxy/hosting (certs, http→https,
host routing) vs app (redirects by host, canonicals, robots, sitemap). The agent fixes app
code; proxy/DNS work goes to DEVELOPER-TODO.

## 1.1 HTTPS
Check: `openssl s_client` cert subject/SAN/expiry; `curl -I http://…` → 301/308 keeping path
and query, single hop; grep server HTML for `http://` resources.
Fix (app): nothing usually. Canonicals must be built from a hardcoded production origin.
HSTS is a security header, not SEO — mention, don't bundle.

## 1.2 URL structure
Probe variants and compare status + content:
`www.` vs apex, `/x/` vs `/x`, `/X` vs `/x`, `?utm_source=…`, `//x`, `/index`.
- Duplicate host serving 200 → **permanent redirect** to the canonical host. Prefer
  doing it in app config (versioned) unless the developer wants it at the proxy.
  Remember: the redirect only works if the proxy routes that host to the app at all
  (a bare `404 page not found` text/plain = proxy has no route → DEVELOPER-TODO).
- Params / double slash → canonical tag handles them (1.4), not redirects.
- Fragments (`#section`) are not separate URLs.

## 1.3 Status codes
- Real 404 for unknown paths (not 200 "not found" = soft 404). Provide a localized 404 page
  with links home and to the main conversion page; keep status 404 + noindex.
- Pages that accept any id (invite/share/redirect pages) return 200 for anything → noindex
  (1.7), not 404, when they can't validate the id.
- Route handlers that proxy upstream files: 404 only when the resource truly doesn't exist;
  upstream failure/timeouts → 503 + `Retry-After`. Add tests for each branch.
- Chains: only mistyped inputs may take 2 hops; internal links must point at final URLs.

## 1.4 Canonicals
- Absolute, https, production origin, **set per page** (never one canonical in a shared
  layout/template — children inherit it and declare themselves the homepage).
- No canonical on noindex pages or the 404.
- Single source of truth for the origin (one constant used by canonicals, robots, sitemap,
  host redirect).
- Verify with `?utm_source=x` variants: canonical must stay clean.

## 1.5 robots.txt
- Allow everything public **including framework asset paths** (e.g. `/_next/`).
- Disallow API/internal routes (especially routes that stream large files).
- **Do not Disallow pages that must be noindexed** — crawlers must fetch them to see noindex.
- Add `Sitemap:` with the absolute sitemap URL.
- Non-production environments: ask the developer whether they exist publicly. If the
  developer wants them excluded from SEO code entirely, keep robots static; otherwise use
  host-aware rules + `X-Robots-Tag: noindex` for non-production hosts (fail-closed risk:
  if the proxy rewrites Host, production could noindex itself — add a prod check).

## 1.6 Sitemap
- Only canonical, 200, indexable URLs; same exact form as canonicals.
- Omit `changefreq`/`priority` (ignored by Google) and `lastmod` unless accurate per URL
  (a fake "now" teaches Google to distrust it).
- Validate XML; confirm content-type.

## 1.7 Indexing controls
Produce a table: page type | index? | why. Typical noindex: utility/redirect pages carrying
private ids, search results, error pages (framework may add it already). Production must
stay indexable — verify `/` and main pages have **no** robots meta.
