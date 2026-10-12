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

# Tilepoint layout in version 12. The cliff/layer byte moved to the end of the record:
# 0-1 ground height, 2-3 water level, 4 flags+ground texture, 5 texture details,
# 6 an added version-12 byte, 7 cliff texture (high nibble) and cliff layer (low nibble).
CLIFF_NONE = 0xF     # "no cliff face here", the value flat ground uses
BASE_LAYER = 2       # the cliff layer the existing land sits on

# Each new area gets its own palette of ground texture indexes, so the eras read as
# different lands. Water textures are left out: they need a matching water level.
# Region kinds per area: ground texture, cliff layer, whether it floods, and the
# doodads scattered through it with their relative weights. Mixed palettes and uneven
# weights are what stop generated land reading as a single flat field.
TREES_GREEN = ((b'LTlt', 6), (b'ATtr', 4), (b'ZTtw', 2), (b'YTpc', 2), (b'ZPsh', 3), (b'ZPfw', 2))
TREES_DARK = ((b'ATtr', 6), (b'ITtw', 3), (b'YTpb', 2), (b'ZPsh', 2), (b'LTrc', 1))
ROCKS_BARREN = ((b'LRrk', 5), (b'IRrs', 4), (b'WTst', 3), (b'YTct', 2), (b'APms', 2), (b'DOlc', 2))
ROCKS_HIGH = ((b'IRrs', 5), (b'LRrk', 3), (b'AObd', 3), (b'YOtf', 2), (b'LPrs', 2))
SCRUB = ((b'ZPfw', 5), (b'ZPsh', 4), (b'YTfc', 3), (b'LPwh', 2), (b'ZPms', 2), (b'CPlp', 1))

# (texture, cliff layer, floods, doodads, density) - density is doodads per 100 tiles.
REGIONS = {
    'west': (
        (3, 3, False, TREES_GREEN, 46), (4, 5, False, TREES_DARK, 52),
        (3, 1, False, SCRUB, 18), (0, 2, True, SCRUB, 10),
        (7, 4, False, TREES_GREEN, 38), (0, 0, False, ROCKS_BARREN, 22),
    ),
    'north': (
        (7, 4, False, TREES_DARK, 50), (6, 6, False, ROCKS_HIGH, 30),
        (1, 2, False, ROCKS_BARREN, 26), (2, 5, False, ROCKS_HIGH, 34),
        (7, 1, True, SCRUB, 10), (6, 3, False, TREES_GREEN, 44),
    ),
    'rest': (
        (2, 4, False, ROCKS_HIGH, 32), (9, 6, False, ROCKS_BARREN, 24),
        (1, 2, False, SCRUB, 16), (0, 1, True, SCRUB, 8),
        (2, 3, False, TREES_DARK, 40), (9, 5, False, ROCKS_HIGH, 28),
    ),
}
CITY_TEXTURE = 0        # packed dirt for the two town sites in each area
CITY_RADIUS = 23        # tiles; flat ground inside, so buildings can be placed
BASE_HEIGHT = 0x2000    # the flat base level the editor calls height 0
WATER_LEVEL = 0x2000    # the map's own water level
WATER_FLAG = 0x4        # the tilepoint flag that floods a point
LAKE_FLOOR = 0x1D00     # ground height under water, so lakes have depth
HEIGHT_SWING = 620      # how far rolling ground moves either side of the base


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


def warp(col, row):
    """Bend coordinates before measuring region distance, so borders meander."""
    return (col + 17.0 * math.sin(row / 16.0) + 8.0 * math.sin(row / 5.5),
            row + 17.0 * math.cos(col / 18.0) + 8.0 * math.cos(col / 6.5))


def noise(col, row, scale, phase=0.0):
    """A cheap smooth field in roughly -1..1."""
    return (math.sin(col / scale + phase) * math.cos(row / (scale * 0.87) + phase)
            + 0.5 * math.sin((col + row) / (scale * 0.5) + phase))


