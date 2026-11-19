# W1-12 Week 1 unit and encounter data
> Lane: @glm · Type: Config/Data · Size: S · Depends on: W1-11 · Spec: battle.md §7

**Goal:** the real data files for the Week 1 fight.

## Acceptance criteria
- [ ] `src/content/units.json` holds `silat`, `tuyul` and `brute` with exactly the values in battle.md §7.
- [ ] `src/content/encounters.json` holds `wk1_clearing` with the units, blocked tiles and elevation listed in battle.md §7.
- [ ] Both pass the W1-11 loader, and a test loads the real files (not fixtures) without errors.
- [ ] `name_key` entries exist in `src/content/text/units.csv` (en, id) with the plain names `Silat fighter`/`Pesilat`, `Tuyul`/`Tuyul`, `Brute`/`Raksasa`. @claude replaces them with final names and codex text in W1-27.

## Evidence
`tests/unit/content/week1_content_test.gd`.
