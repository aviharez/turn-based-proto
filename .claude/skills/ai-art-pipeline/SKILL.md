---
name: ai-art-pipeline
description: Use whenever generating, editing, animating or importing ANY art asset (sprites, animations, tiles, UI, icons, VFX) with SpriteCook or PixelLab. Enforces style consistency, correct pixel grid, palette lock, model choice and import settings.
---

# AI art pipeline (SpriteCook + PixelLab)

Distilled from the SpriteCook blog's art and AI-workflow guides (links per section) and
adapted to this project. All generated art must pass the checks at the end before it is
committed.

## 0. Style lock (do this once, reuse forever)
Sources: https://www.spritecook.ai/blog/consistent-game-art-with-ai ,
https://www.spritecook.ai/blog/presets , https://www.spritecook.ai/blog/make-a-game-when-you-cant-draw
- Theme text, style text and reference images live in `assets/style/` (style-bible.md,
  palette runedeep32.hex, 6-14 approved reference sprites).
- Save the same setup as a SpriteCook **preset** per asset type (hero, spirit, prop, tile,
  icon, UI). Generators have no memory between images; presets + references are the memory.
- Generate ONE hero asset of a new set first, approve it, then use its asset ID as the style
  reference for the rest of the set (this is how SpriteCook's agent skill works).
- Tone guard (see design/art-direction.md): heroes ~3 heads tall, capable silhouettes, no
  chibi proportions or big shiny eyes; spirits eerie-but-charming, not gory, not plush.

## 1. Pick the right tool/model
**Priority: SpriteCook first, PixelLab second** (owner decision, 20 Nov 2026: SpriteCook output is
better). Use PixelLab only when SpriteCook can't do the job (e.g. 8-direction character rotation,
skeleton animation, vfx_workbench) or when a SpriteCook result failed twice.

**Credit rule:** no test or exploration generations. Generate only for assets on an approved task
list, check the balance first, and state the estimated cost before each batch. Mockups and style
checks reuse existing assets plus local scripts (free PixelLab pixelart_workbench edits are fine).
Sources: https://www.spritecook.ai/blog/gpt-image-2-comparison ,
https://www.spritecook.ai/blog/pixel-engine-image
| Asset | Tool |
| --- | --- |
| Small icons, items, props 16-64 px from text | SpriteCook Pixel Engine Image (draws on the grid; 6 credits; text-only) |
| Characters with directions + animations | SpriteCook Character Creator first; PixelLab create_character / animate_character as fallback |
| Style-matched sprites, edits of existing art | SpriteCook Nano Banana model with references |
| UI screen concepts, HUD, menus, signage | GPT-Image-2 class model (best at structured layouts); then cut into components |
| Tiny 16-32 px sprites | strongest model + 16x16 checkerboard reference |
| Tilesets | SpriteCook tileset mode (top-down 15/17-piece, 16 or 32 px); PixelLab create_topdown_tileset only as fallback |
| Animated VFX (spells, hits, auras) | SpriteCook animate first; PixelLab vfx_workbench when frame-exact control is needed |
| Music / SFX | ElevenLabs, PixelLab create_music / create_sound_effect |

## 2. Pixel grid and resolution
Sources: https://www.spritecook.ai/blog/why-ai-cant-match-pixel-art-resolution ,
https://www.spritecook.ai/blog/nanobanana-pixel-art-for-games , https://www.spritecook.ai/blog/tiny-pixel-art-animations
- Image models paint blocks, not pixels; a redraw can choose a different block grid.
- Always keep **Pixel Perfect** on; run grid detection on every output and compare the
  detected grid with the target (heroes ~44-48 px tall on a 48 px canvas, 32x32 tiles, 32x32 icons).
- Mismatch -> rerun with the Pro model, or add internal detail / clearer silhouette; do not
  ship a mismatched sprite.
- For 16-32 px work: short prompt + checkerboard reference + a second reference in our
  top-down view. Judge at 4x, then approve at 1x.
- Converting generic AI images: generate at highest resolution, detect grid, resample to
  1 logical pixel = 1 pixel, quantise to our 32-colour palette.

