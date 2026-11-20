# Battle (Week 1 rules)

> **Status**: Approved for Week 1 build · **Owner**: @claude · **Builders**: @gpt (sim), @glm (data, tests), @claude (view)
> **Source**: `design/game-brief.md` (Controls, First minute, Challenge), `production/milestone.md` Week 1.
> **Scope**: move, Strike, Guard, Parry, Focus, intents, high ground, win/lose.
> Cast and spell weaving come in Week 2 and get their own GDD (`design/gdd/spell-weaving.md`).

## 1. Overview

One hero fights a small group of spirits on a 7×8 tile grid. Rounds alternate:
the player moves and acts, then every enemy carries out the attack it **announced
a turn earlier** (its *intent*). Intents mark the exact tiles they will hit, so
the player always knows what is coming. In response the player can step out of the red
tiles, **Guard** to halve the damage, or **Parry** to cancel one hit and throw
it back at the attacker. **Focus** pays for Guard and Parry and comes back
slowly, so the player can't block every hit. Standing on **high ground** adds
+1 attack range. The battle is won when every enemy is down and lost when the
hero's HP reaches 0.

## 2. Player Fantasy

"I read the fight and turned their attack against them." The player sees every
hit coming and feels clever for picking the right answer: dodge this one, guard
that one, parry the brute's smash back into its face. A turn should take
seconds, not minutes.

## 3. Detailed Rules

### 3.1 Grid
- Size: `Tuning.ARENA_WIDTH` × `Tuning.ARENA_HEIGHT` = **7 × 8**.
- Coordinates: `Vector2i(x, y)`, x = 0..6 left→right, y = 0..7 top→bottom.
  The enemy side is the top (low y) and the hero starts near the bottom.
- Each tile has:
  - `walkable` (bool). Blocked tiles hold rocks and ruins: nobody stands on
    them or moves through them.
  - `elevation`, from 0 (ground) to `Tuning.ELEVATION_MAX` (1 = terrace).
- Week 1 movement and range are **4-way**. Distance is Manhattan:
  `BattleGrid.manhattan(a, b)`.
- One unit per tile. Week 1 units are all 1×1; 2×2 bosses come in Week 3.

### 3.2 Units
Per-unit stats live in `src/content/units.json`, never in code:

| Field | Meaning |
| --- | --- |
| `id` | unique string, e.g. `silat`, `tuyul`, `brute` |
| `name_key` | text key in `src/content/text/*.csv` |
| `team` | `hero` or `enemy` |
| `hp` | max HP. Units start at full HP |
| `attack` | damage of a Strike (hero) or of the unit's intent (enemy) |
| `move` | max tiles moved per turn |
| `speed` | initiative. Higher acts first in the enemy phase |
| `intent` | enemy attack pattern: `melee` or `smash` (see 3.6) |

The Week 1 encounter (`src/content/encounters.json`, id `wk1_clearing`) is
1 silat hero vs 3 tuyul + 1 brute. Values are in §7.

### 3.3 Round structure
```
Battle start ─► Enemy planning (every enemy declares an intent)
             ─► Round 1: Player phase ─► Enemy phase ─► Round 2: Player phase ─► …
```
1. **Battle start.** Units are placed from the encounter, the hero gets
   `FOCUS_START` Focus, then the enemies plan (3.6) so round 1 already shows intents.
2. **Player phase.**
   1. Start: any Guard or Parry stance from the last round ends. From round 2
      on, the hero gains `FOCUS_PER_TURN` Focus, capped at `FOCUS_MAX`.
   2. The hero may **Move once** and take **one Action**, in either order.
      The actions are Strike, Guard, Parry, and Cast (Week 2).
   3. **Guard and Parry end the turn at once**: they are stances, so the player moves first.
      Strike does not end the turn: hit-and-run (Strike, then move) is allowed.
   4. The turn ends when the player taps **End turn**, after Guard/Parry, or
      automatically once the hero has both moved and acted.
3. **Enemy phase.**
   1. **Resolve.** Each living enemy, in initiative order, carries out its
      declared intent (3.6). The battle ends the moment the hero or the last enemy dies (3.9).
   2. **Plan.** Each living enemy, in initiative order, repositions and
      declares its next intent (3.6).
4. **Save** (3.10), then the next round.

