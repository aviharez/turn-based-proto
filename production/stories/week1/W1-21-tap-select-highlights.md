# W1-21 Tap-to-select and highlights
> Lane: @claude · Type: UI · Size: S · Depends on: W1-20 · Spec: brief Controls; battle.md §3.11 (`options`)

**Goal:** tap a unit to select it. Tap a highlighted tile to send a command.

## Acceptance criteria
- [ ] Tapping the hero shows `options.move` tiles (blue) and `options.strike` targets (orange outline). Tapping an enemy selects it and shows its intent tiles brighter. Tapping empty space clears the selection.
- [ ] Tapping a highlighted tile emits a command dictionary (`{"action": "move", "to": cell}`) through a signal. The view never moves units itself, except for the demo driver.
- [ ] Every tile is at least 48 dp at the battle zoom (one tile is about 120 px at 1080 wide). Taps outside the arena or on the UI do nothing.

## Evidence
Screenshots: hero selected with move tiles showing; enemy selected.
