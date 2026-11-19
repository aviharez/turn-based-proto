# W1-14 Edge-case tests from battle.md §5
> Lane: @glm · Type: Logic · Size: M · Depends on: W1-06, W1-08 merged · Spec: battle.md §5

**Goal:** one test per row of the battle.md §5 edge-case table that the @gpt stories did not already cover.

## Acceptance criteria
- [ ] The PR has a table that maps each §5 row to a test name (or to the existing test that covers it).
- [ ] The tests use the public API only (`apply`, `snapshot`, events), not private fields.
- [ ] A test that fails because of a sim bug stays failing. Do not skip or disable it: open an issue, tag @gpt and link it in the PR.

## Evidence
`tests/unit/sim/battle/edge_cases_test.gd`.
