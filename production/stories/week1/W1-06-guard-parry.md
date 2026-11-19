# W1-06 Guard and Parry
> Lane: @gpt · Type: Logic · Size: M · Depends on: W1-05, W1-07 · Spec: battle.md §3.5, §3.8, §4, §5

**Goal:** the two defensive stances, the heart of the battle feel.

## Acceptance criteria
- [ ] Guard costs `GUARD_COST` and ends the turn. Every hit taken this enemy phase becomes `dmg - dmg*GUARD_REDUCTION_PCT/100`: 6→3, 2→1, 1→1.
- [ ] Parry costs `PARRY_COST` and ends the turn. The first hit becomes 0 and emits `parried` with `reflected`. An attacker within `PARRY_REFLECT_RANGE` takes the reflected damage. The hero gains `FOCUS_ON_PARRY`. The second hit lands in full.
- [ ] A Parry with no hit keeps the Focus spent. Both stances clear at the next player phase start (`stance_set` with `""`).
- [ ] A reflect that kills the last enemy emits `battle_won`.

## Evidence
`tests/unit/sim/battle/guard_parry_test.gd`. battle.md §8 AC 4, 5, 6.
