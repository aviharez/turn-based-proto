# Local setup: Godot, MCP servers and tools

No secrets live in this repo. Each developer connects MCP servers on their own machine;
tokens stay in your Claude Code / pi config or environment, never in git.

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
| SpriteCook | first choice for all art | `npx spritecook-mcp setup`, or the HTTP MCP `https://api.spritecook.ai/mcp/` (sign in with OAuth or a key in env) |
| PixelLab | fallback art, 8-dir characters, VFX workbench | add the HTTP MCP `https://api.pixellab.ai/mcp` with your token from pixellab.ai, e.g. `claude mcp add pixellab https://api.pixellab.ai/mcp -t http -H "Authorization: Bearer $PIXELLAB_TOKEN"` |
| ElevenLabs | SFX, ambience, music | ElevenLabs MCP with your own API key in env |
| Godot MCP | run the game, screenshots for review | pick one in week 1: godot-mcp-runtime or hi-godot/godot-ai; keep only the one that works |

Claude Code and pi (through the owner's pi MCP extension) can both use MCP servers.
Give each harness only what its lane needs:

| Server | Claude Code | pi (@gpt, @glm) |
| --- | --- | --- |
| Godot MCP | yes | yes (own scene/UI work) |
| SpriteCook, PixelLab, ElevenLabs | yes | no: paid credits, @claude only |

Leaving the art/audio servers out of pi's MCP config is safer than relying on the rule alone.

## When to set each one up
- **Now:** nothing is required to start M1 coding. `make check` needs only Godot on PATH.
- **First `src/view/` story:** a Godot MCP for Claude and pi, so they can run the game and take screenshots
  (or take them manually and drop them in `production/qa/evidence/`).
- **First approved art task:** SpriteCook (then PixelLab as fallback).
- **First audio task:** ElevenLabs.

## pi setup
- MCP: add the Godot MCP to your pi MCP extension config (not the art/audio servers).
- Install: `npm install -g @earendil-works/pi-coding-agent` (or `curl -fsSL https://pi.dev/install.sh | sh`).
- pi loads `AGENTS.md` from the repo root at startup; check the startup header lists it.
- Configure the two providers in pi with your own keys (OpenAI; Z.ai or another GLM-5.3-Flash provider).
  Keys go in pi's own config or env vars, never in this repo.

## 3. Orca lanes
See `AGENTS.md` → Agent lanes. One task = one branch/worktree; `make check` before every PR.
