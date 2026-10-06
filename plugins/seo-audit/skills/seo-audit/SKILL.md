---
name: seo-audit
description: This skill should be used when the user wants a website project audited and fixed for SEO end to end — technical SEO, metadata, rendering, structured data, images, Core Web Vitals, mobile, content accuracy, AI-search visibility — with one batched round of developer questions instead of per-section back-and-forth. Triggers on "SEO audit", "fix SEO", "run the SEO skill", "/seo-audit". Deep support for Next.js App Router; generic fallback for other stacks. Produces seo/AUDIT.md, seo/QUESTIONS.md, seo/CHECKLIST.md, seo/DEVELOPER-TODO.md and seo/prod-check.sh in the target repo, and applies code changes without committing.
---

# SEO Audit

Audit a web project against a full SEO checklist, collect every missing fact in **one**
questions file, apply all code fixes, verify them, and hand the developer a checklist plus a
list of everything that has to happen outside the code.

## Operating contract

- **Three phases, one human gate.** Phase 1 audits and asks; the developer answers once;
  Phase 2 applies and verifies; Phase 3 hands off. Do not ask questions section by section.
- **Never commit or push.** Leave all changes uncommitted on a new branch `seo/audit-<date>`
  (create it at the start of Phase 2 if the working tree allows; otherwise work in place and
  say so). The developer reviews and commits.
- **Never change infrastructure** (DNS, reverse proxy, hosting panel, Search Console, stores).
  Put every such action in `seo/DEVELOPER-TODO.md` with exact steps.
- **Never invent product facts.** Prices, platforms, features, company facts, security claims,
  reviews and ratings come only from the developer's answers or the codebase. When unknown,
  leave the copy untouched and list it in DEVELOPER-TODO.
- **Never use competitor brand names** in copy, titles or keywords, even when searched.
- **Never fabricate structured data** (no Review/AggregateRating without real, visible ratings).
- **Follow the target repo's own rules** (CLAUDE.md / AGENTS.md / conventions docs, i18n,
  package manager, lint/test commands). Read them before editing. Run lint + tests + build
  after changes; report failures honestly.
- **Verify, don't assume.** Every fix is checked against a production build served locally
  (see `references/verification.md`), not just by reading code.

## Phase 0 — Orient (silent, no questions)

1. Read the repo's instruction files and conventions.
2. Detect the stack: `package.json`, framework config, router type, rendering mode.
   Next.js App Router → load `references/nextjs-app-router.md`. Otherwise →
   `references/generic-stack.md`. For Next.js, read the installed version's docs under
   `node_modules/next/dist/docs/` before using any API (versions change APIs, e.g. Next 16
   deprecates `priority` on `next/image`).
3. Find the production origin (metadata, env files, deploy config, links). If it cannot be
   determined, it becomes question #1 with no default.
4. Map routes: public/indexable, utility (redirect, invite, auth), API, error pages.

## Phase 1 — Audit (read-only)

Walk every section in `references/checklist-sections.md` in order. For each item record:
**current state → evidence → problem (or "OK") → proposed fix → needs data? (Y/N)**.

- Gather evidence with real requests. Use `scripts/prod_check.sh` against production (if
  reachable) and against a local production build; `scripts/html_audit.py` for headings,
  landmarks, links, images and metadata in server HTML; `scripts/lighthouse.sh` for
  performance (mobile, simulated throttling).
- Record a **baseline** (Search Console numbers, Lighthouse scores, page weight). Ask for GSC
  numbers in QUESTIONS if not provided.

Write two files from the templates in `assets/templates/`:
- `seo/AUDIT.md` — findings per section with evidence and the planned fix.
- `seo/QUESTIONS.md` — every fact needed from the developer, grouped and numbered. **Each
  question carries a default** used if left blank, or is marked `REQUIRED` (only the
  production domain and facts that would otherwise produce false copy). Always include the
  keyword-research task from `references/content-and-keywords.md` (real Google autocomplete
  and top results from the target market) — the agent cannot see localised results.

Then **stop** and tell the developer: fill `seo/QUESTIONS.md`, then say "apply" (or re-run
the skill with "apply").

## Phase 2 — Apply

Triggered by "apply", or a re-run when `seo/QUESTIONS.md` has answers.

1. Parse answers; apply defaults for blanks and record which defaults were used.
2. Read `references/pitfalls.md`. Create the branch (no commit). Implement fixes **in
   checklist order**, the smallest correct change per item, following repo conventions:
   - Technical (HTTPS, URLs, status codes, canonicals, robots, sitemap, indexing):
     `references/technical.md`
   - Metadata, semantic HTML, rendering, structured data: `references/metadata-and-markup.md`
   - Images, performance, mobile: `references/performance-and-mobile.md`
   - Content, keywords, linking, AI search, off-site: `references/content-and-keywords.md`
3. After each section: lint + tests + production build; fix what broke before moving on.
   Add unit tests for non-trivial logic (structured-data builders, route handlers).
4. Run the full verification in `references/verification.md` against the local production
   build, on **every** page type (home, inner page, utility page, 404) and at mobile and
   desktop widths. Record before/after numbers.
5. Re-read `references/pitfalls.md` before declaring done.

## Phase 3 — Handoff

Write from templates:
- `seo/CHECKLIST.md` — every item ticked or open, each with a one-line note (what changed, or
  why it is open / deferred / declined). Include the baseline and the before/after table.
- `seo/prod-check.sh` — production verification tailored to this site (copy
  `scripts/prod_check.sh`, fill in the site's URLs and expected values).
- `seo/DEVELOPER-TODO.md` — everything outside the code, in order: review + commit → deploy →
  run prod-check → proxy/DNS → Search Console → Bing Webmaster Tools → store listings, social
  bios, off-site links → facts still needed → dates to re-check (≈2 and ≈4 weeks).

Finish with a short summary: files changed (uncommitted), what was verified, what failed,
which defaults were applied, and the top 3 developer actions.

## Bundled resources

| Path | Use |
|---|---|
| `references/checklist-sections.md` | Section list and audit questions (Phase 1 backbone) |
| `references/technical.md` | Sections 1.1–1.7: checks and fixes |
| `references/metadata-and-markup.md` | Sections 2–5 |
| `references/performance-and-mobile.md` | Sections 8–10 |
| `references/content-and-keywords.md` | Sections 6–7, 11–17 |
| `references/nextjs-app-router.md` | Next.js implementation patterns and traps |
| `references/generic-stack.md` | Non-Next.js fallback |
| `references/verification.md` | Serving a prod build locally and verifying reliably |
| `references/pitfalls.md` | Real mistakes to avoid (read twice) |
| `scripts/prod_check.sh` | curl checks: redirects, canonicals, robots, sitemap, noindex, OG, favicon |
| `scripts/html_audit.py` | Server-HTML audit: headings, landmarks, links, images, metadata |
| `scripts/lighthouse.sh` | Lighthouse mobile run + compact summary (LCP phases, bytes by type) |
| `assets/templates/` | AUDIT, QUESTIONS, CHECKLIST, DEVELOPER-TODO templates |
