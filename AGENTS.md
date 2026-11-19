# Runedeep — rules for all agents

Read by every agent: Claude Code, and pi (running OpenAI and GLM-5.3-Flash models). `CLAUDE.md` imports
this file; pi loads it automatically from the repo root.

## Project
Turn-based tactical RPG with roguelike expeditions and a home settlement you build.
Android first, portrait. Godot 4.7 (pinned: 4.7.2-stable), typed GDScript.
Setting: Sundara, a Nusantara-inspired archipelago (see `design/game-brief.md`).
Design source of truth: `design/game-brief.md`, then `design/gdd/`. Milestone: `production/milestone.md`
(30-day Chapter 1 build, feature-complete Sat 19 Dec 2026: anything not listed there waits).

## Architecture (do not break)
- `src/sim/` is pure logic: no Node, no scene, no rendering, no time/delta. Deterministic.
  Classes extend `RefCounted`. Same seed + same inputs = same result, always.
- All randomness goes through `Rng` (`src/sim/core/rng.gd`) seeded per run.
  Never call `randi()`, `randf()`, `randomize()` or `RandomNumberGenerator` outside `rng.gd`.
- The sim returns `SimEvent` objects; `src/view/` only animates events. The view never changes sim state.
- Content lives in `src/content/*.json`. New runes, relics, enemies = data + a small effect script.
- No magic numbers in `src/sim/`: balance values live in `src/content/` or `src/sim/tuning.gd`.
- Typed GDScript everywhere (`var hp: int`, typed arrays, return types). Warnings are treated as errors.

## Definition of done
- `make check` passes: parse check, gdUnit4 tests, determinism test, (later) balance smoke
  (200 seeded runs, no crash, no infinite loop).
- Every new sim rule has at least one test, including an edge case.
- New content has a codex entry and localisation keys (en, id).
- Never mark a task done without running `make check` and pasting its summary.

## Pixel art and rendering rules
- Tiles 32x32. Heroes ~44-48 px tall (48 px canvas), small spirits ~28 px, bosses ~90 px on 2x2 tiles.
- World is drawn through a Camera2D with 3 fixed zoom steps and a sharp-bilinear pixel filter:
  battle view 9 tiles across, build view ~14. No free pinch zoom in battle.
- UI renders at native phone resolution, never inside the pixel world. UI 9-slice from `assets/ui/`.
- Nearest filter on all pixel textures, no sub-pixel positions for sprites.
- Every scene has the 5 depth layers (ground, elevation, props with shadows, foreground frame,
  light and air). See `.claude/skills/pixel-techniques/references/scene-depth.md`.
- Every spirit/enemy keeps its 1 px pale rim for contrast.

## Art generation rules
- SpriteCook first, PixelLab only when SpriteCook can't do it or failed twice.
- No test or exploration generations. Only generate assets from an approved task list,
  check the balance first and state the cost before each batch.
- Log every generated asset (asset_id, sha12, label) in `assets/manifests/`.

## Mobile rules
- Touch targets at least 48 dp (~9 mm). One-thumb play in the bottom 60% of the screen.
- Target 60 fps on a 2020 budget Android (Mali-G52). No per-frame allocations in `src/sim/`.
- The app can be killed at any time: save after every turn.

## Monetization rules (hard)
- Never add: energy, loot boxes/gacha, premium currency, paid stats or runes, forced ads, paid speed-ups.
- Paid items are only: full-game unlock, cosmetics (decor packs, hero skins), supporter pack.
- Chapter 1 ships free with no payment code at all; billing work starts with Chapter 2.
- Any store/IAP change needs a human-approved issue first.
- Farms and buildings use real time, capped at 24 h. Never sell speed-ups.

## Writing rules
- Dialogue is AI-written by the writer agent (Claude) only, from `design/lore/characters/*.md`
  and `design/lore/style-guide.md`.
- Max 2 sentences per line, max 4 lines per conversation unless it's a story scene.
- Never use the phrases in `design/lore/banned-phrases.md`. No vague filler, no "it's not X, it's Y".
- Every text change runs `/text-review` (editor pass) before merge. The owner spot-checks main story scenes.
- All player-facing text lives in `src/content/text/*.csv` (en, id).
- Cultural sensitivity list in `design/lore/sensitivity.md` is binding.

## Devlog (Instagram material)
- Every PR adds one entry in `production/devlog/entries/` (`make devlog TITLE="..."`) and, for visible
  changes, a screenshot or GIF in `production/devlog/media/dayNN/`. Keep the "before" image when replacing art or UI.
- @claude drafts the weekly post with `.claude/skills/devlog/SKILL.md`. Nobody posts; the owner does.

## Git
- One task = one branch/worktree. Conventional commits. Never push to main, never force-push.
- Don't edit files outside your task's scope; ask the coordinator.
- Never read or commit `.env`, keystores or API keys.

## Agent lanes
- @claude (Claude Code): coordinator, design, architecture, review, art/audio generation (MCP), dialogue, game feel.
- @gpt (pi + OpenAI model): systems code, scenes, CI, plugins.
- @glm (pi + GLM-5.3-Flash): content data, tests, docs, localisation, refactors with a written spec.
  Never generates art and never writes dialogue.

MCP access (pi uses the owner's MCP extension):
- @gpt may use the Godot MCP to run the game and screenshot its own scene work.
- @glm may use the Godot MCP only to screenshot its own UI/data work.
- Art and audio MCPs (SpriteCook, PixelLab, ElevenLabs) are @claude only, even if pi can see them.
  They spend paid credits; pi agents write the asset need into the task handoff instead.
- Every agent runs `make check` itself before handing off.

## Skills (all agents)
Skills live in `.claude/skills/<name>/SKILL.md`. Claude Code loads them automatically;
pi agents open the file by path when a rule below applies.
- Before any visual / game-feel / UI work, read `.claude/skills/pixel-techniques/SKILL.md` and the matching reference.
- Before generating or importing art, read `.claude/skills/ai-art-pipeline/SKILL.md`.
- Before marking a UI, design or VFX story done, run `.claude/skills/quality-bar/SKILL.md` and attach evidence.
