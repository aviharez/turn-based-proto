# W1-15 Battle HUD text keys (en, id)
> Lane: @glm · Type: Config/Data · Size: S · Depends on: — · Spec: AGENTS.md writing rules

**Goal:** every word the Week 1 battle screen shows has an en/id key.

## Acceptance criteria
- [ ] Keys are added to `src/content/text/ui.csv`: `UI_HP`, `UI_FOCUS`, `UI_ROUND` (with a `%d` placeholder), `UI_ZOOM_IN`, `UI_ZOOM_OUT`, `UI_VICTORY`, `UI_DEFEAT`, `UI_RETRY`, `UI_INTENT_ATTACK` ("%s hits %d"), `UI_INTENT_APPROACH`, `UI_NOT_ENOUGH_FOCUS`.
- [ ] The Indonesian is natural (not word-for-word) and as short as the English, or the PR flags any id string more than 30% longer.
- [ ] `/text-review` has been run on the new strings, with its result in the PR.

## Note
These are labels only. No dialogue (that is @claude's lane).
