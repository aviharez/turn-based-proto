# Milestone: Chapter 1 feature-complete in 30 days

**Day 1 = Fri 20 Nov 2026 · Day 30 = Sat 19 Dec 2026.**
"Done" = Chapter 1 is feature-complete and playable start-to-finish on an Android phone.
Google Play (closed test, review, store page) is **not** part of these 30 days.

## What ships in Chapter 1
| Area | In | Not in (later updates) |
| --- | --- | --- |
| Battle | 7×8 grid, move / Strike / Cast / Guard / Parry, Focus, telegraphed intents, high ground | Companion ally in battle |
| Spells | Weaving: 4 elements × 3 shapes × 4 modifiers, 5 grimoire slots | Attribute-gated tiers, spellbook crafting |
| Expedition | Wanaraga: 3 floors + Buto Ijo boss, shrine bank-or-push-on, seeded floors, death loses unbanked loot | Endless Depths, Daily Expedition, Oaths |
| Hero | 1 origin × 2 callings (silat fighter, dukun caster), levels, 3 gear slots, 3 rarities | 12 archetypes, skill trees, set bonuses |
| Settlement | Grid with 4 buildings (Forge, Kitchen, Shrine, House), build mode at ~14-tile zoom, upgrades with materials, farm producing offline (24 h cap) | ~12 buildings, quarries |
| House | One room, ~20 furniture pieces from loot and the Forge, place/rotate/remove on a grid, saved | More rooms, visitors, cosmetic packs |
| Allies | 2 allies who move in and run the Forge and Kitchen | Friendships, personal quests |
| Crafting | Forge (gear upgrade), Kitchen (meal = buff for next expedition) | Alchemy |
| Story | Chapter 1 opening, 1 boss scene, ally intros (AI-written, reviewed) | Chapters 2–3 |
| Money | Free. No payments, no ads. | $5.99 unlock arrives with Chapter 2 |
| Languages | English + Indonesian | More |

## Week by week
Each agent works on its own branch per story and opens a PR; `make check` must pass. Owner reviews ~1 h a day.

### Week 1 · 20–26 Nov · "It fights"
- @gpt: battle sim (units, turns, move/Strike, Guard/Parry, Focus, intents, high ground), save after every turn.
- @glm: content schema + loader + validation for units, enemies, runes (JSON), tests for every rule @gpt adds, en/id text keys.
- @claude: battle view grey-box (camera 3 zoom steps, tap-to-select, intent markers, action bar in bottom 60%), feel pass; **art lock**: style bible from existing tests + priced asset list for owner approval (day 3).
- Exit: grey-box battle vs 4 enemies playable on the owner's phone.

### Week 2 · 27 Nov – 3 Dec · "It's a run"
- @gpt: spell weaving, enemy AI picking intents, expedition flow (3 floors + shrine), floor generator (seeded), death/bank rules.
- @glm: rune + enemy data (6 enemies), balance smoke test (200 seeded runs, no crash/softlock), localisation.
- @claude: **art batch 1** (heroes, enemies, Wanaraga tiles/props), battle scene with 5 depth layers, hit feedback/VFX v1, first SFX.
- Exit: a full 3-floor expedition with real art.

### Week 3 · 4–10 Dec · "It's a home"
- @gpt: Buto Ijo boss (2×2, multi-tile intents), settlement grid + build mode, building upgrades, offline farm (24 h cap), house decorating grid (place/rotate/remove, save).
- @glm: gear/meal/furniture data, crafting recipes, tests for economy rules, save-file migration test.
- @claude: **art batch 2** (buildings, ~20 furniture, boss, 2 allies, UI kit), settlement + house UI, ally intro dialogue.
- Exit: run → return home → build/decorate → run again.

### Week 4 · 11–19 Dec · "It's a game"
- All: bug bash, performance on a budget phone (60 fps), onboarding "first minute", juice and VFX polish, balance tuning from simulations + owner playtests.
- @claude: Chapter 1 story text (+ /text-review), music/ambience, final quality-bar reviews.
- **19 Dec: feature-complete build** + devlog recap.

## Rules that keep it to 30 days
- Anything not in the "In" column waits for an update. Use `/cut` when a week slips; never stretch the date.
- Placeholder art is fine until its art batch; art is generated in 2 approved batches only (credits).
- One PR per story, small enough to review in 10 minutes.
- Every PR adds a devlog entry (see `production/devlog/README.md`).

## Owner to-do
- [ ] Day 3: approve the style bible and the priced asset list (SpriteCook balance: 763 credits; a top-up may be needed for batch 2).
- [ ] Daily: play the latest build on your phone, 15 min; leave notes in the PR or `production/playtests/`.
- [ ] Pick the Godot MCP before the first view story.
