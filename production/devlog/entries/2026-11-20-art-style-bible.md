---
date: 2026-11-20
day: 1            # of 30
title: Art lock: 32 colours and a style bible
branch: art-style-bible
agent: claude
kind: art
show: yes               # yes = worth a post/story, no = log only
media: [day01/style-lock-reference-sheet.png]               # paths under production/devlog/media/, e.g. [day03/guard-parry.gif]
---

**Hook (one line a stranger would stop for):** Every sprite in our game will use only these 32 colours. Can you spot the difference?

**What changed (1–3 lines, plain words):** Locked the art style before spending any credits: a 32-colour palette taken from our best tests, size rules, and the 5 depth layers that stop floors looking like wallpaper. The sheet shows each test before and after the lock.

**Numbers:** 32 colours · 8 reference images · mean colour error 13–20/255 after locking · 0 credits spent

**Behind the scenes / AI note:** The first automatic palette wasted 8 of 32 slots on near-black and had no blue for the hero's shirt. Claude switched to a fixed budget per role (stone, moss, skin, danger red...). Measuring also showed the Day 0 heroes are 34 px tall, not the 48 px the rules ask for, so they will be redrawn.
