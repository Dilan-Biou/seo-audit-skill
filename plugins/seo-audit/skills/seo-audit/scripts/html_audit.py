#!/usr/bin/env python3
"""Audit the SERVER HTML of a URL (what crawlers get before JavaScript).

Usage: html_audit.py URL [--host HOST] [--ua UA] [--find "text" ...]

Prints: head metadata (title, description, canonical, robots, og:*), heading outline,
landmarks, links (zone, href, accessible name) with nameless links flagged, images (alt),
elements shipped at opacity:0, JSON-LD types, and whether each --find string appears in
visible HTML (scripts stripped) — use it to prove content like FAQ answers is server-rendered.
"""
import argparse, json, re, sys, urllib.request
from html.parser import HTMLParser

ap = argparse.ArgumentParser()
ap.add_argument("url"); ap.add_argument("--host"); ap.add_argument("--ua", default="Mozilla/5.0 seo-audit")
ap.add_argument("--find", nargs="*", default=[])
a = ap.parse_args()
req = urllib.request.Request(a.url, headers={"User-Agent": a.ua, **({"Host": a.host} if a.host else {})})
try:
    with urllib.request.urlopen(req, timeout=30) as r:
        status, html = r.status, r.read().decode("utf-8", "replace")
except urllib.error.HTTPError as e:
    status, html = e.code, e.read().decode("utf-8", "replace")

head = html.split("</head>")[0]
def meta(pattern):
    return [re.sub(r"\s+", " ", m)[:140] for m in re.findall(pattern, head)]
print(f"status {status}")
print("title:", meta(r"<title>([^<]*)</title>"))
print("description:", meta(r'<meta name="description" content="([^"]*)"'))
print("canonical:", meta(r'<link rel="canonical" href="([^"]*)"'))
print("robots:", meta(r'<meta name="robots" content="([^"]*)"'))
print("og:", meta(r'<meta property="og:(?:title|url|image)" content="([^"]*)"'))
print("twitter:card:", meta(r'<meta name="twitter:card" content="([^"]*)"'))
print("icons:", meta(r'<link rel="(?:icon|apple-touch-icon)"[^>]*href="([^"]*)"'))
print("metadata outside <head>:", bool(re.search(r"<title>|rel=\"canonical\"", html.split("</head>", 1)[-1])))

class P(HTMLParser):
    def __init__(s):
        super().__init__(); s.zone=[]; s.h=None; s.buf=""; s.out=[]; s.lm={}; s.a=None; s.links=[]; s.imgs=[]; s.hidden=0
    def handle_starttag(s, t, at):
        at = dict(at)
        if t in ("header","nav","main","footer","section","article","aside"):
            s.lm[t] = s.lm.get(t,0)+1
            if t in ("header","main","footer"): s.zone.append(t)
        if re.fullmatch(r"h[1-6]", t): s.h, s.buf = t, ""
        if "opacity:0" in (at.get("style") or "").replace(" ", ""): s.hidden += 1
        if t == "a": s.a = {"href": at.get("href"), "name": at.get("aria-label") or "", "zone": s.zone[-1] if s.zone else "-"}
        if t == "img":
            s.imgs.append((at.get("src","")[:60], at.get("alt")))
            if s.a is not None and at.get("alt"): s.a["name"] += at["alt"]
    def handle_endtag(s, t):
        if t in ("header","main","footer") and s.zone: s.zone.pop()
        if t == s.h: s.out.append("  "*(int(t[1])-1) + f"{t}: {s.buf.strip()[:70]}"); s.h=None
        if t == "a" and s.a is not None: s.links.append(s.a); s.a=None
    def handle_data(s, d):
        if s.h: s.buf += d
        if s.a is not None: s.a["name"] += d

body = re.sub(r"<script.*?</script>", "", html, flags=re.S)
p = P(); p.feed(body)
h1 = sum(1 for o in p.out if o.startswith("h1"))
print(f"\noutline (h1 count {h1}):"); print("\n".join(p.out) or "  (none)")
print("\nlandmarks:", p.lm)
print(f"\nlinks ({len(p.links)}):")
for l in p.links:
    name = re.sub(r"\s+", " ", l["name"]).strip()
    print(f"  {l['zone']:6} {str(l['href'])[:50]:50} | {name[:40] or '❌ NO NAME'}")
print(f"\nimages ({len(p.imgs)}): missing alt attr: {[s for s,alt in p.imgs if alt is None]}")
print("elements shipped at opacity:0 (hidden until JS):", p.hidden)
types = []
for blk in re.findall(r'<script type="application/ld\+json">(.*?)</script>', html, re.S):
    try:
        d = json.loads(blk); nodes = d.get("@graph", [d]); types += [n.get("@type") for n in nodes]
    except Exception as e: types.append(f"INVALID JSON ({e})")
print("JSON-LD types:", types)
import html as h
visible = h.unescape(body)
for f in a.find:
    print(f"find {f[:40]!r}: {'✅ in server HTML' if f in visible else '❌ NOT in server HTML'}")
