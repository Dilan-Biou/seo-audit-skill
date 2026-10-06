# Next.js App Router patterns

Always read the installed version's docs in `node_modules/next/dist/docs/` first
(`01-app/03-api-reference/…`). If `node_modules` is missing, install with the repo's package
manager before auditing.

## Origin + canonicals
```ts
// src/lib/site.ts — single source of truth
export const SITE_URL = new URL("https://example.com");
// app/layout.tsx
export async function generateMetadata(): Promise<Metadata> {
  return { metadataBase: SITE_URL, title, description, openGraph: await openGraph({ title, description }) };
}
// app/page.tsx and each indexable page
alternates: { canonical: "/" }            // per page, never in the layout
```
Metadata merges **shallowly** per key: a page's `openGraph`/`robots`/`alternates` replace the
parent's whole object.

## Host redirect (next.config.ts)
```ts
import { SITE_URL } from "./src/lib/site";
async redirects() {
  return [{ source: "/:path*", has: [{ type: "host", value: `www.${SITE_URL.host}` }],
            destination: `${SITE_URL.origin}/:path*`, permanent: true }]; // 308, keeps query
}
```
Next itself 308s `/x/` → `/x` and `//x` → `/x`.

## robots / sitemap / icons / OG
- `app/robots.ts`, `app/sitemap.ts` (MetadataRoute types). Reading `headers()` makes robots
  dynamic — only do that for host-aware rules.
- `app/favicon.ico`, `app/icon.png`, `app/apple-icon.png` file conventions.
- Prefer an explicit `images` entry in a shared `openGraph()` helper over the
  `opengraph-image` file convention: the file image is lost on any child page that sets its
  own `openGraph`.

## i18n
If the repo uses `next-i18next` (or similar), titles/descriptions/alt text go in locale
files; read them in `generateMetadata` via the server `getT(ns)`. Array items (e.g. FAQ) are
not typed keys — reading them needs `returnObjects` and the repo's existing cast pattern;
avoid adding new `as` casts if conventions forbid them.

## noindex / 404
- `robots: { index: false }` in the page's metadata.
- `app/not-found.tsx` handles all unmatched URLs with status 404 and auto-noindex. It cannot
  export metadata (only `global-not-found` can); a `<title>` element works for first paint
  but the layout title returns after hydration — acceptable for a noindex page.

## JSON-LD
Render `<script type="application/ld+json" dangerouslySetInnerHTML={{ __html:
JSON.stringify(data).replace(/</g, "\\u003c") }} />` in the page.

## Images / fonts
- `next/image`: `width`/`height` + `sizes`; LCP: `loading="eager"` + `fetchPriority="high"`
  (`priority` deprecated in v16). Standalone Docker output needs `sharp` installed and a
  writable `.next/cache`.
- `next/font/local` preloads every listed file; list only used weights.

## Collapsed content
Base UI Accordion: `hiddenUntilFound` keeps panels in the DOM. Radix: `forceMount` /
`hidden="until-found"` patterns. Verify in raw server HTML.

## Streaming metadata
Async `generateMetadata` may stream tags into `<body>` for non-bot UAs; `htmlLimitedBots`
controls the bot list. Verify with multiple UAs rather than assuming.

## Verify build output
`pnpm build` route table: `ƒ` dynamic, `○` static — robots/sitemap/icons should be static.
