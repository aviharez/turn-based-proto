#!/usr/bin/env python3
"""Compile devlog entries into an Instagram carousel draft that matches the
Goomi Builds templates (cover, patch-notes slide, outro + caption).

usage: tools/devlog/digest.py --from 2026-11-20 --to 2026-11-26 [--devlog 02]
Writes production/devlog/digests/<from>_<to>.md and prints its path.
The draft is a starting point: Claude (devlog skill) or the owner edits it.
"""
import argparse
import datetime as dt
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
ENTRIES = ROOT / "production/devlog/entries"
OUT = ROOT / "production/devlog/digests"
START = dt.date(2026, 11, 20)
TOTAL_DAYS = 30


def parse(path: Path) -> dict:
    text = path.read_text(encoding="utf-8")
    m = re.match(r"^---\n(.*?)\n---\n(.*)$", text, re.S)
    meta, body = ({}, text) if not m else (m.group(1), m.group(2))
    data = {"body": body.strip(), "file": path.name}
    if m:
        for line in meta.splitlines():
            if ":" in line:
                k, v = line.split(":", 1)
                data[k.strip()] = v.split("#", 1)[0].strip()
    return data


def section(body: str, label: str) -> str:
    m = re.search(r"\*\*" + re.escape(label) + r"[^*]*\*\*\s*(.*?)(?=\n\*\*|\Z)", body, re.S)
    return m.group(1).strip() if m else ""


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("--from", dest="start", required=True)
    ap.add_argument("--to", dest="end", required=True)
    ap.add_argument("--devlog", default="XX", help="devlog number for the cover")
    a = ap.parse_args()
    lo, hi = dt.date.fromisoformat(a.start), dt.date.fromisoformat(a.end)
    rows = []
    for p in sorted(ENTRIES.glob("*.md")):
        d = parse(p)
        try:
            day = dt.date.fromisoformat(d.get("date", ""))
        except ValueError:
            continue
        if lo <= day <= hi:
            rows.append(d)
    last_day = min(TOTAL_DAYS, max(1, (hi - START).days + 1))
    progress = round(last_day / TOTAL_DAYS * 100 / 5) * 5
    by_kind = lambda k: [r for r in rows if r.get("kind", "").startswith(k)]
    pick = lambda k: (by_kind(k) or [{}])[0]
    shows = [r for r in rows if r.get("show", "yes").startswith("yes")]
    media = [m.strip() for r in rows for m in r.get("media", "[]").strip("[]").split(",") if m.strip()]

    lines = [
        f"# Devlog draft {a.start} → {a.end} (Day {last_day}/30)",
        "",
        f"Entries: {len(rows)} · worth posting: {len(shows)}",
        "",
        "## Slide 1 · Cover (CoverGoomiBuilds)",
        f"- Tag: GOOMI BUILDS · DEVLOG {a.devlog}",
        f"- Headline: Day {last_day:02d}: [pick the best hook below]",
        f"- Screenshot/GIF: {media[0] if media else '[none logged — capture one!]'}",
        "",
        "## Slide 2+ · Patch notes (SlideDevlog)",
        f"- BUILD: Day {last_day} · {hi.isoformat()}",
        f"- + ADDED: {section(pick('added').get('body', ''), 'What changed') or '[…]'}",
        f"- ~ FIXED: {section(pick('fixed').get('body', ''), 'What changed') or '[…]'}",
        f"- – CUT: {section(pick('cut').get('body', ''), 'What changed') or '[…]'}",
        f"- PROGRESS: {progress}% (day {last_day} of {TOTAL_DAYS})",
        "- NEXT QUEST: [from production/milestone.md, next week's exit line]",
        "",
        "## Hooks to choose from",
    ]
    lines += [f"- Day {r.get('day', '?')} · {section(r['body'], 'Hook') or r.get('title', '')}" for r in shows] or ["- [none]"]
    lines += ["", "## Behind the scenes (AI notes)"]
    lines += [f"- {section(r['body'], 'Behind the scenes')}" for r in rows if section(r["body"], "Behind the scenes")] or ["- [none]"]
    lines += ["", "## Media logged"] + ([f"- {m}" for m in media] or ["- [none]"])
    lines += [
        "",
        "## Caption draft",
        f"Day {last_day}/30 of building a pixel RPG with an AI dev team 🛠️",
        "",
        "[2–3 lines: what you can see in the post, one honest AI lesson]",
        "",
        "Built with Claude Code, GPT and GLM agents, art with SpriteCook + PixelLab. Every line reviewed by a human 🦊",
        "",
        "#indiedev #gamedev #buildinpublic #pixelart #godot #devlog #aigamedev",
    ]
    OUT.mkdir(parents=True, exist_ok=True)
    out = OUT / f"{a.start}_{a.end}.md"
    out.write_text("\n".join(lines) + "\n", encoding="utf-8")
    print(out.relative_to(ROOT))


if __name__ == "__main__":
    main()
