---
date: 2026-11-20
day: 1            # of 30
title: "Tap to select: move tiles, strike targets, enemy intent"
branch: feat/w1-21-tap-select
agent: claude
kind: added
show: yes               # yes = worth a post/story, no = log only
media: [day01/tap-select.png]
---

**Hook (one line a stranger would stop for):**
Tap your hero: blue is where you can go, orange is who you can hit.

**What changed (1–3 lines, plain words):**
Tapping the hero shows move tiles and strike targets. Tapping an enemy lights up the tiles it is about to hit. A tap on a blue tile sends a move command, and the hero walks there.

**Numbers:** (tests passing, files changed, credits spent, time it took, FPS...)
29/29 tests passing (11 new for tap rules). 0 credits.

**Behind the scenes / AI note:** (which agent did it, what went wrong, what a human had to fix)
Claude caught two problems in its own screenshots: blue tiles too faint on grey stone, and stale strike targets after a move.
