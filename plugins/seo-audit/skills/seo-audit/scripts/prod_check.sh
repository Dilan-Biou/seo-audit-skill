#!/usr/bin/env bash
# Generic SEO checks against a running site (production or a local prod build).
#
# Usage:
#   prod_check.sh --site https://example.com [--base http://127.0.0.1:3123] \
#                 [--index "/ /download"] [--noindex "/invite/x"] [--no-www]
#
#   --site     canonical production origin (what canonicals/sitemap must use)
#   --base     where to send requests (defaults to --site). With a local base, requests
#              carry "Host: <site host>" so host-dependent logic behaves like production.
#   --index    space-separated paths that must be indexable with a self canonical
#   --noindex  space-separated paths that must carry a robots noindex
#   --no-www   skip the www → apex redirect checks
set -u
SITE=""; BASE=""; INDEX="/"; NOINDEX=""; WWW=1
while [ $# -gt 0 ]; do
  case "$1" in
    --site) SITE="${2%/}"; shift 2;; --base) BASE="${2%/}"; shift 2;;
    --index) INDEX="$2"; shift 2;; --noindex) NOINDEX="$2"; shift 2;;
    --no-www) WWW=0; shift;; *) echo "unknown arg $1"; exit 2;;
  esac
done
[ -z "$SITE" ] && { echo "--site required"; exit 2; }
BASE="${BASE:-$SITE}"; HOST="${SITE#*://}"; HOSTHDR=()
[ "$BASE" != "$SITE" ] && HOSTHDR=(-H "Host: $HOST")
PASS=0; FAIL=0
ok(){ PASS=$((PASS+1)); printf "✅ %-52s %s\n" "$1" "${2:-}"; }
bad(){ FAIL=$((FAIL+1)); printf "❌ %-52s %s\n" "$1" "${2:-}"; }
get(){ curl -s -m 30 "${HOSTHDR[@]}" "$BASE$1"; }
code(){ curl -s -o /dev/null -m 30 "${HOSTHDR[@]}" -w "%{http_code} %{redirect_url}" "$BASE$1"; }

# Production-only transport checks
if [ "$BASE" = "$SITE" ]; then
  r=$(curl -s -o /dev/null -m 30 -w "%{http_code} %{redirect_url}" "http://$HOST/")
  [[ "$r" =~ ^30[178]\ https://$HOST/?$ ]] && ok "http → https" "$r" || bad "http → https" "$r"
fi
if [ $WWW = 1 ]; then
  if [ "$BASE" = "$SITE" ]; then
    r=$(curl -s -o /dev/null -m 30 -w "%{http_code} %{redirect_url}" "https://www.$HOST/x-seo-check?q=1")
  else
    r=$(curl -s -o /dev/null -m 30 -H "Host: www.$HOST" -w "%{http_code} %{redirect_url}" "$BASE/x-seo-check?q=1")
  fi
  [[ "$r" == 30[178]\ "$SITE/x-seo-check?q=1" ]] && ok "www → apex (permanent, path+query kept)" "$r" \
    || bad "www → apex (permanent, path+query kept)" "$r  (plain '404 page not found' = proxy has no route)"
fi

# robots + sitemap
R=$(get /robots.txt); rc=$(code /robots.txt)
[[ "$rc" == 200* ]] && ok "robots.txt 200" || bad "robots.txt 200" "$rc"
echo "$R" | grep -qi "^sitemap: $SITE/sitemap.xml" && ok "robots.txt Sitemap line" || bad "robots.txt Sitemap line"
echo "$R" | grep -qiE "^disallow: /\s*$" && bad "robots.txt does NOT block everything" "found 'Disallow: /'" || ok "robots.txt does not block everything"
S=$(get /sitemap.xml)
echo "$S" | python3 -c "import sys,xml.dom.minidom as m; m.parseString(sys.stdin.read())" 2>/dev/null \
  && ok "sitemap.xml valid XML" "$(echo "$S" | grep -o '<loc>' | wc -l) URLs" || bad "sitemap.xml valid XML"
bad_origin=$(echo "$S" | grep -oE '<loc>[^<]+' | sed 's/<loc>//' | grep -v "^$SITE" | head -3)
[ -z "$bad_origin" ] && ok "sitemap URLs use $SITE" || bad "sitemap URLs use $SITE" "$bad_origin"

# indexable pages
for p in $INDEX; do
  H=$(get "$p?utm_source=seo-check"); exp="$SITE${p%/}"; [ "$p" = "/" ] && exp="$SITE"
  c=$(echo "$H" | grep -oE '<link rel="canonical" href="[^"]*"' | head -1 | sed 's/.*href="//;s/"$//')
  [ "${c%/}" = "${exp%/}" ] && ok "canonical $p (with ?utm)" "$c" || bad "canonical $p (with ?utm)" "got '$c' want '$exp'"
  echo "$H" | grep -qiE '<meta name="robots"[^>]*noindex' && bad "$p indexable" "has noindex" || ok "$p indexable"
  t=$(echo "$H" | grep -oE '<title>[^<]*</title>' | head -1); [ -n "$t" ] && ok "$p has <title>" "$t" || bad "$p has <title>"
  echo "$H" | grep -q 'name="description"' && ok "$p has meta description" || bad "$p has meta description"
  og=$(echo "$H" | grep -oE 'property="og:image" content="[^"]*"' | head -1)
  [ -n "$og" ] && ok "$p og:image" "${og#*content=}" || bad "$p og:image"
  echo "$H" | grep -q '<h1' && ok "$p has <h1>" || bad "$p has <h1>"
  echo "$H" | grep -q '<main' && ok "$p has <main>" || bad "$p has <main>"
done
TITLES=$(for p in $INDEX; do get "$p" | grep -oE '<title>[^<]*</title>' | head -1; done | sort | uniq -d)
[ -z "$TITLES" ] && ok "titles unique across indexable pages" || bad "titles unique across indexable pages" "$TITLES"

# noindex pages
for p in $NOINDEX; do
  get "$p" | grep -qiE '<meta name="robots"[^>]*noindex' && ok "$p noindex" || bad "$p noindex"
done

# 404 + icons
r=$(code /seo-check-missing-page); [[ "$r" == 404* ]] && ok "unknown path → 404" "$r" || bad "unknown path → 404 (soft 404?)" "$r"
r=$(code /favicon.ico); [[ "$r" == 200* ]] && ok "favicon.ico 200" || bad "favicon.ico 200" "$r"

H=$(get /); n=$(echo "$H" | grep -c 'application/ld+json')
[ "$n" -ge 1 ] && ok "JSON-LD on home" "$n block(s)" || bad "JSON-LD on home"

echo; echo "passed $PASS, failed $FAIL"; [ $FAIL -eq 0 ]
