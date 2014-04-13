#!/bin/bash
#set -x

# Requirement
type pandoc >/dev/null 2>&1 || { echo >&2 "I require pandoc but it's not installed.  Aborting."; exit 1; }

# We need the path of our project
fullpath=$(python -c 'import os,sys;print os.path.realpath(sys.argv[1])' $0)
pomodorodir=$(dirname $fullpath)

echo "# Overview" > $pomodorodir/html/index.md
echo "" >> $pomodorodir/html/index.md

# Get the Mont and Year
for month in $(for day in $(ls -r $pomodorodir/pomodori/20*); do basename $day .markdown | awk -F- '{print $1"-"$2}'; done | uniq); do

  #Add the month to index.md
  echo "## $month" >> $pomodorodir/html/index.md
  echo "" >> $pomodorodir/html/index.md

  # For each day of a month create a Link
  for dayofmonth in $(ls -r $pomodorodir/pomodori/${month}*); do

    #echo $dayofmonth;
    dayofmonth_basename=$(basename $dayofmonth .markdown)

    pandoc --self-contained -o $pomodorodir/html/${dayofmonth_basename}.html $dayofmonth -c $pomodorodir/css/pandoc.css -c $pomodorodir/css/github2.css

    echo "* [${dayofmonth_basename}](${dayofmonth_basename}.html)" >> $pomodorodir/html/index.md

  done

  echo "" >> $pomodorodir/html/index.md
done

pandoc --self-contained -o $pomodorodir/html/index.html $pomodorodir/html/index.md -c $pomodorodir/css/pandoc.css -c $pomodorodir/css/github2.css
