# Verification

## Serve a production build locally
1. Build with the repo's command (e.g. `pnpm build`).
2. Start on a spare port in the background (e.g. `PORT=3123 pnpm start`), poll a health or
   home URL until it answers.
3. **Confirm the server is the new build**: process start time (`ps -eo pid,lstart,cmd`) must be
   after the build artefact's mtime (Next: `.next/BUILD_ID`). A leftover server holding the port
   silently serves the previous build and makes correct fixes look broken.
4. Stop it **by PID** (`ss -ltnp | grep :3123` → `kill <pid>`). Do not `pkill -f <pattern>`
   inside the same shell command chain — the pattern can match the tool's own shell and abort
   the rest of the command.

## Host-dependent behaviour
Use `curl -H "Host: www.example.com" http://127.0.0.1:3123/...` to test host redirects,
host-aware robots, etc. without DNS.

## What to verify per section
- 1.x: `scripts/prod_check.sh http://127.0.0.1:3123 --host example.com` style runs; every
  probe variant from technical.md.
- 2–5: `scripts/html_audit.py` on home, an inner page, a utility page, the 404; JSON-LD parsed
  and every FAQ Q/A found in visible HTML; OG per page (not only home).
- 8–10: `scripts/lighthouse.sh` 2–3 runs per page type; browser checks at 320/375/414 + desktop
  (positions, overflow, tap sizes, menu state). Before/after screenshots for visual changes.
- Content: grep raw HTML (scripts stripped) for each old claim (expect 0) and each new phrase
  (expect ≥ 1).

## Production (after the developer deploys)
`seo/prod-check.sh` must pass. If a host returns `404 page not found` (text/plain, no app
headers like `x-powered-by`) the proxy has no route for it — infrastructure, not code. Compare
with a never-configured subdomain to prove it.
