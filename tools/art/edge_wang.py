"""Edge-Wang variation tiles, following SpriteCook's "Wang tiles explained" method.

1. One seamless source texture of a single terrain (here: moss base + scattered decor, wrapped).
2. Two source spots for horizontal edge colours (top/bottom), two for vertical (left/right).
   An edge patch is centred ON the seam, so the tile above takes the patch's upper half and
   the tile below its lower half -> the same grass continues across the seam.
3. Every tile gets its own middle from a different spot (the variety).
4. Each edge triangle is joined to the middle along the lowest-colour-difference path
   inside that triangle (dynamic programming), so seams follow the art, not straight lines.
5. index = top + 2*right + 4*bottom + 8*left ; atlas col = i % 4, row = i // 4.
6. Map: random 0/1 per horizontal edge ((rows+1) x cols) and per vertical edge (rows x (cols+1)).
"""
import sys, random
import numpy as np
from PIL import Image

T = 24
H = T // 2
NOWRAP = False
BUSY = 60
DMIN = 2            # at least a 2 px border always comes from the edge patch


def window(src, x, y):
    """24x24 window of a wrapping source starting at (x, y)."""
    s = np.roll(np.roll(src, -y, axis=0), -x, axis=1)
    return s[:T, :T].copy()


def seam_mask_top(edge, mid):
    """Mask (True = take edge pixel) for the TOP triangle, min-cost seam."""
    diff = np.abs(edge[..., :3].astype(int) - mid[..., :3].astype(int)).sum(-1)
    INF = 10**9
    dmax = [max(DMIN, min(x + 1, T - x, H)) for x in range(T)]
    # cost of putting the boundary at depth d in column x = diff at the first middle row
    cost = np.full((T, H + 1), INF)
    for x in range(T):
        for d in range(DMIN, dmax[x] + 1):
            cost[x, d] = diff[min(d, T - 1), x] + diff[max(d - 1, 0), x]
    acc = cost.copy(); back = np.zeros((T, H + 1), int)
    for x in range(1, T):
        for d in range(DMIN, dmax[x] + 1):
            best, arg = INF, d
            for pd in (d - 1, d, d + 1):
                if DMIN <= pd <= H and acc[x - 1, pd] < best:
                    best, arg = acc[x - 1, pd], pd
            acc[x, d] = cost[x, d] + best; back[x, d] = arg
    d = int(np.argmin(acc[T - 1])); depth = [0] * T
    for x in range(T - 1, -1, -1):
        depth[x] = d; d = back[x, d]
    m = np.zeros((T, T), bool)
    for x in range(T):
        m[:depth[x], x] = True
    return m


def apply_edge(tile, edge, k):
    """k = number of 90deg CCW rotations that bring this edge to the top."""
    t = np.rot90(tile, k); e = np.rot90(edge, k)
    m = seam_mask_top(e, t)
    t = t.copy(); t[m] = e[m]
    return np.rot90(t, -k)


def build(src_img, out_prefix, seed=7):
    src = np.array(src_img.convert('RGBA'))
    S = src.shape[0]
    cols, counts = np.unique(src.reshape(-1, 4), axis=0, return_counts=True)
    base = cols[counts.argmax()]                     # most common colour = ground base
    busy = (np.abs(src[..., :3].astype(int) - base[:3]).sum(-1) > BUSY)   # anything clearly off the base colour

    def decor(x, y):
        return int(window(busy[..., None].astype(np.int32), x, y).sum())

    rng = random.Random(seed)
    lo, hi = (H, S - T - H) if NOWRAP else (0, S)      # NOWRAP: never cut across the texture border
    cands = [(x, y) for x in range(lo, hi, 2) for y in range(lo, hi, 2)]
    scored = sorted(cands, key=lambda p: decor(*p))
    plain = [p for p in scored if decor(*p) == 0] or scored[:20]
    hspots = rng.sample(plain, 2); vspots = rng.sample([p for p in plain if p not in hspots], 2)
    # middles: prefer windows whose detail stays clear of the border, then the richest interiors
    def border_busy(x, y):
        w = window(busy[..., None].astype(np.int32), x, y)[..., 0]
        return int(w[:3].sum() + w[-3:].sum() + w[:, :3].sum() + w[:, -3:].sum())
    def far(p, qs, d=14): return all(abs(p[0]-q[0]) + abs(p[1]-q[1]) > d for q in qs)
    ranked = sorted(cands, key=lambda p: border_busy(*p) * 10 - decor(*p))
    mids = []
    for p in ranked:
        if decor(*p) > 0 and far(p, mids): mids.append(p)
        if len(mids) == 10: break
    for p in sorted(cands, key=lambda p: decor(*p)):     # 6 quiet middles
        if len(mids) == 16: break
        if far(p, mids): mids.append(p)
    print('middles found', len(mids), 'border px', [border_busy(*p) for p in mids])
    rng.shuffle(mids)
    print('middles found', len(mids))

    tiles = {}
    for i in range(16):
        top, right, bottom, left = i & 1, (i >> 1) & 1, (i >> 2) & 1, (i >> 3) & 1
        tile = window(src, *mids[i])
        hx, hy = hspots[top];    tile = apply_edge(tile, window(src, hx, (hy + H) % S), 0)
        hx, hy = hspots[bottom]; tile = apply_edge(tile, window(src, hx, (hy - H) % S), 2)
        vx, vy = vspots[left];   tile = apply_edge(tile, window(src, (vx + H) % S, vy), 3)
        vx, vy = vspots[right];  tile = apply_edge(tile, window(src, (vx - H) % S, vy), 1)
        tiles[i] = tile

    sheet = np.zeros((4 * T, 4 * T, 4), np.uint8)
    for i, t in tiles.items():
        sheet[(i // 4) * T:(i // 4 + 1) * T, (i % 4) * T:(i % 4 + 1) * T] = t
    Image.fromarray(sheet).save(out_prefix + '_sheet.png')
    return tiles


def render_map(tiles, cols, rows, seed=3):
    rng = random.Random(seed)
    hz = [[rng.randint(0, 1) for _ in range(cols)] for _ in range(rows + 1)]
    vt = [[rng.randint(0, 1) for _ in range(cols + 1)] for _ in range(rows)]
    out = np.zeros((rows * T, cols * T, 4), np.uint8)
    for r in range(rows):
        for c in range(cols):
            i = hz[r][c] + 2 * vt[r][c + 1] + 4 * hz[r + 1][c] + 8 * vt[r][c]
            out[r * T:(r + 1) * T, c * T:(c + 1) * T] = tiles[i]
    return Image.fromarray(out)


if __name__ == '__main__':
    src = Image.open(sys.argv[1])
    tiles = build(src, sys.argv[2])
    render_map(tiles, 9, 16).save(sys.argv[2] + '_map.png')
