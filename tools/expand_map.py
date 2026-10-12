"""Grow a map's terrain grid, keeping the existing land in one corner.

The old terrain keeps its exact world coordinates, so every unit, doodad, region
and camera in the map stays where it was: the new land is added to the east and
north instead of the map growing outwards from its centre.

    python tools/expand_map.py release/<map>.w3x release/<bigger>.w3x --size 480

Each new quarter is filled with starter terrain: a handful of segmented regions with
their own ground textures, and two flat town sites, so there is a shape to react to
and reshape in World Editor rather than an empty plane.
"""
import argparse, math, struct, sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from mpq import MPQ, replace_files

TILE = 128  # world units per terrain tile
POINT = 8   # bytes per tilepoint in w3e version 12


def read_w3e(data):
    """Return (header length, grid width, grid height, offsets) for a w3e file."""
    if data[:4] != b'W3E!':
        raise ValueError('not a w3e file')
    off = 8 + 1 + 4  # version, tileset character, custom-tileset flag
    ground = struct.unpack_from('<I', data, off)[0]
    off += 4 + 4 * ground
    cliff = struct.unpack_from('<I', data, off)[0]
    off += 4 + 4 * cliff
    width, height, ox, oy = struct.unpack_from('<IIff', data, off)
    head = off + 16
    if len(data) - head != width * height * POINT:
        raise ValueError('unexpected tilepoint count; this tool expects w3e version 12')
    return head, width, height, ox, oy, ground


# Each new quarter gets its own palette of ground textures, so the three eras read as
# different lands. Water textures are left out: they need a matching water level.
PALETTES = {'east': (3, 4, 0, 7), 'north': (7, 6, 1, 2), 'far': (2, 9, 1, 0)}
CITY_TEXTURE = 0        # packed dirt for the two town sites in each quarter
CITY_RADIUS = 16        # tiles; flat ground inside, so buildings can be placed
REGIONS_PER_QUARTER = 14
BASE_HEIGHT = 0x2000    # the flat base level the editor calls height 0


def quarter_seeds(name, x0, x1, y0, y1):
    """Region centres for one quarter, with the first two marked as city sites.

    The layout is derived from the quarter's own bounds rather than randomly, so
    rebuilding the map twice gives the same land.
    """
    palette = PALETTES[name]
    seeds = []
    for i in range(REGIONS_PER_QUARTER):
        # Two interleaved golden-ratio sequences scatter the centres without clumping.
        fx = (i * 0.618034) % 1.0
        fy = (i * 0.381966 + 0.21) % 1.0
        x = x0 + fx * (x1 - x0)
        y = y0 + fy * (y1 - y0)
        seeds.append((x, y, palette[i % len(palette)], i < 2))
    return seeds


def point_terrain(col, row, seeds):
    """Pick the nearest region centre, then that region's texture and height."""
    best = seeds[0]
    best_d = None
    for seed in seeds:
        d = (col - seed[0]) ** 2 + (row - seed[1]) ** 2
        if best_d is None or d < best_d:
            best, best_d = seed, d
    if best[3] and best_d <= CITY_RADIUS ** 2:
        return CITY_TEXTURE, BASE_HEIGHT  # town sites are flat
    rise = math.sin(col / 23.0) * math.cos(row / 19.0) + 0.5 * math.sin((col + row) / 11.0)
    return best[2], int(BASE_HEIGHT + rise * 90)


def generated_point(reference, texture, height):
    """A new tilepoint: the reference's water and flags, with our texture and height."""
    point = bytearray(reference)
    struct.pack_into('<H', point, 0, height)
    point[4] = texture & 0x0F  # low nibble is the ground texture, high nibble the flags
    point[5] = 0               # no texture variation
    point[6] = 0x20            # no cliff texture, layer height 2 (the flat base level)
    return bytes(point)


