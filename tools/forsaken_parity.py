"""Bring object-data changes made in the Forsaken (Reforged equipment) line into the normal map.

    python tools/forsaken_parity.py BASE OUT

Run on a base that does not have them yet; running it again changes nothing.
* House portals (A0P3 hero, A04J Spirit of Gaya) take 3 seconds to cast instead of 6 (Forsaken DY).
* The Shrine of Individuality shows Reset Talents bottom-left and the Legendary Bonus Menu
  bottom-right (Forsaken DZ).
* Every equipment item, and the Armory entries that show it, names its slot under the required
  level, e.g. "Slot: Helm" (Forsaken BL). The slot is the backpack's own (src GearSlots.j), which
  is the same classification the Forsaken equipment used.
Reforged reads display text from war3mapSkin.*, so text goes there as well; the 1.29.2 conversion
puts it back inline.
"""
import argparse
import json
import re
from pathlib import Path

from mpq import MPQ, write_files
from objdata import read_objects, write_objects, fields
from talents_catalog import setf

ROOT = Path(__file__).resolve().parents[1]
GEAR_SLOTS = ROOT / 'src/triggers/05 Items crafting and shops/GearSlots.j'
HINTS = ROOT / 'src/armory-hints.json'
LABELS = dict(PRIMARY='Weapon', OFFHAND='Offhand', HEAD='Helm', CHEST='Chest', GLOVES='Gloves',
              BOOTS='Boots', RING='Ring', TRINKET='Trinket')
SLOT_PREFIX = '|cffffcc00Slot|r: '
PORTALS = {
    # ability: (field, text shown in its tooltip)
    'A0P3': ('Hmt2', 'Teleports the Hero and any of your nearby units to a target House. Requires 3 seconds to cast.'),
    'A04J': ('acas', 'Teleports the Spirit of Gaya and any of your nearby troops to a target house.|n'
                     'Takes 3 seconds to cast and has 90 seconds cooldown.'),
}
SHRINE = {'nTRt': 0, 'n0KL': 3}  # button column on the bottom row (ubpy 2)


def slot_tooltip(tooltip, label):
    """Insert the slot line after the required-level line, or at the end."""
    if SLOT_PREFIX in tooltip:
        return tooltip
    line = SLOT_PREFIX + label
    lines = tooltip.split('|n')
    for index, text in enumerate(lines):
        plain = re.sub(r'\|c[0-9a-fA-F]{8}|\|r', '', text)
        if re.search(r'required level|level requirement', plain, re.I):
            lines.insert(index + 1, line)
            return '|n'.join(lines)
    return tooltip + ('|n' if tooltip else '') + line


def by_id(table):
    return {o['id'] or o['base']: o for group in ('original', 'custom') for o in table[group]}


def gear_slots():
    text = GEAR_SLOTS.read_text(encoding='utf-8')
    found = dict(re.findall(r"SaveInteger\(GearSlotTable,1,'(\w{4})',GEAR_(\w+)\)", text))
    if len(found) < 200:
        raise ValueError('GearSlots.j has an unexpected layout')
    return {raw: LABELS[kind] for raw, kind in found.items()}


def prepare(archive):
    files = {}
    tables = {}
    for name, ext in [('war3map.w3a', 'w3a'), ('war3mapSkin.w3a', 'w3a'), ('war3map.w3u', 'w3u'),
                      ('war3mapSkin.w3u', 'w3u'), ('war3map.w3t', 'w3t'), ('war3mapSkin.w3t', 'w3t')]:
        data = archive.read(name)
        if data:
            tables[name] = (read_objects(data, ext), ext)

    abilities = by_id(tables['war3map.w3a'][0])
    skin_abilities = by_id(tables['war3mapSkin.w3a'][0]) if 'war3mapSkin.w3a' in tables else {}
    for raw, (field, text) in PORTALS.items():
        setf(abilities[raw], field, 2, 3., 1, 2 if field == 'Hmt2' else 0)
        target = skin_abilities.get(raw, abilities[raw])
        setf(target, 'aub1', 3, text, 1)

    for name in ('war3map.w3u', 'war3mapSkin.w3u'):
        if name in tables:
            units = by_id(tables[name][0])
            for raw, column in SHRINE.items():
                if raw in units:
                    setf(units[raw], 'ubpx', 0, column)
                    setf(units[raw], 'ubpy', 0, 2)

    slots = gear_slots()
    hints = json.loads(HINTS.read_text(encoding='utf-8'))
    shown = {}
    for index, entry in hints.items():
        if entry['item'] in slots:
            for unit in (entry['unit'], 'z%03d' % int(index)):
                shown[unit] = slots[entry['item']]
    for plain, skin, wanted in [('war3map.w3t', 'war3mapSkin.w3t', slots), ('war3map.w3u', 'war3mapSkin.w3u', shown)]:
        objects = by_id(tables[plain][0])
        skin_objects = by_id(tables[skin][0]) if skin in tables else {}
        for raw, label in wanted.items():
            if raw not in objects:
                continue
            tooltip = fields(objects[raw]).get('utub', '')
            if tooltip.startswith('TRIGSTR_'):
                raise ValueError('unresolved tooltip: ' + raw)
            text = slot_tooltip(tooltip, label)
            setf(objects[raw], 'utub', 3, text)
            if raw in skin_objects:
                setf(skin_objects[raw], 'utub', 3, text)

    for name, (table, ext) in tables.items():
        files[name] = write_objects(table, table['version'], ext)
    return files


def main():
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument('base', type=Path)
    parser.add_argument('out', type=Path)
    args = parser.parse_args()
    if args.out.exists():
        parser.error('Output already exists; choose a new path.')
    files = prepare(MPQ(str(args.base)))
    args.out.parent.mkdir(parents=True, exist_ok=True)
    write_files(str(args.base), str(args.out), files)
    print('Forsaken parity: 3-second house portals, shrine buttons, slot lines on equipment and Armory entries.')


if __name__ == '__main__':
    main()
