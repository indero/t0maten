#!/usr/bin/env bash
set -e -o pipefail

# Requirement
type pandoc >/dev/null 2>&1 || {
  echo >&2 "I require pandoc but it's not installed. Aborting."
  exit 1
}

cd "$(dirname "$0")"

POMODORI_DIR=${POMODORI_DIR:-./pomodori}
HTML_DIR=${HTML_DIR:-./html}
CSS_DIR=${CSS_DIR:-./css}

cat > ${HTML_DIR}/index.md <<EOT
---
title: t0maten Overview
---

EOT

# Get the Mont and Year
find ${POMODORI_DIR} -name '*.markdown' -exec basename -s .markdown "{}" \; \
  | cut -d'-' -f1-2 \
  | sort -u \
  | while read -r month; do

  #Add the month to index.md
  echo "## $month\n" >> ${HTML_DIR}/index.md

  # For each day of a month create a Link
  for dayofmonth in $(ls -r ${POMODORI_DIR}/${month}*); do

    #echo $dayofmonth;
    dayofmonth_basename=$(basename $dayofmonth .markdown)

    pandoc \
      --self-contained \
      --metadata="title:Pomodoro ${day}" \
      -o ${HTML_DIR}/${dayofmonth_basename}.html \
      -c ${CSS_DIR}/pandoc.css \
      -c ${CSS_DIR}/github2.css \
      $dayofmonth

    echo "* [${dayofmonth_basename}](${dayofmonth_basename}.html)" >> ${HTML_DIR}/index.md

  done

  echo "" >> ${HTML_DIR}/index.md
done

pandoc \
  --self-contained \
  -o ${HTML_DIR}/index.html \
  -c ${CSS_DIR}/pandoc.css \
  -c ${CSS_DIR}/github2.css \
  ${HTML_DIR}/index.md
