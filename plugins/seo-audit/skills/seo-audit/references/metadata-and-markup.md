# Metadata, semantic HTML, rendering, structured data (sections 2–5)

## 2.1 Titles
- Unique per page; "Brand — what it is, in words people search". Use keyword research
  answers (Q: keywords) — never guess vocabulary. ~50–60 chars.
- Utility pages (noindex) still get an accurate title: people see it in tabs and shares.
- Display strings go through the repo's i18n system if it has one.

## 2.2 Descriptions
- Unique, accurate, concrete use cases, ~120–155 chars. Not a ranking factor — CTR.
- Every claim must be true per developer answers.

## 2.3 Open Graph / social
- A page-level `openGraph` object **replaces** the parent's whole object (including images
  set by file conventions in some frameworks). Build the full object per page through one
  helper: title, description, url (only for canonical indexable pages — never in a shared
  layout, never on private-id pages), siteName, locale, type, images (1200×630, alt).
- Twitter card is usually derived from OG; confirm `summary_large_image` appears.
- Share image: generate from real brand assets if none exists (logo, brand color, a real
  screenshot, the product tagline). Persian/Arabic text needs proper shaping (PIL with
  raqm works; many SVG/OG renderers don't). Show it to the developer in the handoff.
- Icons: favicon.ico (16/32/48), icon.png sized a **multiple of 48** (e.g. 192) — Google's
  search favicon requirement; apple-touch-icon 180 square (iOS masks it; transparency → black).
  Ask the developer for shape preference (round vs square) in QUESTIONS (default: keep).

## 3. Semantic HTML
Run `scripts/html_audit.py <url>` on each page type. Check:
- exactly one h1; no skipped levels; `main` present; header/nav/footer
- every link has a name (text, img alt, or aria-label); icon-only links/buttons need labels
  (translated); open/close buttons need distinct labels
- **content present in server HTML**: search the raw HTML (scripts stripped) for every
  important string (FAQ answers, feature copy). Collapsed UI (accordion, tabs) often
  doesn't render closed panels — use the component's "keep mounted / hidden until found"
  option.

## 4. Rendering
- Fetch with several user agents (browser, Googlebot, Bingbot, TelegramBot, WhatsApp,
  facebookexternalhit, GPTBot, curl) and confirm title/canonical/og are inside `<head>` for
  all (frameworks with streaming metadata may move them to `<body>` for unknown UAs).
- Count elements shipped with inline `opacity:0` (entrance animations): text is indexable but
  invisible until JS runs → LCP render delay (section 9).
- Check the page needs no client-side fetch for important content.

## 5. Structured data
- One `@graph` on the homepage linking entities by `@id`: Organization (+ parentOrganization
  if a company owns the product — must also be visible on the page), WebSite (site name in
  results), SoftwareApplication/MobileApplication (category, OS, offers price only if known),
  FAQPage generated **from the same strings** the FAQ renders (only if answers are verified).
- Serialize with `<` escaped (`<`). Unit-test the builder (escaping, @id links,
  FAQ mapping). Verify every Q/A in markup is visible on the page.
- Skip: Review/AggregateRating without real ratings; BreadcrumbList without hierarchy.
- Developer validates after deploy: Rich Results Test + validator.schema.org (TODO list).
