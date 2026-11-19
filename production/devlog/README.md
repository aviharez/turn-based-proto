# Devlog: progress for Instagram (Goomi Builds)

Every PR leaves a trace here, so posts never start from a blank page.

## Folders
- `entries/` one Markdown file per PR or per notable day: `YYYY-MM-DD-<branch>.md` (start one with `make devlog TITLE="..."`).
- `media/dayNN/` screenshots and GIFs (PNG/GIF committed; keep each under ~3 MB). MP4/MOV stay local (gitignored).
- `media/inbox/` where F9 screenshots and `make clip` videos land; move the good ones to `media/dayNN/`.
- `digests/` Instagram carousel drafts compiled by `make devlog-digest FROM=... TO=...`.

## Capturing
- **Screenshot:** run the game, press **F9** (desktop) or tap with **3 fingers** (phone, debug build).
- **Video:** `make clip SCENE=res://path/to/scene.tscn SECONDS=8` (desktop, needs ffmpeg) → 1080-wide MP4 for Reels.
  On the phone, Android's own screen recorder is simplest.
- **Pixel art for a post:** `tools/devlog/upscale.py art.png` → crisp 1080×1350 image (never blurry).

## Who writes what
- Every agent adds one entry to its PR (template in `entry-template.md`): hook, what changed, numbers, AI note.
- @claude runs the `devlog` skill weekly (and at each week's exit) to turn entries into a carousel draft + caption
  that fits the Goomi Builds templates on the Instagram canvas.
- The owner picks what to post. Nothing is posted automatically.
