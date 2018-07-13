#!/usr/bin/env bash
set -e -o pipefail

# Requirement
type pandoc >/dev/null 2>&1 || {
  echo >&2 "I require pandoc but it's not installed. Aborting."
  exit 1
}

cd "$(dirname "$0")"
pomodorodir="."

echo "# Overview" > $pomodorodir/html/index.md
echo "" >> $pomodorodir/html/index.md

# Get the Mont and Year
find pomodori -name '*.markdown' -exec basename -s .markdown "{}" \; \
  | cut -d'-' -f1-2 \
  | sort -u \
  | while read -r month; do

  #Add the month to index.md
  echo "## $month\n" >> $pomodorodir/html/index.md

  # For each day of a month create a Link
  for dayofmonth in $(ls -r $pomodorodir/pomodori/${month}*); do

    #echo $dayofmonth;
    dayofmonth_basename=$(basename $dayofmonth .markdown)

    pandoc \
      --self-contained \
      -o $pomodorodir/html/${dayofmonth_basename}.html $dayofmonth \
      -c $pomodorodir/css/pandoc.css \
      -c $pomodorodir/css/github2.css

    echo "* [${dayofmonth_basename}](${dayofmonth_basename}.html)" >> $pomodorodir/html/index.md

  done

  echo "" >> $pomodorodir/html/index.md
done

pandoc \
  --self-contained \
  -o $pomodorodir/html/index.html $pomodorodir/html/index.md \
  -c $pomodorodir/css/pandoc.css \
  -c $pomodorodir/css/github2.css
