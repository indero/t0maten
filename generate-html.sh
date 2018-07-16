#!/usr/bin/env bash
set -e -o pipefail

# Requirement
type pandoc >/dev/null 2>&1 || {
  echo >&2 "I require pandoc but it's not installed. Aborting."
  exit 1
}

cd "$(dirname "$0")"

POMODORI_DIR="${POMODORI_DIR:-./pomodori}"
HTML_DIR="${HTML_DIR:-./html}"
CSS_DIR="${CSS_DIR:-./css}"

cat > "${HTML_DIR}/index.md" <<EOT
---
title: t0maten Overview
---
EOT

# Get the Mont and Year
find "${POMODORI_DIR}" -name '*.markdown' -exec basename -s .markdown "{}" \; \
  | cut -d'-' -f1-2 \
  | sort -u \
  | while read -r month; do

  #Add the month to index.md
  echo -e "\\n## ${month}\\n" >> "${HTML_DIR}/index.md"

  # For each day of a month create a Link
  find "$POMODORI_DIR" -name "${month}*.markdown" \
    -exec basename -s .markdown "{}" \; \
    | sort -u \
    | while read -r day; do

    pandoc \
      --self-contained \
      --metadata="title:Pomodoro ${day}" \
      -o "${HTML_DIR}/${day}.html" \
      -c "${CSS_DIR}/pandoc.css" \
      -c "${CSS_DIR}/github2.css" \
      "${POMODORI_DIR}/${day}.markdown"

    echo "* [${day}](${day}.html)" >> "${HTML_DIR}/index.md"

  done
done

pandoc \
  --self-contained \
  -o "${HTML_DIR}/index.html" \
  -c "${CSS_DIR}/pandoc.css" \
  -c "${CSS_DIR}/github2.css" \
  "${HTML_DIR}/index.md"
