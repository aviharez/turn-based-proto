# Runedeep style bible (art lock v1)

> **Status:** draft for owner approval, Day 3 (23 Nov 2026) · **Owner:** @claude · Story W1-24
> **Binding for:** every generated or hand-made asset from art batch 1 onward.
> **Sources:** `design/game-brief.md` (Look, Avoid), AGENTS.md (pixel art and rendering rules),
> `.claude/skills/ai-art-pipeline/SKILL.md`, the Day 0 style tests (`references/`).
> Evidence: `production/qa/evidence/W1-24-style-bible/` (palette swatch, reference sheet).

## 1. One sentence
**Modern, warm, layered pixel art of an overgrown Nusantara archipelago:** capable adult
heroes, eerie-but-charming spirits, and scenes with real height and light. Never retro, never chibi, never flat.

## 2. View and grid
| Rule | Value | Ref |
| --- | --- | --- |
| View | top-down **3/4**: floors seen from above, walls and props show their front face | ref07 |
| Tile | **32 × 32** px | AGENTS.md |
| Battle view | 9 tiles across (288 px world) → ×3.75 on a 1080-wide screen | ref07 is exactly 288 × 512 |
| Build view | ~14 tiles across | brief |
| Light | from the **top-left**, warm. Shadows fall bottom-right as soft dark ovals or blobs under every unit and prop | ref07, ref05 |
| Pixel grid | 1 art pixel = 1 world pixel. No mixed pixel sizes, no sub-pixel sprite positions | ai-art-pipeline §2 |

## 3. Scale (measured from the Day 0 tests vs the target)
The Day 0 sprites are **style references, not final scale**. Batch 1 regenerates every unit at the target size.

| Unit | Day 0 test (canvas → visible height) | **Target** |
| --- | --- | --- |
| Hero (silat, dukun) | 36 px → 34 / 33 px | **48 px canvas, 44–48 px tall**, ~3 heads tall |
| Small spirit (tuyul) | 24 px → 22 px | **~28 px tall** on a 32 px canvas |
| Brute (Week 1 enemy) | — | **~40 px tall** on a 48 px canvas: bulkier, not taller than the hero by much |
| Boss (Buto Ijo) | 68 px → 68 px | **~90 px** on a 96 px canvas, standing on 2 × 2 tiles |
| Buildings (joglo, rumah gadang) | 176 × 160 | footprint in whole tiles (4 × 4 = 128 px wide) + roof overhang. Rescale in batch 2 |

## 4. Characters
- **Proportions:** ~3 heads tall, capable adults with readable hands, weapons and feet. **No chibi, no big
  shiny eyes, no plush spirits** (brief: Avoid). Ref: ref01 silat, ref02 dukun.
- **Silhouette first:** each unit must read as a black silhouette at battle zoom. The hero's weapon sticks
  out of the silhouette (ref01 golok, ref02 staff).
- **Outline:** 1 px dark outline (palette 0–1), **selective**: lighter inside where two
  shapes of the same colour meet. Ref: ref01, ref04.
- **Spirit rim (rule):** every spirit/enemy keeps a **1 px pale rim** (palette 31 `#d8dcdd`, or 6 `#a7a699`
  on bright ground) on its light side (top-left), so it separates from busy jungle floors. Ref: ref03 and
  the mock in `production/devlog/media/day00/03-depth-target-with-units.png`.
- **Shading:** 3–4 tones per material, with hue-shifted ramps (shadows go cooler or redder, never just darker grey).
  No dithering on characters. Light dithering is allowed on large ground textures only.
- **Motifs:** batik and songket patterns as **2–3 px suggestions** (ref02 robe), never real text, never
  a real sacred symbol (see `design/lore/sensitivity.md`).
- **Tone guard per creature:** tuyul = small, bald, sly, grey-violet (ref03). Brute = heavy, hairy, dark,
  "genderuwo-like" without copying any one depiction. Buto Ijo = huge green ogre with gold armbands and a club (ref04).

## 5. Environment and depth (fixes the "wallpaper" complaint)
Every scene has **5 depth layers** (AGENTS.md; `.claude/skills/pixel-techniques/references/scene-depth.md`):

| Layer | What | Ref |
| --- | --- | --- |
| 1 Ground | flagstone + moss + dirt path. Uses **edge-Wang variation** so no tile repeat shows (`tools/art/edge_wang.py`) | ref07 centre, ref08 |
| 2 Elevation | raised terraces with a **visible front wall** (≥ 12 px tall) and stairs. The wall face is darker than the top | ref07 terraces |
| 3 Props | stupa, fallen blocks, roots, palms. Y-sorted, each with a contact shadow | ref07 |
| 4 Foreground frame | canopy and fern overhang at the screen edges, drawn over the units, never covering the 7 × 8 arena | ref07 top and bottom |
| 5 Light and air | sun shafts, fireflies, a warm grade at the top and cooler at the bottom | ref07 |