**Initiative order**: higher `speed` first, ties go to the lower spawn index
(the order of units in the encounter file). The order is fixed for the whole battle.

### 3.4 Move
- The hero (or an enemy while planning) moves up to `move` tiles along a
  4-way path of walkable, unoccupied tiles. Each step costs 1, whether it goes up, down or stays level.
- It cannot move through or onto another unit.
- Reachable tiles are found with a BFS that uses `BattleGrid.neighbours()`'s
  fixed order (up, right, down, left), so ties always break the same way.
- A Move to the tile the unit already stands on is not a move. It is rejected.

### 3.5 Hero actions
| Action | Focus cost | Effect |
| --- | --- | --- |
| **Strike** | `STRIKE_COST` (0) | Hit one enemy within strike range (3.7) for `attack` damage. On a hit, gain `FOCUS_ON_STRIKE_HIT`. |
| **Guard** | `GUARD_COST` (1) | Stance until the next player phase: **every** hit the hero takes is reduced by `GUARD_REDUCTION_PCT`. |
| **Parry** | `PARRY_COST` (2) | Stance until the next player phase: the **first** hit that lands on the hero is cancelled (0 damage). If the attacker is within `PARRY_REFLECT_RANGE`, it takes `PARRY_REFLECT_PCT` of that hit as damage. Hero gains `FOCUS_ON_PARRY`. Later hits in the same phase land normally. |
| Cast | per spell | Week 2. |

- An action whose cost is higher than the current Focus is not allowed (its button is disabled).
- Guard and Parry can't both be active at once: the hero gets one action per turn.
- If no hit lands on a Parry, the Focus is spent anyway. Guessing wrong costs Focus.
- Week 1 enemies never Guard or Parry, so reflected damage always lands in full.

### 3.6 Enemy intents
An intent is declared in the **Plan** step and carried out in the **next** **Resolve**
step, so the player always gets one turn to answer it.

| Intent | Tiles | Declared when |
| --- | --- | --- |
| `melee` attack | the hero's tile at planning time | the enemy reached a tile within attack range (3.7) of the hero |
| `smash` attack | the hero's tile + the next tile beyond it on the line from the brute through the hero (only the first tile if the second is off the grid) | same, for `smash` units |
| `approach` | none | no attack tile could be reached this turn |

**Intents are locked to tiles, not to the hero.** On Resolve, an attack hits
whatever hero stands on its tiles **now**. If the hero stepped away, it misses.
Enemies never hit each other in Week 1.

**Planning rule (Week 1; real AI comes in Week 2):** for each living enemy, in initiative order:
1. Find the tiles it can reach this turn (3.4), including the tile it stands on.
2. From those, keep the tiles from which the hero's current tile is within the enemy's
   attack range (3.7).
3. If any are left: move to the one with the **shortest path**. Ties go to
   the lowest `y`, then the lowest `x`. Declare the attack on the hero's tile (plus the smash tile).
4. Otherwise move to the reachable tile with the **lowest Manhattan distance to
   the hero** (ties: shortest path, then lowest `y`, then `x`) and declare `approach`.

Moving while planning plays out on screen (`unit_moved` events), so the player sees
enemies close in before their red tiles appear.

**Resolve:** for each attack intent, if the hero stands on one of its tiles,
apply the hit (3.8). An enemy that died before its turn does nothing: its intent is removed
when it dies.

### 3.7 Range and high ground
- Base attack range is `STRIKE_RANGE` (1, adjacent) for the hero and every Week 1 enemy.
- **High ground:** if the attacker's tile has a **higher** elevation than the
  target's tile, its range is `+HIGH_GROUND_RANGE_BONUS` (+1).
- In range = `manhattan(attacker, target) <= range`. Week 1 has no line-of-sight rule.
- High ground works for enemies too: a tuyul on a terrace can reach 2 tiles down.

### 3.8 Taking a hit
For each hit the hero takes, in this order:
1. **Parry** active and unused → damage 0, the parry is used up, the hero gains
   `FOCUS_ON_PARRY`, and the attacker takes the reflected damage if it is in reflect range.
2. Otherwise, **Guard** active → damage reduced (§4).
3. Subtract the damage from HP, but never below 0.

