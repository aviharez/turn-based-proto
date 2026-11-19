# W1-04 Strike, damage, death, win/lose
> Lane: @gpt · Type: Logic · Size: S · Depends on: W1-02 · Spec: battle.md §3.5, §3.9, §4

**Goal:** the hero can kill enemies, and the battle ends correctly.

## Acceptance criteria
- [ ] `strike` on a target in `options.strike` deals `attack` damage (`attacked`, `damaged`). At 0 HP it emits `unit_died` and the unit leaves the grid.
- [ ] Killing the last enemy emits `battle_won`. No enemy phase runs, and every later command is rejected.
- [ ] A hero at 0 HP emits `battle_lost`, and the remaining intents are skipped. A test checks this with a hand-placed lethal intent.
- [ ] HP never goes below 0, and no Strike is possible on an empty tile or an ally.

## Evidence
`tests/unit/sim/battle/strike_test.gd`. battle.md §8 AC 3 (flat part), AC 8.