def area_seeds(name, x0, x1, y0, y1):
    """Region centres on a jittered grid, so regions are patches rather than bands."""
    kinds = REGIONS[name]
    width, height = max(x1 - x0, 1), max(y1 - y0, 1)
    columns = max(2, int(round(math.sqrt(len(kinds) * 2.2 * width / height))))
    rows = max(2, int(round(len(kinds) * 2.2 / columns)))
    seeds = []
    for index in range(columns * rows):
        gx, gy = index % columns, index // columns
        # Jitter each grid cell by a fixed fraction, keeping the layout repeatable.
        jx = 0.5 + 0.34 * math.sin(index * 2.399)
        jy = 0.5 + 0.34 * math.cos(index * 1.618)
        x = x0 + (gx + jx) * width / columns
        y = y0 + (gy + jy) * height / rows
        texture, layer, floods, doodads, density = kinds[(gx * 3 + gy * 5 + index) % len(kinds)]
        city = index in (1, columns * rows - 2)
        seeds.append(dict(x=x, y=y, texture=CITY_TEXTURE if city else texture,
                          layer=2 if city else layer, floods=False if city else floods,
                          doodads=() if city else doodads,
                          density=0 if city else density, city=city))
    return seeds


def nearest_region(col, row, seeds):
    wx, wy = warp(col, row)
    best, best_d = seeds[0], None
    for seed in seeds:
        d = (wx - seed['x']) ** 2 + (wy - seed['y']) ** 2
        if best_d is None or d < best_d:
            best, best_d = seed, d
    return best, best_d


def point_terrain(col, row, seeds):
    """Texture, cliff layer, ground height and flags for one new tilepoint."""
    seed, distance = nearest_region(col, row, seeds)
    if seed['city'] and distance <= CITY_RADIUS ** 2:
        return CITY_TEXTURE, 2, BASE_HEIGHT, 0   # town sites are flat and unflooded
    rolling = noise(col, row, 34.0) + 0.5 * noise(col, row, 11.0, 1.7)
    height = int(BASE_HEIGHT + rolling * HEIGHT_SWING)
    if seed['floods']:
        # Lakes keep their high ground as islands; everything lower floods.
        if rolling < 0.35:
            return seed['texture'], 1, LAKE_FLOOR + int(rolling * 60), WATER_FLAG
        return seed['texture'], 2, BASE_HEIGHT + int(rolling * 180), 0
    return seed['texture'], seed['layer'], height, 0


def generated_point(reference, texture, layer, height, cliff, flags):
    """A new tilepoint: the map's water level, with our own surface."""
    point = bytearray(reference)
    struct.pack_into('<H', point, 0, height)
    struct.pack_into('<H', point, 2, WATER_LEVEL)
    point[4] = ((flags & 0xF) << 4) | (texture & 0x0F)
    point[5] = 0               # no texture variation
    point[6] = 0               # the added version-12 byte
    point[7] = ((cliff & 0xF) << 4) | (layer & 0xF)
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
    areas = {'west': area_seeds('west', 0, pad_x, 0, top),
             'north': area_seeds('north', 0, new, top, new),
             'rest': area_seeds('rest', pad_x, new, 0, top)}

    def seeds_for(col, row):
        return areas['north'] if row >= top else areas['west'] if col < pad_x else areas['rest']

    # First pass: work out every new point's surface. Cliff faces need to know their
    # neighbours' layers, so the layers have to exist before the bytes are written.
    kept = lambda c, r: pad_y <= r < top and pad_x <= c < pad_x + width
    surface, area_of = {}, {}
    for row in range(new):
        for col in range(new):
            if not kept(col, row):
                name = 'north' if row >= top else 'west' if col < pad_x else 'rest'
                surface[(col, row)] = point_terrain(col, row, areas[name])
                area_of[(col, row)] = name

    def layer_at(col, row):
        if (col, row) in surface:
            return surface[(col, row)][1]
        if kept(col, row):
            return data[head + ((row - pad_y) * width + (col - pad_x)) * POINT + 7] & 0xF
        return None

    out_rows = []
    for row in range(new):
        made = bytearray()
        for col in range(new):
            if kept(col, row):
                source = head + ((row - pad_y) * width + (col - pad_x)) * POINT
                made += data[source:source + POINT]
                continue
            texture, layer, point_height, flags = surface[(col, row)]
            neighbours = [layer_at(col + dx, row + dy)
                          for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1))]
            cliff = 0 if any(n is not None and n != layer for n in neighbours) else CLIFF_NONE
            made += generated_point(reference, texture, layer, point_height, cliff, flags)
        out_rows.append(bytes(made))
    out += b''.join(out_rows)
    return bytes(out), old_tiles, ox, oy, pad_x, pad_y, origin, areas, surface, area_of


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