- The **arena floor stays calm** (low contrast, palette 3–11) so units and intent tiles read clearly. Detail and
  contrast go into the frame and the props.
- Materials: andesite stone (palette 2–6), moss (7–11), laterite dirt (13–15, 22), wood (12–15, 19–21).

## 6. Palette: `runedeep32.hex`
32 colours, taken from the Day 0 tests and concept B (role-budgeted k-means, then hand-tuned).
Every test sprite maps to it with a mean RGB error of 13–20 (reference sheet: original vs locked).

| Idx | Role | Use |
| --- | --- | --- |
| 0–1 | outline | outlines, deepest shadow (0 cool, 1 warm) |
| 2–6 | stone | andesite ramp, ruins, the brute's fur shadows |
| 7–11 | moss | foliage ramp, the Buto Ijo's skin |
| 12–15 | earth | soil, wood, leather |
| 16–18 | skin | human skin ramp (also warm highlights) |
| 19–23 | red | laterite, roof tiles, cloth. **23 `#a93624` = danger red** (intent tiles, hit flash) |
| 24–26 | gold | sunlight, gold trim, Focus colour (24) |
| 27–28 | blue | the silat's cloth, night shadow tint |
| 29 | spirit violet | tuyul and spirit shading |
| 30 | jade | magic, the dukun's staff gem, Cast UI |
| 31 | pale | spirit rim, bone, highlight sparkles |

**Rules:** sprites use only these colours. Transparent padding ≥ 1 px, hard alpha only (no
semi-transparent edges). VFX may add additive glow in-engine. The UI (native resolution) may use tints of the palette.

## 7. UI look (summary; the full UI kit comes in Week 3)
- Dark warm panels (palette 1 at ~90 %) with a thin gold border (25). Text is rendered by Godot, never baked into art.
- Danger = red 23, Focus = gold 24, Guard = blue 28, Parry = gold 26 flash, Cast = jade 30.
- The UI lives at native phone resolution on a CanvasLayer, outside the pixel world.

## 8. Do / Don't
| Do | Don't |
| --- | --- |
| state "top-down 3/4 view, light from top-left" in every prompt | mix perspectives (side-view, isometric) |
| generate one hero asset first, approve it, then use its id as the style reference | generate a whole set blind |
| keep spirits eerie-but-charming | gore, plush/cute spirits, big shiny eyes |
| detail in props and frame, calm arena floor | busy, high-contrast floor tiles |
| quantise to `runedeep32` and check the grid | ship a sprite with a wrong pixel grid |
| log every asset in `assets/manifests/` (+ prompt in `assets/LOG.md`) | test or exploration generations |

## 9. References (`assets/style/references/`, not imported by Godot: `.gdignore`)
| File | What it locks | Source | sha12 |
| --- | --- | --- | --- |
| ref01-silat.png | hero proportions, outline, cloth | Day 0 style test v0.2 (PixelLab) | a49d5c0d4a7d |
| ref02-dukun.png | caster, batik suggestion, prop silhouette | Day 0 style test v0.2 (PixelLab) | ac1c8e270627 |
| ref03-tuyul.png | small spirit tone, violet-grey | Day 0 style test v0.2 (PixelLab) | 56e5622feb93 |
| ref04-buto-ijo.png | boss rendering, gold trim | Day 0 style test v0.2 (PixelLab) | 3ef22a2dea04 |
| ref05-joglo.png | architecture, stone base, roof | Day 0 style test v0.3 | d44b28861b0b |
| ref06-rumah-gadang.png | architecture, warm windows | Day 0 style test v0.2 | ab4c0398d217 |
| ref07-concept-b-clearing.png | **depth target**: 5 layers, light, 9-tile width | SpriteCook `30acd643-3f87-468c-801c-63f3775642fa` | 7fe2393ccad9 |
| ref08-moss-texture-b.png | ground texture source for edge-Wang | SpriteCook `f2f0e00b-2338-4d33-9676-ed534e140ea1` | 682ca4e43643 |

The Day 0 sprites have no SpriteCook ids (made with PixelLab during the style tests). To use them as SpriteCook
style references, upload them once with `create_asset_upload` (free) at the start of batch 1, and record the ids here.

## 10. Open questions for the owner (Day 3)
1. Approve **runedeep32** as the palette lock? (Swatch: `production/qa/evidence/W1-24-style-bible/01-runedeep32-swatch.png`)
2. The brute is ~40 px tall: OK, or should it stand taller than the hero?
3. The Day 0 heroes are 34 px. Regenerating at 48 px costs credits (see `assets/manifests/batch1-plan.md`). OK?
