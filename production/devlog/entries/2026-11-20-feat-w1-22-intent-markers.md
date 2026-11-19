---
date: 2026-11-20
day: 1            # of 30
title: "Intent markers: see every hit before it lands"
branch: feat/w1-22-intent-markers
agent: claude
kind: added
show: yes               # yes = worth a post/story, no = log only
media: [day01/intent-markers.png]
---

**Hook (one line a stranger would stop for):**
The enemies tell you exactly where they'll hit. The puzzle is what you do about it.

**What changed (1–3 lines, plain words):**
Every enemy attack shows as red tiles with a damage number, and stacked hits read "2+6". The tile under the hero pulses and the hero gets a red ring. Enemies that are only walking this turn get a chevron.

**Numbers:** (tests passing, files changed, credits spent, time it took, FPS...)
35/35 tests passing (6 new). 0 credits.

**Behind the scenes / AI note:** (which agent did it, what went wrong, what a human had to fix)
First try: damage numbers were unreadable mush, because an 8 px font got blown up ×3.75. Fix: draw world text at screen resolution. The hero's red ring also vanished on a red tile until it got a pale edge.
