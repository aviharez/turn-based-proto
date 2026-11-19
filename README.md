# Runedeep (working title)

Turn-based tactical RPG with roguelike expeditions and a settlement you build, set in
Sundara, a Nusantara-inspired archipelago. Android first, portrait. Godot 4.7.2, typed GDScript.

- Design: [`design/game-brief.md`](design/game-brief.md) · Milestone: [`production/milestone.md`](production/milestone.md)
- Rules for every agent: [`AGENTS.md`](AGENTS.md) (Claude also reads [`CLAUDE.md`](CLAUDE.md))
- Setup (Godot, MCP servers): [`docs/setup/mcp-and-tools.md`](docs/setup/mcp-and-tools.md)

## Quick start
```sh
make import   # once per fresh clone
make check    # sim purity + gdUnit4 tests + headless boot — must pass before any PR
make run      # windowed 540x1200 portrait
```

## Layout
| Path | What |
| --- | --- |
| `src/sim/` | Pure deterministic game logic (no nodes). All randomness via `Rng`. |
| `src/view/` | Scenes and presentation; animates `SimEvent`s, never changes sim state. |
| `src/content/` | Data-driven content (JSON) and text (`text/*.csv`, en + id). |
| `tests/` | gdUnit4 tests (`tests/unit/`, `tests/integration/`). |
| `assets/` | Art, UI, audio; generated-asset manifests in `assets/manifests/`. |
| `.claude/` | Claude Code Game Studios agents/skills + Runedeep skills (pixel-techniques, ai-art-pipeline, quality-bar). |

Built on [Claude Code Game Studios](https://github.com/Donchitos/Claude-Code-Game-Studios) v1.3.0 (MIT,
see `third_party/`). Tests use [gdUnit4](https://github.com/MikeSchulze/gdUnit4) 6.2.3 (MIT).
