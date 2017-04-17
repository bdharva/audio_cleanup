#!/bin/sh

# Script and sox both located in usr/local/bin

SOX=sox

if [ $# -lt 2 ]; then
  echo "Usage: $0 infile outfile"
  exit 1
fi

$SOX "$1" "$2" \
  remix - \
  highpass 100 \
  norm \
  compand 0.05,0.2 6:-54,-90,-36,-36,-24,-24,0,-12 0 -90 0.1 \
  vad -T 0.6 -p 0.2 -t 5 \
  fade 0.1 \
  reverse \
  vad -T 0.6 -p 0 -t 7 \
  fade 0.1 \
  reverse \
  norm -0.5

echo "Done."
