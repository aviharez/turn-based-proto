# CRT filter (optional setting only)

Source: https://www.spritecook.ai/blog/crt-shader-pixel-art

One-pass shader: row blur (chroma > luma), brightness-dependent scanlines, phosphor mask,
glow, curvature. Params: LUMA_BLUR 0.45, CHROMA_BLUR 1.2, BEAM 0.21-0.40, MASK_PX 2,
MASK_DARK 0.62, MASK_LIGHT 1.22, GLOW 0.26, WARP (0.031, 0.041), BOOST 1.5.

## Our use
Off by default. A "Retro screen" toggle in Settings for fans. On mobile: shrink glow loop to
3x3 or drop it; drop the mask first on small screens (~43 texture reads/pixel at full quality).
Curvature shifts touch positions near edges - remap input or disable curvature on mobile.
