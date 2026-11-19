# W1-05 Focus
> Lane: @gpt · Type: Logic · Size: S · Depends on: W1-02 · Spec: battle.md §3.3.2, §3.5, §4

**Goal:** the Focus resource exists, with gains and caps exactly as specified.

## Acceptance criteria
- [ ] The hero starts at `FOCUS_START`, gains `FOCUS_PER_TURN` at each player phase start from round 2, and gains `FOCUS_ON_STRIKE_HIT` on each Strike hit.
- [ ] Focus is clamped to 0..`FOCUS_MAX`. `focus_changed.delta` is the amount actually gained, and there is no event when that is 0.
- [ ] `options.guard` and `options.parry` are false when Focus is lower than their cost.

## Evidence
`tests/unit/sim/battle/focus_test.gd`, including the cap (start at max, then Strike). battle.md §8 AC 9.
