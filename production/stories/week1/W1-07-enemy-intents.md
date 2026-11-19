# W1-07 Enemy intents: plan and resolve
> Lane: @gpt · Type: Logic · Size: M · Depends on: W1-03, W1-04 · Spec: battle.md §3.6

**Goal:** enemies telegraph tile-locked attacks one turn ahead (Week 1 planning rule).

## Acceptance criteria
- [ ] Plan: each enemy, in initiative order, moves to the closest tile from which it can attack (ties: path length, then lowest y, then x) and emits `intent_declared` (`melee` or `smash` tiles plus damage). If it can't reach one, it moves toward the hero and declares `approach`.
- [ ] Resolve: an intent hits only if the hero is standing on one of its tiles **now**. Otherwise it emits `missed`. A smash's second tile is "beyond the hero on the line from the brute", trimmed to the grid.
- [ ] Enemies planned earlier in the phase occupy their new tiles for the later ones. The intent of a dead enemy is removed.
- [ ] A new battle has 4 intents declared before round 1 (battle.md §8 AC 1).

## Evidence
`tests/unit/sim/battle/intent_test.gd`, including dodge (move off the tile) and stay (get hit). battle.md §8 AC 7.
