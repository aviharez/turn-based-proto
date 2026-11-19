# Week 1 stories · 20–26 Nov · "It fights"

**Exit:** a grey-box battle against 4 enemies, playable on the owner's phone.
**Rules source:** `design/gdd/battle.md`. Numbers come from `src/sim/tuning.gd` and `src/content/*.json` only.
Each story = one branch = one PR, reviewable in about 10 minutes. `make check` and a devlog entry are required on every PR.

| ID | Story | Lane | Type | Depends on |
| --- | --- | --- | --- | --- |
| W1-01 | [Battle state and units on the grid](W1-01-battle-state.md) | @gpt | Logic | battle.md |
| W1-02 | [Command API and turn loop](W1-02-command-api-turn-loop.md) | @gpt | Logic | W1-01 |
| W1-03 | [Move](W1-03-move.md) | @gpt | Logic | W1-02 |
| W1-04 | [Strike, damage, death, win/lose](W1-04-strike-win-lose.md) | @gpt | Logic | W1-02 |
| W1-05 | [Focus](W1-05-focus.md) | @gpt | Logic | W1-02 |
| W1-06 | [Guard and Parry](W1-06-guard-parry.md) | @gpt | Logic | W1-05, W1-07 |
| W1-07 | [Enemy intents: plan and resolve](W1-07-enemy-intents.md) | @gpt | Logic | W1-03, W1-04 |
| W1-08 | [High ground](W1-08-high-ground.md) | @gpt | Logic | W1-04, W1-07 |
| W1-09 | [Save after every phase](W1-09-save-every-phase.md) | @gpt | Integration | W1-07 |
| W1-10 | [Android debug build for the owner's phone](W1-10-android-debug-build.md) | @gpt | Config | — |
| W1-11 | [Content loader and validation](W1-11-content-loader.md) | @glm | Logic | — |
| W1-12 | [Week 1 unit and encounter data](W1-12-week1-content-data.md) | @glm | Config/Data | W1-11 |
| W1-13 | [Runes schema (Week 2 prep)](W1-13-runes-schema.md) | @glm | Logic | W1-11 |
| W1-14 | [Edge-case tests from battle.md §5](W1-14-edge-case-tests.md) | @glm | Logic | W1-06, W1-08 |
| W1-15 | [Battle HUD text keys (en, id)](W1-15-battle-text-keys.md) | @glm | Config/Data | — |
| W1-20 | [Battle view scaffold and 3-step camera](W1-20-view-scaffold-camera.md) | @claude | UI | — |
| W1-21 | [Tap-to-select and highlights](W1-21-tap-select-highlights.md) | @claude | UI | W1-20 |
| W1-22 | [Intent markers](W1-22-intent-markers.md) | @claude | UI | W1-21 |
| W1-23 | [Action bar and HUD in the bottom 60%](W1-23-action-bar-hud.md) | @claude | UI | W1-22 |
| W1-24 | [Art lock: style bible](W1-24-style-bible.md) | @claude | Visual | — |
| W1-25 | [Art lock: priced asset list, batch 1](W1-25-asset-list-batch1.md) | @claude | Visual | W1-24 |
| W1-26 | [Wire the view to BattleSim](W1-26-wire-view-to-sim.md) | @claude | Integration | W1-02..W1-07, W1-23 |
| W1-27 | [Unit names and codex text](W1-27-unit-names-codex.md) | @claude | Config/Data | W1-12 |
| W1-28 | [Feel pass v1](W1-28-feel-pass-v1.md) | @claude | Visual | W1-26 |
| W1-30 | [Exit playtest on the phone](W1-30-exit-playtest.md) | owner | Playtest | W1-10, W1-26 |

**Suggested start order.** @gpt: W1-01 → W1-02 → W1-03/04/05 → W1-07 → W1-06 → W1-08 → W1-09, with W1-10 any time.
@glm: W1-11 → W1-12 → W1-15 → W1-13, then W1-14 once W1-06 and W1-08 have merged.
@claude: W1-24 → W1-20..23 (the owner approves the art list on Day 3), then W1-26 → W1-28.

**Lane rules** (AGENTS.md): @gpt and @glm never generate art and never write dialogue or codex prose. They write the asset or text need into their PR handoff instead.
