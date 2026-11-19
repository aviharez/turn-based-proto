# Keeping the hero visible behind objects

Source: https://www.spritecook.ai/blog/2d-see-through-fade-dither-cutout-silhouette

Looks: fade (40% opacity; blends colours), dither (4x4 Bayer, 18 px clear radius, 16 px soft
edge; palette-safe), cutout (22 px hard hole), silhouette (flat-colour hero copy clipped to the
object's pixels; scenery untouched).

Trigger: feet behind the object's base (Y-sort), then 3x4 sample grid vs opaque pixels;
on when 3 of 12 hidden, ease 0.2 s.

## Our use
Settlement only: **silhouette** for big houses (joglo roofs), **dither** for trees.
Expedition floors are designed so nothing occludes units.

## Pitfalls
Tiles on one layer share opacity (objects need own sprites); one material per sprite (merge
discard into existing shader); origin at the feet; don't dither the whole hero.
