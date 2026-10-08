# seo-audit — an SEO audit & fix skill for Claude Code

> Not a developer? Start with the friendly explanation: **[ABOUT.md](ABOUT.md)** · **[فارسی](ABOUT.fa.md)**.

Point it at a web project and it runs a full SEO checklist **end to end**:

1. **Audit** — crawls the code and the live site, runs every check, writes `seo/AUDIT.md`
   and **one** `seo/QUESTIONS.md` with everything it needs from you (each with a default).
2. **You answer once** — product facts, keyword research from your market, preferences.
3. **Apply** — implements all fixes section by section, runs lint/tests/build, verifies on a
   local production build at mobile and desktop widths. **Nothing is committed** — you review.
4. **Handoff** — `seo/CHECKLIST.md` (ticked, with before/after numbers),
   `seo/prod-check.sh` (verify production after deploy), `seo/DEVELOPER-TODO.md`
   (Search Console, Bing, proxy/DNS, stores, off-site, re-check dates).

No section-by-section back-and-forth.

## What it covers
HTTPS · URL structure & duplicate hosts · status codes · canonicals · robots.txt · sitemap ·
indexing controls · titles & descriptions · Open Graph & favicons · semantic HTML · server
rendering · JSON-LD structured data · internal linking · site architecture · images ·
Core Web Vitals (LCP phases, fonts, JS) · mobile · search intent · keyword research ·
content accuracy · AI-search visibility · off-site authority · Search Console · analytics.

Deep support for **Next.js App Router**; a generic guide for other stacks.

## Hard rules it follows
- Never commits, pushes, or touches infrastructure (DNS, proxy, hosting, Search Console).
- Never invents product facts, reviews or ratings; never uses competitor brand names.
- Follows your repo's own conventions (i18n, lint, tests, package manager).
- Verifies every fix against a real production build instead of assuming.

## Install

### As a Claude Code plugin (recommended)
```
/plugin marketplace add Dilan-Biou/seo-audit-skill
/plugin install seo-audit@seo-audit-skill
```
Then in any project: `/seo-audit:seo-audit`, or just ask "run an SEO audit".

### As a plain skill
```bash
git clone https://github.com/Dilan-Biou/seo-audit-skill.git
mkdir -p ~/.claude/skills
cp -r seo-audit-skill/plugins/seo-audit/skills/seo-audit ~/.claude/skills/
```
Then: `/seo-audit`. (Use one install method, not both.)

### Other coding assistants (Cursor, Copilot, …)
Everything is plain Markdown and scripts. Tell the assistant to follow
`plugins/seo-audit/skills/seo-audit/SKILL.md`; the `references/`, `scripts/` and
`assets/templates/` folders work the same way.

## Requirements
- `curl`, `python3` (checks)
- Chrome/Chromium + npm access (Lighthouse via `npx`/`pnpm dlx`) — optional; the audit
  continues without it and says so.

## Use the scripts directly
```bash
S=plugins/seo-audit/skills/seo-audit/scripts
bash $S/prod_check.sh --site https://example.com --index "/ /pricing" --noindex "/share/x"
python3 $S/html_audit.py https://example.com/ --find "a sentence that must be in the HTML"
bash $S/lighthouse.sh https://example.com/
```
A human-oriented cheat sheet lives in
[`plugins/seo-audit/skills/seo-audit/README.md`](plugins/seo-audit/skills/seo-audit/README.md).

## Layout
```
.claude-plugin/marketplace.json        marketplace (this repo)
plugins/seo-audit/
├── .claude-plugin/plugin.json         plugin manifest
└── skills/seo-audit/
    ├── SKILL.md                       workflow the agent follows
    ├── README.md                      cheat sheet for humans
    ├── references/                    per-section guides, Next.js + generic, pitfalls
    ├── scripts/                       prod_check.sh, html_audit.py, lighthouse.sh
    └── assets/templates/              AUDIT, QUESTIONS, CHECKLIST, DEVELOPER-TODO
```

## Contributing
Issues and PRs welcome — especially new entries for `references/pitfalls.md` from real runs,
and framework guides beyond Next.js.

## License
[MIT](LICENSE)
