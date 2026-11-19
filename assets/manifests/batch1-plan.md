# Art batch 1: priced asset list (for owner approval, Day 3)

> Story W1-25 · Owner: @claude · Generation date: Week 2 (27 Nov onward), **only after approval**
> Style rules: `assets/style/style-bible.md` · Palette: `assets/style/runedeep32.hex`
> **Prices checked live on 20 Nov 2026** (SpriteCook MCP `list_character_workflows`, `list_generation_models`).
> **Balance on 20 Nov: 763 credits** (apprentice tier). **0 credits spent so far.**

## Pricing used
| Item | Credits | Source |
| --- | --- | --- |
| Character Creator base character | 12 | `base_character_credit_cost` |
| First animation in a character run (idle, attack, hurt, death; 8–12 frames) | 20 | `credit_costs.basic` |
| Each further animation **in the same run** | 14 | `batch_credit_cost` |
| Custom precise animation (Pixel Engine v1.5, 3–16 frames) | 26 | ai-art-pipeline §4 (no batch price) |
| Prop / icon from text, 16–128 px (Pixel Engine Image) | 6 | `pixel-engine-image-v1` |
| Style-matched image with references (Nano Banana 2.1, 2K) | 18 | `gemini-nano-banana-2.1` |
| Tileset 15-piece, 32 px | **~18 (estimate)** | the tileset tool doesn't list a price. I'll check the live price before the first one and report if it's higher |
| Uploading the Day 0 refs as style references | 0 | `create_asset_upload` |

## Choices that keep it cheap
- **Units face the camera (front 3/4) and flip horizontally** toward their target. No walk cycles:
  moves are 0.15 s tweens with a 1 px bob (W1-28). This drops back/side preps (12 each) and walk animations.
- **Light shafts, fireflies, colour grade, hit flash, damage numbers: made in-engine** (shaders/particles), 0 credits.
- **Enemies 3–6 for Week 2 start as palette-swap variants** of the tuyul and brute (local remap to runedeep32, 0 credits). Only one new unique enemy is in this batch.
- Generate **one hero first** (silat), approve it, then use its id as the style reference for everything else (ai-art-pipeline §0).

## The list
| # | Asset | Size | Tool / model | Contents | Credits | Priority |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | **Silat hero** | 48 px canvas, 44–48 tall | Character Creator | base 12 + idle 20 + attack/hurt/death 3×14 | 74 | must |
| 2 | Silat guard pose | 48 px | NB 2.1 edit of #1 | 1 still | 18 | must |
| 3 | Silat parry | 48 px | PE v1.5 animate #1 | 6 frames | 26 | must |
| 4 | **Tuyul** | 32 px canvas, ~28 tall | Character Creator | base + idle + attack/hurt/death | 74 | must |
| 5 | **Brute** | 48 px canvas, ~40 tall | Character Creator | base + idle + attack (smash)/hurt/death | 74 | must |
| 6 | Ground tileset: flagstone ↔ moss | 32 px, 15-piece | SpriteCook tileset (ref07, ref08 as refs) | 1 atlas | ~18 | must |
| 7 | Ground tileset: dirt path ↔ moss | 32 px, 15-piece | SpriteCook tileset | 1 atlas | ~18 | must |
| 8 | Terrace kit: top edge, front wall, corners, stairs | 32 px pieces on one sheet | NB 2.1 2K, refs ref07 | 1 sheet, sliced locally | 18 | must |
| 9 | Props ×10: stupa, 2 fallen blocks, mossy rock, root clump, 2 fern clumps, palm, stone lantern, offering tray (First minute) | 32–96 px | Pixel Engine Image | 10 × 6 | 60 | must |
| 10 | Foreground frame: top canopy strip + bottom fern strip | 288 × ~96 px each | NB 2.1 2K, refs ref07 | 2 images | 36 | must |
| 11 | Battle action icons: Strike, Guard, Parry, Cast, End turn | 32 px | Pixel Engine Image | 5 × 6 | 30 | must |
| 12 | Intent icons: attack, smash, approach | 16–24 px | Pixel Engine Image | 3 × 6 | 18 | should |
| 13 | **Dukun hero** (second calling) | 48 px | Character Creator + guard edit + cast (v1.5) | 74 + 18 + 26 | 118 | should |
| 14 | One new unique enemy for Week 2 (designed in the Week 2 enemy data) | 32–48 px | Character Creator | base + 4 anims | 74 | could |

## Totals
| | Credits |
| --- | --- |
| **Must** (#1–11) | **446** |
| + Should (#12–13) | 136 → **582** |
| + Could (#14) | 74 → **656** |
| Retry reserve 15 % of the chosen set | 67 (must) · 87 (must+should) · 98 (all) |
| **All + reserve** | **754 of 763** (9 left) |
| **Must + should + reserve (recommended)** | **669** (94 left for fixes, or banked for batch 2) |

**Batch 2 (Week 3: Buto Ijo boss, 4 buildings, ~20 furniture, 2 allies, UI kit) will need a top-up whatever you choose.**
Rough estimate: 600–750 credits. I'll price it as its own list before Week 3.

## Cut line (what to drop first if you want it cheaper)
1. #14 the unique enemy (−74, plus its reserve): Week 2 uses palette swaps only.
2. #12 intent icons (−18): drawn in-engine as shapes.
3. #13 the dukun moves to batch 2 (−118): the Week 2 slice plays with the silat only.
4. #2 the guard pose (−18): Guard is shown with a blue shield VFX on the idle sprite.

With all four cut: **must-only ≈ 428 + reserve 64 = 492**.

## Process once approved
1. Upload ref01–ref08 as SpriteCook style references (free) and record their ids in the style bible.
2. Generate #1 silat, check scale/grid/palette (`make art-check`), show it to the owner, then lock it as the style reference.
3. Batch the rest in the order above. Check the balance before each batch and state the cost in the PR.
4. Log every asset (asset_id, sha12, label) in `assets/manifests/spritecook-assets.json` and the prompts in `assets/LOG.md`.
5. A failure is retried at most twice on SpriteCook, then PixelLab is used (rule: SpriteCook first).
