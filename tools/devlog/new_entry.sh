#!/usr/bin/env bash
# Creates production/devlog/entries/<date>-<branch>.md from the template.
# usage: tools/devlog/new_entry.sh "Short title"
set -euo pipefail
cd "$(dirname "$0")/../.."
title="${1:-Untitled}"
start="2026-11-20"   # Day 1 of the 30-day build
today="$(date +%F)"
day=$(( ( $(date -d "$today" +%s) - $(date -d "$start" +%s) ) / 86400 + 1 ))
branch="$(git rev-parse --abbrev-ref HEAD 2>/dev/null | tr '/' '-' || echo local)"
out="production/devlog/entries/${today}-${branch}.md"
if [ -e "$out" ]; then echo "exists: $out (edit it)"; exit 0; fi
sed -e "s/{{DATE}}/$today/" -e "s/{{DAY}}/$day/" -e "s/{{TITLE}}/$title/" -e "s#{{BRANCH}}#$branch#" \
  production/devlog/entry-template.md > "$out"
echo "created $out"
