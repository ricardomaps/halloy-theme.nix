#!/usr/bin/env bash
set -euo pipefail

URL="https://themes.halloy.chat"

tmp=$(mktemp)
curl -s "$URL" > "$tmp"

paste \
  <(grep -oP 'name="encoded" value="\K[^"]+' "$tmp") \
  <(grep -oP 'name="name" value="\K[^"]+' "$tmp") |
while read -r encoded name; do
    echo "Fetching theme: $name"

    curl -s "$URL/?/toToml" \
      -X POST \
      -H 'Origin: https://themes.halloy.chat' \
      -H 'Referer: https://themes.halloy.chat/' \
      -H 'Content-Type: application/x-www-form-urlencoded' \
      --data-urlencode "encoded=$encoded" \
      --data-urlencode "name=$name" |
      jq -r '.data | fromjson | .[2]' > "${name}.toml"
done

rm "$tmp"