DOODAD_ENTRY = 74        # bytes in an ordinary doodad record (no item sets, no Reforged block)
NEW_EDITOR_ID = 20000    # editor ids for generated doodads start well past the existing ones
# New towns are stamped from a village that already exists on the map, so they are laid
# out in its style instead of from invented building lists.
TOWN_SOURCE = (21504.0, -23552.0)
TOWN_RADIUS = 2600.0


def town_template(data, centre, radius):
    """Every doodad around an existing village, as offsets from its centre."""
    count = struct.unpack_from('<i', data, 12)[0]
    off, parts = 16, []
    for _ in range(count):
        start = off
        x, y = struct.unpack_from('<2f', data, off + 8)
        off += 36 + 8 + 6
        sets = struct.unpack_from('<i', data, off)[0]
        off += 4
        for _ in range(sets):
            off += 4 + 8 * struct.unpack_from('<i', data, off)[0]
        off += 4 + 4
        off += 12 + 36 * struct.unpack_from('<i', data, off + 8)[0]
        if off - start == DOODAD_ENTRY and abs(x - centre[0]) < radius and abs(y - centre[1]) < radius:
            parts.append((x - centre[0], y - centre[1], data[start:off]))
    return parts


def stamp_town(template, world_x, world_y, angle, surface, origin, editor_id, out):
    """Copy a village template to a new place, turned by angle."""
    cos, sin = math.cos(angle), math.sin(angle)
    placed = 0
    for dx, dy, raw in template:
        x = world_x + dx * cos - dy * sin
        y = world_y + dx * sin + dy * cos
        key = (int((x - origin) / TILE), int((y - origin) / TILE))
        if key not in surface or surface[key][3] & WATER_FLAG:
            continue  # stays on generated, dry land
        entry = bytearray(raw)
        struct.pack_into('<2f', entry, 8, x, y)
        struct.pack_into('<f', entry, 20, struct.unpack_from('<f', entry, 20)[0] + angle)
        struct.pack_into('<i', entry, 58, editor_id + placed)
        out += entry
        placed += 1
    return placed


def doodad_templates(data, wanted):
    """One real record per doodad type, to copy rather than build records from scratch."""
    count = struct.unpack_from('<i', data, 12)[0]
    off, found = 16, {}
    for _ in range(count):
        start = off
        kind = data[off:off + 4]
        off += 36 + 8 + 6
        sets = struct.unpack_from('<i', data, off)[0]
        off += 4
        for _ in range(sets):
            off += 4 + 8 * struct.unpack_from('<i', data, off)[0]
        off += 4 + 4
        off += 12 + 36 * struct.unpack_from('<i', data, off + 8)[0]
        if off - start == DOODAD_ENTRY and kind in wanted and kind not in found:
            found[kind] = data[start:off]
    return found, off


