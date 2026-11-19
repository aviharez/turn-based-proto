---
date: 2026-11-20
day: 1            # of 30
title: "Grey-box battle view with 3-step camera"
branch: feat/w1-20-battle-view-camera
agent: claude
kind: added
show: yes               # yes = worth a post/story, no = log only
media: [day01/battle-greybox-zoom-steps.png]
---

**Hook (one line a stranger would stop for):**
Day 1: the battlefield exists. It's grey boxes and coloured circles, and that's the point.

**What changed (1–3 lines, plain words):**
The 7×8 arena now draws on a phone screen with terraces, rocks and unit tokens. Three fixed zoom steps (9, 11 and 14 tiles across), no pinch zoom.

**Numbers:** (tests passing, files changed, credits spent, time it took, FPS...)
18/18 tests passing (7 new for the camera maths). 0 credits spent. A battle tile is 120 px wide on a 1080 px phone, about 46 dp: a finger fits.

**Behind the scenes / AI note:** (which agent did it, what went wrong, what a human had to fix)
Claude built it and checked its own screenshots. The first pass showed a grey gap at the widest zoom and a seam across stacked terraces; both were fixed before the PR.
