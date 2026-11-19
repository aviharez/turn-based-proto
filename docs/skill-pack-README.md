# Runedeep project skills

Three project skills for the game repo. Copy the `.claude/` folder into the repo root
(next to CLAUDE.md, alongside the CCGS template's own `.claude/` content).

| Skill | Use it for |
| --- | --- |
| `pixel-techniques` | Every visual / game-feel feature: render settings, transitions, hit feedback, status visuals, camera, fog of war, lighting, day/night, water, foliage, see-through, parallax, CRT, tilesets, inventory UI, touch input. 17 reference files, each linked to its SpriteCook article. |
| `ai-art-pipeline` | Generating, animating, cleaning and importing art with SpriteCook and PixelLab; style lock, model choice, pixel grid, UI kits, agent setup, acceptance checks. |
| `quality-bar` | UI, game design and VFX checklists and the /ui-review, /design-review, /vfx-review procedures. |

Built from 46 of the 59 SpriteCook blog posts (game techniques, tilesets, Godot tutorial,
AI art workflow, characters and animation). Skipped 13 that don't apply: Unity/Tiled-only
tutorials, Cursor/OpenCode/Claude-desktop plugin posts (we use Claude Code + Codex), product
announcements and rewards, Chroma Awards, wallpapers, the Nano Banana 2 Lite and Phaser posts,
and the pet-to-sprite post. All text is summarised in our own
words with the original article linked; agents are told to read the original for code and
ready-made prompts.

## Tools
`tools/art/edge_wang.py` builds a 16-tile edge-Wang sheet from a seamless source texture (SpriteCook method) and renders a test map.

## Make Codex and omp use them too
Codex and omp don't read `.claude/skills/` automatically. Add this to AGENTS.md:

```markdown
## Skills (all agents)
- Before any visual / game-feel / UI work, read .claude/skills/pixel-techniques/SKILL.md
  and the matching reference file.
- Before generating or importing art, read .claude/skills/ai-art-pipeline/SKILL.md.
- Before marking a UI, design or VFX story done, run the checklist in
  .claude/skills/quality-bar/SKILL.md and attach the evidence.
```
