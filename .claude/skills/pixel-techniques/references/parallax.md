# Atmospheric perspective for parallax

Source: https://www.spritecook.ai/blog/2d-parallax-background-atmospheric-perspective

Blend each layer toward the sky's average colour on the same row; farther (slower) layers
blend more. Optional mist toward the bottom of mountain layers.

Numbers: amount 0.80 for far peaks (scroll 0.08) down to 0.04 for near trees (scroll 0.6);
ground/sky 0; mist 0.20-0.22; one global strength 0..1.

Godot 4: per-layer canvas_item shader `mix(c.rgb, sky, k)`, k = clamp(amount + mist*y, 0, 1);
1-px-wide sky-row texture built in GDScript; own ShaderMaterial per layer.

## Our use
Title screen, region title cards, settlement sky with volcano silhouettes, world map.
Prompt background art with "no haze" so haze stays controllable.

Pitfalls: single horizon colour; lowering opacity; modulate only darkens; never haze the play
layer; atlas/cropped layers break the row lookup.
