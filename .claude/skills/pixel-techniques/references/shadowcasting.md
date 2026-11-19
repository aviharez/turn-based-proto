# Shadowcasting: fog of war, torchlight, line of sight

Source: https://www.spritecook.ai/blog/2d-shadowcasting-torchlight-fog-of-war

Grid recursive shadowcasting (Bergstrom), explicit stack, 8 octants scanned between slopes.
Input: bool grid (true = blocks light). Output: visibility grid.

## Numbers
- Radius in cells; a cell exactly at radius is not visible (range 10 reaches 9).
- Light falloff power 0.8, quantised into 6 bands.
- Per-pixel walls: light spreads ~5 px into wall faces.
- Cost ~0.04 ms per call on a 23x11 tile grid -> recompute every move for free.

## Fog of war (3 states)
never seen = black; explored, out of view = desaturated grey-blue; visible = full light.
Persist the explored grid with the floor save.

## Our use (turn-based grid - a perfect fit)
- Recast after every hero move and every door/wall change (Stone walls, broken walls).
- Enemy sight: cast from the enemy cell with its sight radius; decide that enemy-cast is
  authoritative for stealth (Hollow archetype).
- Torch/lantern items change the hero's radius; Darkness oaths shrink it.
- This logic lives in src/sim/ (deterministic, tested); the view only shades.

## Pitfalls
Origin inside a wall sees nothing (move to nearest floor). Per-tile casting on dual-grid
offset art cuts light through walls. Sight is asymmetric. Doors must update the grid + recast.
