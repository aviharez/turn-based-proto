# Local setup: Godot, MCP servers and tools

No secrets live in this repo. Each developer connects MCP servers on their own machine;
tokens stay in your Claude Code / Codex config or environment, never in git.

## 1. Godot
- Install Godot **4.7.2-stable** and put it on PATH as `godot` (or pass `GODOT=/path` to make).
- First clone: `make import`, then `make check`.
- Android: install Android export templates and the Android SDK/JDK in the editor
  (Editor → Editor Settings → Export → Android). Debug keystore is per machine;
  the release keystore is never committed (`*.keystore`/`*.jks` are gitignored).
- Package name in `export_presets.cfg` is `com.aviharez.runedeep` (change before the first Play upload; it can't change after).

## 2. MCP servers (Claude Code)
| Server | Use | Setup |
| --- | --- | --- |
| SpriteCook | first choice for all art | `npx spritecook-mcp setup` (OAuth in browser) |
| PixelLab | fallback art, 8-dir characters, VFX workbench | add the HTTP MCP `https://api.pixellab.ai/mcp` with your token from pixellab.ai, e.g. `claude mcp add pixellab https://api.pixellab.ai/mcp -t http -H "Authorization: Bearer $PIXELLAB_TOKEN"` |
| ElevenLabs | SFX, ambience, music | ElevenLabs MCP with your own API key in env |
| Godot MCP | run the game, screenshots for review | pick one in week 1: godot-mcp-runtime or hi-godot/godot-ai; keep only the one that works |

Codex and omp/DeepSeek don't need the art MCPs (no visual tasks in their lanes).

## 3. Orca lanes
See `AGENTS.md` → Agent lanes. One task = one branch/worktree; `make check` before every PR.
