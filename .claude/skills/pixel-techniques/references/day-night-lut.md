# Day/night with a colour lookup table (LUT)

Source: https://www.spritecook.ai/blog/pixel-art-day-night-cycle-color-lookup-table (includes agent prompt)

Instead of a dark overlay, every palette colour gets its own colour per time of day,
so shadows go blue while windows and lanterns stay warm.

## Setup
- Row 0 = the palette's distinct colours (we have one locked 32-colour palette: perfect).
- Rows: day, dusk, blue hour, night, dawn (blue hour avoids grey mud when blending).
- Night formula starting point in OKLab: lightness x0.47 + 0.13, shift a/b cooler.
- Max 256 colours (one red channel).

## Godot 4
1. Import LUT lossless, Nearest, no mipmaps.
2. On load build an index image: red = column of each pixel's colour; count misses.
3. Shader: read column, texelFetch the two neighbouring rows, mix by fractional
   `time_of_day`, multiply by COLOR.
4. One global uniform drives time_of_day.

## Our use
- Settlement real-time day/night (ties to farm timers) and festival nights.
- Region moods: the same LUT technique re-grades regions (volcano, jungle, sea) without
  new palettes.

## Pitfalls
Compressed/smoothed textures miss; anti-aliased edges add off-palette colours; HDR 2D breaks it;
same-day colours change together; can't separate stars from sky screen-wide.
