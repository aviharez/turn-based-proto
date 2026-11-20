# W1-02 Command API and turn loop
> Lane: @gpt · Type: Logic · Size: M · Depends on: W1-01 · Spec: battle.md §3.3, §3.11

**Goal:** `BattleSim.apply(command) -> Array[SimEvent]` drives the rounds: player phase, then enemy phase.

## Acceptance criteria
- [ ] `end_turn` runs the enemy phase (resolve, then plan; both can be stubs until W1-07) and starts the next player phase. It emits `phase_started` with `round` and `phase`.
- [ ] Initiative order: higher `speed` first, ties by spawn index. Fixed for the whole battle and covered by a test.
- [ ] The hero may move once and act once, in either order. The turn ends by itself once both are done, or after Guard or Parry.
- [ ] Every invalid command (wrong phase, a second move, an unknown `action`) returns `command_rejected` and leaves `snapshot()` unchanged. Test: compare the snapshot before and after.

## Evidence
`tests/unit/sim/battle/turn_loop_test.gd`. battle.md §8 AC 11.

## Files
`src/sim/battle/battle_sim.gd`
