"""Grow a map's terrain grid, keeping the existing land where it already is.

Warcraft places a map's terrain symmetrically around the world origin, so a 480x480
map runs from -30720 to 30720. The existing land therefore cannot simply be extended
eastwards: that pushes its far edge outside the world box and the editor refuses the
map. Instead the new grid is centred on the origin and the old terrain is placed at
the offset that leaves every existing world coordinate untouched, so units, doodads,
regions and cameras all stay exactly where they were.

    python tools/expand_map.py release/<map>.w3x release/<bigger>.w3x --size 480

The new land is filled with starter terrain: segmented regions with their own ground
textures and two flat town sites per area, as something to reshape in World Editor.
"""
import argparse, math, struct, sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from mpq import MPQ, replace_files

TILE = 128   # world units per terrain tile
POINT = 8    # bytes per tilepoint in w3e version 12

# Each new area gets its own palette of ground texture indexes, so the eras read as
# different lands. Water textures are left out: they need a matching water level.
PALETTES = {'west': (3, 4, 0, 7), 'north': (7, 6, 1, 2), 'rest': (2, 9, 1, 0)}
CITY_TEXTURE = 0        # packed dirt for the two town sites in each area
CITY_RADIUS = 16        # tiles; flat ground inside, so buildings can be placed
REGIONS_PER_AREA = 14
BASE_HEIGHT = 0x2000    # the flat base level the editor calls height 0


def read_w3e(data):
    """Return (header length, grid width, grid height, world offsets) for a w3e file."""
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
    return head, width, height, ox, oy


def placement(old_tiles, new_tiles, ox, oy):
    """Where the old terrain sits in the new grid, keeping its world coordinates.

    The new map is centred on the origin, so the padding on each side follows from
    where the old terrain already was.
    """
    origin = -(new_tiles * TILE) / 2.0
    pad_x = (ox - origin) / TILE
    pad_y = (oy - origin) / TILE
    if pad_x != int(pad_x) or pad_y != int(pad_y):
        raise ValueError('the old terrain does not land on a tile boundary of the new grid')
    pad_x, pad_y = int(pad_x), int(pad_y)
    if pad_x < 0 or pad_y < 0 or pad_x + old_tiles > new_tiles or pad_y + old_tiles > new_tiles:
        raise ValueError('the existing land does not fit inside a %dx%d world; it spans '
                         'x %.0f..%.0f, y %.0f..%.0f and the world box is +/-%.0f'
                         % (new_tiles, new_tiles, ox, ox + old_tiles * TILE,
                            oy, oy + old_tiles * TILE, -origin))
    return pad_x, pad_y, origin


def area_seeds(name, x0, x1, y0, y1):
    """Region centres for one area, with the first two marked as city sites.

    The layout comes from the area's own bounds rather than randomly, so rebuilding
    the map twice gives the same land.
    """
    palette = PALETTES[name]
    seeds = []
    for i in range(REGIONS_PER_AREA):
        # Two interleaved golden-ratio sequences scatter the centres without clumping.
        fx = (i * 0.618034) % 1.0
        fy = (i * 0.381966 + 0.21) % 1.0
        seeds.append((x0 + fx * (x1 - x0), y0 + fy * (y1 - y0), palette[i % len(palette)], i < 2))
    return seeds


def point_terrain(col, row, seeds):
    """Pick the nearest region centre, then that region's texture and height."""
    best, best_d = seeds[0], None
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