## 3. Generation settings
Source: https://www.spritecook.ai/blog/creating-pixel-art-assets
- Always state the view angle ("top-down 3/4 view") and the style.
- Grid: 32 px tiles, 32x32 icons, heroes ~44-48 px tall (48 px canvas), small spirits ~28 px, bosses ~90 px.
- Remove BG on for sprites, off for scenes/textures. Smart Crop "Power of 2" for atlases.
- Palette lock to our 32 colours; up to 14 style references.

## 4. Animation
Sources: https://www.spritecook.ai/blog/character-creator-flow ,
https://www.spritecook.ai/blog/custom-character-animations ,
https://www.spritecook.ai/blog/pixel-engine-v1-5-sprite-animation-model ,
https://www.spritecook.ai/blog/animate-custom-sprites , https://www.spritecook.ai/blog/animate-detailed-sprites
- Choose perspective first (top-down); changing it later means regenerating.
- Default animation set per unit: idle (4), move (4-6), attack (6), cast (6), hurt (2-3),
  death (6-8). Start small to save credits.
- Pixel Engine v1.1 for loops/idles/walks (more fluid, even frame counts, batch discount);
  v1.5 for precise actions (weapon swaps, two-step moves; 3-16 frames, steadier, 26 credits).
- Use a prep pose for direction-specific moves. Generate related animations together.
- Animation does not rotate the view: the source sprite's perspective carries over.
- Review auto-filled motion prompts; check live price before batches.

## 5. Cleanup
Sources: https://www.spritecook.ai/blog/smart-outline-repair , https://www.spritecook.ai/blog/edit-pixel-art-with-ai ,
https://www.spritecook.ai/blog/pixel-editor , https://www.spritecook.ai/blog/slice-sprite-sheets-and-animations
- Smart outline repair stays on (free; MCP `outline_repair` default on); fixes BG-removal gaps.
- Recolours, palette fixes, per-frame fixes (<=24 frames), crops/integer scaling: SpriteCook
  "Edit with Agent" (one change per message; set a credit cap). It cannot invent new parts.
- Frame drift, onion skin, layer work: SpriteCook Pixel Editor or Aseprite/LibreSprite.
- Packed sheets: Slicer (auto detect / fixed grid / custom), smart alpha on.

## 6. UI kits
Source: https://www.spritecook.ai/blog/generate-game-ui-with-ai
- One high-res concept image per layout (HUD, settlement, inventory, skill tree, shop),
  all referencing the first approved concept.
- Regenerate components on transparent backgrounds with the concept as reference; never crop
  from the concept. Ask for pressed/disabled states as scoped batches.
- Panels, buttons, bars = 9-slice. Real text is rendered by Godot with our pixel font -
  never ship AI-generated text.
- Handoff: concept + transparent elements + manifest (9-slice margins, states) + atlas.

## 7. Agent setup
Sources: https://www.spritecook.ai/blog/ai-agent-generate-sprites , https://www.spritecook.ai/blog/codex-spritecook-plugin
- Claude Code: MCP `https://api.spritecook.ai/mcp/` with Bearer key (keys in env, never in git).
- Only Claude Code generates art. pi agents (GPT, GLM) don't get the art MCPs; they hand art needs to @claude.
- Check credit balance before batches; poll long jobs instead of assuming completion.

## 8. Disclosure and ethics
Source: https://www.spritecook.ai/blog/is-ai-art-ok-in-indie-games
- Google Play does not require tagging individual AI art assets (check policy before launch).
- Players react badly to generic or inconsistent AI art -> every asset is reviewed by eye.
- Never generate look-alikes of existing protected characters.
- Log every prompt, model and seed in assets/LOG.md.

## Acceptance checks (run `make art-check`)
1. Detected pixel grid == target grid.
2. All colours inside runedeep32 palette (or the approved LUT).
3. Transparent padding >= 1 px; hard alpha only.
4. Silhouette readable at battle zoom (9 tiles across) on a 1080x2400 screenshot.
5. Matches style bible (Claude compares against 3 reference sprites and says why).
6. Prompt logged in assets/LOG.md.
