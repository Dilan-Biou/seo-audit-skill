# Images, performance, mobile (sections 8–10)

Measure first with `scripts/lighthouse.sh <url>` (mobile, simulated slow 4G) per page type,
and record bytes by resource type. Re-measure after every change; Lighthouse varies ±5
points — run 2–3 times before claiming a regression or win.

## 8. Images
- Compare natural vs rendered width (browser JS: `naturalWidth` vs `getBoundingClientRect`).
  Typical waste: multi-thousand-px logos shown at 48px; 1200px screenshots shown at ~280px.
- Use the framework image component (Next: `next/image`) → resized WebP/AVIF srcset,
  lazy by default. Give fixed width/height (or `fill`) to avoid CLS; set `sizes` to the slot.
- Exactly the LCP image(s): eager + `fetchPriority="high"`. Everything else lazy.
- Frameworks may auto-preload every eager `<img>` — check the `Link` response header and
  `<link rel=preload as=image>` count before/after.
- Alt: meaningful for informative images; `alt=""` when adjacent text says the same.
- Runtime optimizers need a writable cache dir in containers → add a production check
  (`/_next/image?...` returns 200 + image/webp).

## 9. Performance / Core Web Vitals
Read the **LCP phases** (TTFB, load delay, load time, render delay):
- **Render delay large** (seconds) → content hidden until hydration: hero wrapped in JS
  entrance animations starting at `opacity:0`. Fix: render the LCP element with no
  entrance animation; animate hero text with a CSS keyframe (runs at first paint) behind
  `motion-safe:`; keep below-fold animations.
- **Load time large with a small image** → bandwidth contention (fonts, JS). Check fonts:
  self-hosted font families often preload every weight — keep only weights the CSS uses
  (grep weight utilities/CSS). Test `preload:false` before adopting: it can make FCP worse.
- **TTFB large** → per-request rendering (dynamic SSR, no-store). Making pages static is
  usually a refactor (e.g. i18n reading the request) → recommend as a separate plan.
- Unused JS: check if providers/libraries are required by the repo's conventions before
  proposing removal.
- Static assets should be `immutable` long-cache.
- Trade-offs are allowed when UX wins (e.g. text-first mobile hero) — state them.

## 10. Mobile
At 320, 375, 414 px (and desktop to confirm no regression):
- `scrollWidth > innerWidth` → horizontal overflow
- text < 12px; tap targets < 44–48px (pad with `p-3 -m-3` to grow hit area without moving
  the icon); icon buttons labelled
- menu opens, links navigate, menu closes after navigation
- **h1 and primary CTA position**: if the first screen is only an illustration, put the text
  first in the DOM on mobile (desktop grid order unchanged) — confirm with positions, not
  just screenshots.
Note: background/hidden browser panes pause CSS transitions, animations and smooth scroll —
measure state (classes, computed values) instead of trusting a mid-animation screenshot.
