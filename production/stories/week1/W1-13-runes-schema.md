# W1-13 Runes schema (Week 2 prep)
> Lane: @glm · Type: Logic · Size: S · Depends on: W1-11 · Spec: brief (spell weaving: 4 elements × 3 shapes × 4 modifiers)

**Goal:** a validated `runes.json` format, so that spell weaving in Week 2 starts from data.

## Acceptance criteria
- [ ] `ContentLoader.load_runes()` accepts entries `{id, kind: element|shape|modifier, name_key, focus_cost, params: {}}` and validates `kind`, `focus_cost >= 0` and unique ids.
- [ ] `src/content/runes.json` contains only the **ids and kinds** (4 elements, 3 shapes, 4 modifiers) with `focus_cost` 0 and empty `params`. Numbers come with the Week 2 spell-weaving GDD, so nothing is invented here.
- [ ] Tests: one valid fixture, one test per invalid case.

## Note
Rune ids: `fire, water, earth, wind` · `bolt, ring, wall` · `amplify, extend, pierce, echo`. This list is provisional. The spell-weaving GDD may rename them.
