---
name: quality-bar
description: Use when designing, building or reviewing UI screens, game systems, or VFX, and before marking any UI, design or VFX story done. Contains the project's quality checklists and review procedures (/ui-review, /design-review, /vfx-review).
---

# Quality bar: UI, game design, VFX

UI, game design and VFX are the game's selling points. A story touching them is not done
until its checklist passes and evidence (screenshots / GIF / bot report) is attached.

## UI checklist (/ui-review)
Benchmarks: Shattered Pixel Dungeon (clarity), Into the Breach (telegraph readability),
Balatro (juice), Sea of Stars and Moonlighter (pixel UI polish and inventory feel).
1. Portrait, one thumb: primary actions in the bottom 60% of the screen.
2. Touch targets >= 12x12 base px (~48 dp at x5); 2 px minimum gap between targets.
3. Any screen reachable in <= 3 taps from the expedition HUD or settlement.
4. Text: pixel font, never smaller than its native size; English + Indonesian strings fit
   (Indonesian strings are often longer) - test both.
5. All panels 9-slice with tiled edges; no stretched art.
6. Every state exists: normal, pressed (2-frame press), disabled, selected, new-item dot.
7. Rarity/status readable without colour (shape or icon too).
8. Panels fade or slide; never scale "rubber" open. Transitions per pixel-techniques.
9. The enemy-intent layer is the most readable thing on the screen at all times.
10. Screenshot test at 1x on the budget phone: a stranger can say what each button does.
Evidence: emulator screenshots of every state, EN + ID.

## Game design checklist (/design-review)
1. Each system has a one-page spec: player fantasy, the decision it creates, numbers,
   how it interacts with 2+ other systems, the metric that proves it works.
2. Every turn offers a meaningful choice (not one obvious best move) - check with the balance
   bot: if the bot's greedy policy matches the best policy >90% of turns, the floor is too flat.
3. Telegraph test: playtesters predict enemy actions correctly >= 90% of the time.
4. First 15 minutes: player makes a real build decision within 5 minutes; no text wall > 2 lines.
5. Difficulty: win-rate targets per difficulty mode and Oath from the balance bot.
6. Loot respects time: guaranteed upgrade every N floors; bad-luck protection.
7. No pay-to-win, no energy, no FOMO timers beyond the 24 h farm cap.
8. Playtest protocol: 5 outside players per milestone, screen-recorded, note every
   confusion moment; "would you play one more run?" asked at the end.

## VFX checklist (/vfx-review)
1. **VFX language sheet** (design/vfx-language.md): one colour family + motion signature per
   element (e.g. fire = upward flicker, warm ramp; frost = sharp shards, cold ramp; storm =
   jagged lines that chain; stone = dust puffs; blight = sinking drips; void = inward pull).
   Every spell's VFX must follow its element's signature.
2. Layers kept separate: **telegraph** (where it will hit, readable, low-motion) vs
   **impact** (juicy, short). Telegraphs never get hidden by impact VFX.
3. Palette-safe: only palette colours, no additive blends that invent colours (except the
   approved glow screen-blend for legendary loot).
4. Duration budget: impact <= 0.35 s, telegraph loops 0.6-1.0 s, total enemy phase <= 0.6 s.
5. Hit feedback numbers per pixel-techniques/hit-feedback.md.
6. Combos must stay readable: when 3+ effects overlap, the lower-priority ones drop particles.
7. Mobile budget: <= 200 active particles; measure frame time on the budget phone.
8. Evidence: GIF of each spell at 1x and 4x, recorded in the emulator.

## Milestone gate add-on
At each roadmap gate, take 5 screenshots and one 15-second vertical clip. Ask:
"Would this make someone stop scrolling on TikTok?" If not, schedule a polish pass before
new content. Consider a paid 1-2 day review from a professional pixel artist / UI designer
at the vertical slice.
