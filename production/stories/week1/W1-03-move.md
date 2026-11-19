# W1-03 Move
> Lane: @gpt · Type: Logic · Size: S · Depends on: W1-02 · Spec: battle.md §3.4

**Goal:** the hero moves up to `move` tiles. `options.move` lists exactly the legal tiles.

## Acceptance criteria
- [ ] `options.move` = a BFS within `move` steps (using `BattleGrid.neighbours()` order), skipping blocked and occupied tiles. The unit's own tile is not listed.
- [ ] `move` to a listed tile emits `unit_moved` with the full `path`. Any other tile is `command_rejected`.
- [ ] Edge cases: a hero boxed in by units gets an empty list. A tile exactly `move` steps away is listed. One step further is not.

## Evidence
`tests/unit/sim/battle/move_test.gd`. battle.md §8 AC 2.
