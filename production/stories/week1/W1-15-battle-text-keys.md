# W1-15 Battle HUD text keys (en, id)
> Lane: @glm · Type: Config/Data · Size: S · Depends on: — · Spec: AGENTS.md writing rules

**Goal:** every word the Week 1 battle screen shows has an en/id key.

## Acceptance criteria
- [ ] Keys are added to `src/content/text/ui.csv`: `UI_HP`, `UI_FOCUS`, `UI_ROUND` (with a `%d` placeholder), `UI_ZOOM_IN`, `UI_ZOOM_OUT`, `UI_VICTORY`, `UI_DEFEAT`, `UI_RETRY`, `UI_INTENT_ATTACK` ("%s hits for %d": name, damage), `UI_INTENT_ATTACK_AREA` ("%s hits %d tiles for %d": name, tiles, damage), `UI_INTENT_APPROACH` ("%s moves closer": name), `UI_NOT_ENOUGH_FOCUS`.
- [ ] Placeholders match the English exactly in count and order in the `id` column too (the HUD shows the bare key if the count differs). The HUD (W1-23, PR #11) already calls these keys.
- [ ] The Indonesian is natural (not word-for-word) and as short as the English, or the PR flags any id string more than 30% longer.
- [ ] `/text-review` has been run on the new strings, with its result in the PR.

## Note
These are labels only. No dialogue (that is @claude's lane).