def expand_w3e(data, size):
    head, width, height, ox, oy, ground = read_w3e(data)
    new = size + 1
    if new < width or new < height:
        raise ValueError('the new size must be at least as large as the current map')
    # A point well inside the map is the template for water level and the version-12 byte.
    reference = data[head + (height // 2 * width + width // 2) * POINT:][:POINT]
    edge = data[head:][:POINT]  # the map's own corner point, for the new outer border
    out = bytearray(data[:head])
    struct.pack_into('<II', out, head - 16, new, new)
    east = quarter_seeds('east', width, new, 0, height)
    north = quarter_seeds('north', 0, width, height, new)
    far = quarter_seeds('far', width, new, height, new)
    rows = []
    for row in range(new):
        if row < height:
            kept = data[head + row * width * POINT:head + (row + 1) * width * POINT]
        else:
            kept = b''
        made = bytearray()
        for col in range(len(kept) // POINT, new):
            if row == new - 1 or col == new - 1:
                made += edge  # the map's own border point, reused for the new outer edge
                continue
            seeds = far if row >= height and col >= width else north if row >= height else east
            texture, point_height = point_terrain(col, row, seeds)
            made += generated_point(reference, texture, point_height)
        rows.append(kept + bytes(made))
    out += b''.join(rows)
    return bytes(out), width, height, ox, oy


def expand_grid(data, head, old_side, new_side, fill):
    """Rebuild a square per-cell map (pathing, shadows) with the old data in the corner."""
    out = bytearray(data[:head])
    for row in range(new_side):
        if row < old_side:
            start = head + row * old_side
            out += data[start:start + old_side]
            out += bytes([fill]) * (new_side - old_side)
        else:
            out += bytes([fill]) * new_side
    return bytes(out)


def expand_w3i(data, old_tiles, new_tiles, ox, oy):
    """Move the camera bounds out to the new edge, keeping the map's own margins."""
    out = bytearray(data)
    bounds = list(struct.unpack_from('<8f', data, 76))
    old_max_x = ox + old_tiles * TILE
    old_max_y = oy + old_tiles * TILE
    new_max_x = ox + new_tiles * TILE
    new_max_y = oy + new_tiles * TILE
    for i in range(0, 8, 2):
        # Only the far edges move; the near edges keep their original inset.
        if bounds[i] > (ox + old_max_x) / 2:
            bounds[i] += new_max_x - old_max_x
        if bounds[i + 1] > (oy + old_max_y) / 2:
            bounds[i + 1] += new_max_y - old_max_y
    struct.pack_into('<8f', out, 76, *bounds)
    playable_w, playable_h = struct.unpack_from('<2i', data, 124)
    struct.pack_into('<2i', out, 124,
                     playable_w + new_tiles - old_tiles, playable_h + new_tiles - old_tiles)
    return bytes(out), bounds


def main():
    p = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    p.add_argument('source')
    p.add_argument('output')
    p.add_argument('--size', type=int, default=480, help='new playable size in tiles (max 480)')
    a = p.parse_args()
    if not 32 <= a.size <= 480:
        p.error('size must be between 32 and 480 tiles')

    src = MPQ(a.source)
    w3e, old_width, old_height, ox, oy = expand_w3e(src.read('war3map.w3e'), a.size)
    if old_width != old_height:
        raise ValueError('this tool expects a square map')
    old_tiles, new_tiles = old_width - 1, a.size

    wpm = src.read('war3map.wpm')
    magic, version, cells_w, cells_h = struct.unpack_from('<4sIII', wpm, 0)
    if magic != b'MP3W' or cells_w != cells_h:
        raise ValueError('unexpected pathing map')
    per_tile = cells_w // old_tiles  # pathing cells across one terrain tile
    new_cells = new_tiles * per_tile
    ground = max(set(wpm[16:]), key=wpm[16:].count)  # the map's own "ordinary ground" value
    wpm_out = bytearray(wpm[:16])
    struct.pack_into('<II', wpm_out, 8, new_cells, new_cells)
    wpm_out = expand_grid(bytes(wpm_out) + wpm[16:], 16, cells_w, new_cells, ground)

    shd = src.read('war3map.shd')
    shd_side = int(round(len(shd) ** 0.5))
    if shd_side * shd_side != len(shd):
        raise ValueError('unexpected shadow map')
    shd_out = expand_grid(shd, 0, shd_side, shd_side * new_tiles // old_tiles, 0)

    w3i, bounds = expand_w3i(src.read('war3map.w3i'), old_tiles, new_tiles, ox, oy)

    replace_files(a.source, a.output, {'war3map.w3e': w3e, 'war3map.wpm': wpm_out,
                                       'war3map.shd': shd_out, 'war3map.w3i': w3i})
    print(f'{old_tiles}x{old_tiles} -> {new_tiles}x{new_tiles} tiles, existing land kept at the '
          f'south-west corner ({ox:.0f}, {oy:.0f})')
    print(f'camera bounds now {bounds[0]:.0f},{bounds[1]:.0f} to {bounds[2]:.0f},{bounds[3]:.0f}')
    print('EXPANDED MAP:', a.output)


if __name__ == '__main__':
    main()
