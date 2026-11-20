---
date: 2026-11-20
day: 1            # of 30
title: Battle rules on one page
branch: docs-battle-gdd
agent: claude
kind: added
show: no                # yes = worth a post/story, no = log only
media: []               # paths under production/devlog/media/, e.g. [day03/guard-parry.gif]
---

**Hook (one line a stranger would stop for):** Before any code: every number in the battle written on one page, so two AI coders build the same game.

**What changed (1–3 lines, plain words):** Wrote the battle rules: 7×8 grid, move 3, Strike, Guard (halves a hit), Parry (cancels the first hit and throws it back), Focus 2→6, intents locked to tiles, high ground +1 range. All numbers live in `tuning.gd` or JSON.

**Numbers:** 15 tuning constants · 12 acceptance criteria · 16 tests passing · 0 credits

**Behind the scenes / AI note:** Claude wrote the spec. The trick: the sim hands the view a list of legal moves, so the view never has to know the rules.
