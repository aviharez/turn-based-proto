# W1-20 Battle view scaffold and 3-step camera
> Lane: @claude · Type: UI · Size: S · Depends on: — · Spec: AGENTS.md rendering rules; brief Controls

**Goal:** a battle scene that draws the 7×8 grey-box grid, framed so the battle view shows 9 tiles across, with three fixed zoom steps.

## Acceptance criteria
- [ ] `src/view/battle/battle_view.tscn` draws the grid from a **snapshot dictionary** (battle.md §3.11 shape), not from sim internals: ground tiles, blocked tiles, terraces (with a darker side wall to show height) and a 1-tile frame.
- [ ] Camera2D with 3 fixed zoom steps: **9 / 11 / 14 tiles** across the viewport width. Step changes go through buttons only (no pinch). The camera position is snapped to whole pixels.
- [ ] Zoom step numbers live in one view config script, not scattered through the code.
- [ ] Until W1-26 the scene runs standalone from a demo snapshot (`src/view/battle/demo/`), which is deleted in W1-26.

## Evidence
`production/qa/evidence/W1-20-view-scaffold-camera/`: one screenshot per zoom step at 1080×1920.
