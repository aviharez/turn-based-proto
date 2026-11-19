---
name: devlog
description: Use when a PR is opened, a week of the 30-day build ends, a visible feature lands, or the owner asks for Instagram/devlog content. Logs progress to production/devlog/ and turns it into Goomi Builds carousel drafts and captions.
---

# Devlog for Instagram (Goomi Builds)

The owner documents the 30-day Chapter 1 build on Instagram (@goomi_studio, series "Goomi Builds").
Your job: make sure material exists (entries + media) and draft posts. You never post anything.

## 1. Every PR (all agents)
- Add `production/devlog/entries/<date>-<branch>.md` from `production/devlog/entry-template.md`
  (`make devlog TITLE="..."`). Fill Hook, What changed, Numbers, AI note. Set `show: no` for boring plumbing.
- Visible change? Add a screenshot (F9 in the game) or GIF to `production/devlog/media/dayNN/` and list it in `media:`.
  Before/after pairs are the best-performing material: keep the "before" when you replace art or UI.

## 2. Weekly draft (@claude, at each week's exit in production/milestone.md)
1. `make devlog-digest FROM=<week start> TO=<week end> DEVLOG=<n>` → draft in `production/devlog/digests/`.
2. Edit it into one carousel of 5–7 slides using the canvas templates:
   - Cover (`CoverGoomiBuilds`): "Day NN: <hook>" + the best screenshot/GIF.
   - 2–4 content slides: one idea each (a GIF, a before/after, a number, an AI lesson).
   - Patch notes (`SlideDevlog`): + ADDED / ~ FIXED / – CUT, progress % (day/30), NEXT QUEST.
   - Outro (`SlideOutro`).
3. Caption: hook on line 1, 2–3 short lines, one honest AI lesson, a question for comments, 6–8 hashtags.
4. Pixel art for slides goes through `tools/devlog/upscale.py` (integer nearest-neighbour only).
5. Show the draft to the owner. Only if asked, put it on the Instagram canvas as a new page.

## 3. Rules
- Honest: say which parts AI made and what a human fixed. Never fake a screenshot or progress number.
- No spoilers past Chapter 1's first boss reveal unless the owner OKs it.
- Respect `design/lore/sensitivity.md` in captions too.
- Post ideas already planned (pick per week): Day 0 plan + AI team · "why our tiles looked like wallpaper" (edge Wang) ·
  Guard/Parry GIF · art lock before/after · first full run · village build timelapse · house decorating ·
  Buto Ijo boss reveal · "what the AI couldn't do" · Day 30 recap.
