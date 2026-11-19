# Water: ponds and shorelines

Sources:
- https://www.spritecook.ai/blog/pixel-art-pond-water-reflections-ripples
- https://www.spritecook.ai/blog/2d-water-shoreline-distance-field

## Pond (layered palette-index water)
Six layers: depth, sky light, tree reflections, shoreline lapping, quiet back bank,
small details. Each water pixel stores a palette index; colours resolved once at the end.
- Depth from blurred shore distance: tone 3 under 3 px, tone 1 beyond 7 px.
- Reflections flipped, squashed to 55%, three tones, whole-pixel row shifts, first 3 rows still.
- 5 s loop; every motion a whole number of cycles. Ripples 5 frames @0.2 s; glints 0.6 s; leaves 3 s.
Pitfalls: alpha blending -> muddy water; full-strength reflections; fractional loops jump;
light outline around shore; glints on a fixed grid.

## Shoreline (distance field)
Distance from each water pixel to nearest land (from land alpha), clamp 32 px, 8-bit,
+-3 px noise wobble. Depth bands at 5/13/26 px; foam under 2.2 + 1.1*sin(t*2.5) px;
waves 11 px apart moving 4.4 px/s, visible 4-20 px from land.
Bake once at load (Felzenszwalb-Huttenlocher), FastNoiseLite wobble, L8 image, Sprite2D under
the TileMapLayer, Nearest.

## Our use
Coastal region (archipelago!), settlement pond/rice terraces (pond technique), island
transitions on the world map (shoreline). Water stays in the VIEW; sim only knows "water tile".
