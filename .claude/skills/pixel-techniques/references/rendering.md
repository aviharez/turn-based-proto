# Rendering: modern pixel setup (decision 20 Nov 2026)

Sources:
- https://www.spritecook.ai/blog/pixel-perfect-pixel-art-game-settings (pixel settings basics)
- https://apples-moonflowergames-com.pages.dev/articles/pixel-art-smooth-camera-anti-aliasing (smooth camera + AA)
- https://godotengine.org/qa/72525/how-to-apply-sharp-bilinear-filter-fix-pixel-wobble-pixel-art

## Project decision: modern pixel, NOT a retro locked canvas
- Art: 32 px tiles. Heroes ~44-48 px tall (48 px canvas), small spirits ~28 px, bosses ~90 px (2x2 tiles).
- World: rendered through Camera2D at NON-integer scales with a sharp-bilinear / sub-pixel filter
  (nearest upscale by floor(scale), then bilinear to the final size). Pixels stay even, no shimmer.
- UI: drawn at the phone's native resolution (crisp text, room for information). Frames, icons and
  buttons are pixel art scaled by an integer factor; text uses a real font at native size.
- Zoom: 3 fixed steps with +/- buttons. Battle = 9 tiles across (~46 dp per tile, finger-safe, since
  touch targets must be >= 48 dp ~ 9 mm). Build/village = ~14 tiles across, placement by dragging a
  snapping ghost footprint + Confirm. No free pinch zoom during battle (accidental zooms on mobile).
- Portrait, all aspect ratios: fill the screen (no black bars); extra height = more visible world.

## Godot 4 notes
- Textures: Nearest import; the sharp-bilinear pass happens in the world SubViewport/camera shader.
- Keep camera position snapped to world pixels at each zoom step to avoid crawl; tween zoom on the
  physics tick.
- Safe areas: keep interactive UI out of notches and the gesture bar.
- Never put UI inside the pixel world viewport.

## Pitfalls
- Plain nearest-neighbour at non-integer scale = uneven, shimmering pixels.
- Linear filtering without the integer pre-scale = blurry pixel art.
- Mixing sprite pixel sizes (e.g. a 24 px-era sprite scaled 1.33x) breaks the look; regenerate instead.
