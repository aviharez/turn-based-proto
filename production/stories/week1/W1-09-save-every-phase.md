# W1-09 Save after every phase
> Lane: @gpt · Type: Integration · Size: M · Depends on: W1-07 · Spec: battle.md §3.10

**Goal:** the app can be killed at any time and the battle resumes at the last phase.

## Acceptance criteria
- [ ] `BattleState.to_dict()` / `from_dict()` round-trip: `snapshot()` is equal before and after.
- [ ] Determinism test: run 10 rounds of fixed commands, then save at round 5, load, replay rounds 6–10. The event lists are identical.
- [ ] File I/O lives **outside** `src/sim/` (e.g. `src/app/save_store.gd`). It writes `user://save/battle.json` atomically: write a temp file, then rename.

## Evidence
`tests/unit/sim/battle/save_roundtrip_test.gd`, plus `tests/integration/save/save_store_test.gd`. battle.md §8 AC 10.
