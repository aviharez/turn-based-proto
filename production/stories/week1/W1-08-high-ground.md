# W1-08 High ground
> Lane: @gpt · Type: Logic · Size: S · Depends on: W1-04, W1-07 · Spec: battle.md §3.7

**Goal:** a unit on higher elevation gets +`HIGH_GROUND_RANGE_BONUS` range, for both the hero and enemies.

## Acceptance criteria
- [ ] `options.strike` includes a target at distance 2 only when the hero's tile is higher than the target's.
- [ ] Enemy planning uses the same range rule: a tuyul on a terrace declares an attack from 2 tiles away.
- [ ] Being lower than the target gives no penalty.

## Evidence
`tests/unit/sim/battle/high_ground_test.gd`. battle.md §8 AC 3 (terrace part).
