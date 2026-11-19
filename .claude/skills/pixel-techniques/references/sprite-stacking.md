# Sprite stacking (rarely used)

Source: https://www.spritecook.ai/blog/sprite-stacking-pixel-art

Slice an object into 1-px-high horizontal layers, draw bottom->top lifted 1 px each, rotate
all by the same angle -> fake 3D at any heading. Squash ~0.75 (below 0.6 roofs get thin).
Godot: Node2D `_draw()` loop with draw_set_transform_matrix + draw_texture_rect_region, Nearest.

## Our use
Maybe for boats (perahu) on the world map. Pre-render static stacks to plain sprites.
Pitfalls: slow turns jitter at small sizes; outline the finished stack once; sort by ground
contact; poor fit for thin/hollow shapes.
