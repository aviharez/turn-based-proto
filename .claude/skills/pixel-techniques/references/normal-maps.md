# Normal maps from the sprite outline

Source: https://www.spritecook.ai/blog/pixel-art-normal-maps-from-outline

Generate normals from the alpha edge: distance-to-transparency -> rounded bevel height
(+ a little brightness for detail) -> slope = normal. Blur height slightly first.

## Numbers (~30 px sprite; scale to our 16x24 heroes)
bevel 5 px (1-2 for boxy props), top height 12, detail 1.5, blur sigma 0.7.
Lights: radius 70 px, height 26, energy 1.6, 6 quantised steps, warm light, dark-blue ambient.

## Godot 4
canvas_item shader with `light()` = falloff * N.L, quantise `ceil(lit*bands)/bands`.
CanvasTexture with diffuse + normal, Nearest. Apply to EVERY lit sprite and the floor.
PointLight2D with Height + white gradient texture; CanvasModulate for darkness.

## Our use
Dungeon floors with torches, keris glow and fire runes. Bake normals in the asset pipeline
(tools/bake_normals.py) so agents never hand-paint them.

## Mobile check
Measure frame time on the budget test phone with 4 lights; cap active lights per floor.

## Pitfalls
Pad sprites with a transparent border; needs hard alpha; light must sit above bevel top;
flip green channel if inverted.
