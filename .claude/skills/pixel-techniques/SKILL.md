---
name: pixel-techniques
description: Use before implementing ANY visual, game-feel, lighting, tile, water, camera, transition or UI-window feature in the Godot project. Maps each game feature to a proven pixel-art technique (from the SpriteCook "game techniques" library) with numbers, Godot 4 steps and pitfalls.
---

# Pixel techniques library

This skill is the project's reference for how visual and game-feel features are built.
Each reference file summarises one technique in our own words, adapted to THIS game
(turn-based, portrait, 32 px tiles, zoomable camera, native-resolution UI, Godot 4, Android). The original articles contain
full shader code and a ready-made prompt for coding agents.

## Rules

1. Before implementing a feature listed below, read its reference file.
2. Then open the original article (URL at the top of the reference) with WebFetch and
   follow its code and its agent prompt. Do not copy article text into the repo;
   write our own implementation and credit the article in a code comment.
3. Keep every effect palette-safe: no blends that invent off-palette colours unless the
   reference says it is acceptable.
4. Count time in physics ticks (60/s) or in turn phases, never in rendered frames.
5. After implementing, run the game via the Godot MCP, take screenshots or a GIF, and
   compare against the reference's numbers. Report the result.

## Feature -> reference map

| Game feature | Reference |
| --- | --- |
| Project render settings, base resolution, scaling, notches | references/rendering.md |
| Floor change, entering/leaving settlement, menus opening full-screen | references/transitions.md |
| Every hit, crit, kill, block, parry | references/hit-feedback.md |
| Damage taken feedback, shields, status visuals | references/damage-flash.md |
| Camera on the grid and in the settlement | references/camera.md |
| Fog of war, torch light, enemy line of sight | references/shadowcasting.md |
| Lit dungeons with volume on sprites | references/normal-maps.md |
| Settlement day/night, region moods | references/day-night-lut.md |
| Ponds, rivers, coasts, rice terraces | references/water.md |
| Trees, bamboo, palms in wind | references/foliage-wind.md |
| Hero hidden behind houses/trees in the settlement | references/see-through.md |
| Menu backgrounds, region title cards, settlement sky | references/parallax.md |
| Optional retro filter setting | references/crt.md |
| Ground, walls, paths, terrain transitions, AND variety inside one terrain (edge Wang) | references/tilesets.md |
| Inventory, loot reveal, rarity, chests | references/inventory-ui.md |
| Tap handling, input buffering, touch forgiveness | references/input-forgiveness.md |
| Fake-3D props (boats, carts) - rarely used | references/sprite-stacking.md |
| ANY scene, arena or village layout (depth, layers, lighting) | references/scene-depth.md |
