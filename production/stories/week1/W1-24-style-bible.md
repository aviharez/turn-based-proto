# W1-24 Art lock: style bible
> Lane: @claude · Type: Visual · Size: M · Depends on: — · Spec: brief Look; ai-art-pipeline §0; Day 0 style tests

**Goal:** one written style bible plus a palette, built from the existing art tests, so that every generation in batch 1 matches.

## Acceptance criteria
- [ ] `assets/style/style-bible.md` covers view angle, scale (with the measured sizes of the Day 0 sprites), proportions, outline/rim rule, light direction, shading, palette use, depth layers, tone guard (no chibi) and the do/don't list. Each rule cites the reference image it comes from.
- [ ] `assets/style/runedeep32.hex` is a 32-colour palette taken from the approved tests (Day 0 sprites and concept B) and grouped by role (outline, skin, moss, laterite, stone, gold light, spirit pale, UI).
- [ ] `assets/style/references/`: the 6–14 approved reference images, each listed with its source and SpriteCook asset id.
- [ ] **No generation.** Spend 0 credits.

## Evidence
A palette swatch PNG and a reference sheet PNG in `production/qa/evidence/W1-24-style-bible/`. Owner sign-off on Day 3.
