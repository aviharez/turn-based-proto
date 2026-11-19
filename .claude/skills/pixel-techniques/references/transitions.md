# Screen transitions

Source: https://www.spritecook.ai/blog/pixel-art-screen-transitions (includes a ready agent prompt)

Eight styles share one timer and a 0..1 progress value: fade, stepped fade, Bayer dither,
pixelate, iris, diagonal wipe, diamonds, shutters.

## Timing (60 ticks/s)
Cover 33 ticks -> black 9 (swap scene here) -> uncover 33 -> wait 9. Game paused 84 ticks (~1.4 s).
Stepped fade: 4 hard steps. Dither: 2x2 game-pixel blocks vs 8x8 Bayer. Pixelate: blocks 1..16.

## Godot 4
1. Full-screen ColorRect + canvas_item shader under a CanvasLayer at layer 100 (above HUD).
2. `pixel_size` = 1 with viewport stretch.
3. Autoload that counts physics ticks, process mode Always.
4. Pause tree, swap only while fully black, unpause. Ignore repeat requests mid-transition.
5. All door/stairs/shrine triggers go through the autoload.

## Our use
- Floor -> floor: **dither** (palette-safe, fits spirit-world theme).
- Settlement <-> expedition: **iris** centred on the hero.
- Boss arena: **shutters**.
- Consider shortening to ~0.9 s total for floor changes on mobile; keep the black hold.

## Pitfalls
Plain fade invents off-palette colours; averaging when pixelating does too; working in window
pixels shrinks the pattern; letting input through mid-transition; drawing cover under the HUD.