def scatter_doodads(data, areas, surface, area_of, origin, density_scale):
    """Fill the generated regions with clumped woodland, rock fields and scrub.

    Doodads are placed by walking the generated land rather than by scattering around
    region centres: that keeps each region's own palette and density, and a clumping
    field opens clearings and lanes between the thickets instead of an even sprinkle.
    """
    wanted = {kind for seeds in areas.values() for seed in seeds for kind, _ in seed['doodads']}
    templates, tail_off = doodad_templates(data, wanted)
    missing = wanted - set(templates)
    if missing:
        raise ValueError('no template in this map for doodad '
                         + ', '.join(m.decode('latin-1') for m in sorted(missing)))
    count = struct.unpack_from('<i', data, 12)[0]
    tail = data[tail_off:]  # the special-doodads section, kept as it is
    made = bytearray()
    editor_id = NEW_EDITOR_ID
    state = 2463534242

    def rnd():
        # A small deterministic generator, so the same map always produces the same land.
        nonlocal state
        state ^= (state << 13) & 0xFFFFFFFF
        state ^= state >> 17
        state ^= (state << 5) & 0xFFFFFFFF
        return state / 0xFFFFFFFF

    towns = town_template(data, TOWN_SOURCE, TOWN_RADIUS)
    town_number = 0
    for seeds in areas.values():
        for seed in seeds:
            if not seed['city']:
                continue
            town_number += 1
            editor_id += stamp_town(towns, origin + seed['x'] * TILE, origin + seed['y'] * TILE,
                                    town_number * 1.1, surface, origin, editor_id, made)

    for (col, row), (_, _, _, flags) in surface.items():
        if flags & WATER_FLAG:
            continue  # nothing stands in the lakes
        seed, _ = nearest_region(col, row, areas[area_of[(col, row)]])
        if not seed['doodads'] or seed['city']:
            continue
        # Thickets and clearings: only the raised part of the clumping field is planted.
        clump = noise(col, row, 9.0, 0.4) + 0.6 * noise(col, row, 3.3, 2.1)
        chance = seed['density'] / 100.0 * max(0.0, clump + 0.55) * density_scale
        if rnd() >= chance:
            continue
        kind = pick_weighted(seed['doodads'], rnd())
        jitter_x = (rnd() - 0.5) * TILE
        jitter_y = (rnd() - 0.5) * TILE
        world_x = min(max(origin + col * TILE + jitter_x, origin + TILE), -origin - TILE)
        world_y = min(max(origin + row * TILE + jitter_y, origin + TILE), -origin - TILE)
        entry = bytearray(templates[kind])
        struct.pack_into('<2f', entry, 8, world_x, world_y)
        struct.pack_into('<f', entry, 20, rnd() * math.tau)
        scale = 0.85 + rnd() * 0.45
        struct.pack_into('<3f', entry, 24, scale, scale, scale)
        struct.pack_into('<i', entry, 58, editor_id)
        editor_id += 1
        made += entry
    out = bytearray(data[:tail_off])
    struct.pack_into('<i', out, 12, count + editor_id - NEW_EDITOR_ID)
    return bytes(out) + bytes(made) + tail, editor_id - NEW_EDITOR_ID


def pick_weighted(choices, roll):
    total = sum(weight for _, weight in choices)
    cut = roll * total
    for kind, weight in choices:
        cut -= weight
        if cut <= 0:
            return kind
    return choices[-1][0]


def main():
    p = argparse.ArgumentParser(description=__doc__,
                                formatter_class=argparse.RawDescriptionHelpFormatter)
    p.add_argument('source')
    p.add_argument('output')
    p.add_argument('--size', type=int, default=480, help='new size in tiles (max 480)')
    p.add_argument('--doodads', type=int, default=100,
                   help='doodad density as a percentage of the regions\' own settings')
    a = p.parse_args()
    if not 32 <= a.size <= 480:
        p.error('size must be between 32 and 480 tiles')

    src = MPQ(a.source)
    (w3e, old_tiles, ox, oy, pad_x, pad_y, origin,
     areas, surface, area_of) = expand_w3e(src.read('war3map.w3e'), a.size)

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

    files = {'war3map.w3e': w3e, 'war3map.wpm': wpm_out, 'war3map.shd': shd_out,
             'war3map.w3i': w3i}
    added = 0
    if a.doodads:
        files['war3map.doo'], added = scatter_doodads(src.read('war3map.doo'), areas, surface,
                                                      area_of, origin, a.doodads / 100.0)
    replace_files(a.source, a.output, files)
    print(f'{old_tiles}x{old_tiles} -> {a.size}x{a.size} tiles; world box now '
          f'{origin:.0f}..{-origin:.0f} on both axes')
    print(f'existing land kept at tile ({pad_x}, {pad_y}), world x {ox:.0f}..'
          f'{ox + old_tiles * TILE:.0f}, y {oy:.0f}..{oy + old_tiles * TILE:.0f} (unchanged)')
    print(f'camera bounds {bounds[0]:.0f},{bounds[1]:.0f} to {bounds[2]:.0f},{bounds[3]:.0f}')
    print(f'{added} doodads scattered through the new regions')
    print('EXPANDED MAP:', a.output)


if __name__ == '__main__':
    main()
