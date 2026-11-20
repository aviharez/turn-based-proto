# W1-01 Battle state and units on the grid
> Lane: @gpt · Type: Logic · Size: S · Depends on: battle.md · Spec: battle.md §3.1, §3.2, §3.11 (snapshot)

**Goal:** a pure `BattleState` that places the encounter's units on the grid and returns a snapshot.

## Acceptance criteria
- [ ] `BattleState.new(encounter: Dictionary, unit_defs: Dictionary)` places every unit on its tile, all at full HP, and sets hero Focus to `Tuning.FOCUS_START`. The dictionaries are injected, so this story does not wait for the loader (W1-11).
- [ ] `BattleGrid` gains per-tile `elevation` (0..`Tuning.ELEVATION_MAX`). Blocked tiles and elevation come from the encounter.
- [ ] `snapshot()` returns exactly the shape in battle.md §3.11. `intents` and `options` may be empty for now.
- [ ] Invalid setup fails with a clear error: two units on one tile, a unit on a blocked tile, a tile out of bounds.

## Evidence
`tests/unit/sim/battle/battle_state_test.gd`, including the three invalid-setup cases. Test data comes from a fixture factory, not inline numbers.

## Out of scope
Commands, turns, intents.

## Files
`src/sim/battle/battle_state.gd`, `src/sim/battle/battle_unit.gd`, `src/sim/battle/grid.gd`
