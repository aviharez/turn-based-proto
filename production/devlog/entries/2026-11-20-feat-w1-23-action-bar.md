---
date: 2026-11-20
day: 1            # of 30
title: "One-thumb action bar"
branch: feat/w1-23-action-bar
agent: claude
kind: added
show: yes               # yes = worth a post/story, no = log only
media: [day01/action-bar-hud.png]
---

**Hook (one line a stranger would stop for):**
Every button sits where your thumb already is.

**What changed (1–3 lines, plain words):**
Strike, Cast, Guard, Parry and End turn sit in the bottom of the screen, with Focus costs on the buttons, HP and Focus pips above them, and a line that explains the enemy you tapped. Buttons switch off when the rules say no.

**Numbers:** (tests passing, files changed, credits spent, time it took, FPS...)
46/46 tests (11 new). Highest button at 81% of screen height (the limit is 40%). Smallest button side 140 px, about 53 dp. 0 credits.

**Behind the scenes / AI note:** (which agent did it, what went wrong, what a human had to fix)
The words still show as keys like UI_HP until @glm adds the strings (W1-15). Claude also caught a double-tap bug: a tap on a button would also have tapped the tile behind it.
