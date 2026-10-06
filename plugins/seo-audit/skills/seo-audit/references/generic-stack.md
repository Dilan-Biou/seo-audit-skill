# Generic stack fallback (non-Next.js)

Find the equivalent mechanism for each concern; the outputs are framework-independent.

| Concern | Where to look / what to produce |
|---|---|
| Head tags (title, description, canonical, OG) | Template/layout head, per-route head API (Nuxt `useHead`, Astro `<head>` in layout with per-page props, SvelteKit `<svelte:head>`, Remix/React Router `meta`, Django/Rails templates). Canonical built from a configured origin, never from the request host. |
| Host / trailing-slash redirects | Framework redirects config, server middleware, or the reverse proxy (then DEVELOPER-TODO). |
| robots.txt / sitemap.xml | Static files in the public dir, or generated routes/plugins (e.g. `@astrojs/sitemap`, `@nuxtjs/sitemap`). |
| Rendering | **CSR-only SPA** (empty `<div id="root">` in raw HTML): the biggest SEO problem. Recommend SSR/SSG/prerendering as a separate plan; meanwhile ensure head tags are in the static HTML shell. |
| Images | Framework image component if any (Nuxt Image, Astro `<Image>`); otherwise pre-resize to ~2× display width, WebP, `loading="lazy"` below fold, `fetchpriority="high"` on LCP, explicit width/height. |
| Fonts | Only used weights; `font-display: swap`; preload only the body weight if bandwidth-bound — measure. |
| JSON-LD | `<script type="application/ld+json">` with `<` escaped. |
| 404 | Real 404 status + localized page with navigation. |

Verification is identical: build a production bundle, serve it locally, run
`scripts/prod_check.sh` / `scripts/html_audit.py` / `scripts/lighthouse.sh` against it.