def expand_w3e(data, new_tiles):
    head, width, height, ox, oy = read_w3e(data)
    if width != height:
        raise ValueError('this tool expects a square map')
    old_tiles = width - 1
    pad_x, pad_y, origin = placement(old_tiles, new_tiles, ox, oy)
    new = new_tiles + 1
    reference = data[head + (height // 2 * width + width // 2) * POINT:][:POINT]
    out = bytearray(data[:head])
    struct.pack_into('<IIff', out, head - 16, new, new, origin, origin)

    top = pad_y + height  # first row above the old terrain
    west = area_seeds('west', 0, pad_x, 0, top)
    north = area_seeds('north', 0, new, top, new)
    rest = area_seeds('rest', pad_x, new, 0, top)
    rows = []
    for row in range(new):
        inside_rows = pad_y <= row < top
        made = bytearray()
        for col in range(new):
            if inside_rows and pad_x <= col < pad_x + width:
                source = head + ((row - pad_y) * width + (col - pad_x)) * POINT
                made += data[source:source + POINT]
                continue
            seeds = north if row >= top else west if col < pad_x else rest
            texture, point_height = point_terrain(col, row, seeds)
            made += generated_point(reference, texture, point_height)
        rows.append(bytes(made))
    out += b''.join(rows)
    return bytes(out), old_tiles, ox, oy, pad_x, pad_y, origin


def place_grid(data, head, old_side, new_side, pad_x, pad_y, fill):
    """Rebuild a square per-cell map (pathing, shadows) with the old data at its offset."""
    out = bytearray(data[:head])
    blank = bytes([fill])
    for row in range(new_side):
        if pad_y <= row < pad_y + old_side:
            start = head + (row - pad_y) * old_side
            out += blank * pad_x + data[start:start + old_side] + blank * (new_side - pad_x - old_side)
        else:
            out += blank * new_side
    return bytes(out)


def expand_w3i(data, old_tiles, new_tiles, ox, oy, origin):
    """Move the camera bounds out to the new edge, keeping the map's own margins."""
    out = bytearray(data)
    bounds = list(struct.unpack_from('<8f', data, 76))
    old_min_x, old_max_x = ox, ox + old_tiles * TILE
    old_min_y, old_max_y = oy, oy + old_tiles * TILE
    new_min, new_max = origin, -origin
    for i in range(0, 8, 2):
        # Each corner keeps the inset it had from its own edge of the old map.
        x, y = bounds[i], bounds[i + 1]
        bounds[i] = new_min + (x - old_min_x) if x - old_min_x < old_max_x - x else new_max - (old_max_x - x)
        bounds[i + 1] = new_min + (y - old_min_y) if y - old_min_y < old_max_y - y else new_max - (old_max_y - y)
    struct.pack_into('<8f', out, 76, *bounds)
    playable_w, playable_h = struct.unpack_from('<2i', data, 124)
    struct.pack_into('<2i', out, 124, playable_w + new_tiles - old_tiles,
                     playable_h + new_tiles - old_tiles)
    return bytes(out), bounds


def main():
    p = argparse.ArgumentParser(description=__doc__,
                                formatter_class=argparse.RawDescriptionHelpFormatter)
    p.add_argument('source')
    p.add_argument('output')
    p.add_argument('--size', type=int, default=480, help='new size in tiles (max 480)')
    a = p.parse_args()
    if not 32 <= a.size <= 480:
        p.error('size must be between 32 and 480 tiles')

    src = MPQ(a.source)
    w3e, old_tiles, ox, oy, pad_x, pad_y, origin = expand_w3e(src.read('war3map.w3e'), a.size)

    wpm = src.read('war3map.wpm')
    magic, version, cells_w, cells_h = struct.unpack_from('<4sIII', wpm, 0)
    if magic != b'MP3W' or cells_w != cells_h:
        raise ValueError('unexpected pathing map')
    per_tile = cells_w // old_tiles  # pathing cells across one terrain tile
    ground = max(set(wpm[16:]), key=wpm[16:].count)  # the map's own "ordinary ground" value
    header = bytearray(wpm[:16])
    struct.pack_into('<II', header, 8, a.size * per_tile, a.size * per_tile)
    wpm_out = place_grid(bytes(header) + wpm[16:], 16, cells_w, a.size * per_tile,
                         pad_x * per_tile, pad_y * per_tile, ground)

    shd = src.read('war3map.shd')
    shd_side = int(round(len(shd) ** 0.5))
    if shd_side * shd_side != len(shd):
        raise ValueError('unexpected shadow map')
    shd_per_tile = shd_side // old_tiles
    shd_out = place_grid(shd, 0, shd_side, a.size * shd_per_tile,
                         pad_x * shd_per_tile, pad_y * shd_per_tile, 0)

    w3i, bounds = expand_w3i(src.read('war3map.w3i'), old_tiles, a.size, ox, oy, origin)

    replace_files(a.source, a.output, {'war3map.w3e': w3e, 'war3map.wpm': wpm_out,
                                       'war3map.shd': shd_out, 'war3map.w3i': w3i})
    print(f'{old_tiles}x{old_tiles} -> {a.size}x{a.size} tiles; world box now '
          f'{origin:.0f}..{-origin:.0f} on both axes')
    print(f'existing land kept at tile ({pad_x}, {pad_y}), world x {ox:.0f}..'
          f'{ox + old_tiles * TILE:.0f}, y {oy:.0f}..{oy + old_tiles * TILE:.0f} (unchanged)')
    print(f'camera bounds {bounds[0]:.0f},{bounds[1]:.0f} to {bounds[2]:.0f},{bounds[3]:.0f}')
    print('EXPANDED MAP:', a.output)


if __name__ == '__main__':
    main()
