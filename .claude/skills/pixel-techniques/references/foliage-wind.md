# Trees and foliage in the wind

Source: https://www.spritecook.ai/blog/pixel-art-trees-wind-animation

Split each tree offline into trunk, darker "inside" layer and one sprite per leaf clump.
Each clump steps a 1-px loop (up, right, down, back) 10x/s; phase from world position along
the wind, so a wave travels through canopies. Gusts widen to 2-3 px and push a damped spring.

## Numbers
Wave 1.54 s per loop, 69 px between crests. Oak push 2.2 px / 2.2 s / damping 0.35;
bush 1.4 / 1.0 / 0.35; pine 3.6 / 2.8 / 0.22. Split: min_dist 5, min_size 25, trunk_part 0.4.

## Godot 4
Autoload `Wind` (gust patches, gust(), breeze()). Per-tree script runs the spring per frame,
sets clump positions every 0.1 s to rest + rounded offsets. Tall thin plants bend with a
row-sliding shader.

## Our use
Settlement: banyan (beringin), palms, bamboo, banana plants. Expedition floors stay still
(readability) except decorative edge foliage.

## Pitfalls
Inside layer must cover clump/trunk joins; reassign outline pixels; constant or random motion
reads as jitter.
