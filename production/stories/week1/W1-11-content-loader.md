# W1-11 Content loader and validation
> Lane: @glm · Type: Logic · Size: M · Depends on: — · Spec: battle.md §3.2, §7; `src/content/README.md`

**Goal:** load `units.json` and `encounters.json` into plain dictionaries and reject bad data with readable errors.

## Acceptance criteria
- [ ] `ContentLoader.load_units(path) -> Dictionary` and `load_encounters(path)` return `{id: entry}`. They are pure functions over parsed JSON, with the file read kept in one small function so tests can inject text.
- [ ] Validation lists **every** problem, not just the first: a missing field, a wrong type, `hp <= 0`, `move < 0`, an unknown `team` or `intent`, a duplicate `id`, an encounter that references an unknown unit, or a tile outside `ARENA_WIDTH × ARENA_HEIGHT`.
- [ ] Each rule has one failing-data test and the valid fixture has one passing test.

## Evidence
`tests/unit/content/content_loader_test.gd`.

## Files
`src/content/content_loader.gd` (or `src/sim/content/` if @gpt prefers that during review). No nodes.