Parry is checked before Guard, but since the hero has only one action per turn
they are never both active (3.5). A smash counts as **one hit** even if both of its
tiles cover the hero (they can't in Week 1, since units are 1×1).

### 3.9 Win and lose
- **Win:** the last enemy reaches 0 HP, whether from a Strike or a reflect. Emit `battle_won` and stop.
- **Lose:** the hero reaches 0 HP. Emit `battle_lost` and stop, even if more
  intents were still waiting.
- If one event would trigger both (a reflect kills the last enemy while the hero
  also dies), **win is checked first**. This can't happen in Week 1 because a parried hit deals 0 damage,
  but the rule is fixed now for later.
- Units at 0 HP are removed from the grid at once, so their tile frees up.

### 3.10 Save after every turn
- After every **player phase** and every **enemy phase** the sim produces a
  plain `Dictionary` of the full battle state (`BattleState.to_dict()`), and the
  game writes it to `user://save/battle.json`.
- Loading it (`BattleState.from_dict()`) and replaying the same commands must give
  the exact same event list. A determinism test covers this.
- If the app is killed mid-turn, the game resumes at the start of the last saved phase.

### 3.11 Contract with the view (sim ⇄ view)
The view never changes sim state. It reads a **snapshot** and sends **commands**.

**Commands** (`BattleSim.apply(command: Dictionary) -> Array[SimEvent]`):

| `action` | Extra keys | Valid when |
| --- | --- | --- |
| `move` | `to: Vector2i` | player phase, not moved yet, `to` in `options.move` |
| `strike` | `target: Vector2i` | player phase, not acted yet, `target` in `options.strike` |
| `guard` / `parry` | — | player phase, not acted yet, enough Focus |
| `end_turn` | — | player phase |

An invalid command returns `[SimEvent(&"command_rejected", {"reason": String})]` and leaves the state unchanged.

**Snapshot** (`BattleSim.snapshot() -> Dictionary`, plain values only):
```
{
  "round": int, "phase": "player"|"enemy"|"ended", "result": ""|"won"|"lost",
  "grid": {"width": int, "height": int, "blocked": [Vector2i], "elevation": {Vector2i: int}},
  "units": [{"uid": int, "id": String, "team": String, "cell": Vector2i,
             "hp": int, "hp_max": int, "stance": ""|"guard"|"parry"}],
  "hero": {"uid": int, "focus": int, "focus_max": int, "moved": bool, "acted": bool},
  "intents": [{"uid": int, "kind": "melee"|"smash"|"approach",
               "tiles": [Vector2i], "damage": int}],
  "options": {"move": [Vector2i], "strike": [Vector2i],
              "guard": bool, "parry": bool,
              "costs": {"guard": int, "parry": int}}
}
```
`options` is computed by the sim, so the view never re-implements the rules. `options.costs`
copies `GUARD_COST` and `PARRY_COST` so the HUD can show them without reading `Tuning`.

**Events** (`SimEvent.type`, with its `data` keys):

| Type | Data |
| --- | --- |
| `battle_started` | `round` |
| `phase_started` | `round`, `phase` |
| `unit_moved` | `uid`, `from`, `to`, `path: [Vector2i]` |
| `stance_set` | `uid`, `stance` |
| `focus_changed` | `uid`, `focus`, `delta` |
| `attacked` | `uid`, `target_uid`, `tiles` |
| `damaged` | `uid`, `amount`, `hp`, `source_uid`, `guarded: bool` |
| `parried` | `uid`, `attacker_uid`, `reflected: int` |
| `missed` | `uid` (an intent whose tiles were empty) |
| `intent_declared` | `uid`, `kind`, `tiles`, `damage` |
| `unit_died` | `uid` |
| `battle_won` / `battle_lost` | `round` |
| `command_rejected` | `reason` |

## 4. Formulas

| Name | Formula | Example |
| --- | --- | --- |
| Strike damage | `dmg = attacker.attack` | silat 5 → 5 |
| Intent damage (shown on the marker) | `dmg = enemy.attack` | brute 6 |
| Guarded damage | `taken = dmg - (dmg * GUARD_REDUCTION_PCT) / 100` (integer division) | 6 → 3; 2 → 1; 1 → 1 |
| Parry reflect | `reflect = (dmg * PARRY_REFLECT_PCT) / 100` if `manhattan(hero, attacker) <= PARRY_REFLECT_RANGE`, else 0 | brute 6 → 6 back |
| Attack range | `range = STRIKE_RANGE + (HIGH_GROUND_RANGE_BONUS if elev(attacker) > elev(target) else 0)` | terrace → 2 |
| Focus at player phase start | `focus = min(FOCUS_MAX, focus + FOCUS_PER_TURN)` (from round 2) | 2 → 3 |
| HP after a hit | `hp = max(0, hp - taken)` | |

All integer maths: no floats in the sim, so results are identical on every device.
Week 1 has **no random rolls** at all (no crits, no misses). `Rng` is only used
when Week 2 adds random floors and AI tie-breaks.

## 5. Edge Cases

| Case | Rule |
| --- | --- |
| Hero moves out of a red tile | The attack resolves on the empty tile: `missed` event, no damage. |
| Two intents cover the same tile | Both hit in initiative order. Parry cancels only the first. Guard reduces both. |
| Parry, but no hit lands | Focus is spent, no refund. The stance ends at the next player phase. |
| Parry against a hit from out of reflect range | Hit cancelled, Focus refund given, no reflect (Week 1 enemies are melee, so this only matters from Week 2). |
| Reflect kills the attacker | The attacker dies at once (`unit_died`) and its later intents are removed. If it was the last enemy, the battle is won. |
| Enemy killed before its Resolve | Its intent is removed. Nothing happens on its turn. |
| Last enemy killed by the hero's Strike | `battle_won` straight away. No enemy phase runs. |
| Hero reaches 0 HP with intents still left | `battle_lost`. The remaining intents are skipped. |
| Enemy can't reach anything (boxed in) | Declares `approach` and stays where it is. |
| Planning target tile taken by an enemy planned earlier this phase | That tile counts as occupied: enemies plan one at a time in initiative order. |
| Smash second tile off-grid or blocked | Only the tiles on the grid count. A blocked tile still shows red, but nobody can stand there. |
| Focus already at `FOCUS_MAX` when a gain happens | Capped. `delta` in `focus_changed` is the amount actually gained (may be 0, then no event). |
| Command arrives during the enemy phase or after the battle ended | `command_rejected`, state unchanged. |
| Move or Strike sent twice in one turn | The second is `command_rejected`. |
| Hero has 0 or 1 Focus | Parry disabled (cost 2). Guard enabled at ≥1. Strike always enabled when a target is in range. |
| High ground in reverse (attacker lower than target) | No penalty, base range only. |
| App killed during the enemy phase animation | The sim has already finished the phase and saved. On reload, the player phase starts with the saved state. |

## 6. Dependencies

| System | Direction | What |
| --- | --- | --- |
| `Rng` (`src/sim/core/rng.gd`) | uses (Week 2) | no rolls in Week 1. Keep the seed in the state anyway for save/replay |
| `BattleGrid` (`src/sim/battle/grid.gd`) | uses | bounds, walkability, neighbours, Manhattan. Add elevation |
| Content loader (@glm, W1-11) | uses | `units.json`, `encounters.json` with validation |
| Text (`src/content/text/*.csv`) | uses | unit names, action labels (en, id) |
| Battle view (`src/view/battle/`) | used by | reads the snapshot, plays the events, sends commands |
| Save system | used by | `to_dict` / `from_dict` after every phase |
| Spell weaving (Week 2) | extends | adds the `cast` command and its Focus costs |
| Enemy AI (Week 2) | replaces | the §3.6 planning rule |
| Expedition (Week 2) | uses | starts a battle from an encounter id and reads `battle_won`/`battle_lost` |

## 7. Tuning Knobs

**Global rules: `src/sim/tuning.gd`** (added together with this doc):

| Constant | Value | Safe range | Why |
| --- | --- | --- | --- |
| `ARENA_WIDTH` × `ARENA_HEIGHT` | 7 × 8 | fixed for Ch.1 | fits 9 tiles across with a 1-tile frame |
| `FOCUS_MAX` | 6 | 4–8 | three Parries' worth. Enough to plan, not enough to block everything |
| `FOCUS_START` | 2 | 1–3 | one Parry or two Guards available on round 1 |
| `FOCUS_PER_TURN` | 1 | 1–2 | Parry every other turn at most without Strikes |
| `FOCUS_ON_STRIKE_HIT` | 1 | 0–2 | rewards attacking over turtling |
| `FOCUS_ON_PARRY` | 1 | 0–2 | net Parry cost is 1 when it works: rewards reading intents |
| `STRIKE_COST` | 0 | 0 | the basic action is always free |
| `GUARD_COST` | 1 | 1–2 | |
| `PARRY_COST` | 2 | 2–3 | dearer than Guard because it can reflect |
| `GUARD_REDUCTION_PCT` | 50 | 30–70 | |
| `PARRY_REFLECT_PCT` | 100 | 50–150 | |
| `PARRY_REFLECT_RANGE` | 1 | 1 | melee only for Week 1 |
| `STRIKE_RANGE` | 1 | 1 | |
| `HIGH_GROUND_RANGE_BONUS` | 1 | 1 | brief: "high ground +1 range" |
| `ELEVATION_MAX` | 1 | 1–2 | Week 1: ground and terrace only |

**Per-unit data: `src/content/units.json`** (first pass, tuned by playtest):

| id | team | hp | attack | move | speed | intent |
| --- | --- | --- | --- | --- | --- | --- |
| `silat` | hero | 30 | 5 | 3 | — | — |
| `tuyul` | enemy | 8 | 2 | 3 | 3 | `melee` |
| `brute` | enemy | 20 | 6 | 2 | 1 | `smash` |

The brute's display name is not final (the sensitivity list allows "genderuwo-like
brutes"). The writer sets `name_key` text. Ids stay as they are.

**Encounter: `src/content/encounters.json` → `wk1_clearing`:**
```
hero:   silat @ (3,6)
enemies (spawn index order): tuyul @ (1,2), tuyul @ (5,2), tuyul @ (3,1), brute @ (3,0)
blocked:   (2,4), (4,4)            # fallen stone blocks
elevation: (0,3)=1, (0,4)=1, (6,3)=1, (6,4)=1   # two terraces at the sides
```

**Pacing check (paper maths):** enemy HP total 44 at 5 per Strike ≈ 9 Strikes.
Unanswered incoming damage is up to 12 a round (3×2 + 6), so a hero who never dodges, Guards or
Parries falls in round 3. A hero who reads the intents should win in 7–10 rounds with
10–20 HP left. Tune after the owner's first phone playtest. Kill condition: if a turn still feels slow
or confusing after two tuning rounds (brief).

## 8. Acceptance Criteria

Each line is one or more gdUnit4 tests in `tests/unit/sim/battle/`. Story IDs refer to `production/stories/week1/`.

1. A new battle from `wk1_clearing` has 5 units on the listed tiles, hero Focus = `FOCUS_START`, and 4 declared intents before round 1. *(W1-01, W1-07)*
2. Hero `options.move` = exactly the tiles reachable within `move` steps around blocked and occupied tiles. A 4th step is never offered. *(W1-03)*
3. Strike on an adjacent enemy deals `attack` damage and gives `FOCUS_ON_STRIKE_HIT` Focus. A Strike at distance 2 is rejected on flat ground and allowed from a terrace onto ground. *(W1-04, W1-08)*
4. Guard: a brute hit of 6 deals 3. A tuyul hit of 2 deals 1. Focus −1. *(W1-06)*
5. Parry: the first hit deals 0, the adjacent attacker takes 100% of it, hero Focus −2 then +1. A second hit in the same phase lands at full damage. *(W1-06)*
6. Parry with no hit: Focus −2, no refund, the stance clears next player phase. *(W1-06)*
7. An intent declared on tile T misses if the hero moved off T, and hits if the hero is still on T. *(W1-07)*
8. Killing the last enemy emits `battle_won` and no enemy phase runs. The hero at 0 HP emits `battle_lost` and the remaining intents are skipped. *(W1-04, W1-07)*
9. Focus never goes above `FOCUS_MAX` or below 0. Guard and Parry are rejected when Focus is too low. *(W1-05)*
10. `to_dict` → `from_dict` → the same command list gives the same events as the uninterrupted battle (determinism). *(W1-09)*
11. Every invalid command (wrong phase, double move, target not in options) returns `command_rejected` and leaves `snapshot()` unchanged. *(W1-02)*
12. No number from §7 appears as a literal in `src/sim/` outside `tuning.gd`: reviewed in each PR.
