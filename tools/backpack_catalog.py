"""Add the Backpack button (tBag), its Back-to-hero button (tBhr) and the holder unit (tBpk).

    python tools/backpack_catalog.py BASE OUT

1.29.2 has no frame UI and no extended inventory native, so gear lives in holder units: a
holder carries six inventory slots and the player's selection switches to it. The Backpack
ability replaces Talents in the hero's command card slot (0,1), the slot every job hero
leaves empty; Talents moves onto the holder's own card.
"""
import argparse
import copy
from pathlib import Path

from mpq import MPQ, write_files
from objdata import read_objects, write_objects

BACKPACK = 'tBag'
RETURN = 'tBhr'
HOLDER = 'tBpk'
TALENTS = 'tTal'
DUMMY = 'h02S'          # Simple Casting Dummy: already model-less and out of the way
INVENTORY = 'AInv'      # the six-slot unit inventory

BACKPACK_TEXT = ('Opens your gear. Equipment sits in its own pages, so your own six slots stay '
                 'free for potions and books. Use Back to hero to return.')
RETURN_TEXT = 'Returns to your hero.'
# Icons and order strings are taken from ones this map already uses, because an icon path the
# game cannot find draws as a green square and an order string that is not a real no-target
# order leaves the button doing nothing. Each ability on a unit needs its own order.
BACKPACK_ICON = r'ReplaceableTextures\CommandButtons\BTNTomeBrown.blp'
RETURN_ICON = r'ReplaceableTextures\CommandButtons\BTNSelectHeroOn.blp'
BACKPACK_ORDER = 'cannibalize'
RETURN_ORDER = 'avatar'


def setf(obj, field, ftype, value, level=0, data=0):
    mods = obj['sets'][0]['mods']
    mods[:] = [m for m in mods if not (m['field'] == field and m['level'] == level)]
    mods.append(dict(field=field, type=ftype, level=level, data=data, value=value, end=0))


def button(objects, raw, name, hotkey, icon, tip, text, px, py, order):
    """A channel button copied from the Talents one, so it keeps a shape that works."""
    obj = copy.deepcopy(objects[TALENTS])
    obj['id'] = raw
    for field, ftype, value, level in [('anam', 3, name, 0), ('aart', 3, icon, 0), ('ahky', 3, hotkey, 0),
                                       ('abpx', 0, px, 0), ('abpy', 0, py, 0),
                                       ('atp1', 3, tip, 1), ('aub1', 3, text, 1),
                                       ('Ncl6', 3, order, 1)]:
        setf(obj, field, ftype, value, level)
    return obj


def prepare_abilities(table):
    objects = {o['id']: o for o in table['custom']}
    if TALENTS not in objects:
        raise ValueError('the Talents button is missing; run tools/talents_catalog.py first')
    existing = {o['id'] for o in table['custom']}
    if existing & {BACKPACK, RETURN}:
        raise ValueError('Backpack objects already exist in this map.')
    orders = {m['value'] for o in table['custom'] for m in o['sets'][0]['mods'] if m['field'] == 'Ncl6'}
    for order in (BACKPACK_ORDER, RETURN_ORDER):
        if order in orders:
            raise ValueError('order string %s is already used' % order)
    table['custom'].append(button(objects, BACKPACK, 'Backpack', 'B',
                                  BACKPACK_ICON, 'Backpac|cffffcc00k|r', BACKPACK_TEXT,
                                  0, 1, BACKPACK_ORDER))
    table['custom'].append(button(objects, RETURN, 'Back to hero', 'B',
                                  RETURN_ICON, '|cffffcc00B|rack to hero', RETURN_TEXT,
                                  3, 2, RETURN_ORDER))
    return table


def prepare_holder(units):
    objects = {o['id']: o for o in units['custom']}
    if HOLDER in objects:
        raise ValueError(HOLDER + ' already exists.')
    if DUMMY not in objects:
        raise ValueError('the dummy unit %s is missing from this map' % DUMMY)
    unit = copy.deepcopy(objects[DUMMY])
    unit['id'] = HOLDER
    # The dummy already has no model, no food cost and no collision, so only these change.
    # Locust is dropped: being selectable by its owner is the one thing the holder must be.
    # Every field below is one this map already sets on units, with the type it uses there;
    # an invented field or the wrong type corrupts the whole object file.
    abilities = ','.join([INVENTORY, 'Avul', 'Aeth', RETURN, TALENTS])
    for field, ftype, value in [('unam', 3, 'Backpack'), ('utip', 3, 'Backpack'),
                                ('uabi', 3, abilities), ('uico', 3, BACKPACK_ICON),
                                ('umvs', 0, 0), ('umvt', 3, ''), ('upoi', 0, 0)]:
        setf(unit, field, ftype, value)
    units['custom'].append(unit)
    return units


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('base', type=Path)
    parser.add_argument('out', type=Path)
    args = parser.parse_args()
    if args.out.exists():
        parser.error('Output already exists; choose a new path.')
    archive = MPQ(str(args.base))
    table = read_objects(archive.read('war3map.w3a'), 'w3a')
    units = read_objects(archive.read('war3map.w3u'), 'w3u')
    prepare_abilities(table)
    prepare_holder(units)
    write_files(str(args.base), str(args.out),
                {'war3map.w3a': write_objects(table, table['version'], 'w3a'),
                 'war3map.w3u': write_objects(units, units['version'], 'w3u')})
    print('Added the Backpack button, the Back-to-hero button and the Backpack holder unit.')


if __name__ == '__main__':
    main()
