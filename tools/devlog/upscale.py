#!/usr/bin/env python3
"""Pixel-perfect upscale for Instagram: nearest-neighbour at an integer scale,
centred on a 1080x1350 (4:5) background. Never blurs pixel art.

usage: tools/devlog/upscale.py IN.png [OUT.png] [--bg #15131F] [--fill 0.7]
  --fill  how much of the frame width the art may take (0-1), default 0.7
"""
import argparse
from pathlib import Path
from PIL import Image

W, H = 1080, 1350


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("src")
    ap.add_argument("dst", nargs="?")
    ap.add_argument("--bg", default="#15131F")
    ap.add_argument("--fill", type=float, default=0.7)
    a = ap.parse_args()
    img = Image.open(a.src).convert("RGBA")
    scale = max(1, int(min(W * a.fill / img.width, H * a.fill / img.height)))
    big = img.resize((img.width * scale, img.height * scale), Image.NEAREST)
    canvas = Image.new("RGBA", (W, H), a.bg)
    canvas.alpha_composite(big, ((W - big.width) // 2, (H - big.height) // 2))
    dst = Path(a.dst) if a.dst else Path(a.src).with_name(Path(a.src).stem + f"_ig_x{scale}.png")
    canvas.convert("RGB").save(dst)
    print(f"{dst} (x{scale})")


if __name__ == "__main__":
    main()
