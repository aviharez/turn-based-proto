# W1-22 Intent markers
> Lane: @claude · Type: UI · Size: S · Depends on: W1-21 · Spec: battle.md §3.6, §3.11 (`intents`)

**Goal:** every enemy's next attack can be read at a glance (Into the Breach style).

## Acceptance criteria
- [ ] Each attack intent draws red tiles, a line from the enemy to its tiles, and a damage number. A smash shows both tiles. `approach` shows a small chevron above the enemy and no tiles.
- [ ] When the hero stands on a red tile, the tile pulses and the hero gets a red outline, so "you will be hit" is obvious.
- [ ] Two intents on one tile show stacked damage ("2+6"), not one number hidden under the other.

## Evidence
A screenshot of the demo snapshot with 3 melee intents, 1 smash and 1 approach, where the hero stands on a red tile.
