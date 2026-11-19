# Tilesets: two DIFFERENT kinds of "Wang" - never mix them up

Sources:
- https://www.spritecook.ai/blog/wang-tiles-explained   (EDGE Wang = variety inside one terrain)
- https://www.spritecook.ai/blog/dual-grid-tilesets-explained
- https://www.spritecook.ai/blog/autotile-tilesets-explained
- https://www.spritecook.ai/blog/top-down-tileset
- https://www.spritecook.ai/blog/godot-autotile-tileset

## The two systems (use BOTH, for different jobs)

| | Corner autotile (15/16-piece, dual-grid; PixelLab calls it a "Wang tileset") | EDGE Wang (SpriteCook "Wang tiles explained") |
| --- | --- | --- |
| Job | Draw the TRANSITION where two terrains meet (stone -> moss) | Remove visible REPETITION inside ONE terrain |
| Colours live on | tile corners (terrain A or B) | tile edges (edge colour 0 or 1), all same terrain |
| Map data | which terrain each vertex is | random 0/1 per horizontal edge and per vertical edge |
| Looks wrong when | used for big flat areas: the single all-A tile repeats in a grid | used at terrain borders |

A map uses corner autotiles ONLY at borders and edge-Wang tiles for every solid interior cell.
Repeating one full tile across an area is a bug, not a style.

## Edge Wang: how the 16 tiles are made (article method)
1. Start from ONE seamless (wrapping) texture of the terrain: flat base + fine texture + sparse
   decor. Source can be built by scattering decor sprites with wrap-around onto a base.
2. Pick 2 source spots for horizontal edge colours (top/bottom) and 2 for vertical (left/right).
   An edge patch is centred ON the seam: the tile above takes its upper half, the tile below its
   lower half, so the same grass continues across every seam.
3. Every tile gets its OWN middle from a different spot - this is where the variety comes from.
   Keep some middles plain. Keep decor at least 4 px away from tile borders.
4. Join each edge triangle to the middle along the lowest-colour-difference path inside that
   triangle (dynamic programming), so seams follow the art instead of straight lines.
5. Edge areas must be plain (they appear on ~half of all edges); distinctive features belong in middles.
6. Index = top + 2*right + 4*bottom + 8*left (0..15). Atlas 4x4 in index order:
   Godot atlas coords = Vector2i(i % 4, i / 4).
7. Map: horizontal edges array (rows+1) x cols, vertical edges rows x (cols+1), each a seeded
   random 0/1. Cell index from its 4 edges. Generate once per floor from the floor seed (sim RNG),
   or hash(world_seed, edge position) for infinite maps. Never regenerate per frame.

Proven pipeline (19-20 Nov 2026 test):
- Source: SpriteCook `generate_game_art(mode="texture", pixel=True, bg_mode="include", smart_crop=False)`,
  ~192 px, prompt for a flat base + small low-contrast tufts + rare tiny flowers, NO stones/objects.
  Generate 2 variations and pick the one with soft clumps (the very uniform one looks bland).
- Reduce to ~10 base colours (median cut) but keep rare accents (flowers) as 1-2 explicit colours,
  otherwise quantisation deletes them.
- Cut with NOWRAP=True (never cut across the texture border, so the source need not wrap) and
  BUSY=22 so dark clumps count as detail and stay OUT of edge strips.
- Never paste separate decoration sprites (outlined icons) onto the ground: they read as stickers.

Reference implementation: `tools/art/edge_wang.py` (builds the 16-tile sheet from a source texture
and renders a test map). Acceptance: a 9x16 test map shows no visible grid repetition at 1x.

## Corner autotile (terrain transitions)
- 4 corners x 2 terrains = 16 cases (PixelLab sheet has all 16; SpriteCook 15-piece omits all-empty).
- Dual-grid rendering is offset half a tile and is 1 tile larger than the painted grid.
- SpriteCook Godot export: TileMapLayer + .tres terrain set, paint from the Terrains tab in
  connect mode. PixelLab: use get_topdown_tileset metadata corners or classify corners by pixel.
- The SIM grid is the painted grid; shadowcasting and pathing never use the render offset.

## Project decisions
- Tiles 32 px (source texture ~384 px for 32 px edge-Wang). Floors: corner autotile for stone<->moss<->water borders, edge Wang inside each terrain.
- Keep decor density LOW on the playable board (readability of units and intent markers beats
  decoration); denser decor outside the board and in the settlement.
