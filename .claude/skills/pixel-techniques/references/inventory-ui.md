# Inventory, loot window and rarity

Source: https://www.spritecook.ai/blog/pixel-art-inventory-ui-loot-window

## 9-slice frame
One 96x96 frame art, 16 px margins. Corners as drawn; edges and centre TILE, not stretch.
Godot: NinePatchRect, all margins 16, axis stretch = Tile.

## Article layout (landscape) and our portrait version
Article: window 222x172, 5x3 slots of 34x34 with 3 px gaps, icons 32x32.
Ours (216 wide): inventory grid 5 columns x 34 px + 4 gaps x 3 px = 182 px, centred with
17 px margins; scrolls vertically. Item detail opens as a bottom sheet, not a popup.

## Rarity colours (border / light / fill) - starting point, remap to our palette
Common #5e6878/#8b96a6/#26212e, Uncommon #3a7d3a/#6cbf4a/#1c2a22, Rare #2f6fc4/#64b3f0/#1b2440,
Epic #6d3aa8/#a974e0/#261c3a, Legendary #d9a440/#f2d16b/#33261a.
Rarity must also be readable without colour: border notch shape per rarity (colour-blind safe).

## Loot reveal timing
Chest shake 0.6 s, lid 24 fps, window fades in at 1.00 s, first item lands 1.38 s, then every 0.15 s.
Sparkles per landing 0/4/6/8/14 (common->legendary), 7 px -> 1 px. Rings grow 3 px (rare),
5 px (epic). Epic: border light streak every 1.4 s. Legendary: rays + beam + 2-frame white flash.
Warm glow (255,178,84) starts 0.1 s, peaks 0.18 s, half by 0.8 s; screen blend.
Offer "tap to skip" after the first reveal - mobile players are impatient.

## Pitfalls
Stretched edges turn rivets into bars; scaling the window open looks rubbery (fade instead);
fractional scale blurs; blurred rects make boxy glows. Generate each 32x32 icon separately
for consistent sizes; stack counts use 3x5 px digits.
