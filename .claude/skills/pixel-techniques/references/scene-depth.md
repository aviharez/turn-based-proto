# Scene depth: never ship a "wallpaper" floor

Target look: SpriteCook concept B (asset 30acd643-3f87-468c-801c-63f3775642fa), a jungle temple
arena with depth. Concepts are TARGETS only (thousands of colours, no grid); rebuild every arena from
modular tiles and props.

## Five layers, every scene
1. Ground: 2-3 surfaces (flagstone / grass / dirt path). Corner autotiles at borders, edge-Wang inside.
2. Elevation: raised terraces with visible side walls + steps (tileset with wall height). High ground
   = gameplay bonus, so it is placed by the level generator, not as decoration.
3. Props with height: trees, stupas, ruins, rocks, ferns. Each gets a soft cast shadow (dark, low
   alpha, offset down-right, palette colour). Y-sorted against units; see-through dither (see-through.md).
4. Foreground frame: canopy and ferns overlapping the screen edges on the non-walkable outer ring.
   Foliage wind on canopy edges (foliage-wind.md).
5. Light and air: per-region colour-lookup grading (day-night-lut.md), light shafts on the ground,
   soft vignette, torch normal-map light at night (normal-maps.md), small particles (fireflies, dust).

## Layout rules
- View is 9 tiles wide; walkable arena ~7x8 tiles; outer ring is scenery.
- Straight walls only (horizontal/vertical) in 3/4 view; no diagonal walls on a square grid.
- No tall prop on walkable tiles near the centre; tall props on the ring or terrace edges.
- Value structure: brightest light on the walkable centre, darker edges, so the eye lands on the fight.
- Units must stay readable: spirits keep their 1 px rim; intent markers draw above all scenery.

## Acceptance
Screenshot at battle zoom next to the target concept: does it have all 5 layers, and does the
fight area read first? If it looks like a flat texture with sprites on top, it fails.
