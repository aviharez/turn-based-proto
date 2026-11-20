# W1-23 Action bar and HUD in the bottom 60%
> Lane: @claude · Type: UI · Size: M · Depends on: W1-22 · Spec: brief Controls; AGENTS.md mobile rules

**Goal:** one-thumb controls: Strike, Cast (disabled until Week 2), Guard, Parry and End turn, plus HP, Focus and zoom.

## Acceptance criteria
- [ ] The action bar and zoom buttons sit inside the **bottom 60%** of the screen, every button is at least 48 dp, and the bar renders at native resolution on a CanvasLayer, never inside the pixel world.
- [ ] Button states follow `options`: Guard and Parry are disabled when there is not enough Focus (with the cost shown on the button), Strike is disabled with no target, and Cast always shows as disabled ("Week 2" in the demo build).
- [ ] The HUD shows HP and Focus (pips out of `focus_max`) and the round number. All text uses `tr()` keys, and `src/content/text/ui.csv` is registered as a translation in `project.godot`.
- [ ] One line under the bar explains the selected enemy's intent ("Brute hits 2 tiles for 6").

## Evidence
Screenshots at 1080×1920 and at 1080×2400 (a tall phone), with the bottom-60% line drawn on a debug copy.
