# W1-26 Wire the view to BattleSim
> Lane: @claude · Type: Integration · Size: M · Depends on: W1-02..W1-07, W1-12, W1-23 · Spec: battle.md §3.11

**Goal:** the grey-box battle is playable end to end against the real sim.

## Acceptance criteria
- [ ] The battle scene builds `BattleSim` from `wk1_clearing`, sends the view's commands to `apply()`, plays the returned events in order (simple tweens), then re-reads `snapshot()`.
- [ ] The demo snapshot and demo driver (`src/view/battle/demo/`) are deleted. The view contains no rule logic: a grep for `manhattan` or `Tuning.` in `src/view/` finds nothing.
- [ ] Win and lose show a panel with Retry. The scene is the project's main scene for the Week 1 build.

## Evidence
A short GIF of one full round (move, Parry, the brute's smash reflected) in `production/devlog/media/`, plus screenshots of the win and lose panels.
