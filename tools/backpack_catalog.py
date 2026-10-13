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
HOLDER_BASE = 'hfoo'    # the stock footman: an ordinary, selectable unit
INVENTORY = 'AInv'      # the six-slot unit inventory

BACKPACK_TEXT = ('Opens your gear. Equipment sits in its own pages, so your own six slots stay '
                 'free for potions and books. Use Back to hero to return.')
RETURN_TEXT = 'Returns to your hero.'
# Icons and order strings are taken from ones this map already uses, because an icon path the
# game cannot find draws as a green square and an order string that is not a real no-target
# order leaves the button doing nothing. Each ability on a unit needs its own order.
BACKPACK_ICON = r'ReplaceableTextures\CommandButtons\BTNTomeBrown.blp'
RETURN_ICON = r'ReplaceableTextures\CommandButtons\BTNSelectHeroOn.blp'
HOLDER_MODEL = 'units\\nightelf\\Wisp\\Wisp.mdl'
BACKPACK_ORDER = 'cannibalize'
RETURN_ORDER = 'avatar'


# Channel's Ncl1..Ncl6 are distinguished by their data column, not just their field id, so
# the data index is part of a field's identity here. Writing the order string at data 0
# instead of data 6 leaves the ability with no order at all, and the button does nothing.
ORDER_DATA = 6


def setf(obj, field, ftype, value, level=0, data=0):
    mods = obj['sets'][0]['mods']
    mods[:] = [m for m in mods
               if not (m['field'] == field and m['level'] == level and m['data'] == data)]
    mods.append(dict(field=field, type=ftype, level=level, data=data, value=value, end=0))


def button(objects, raw, name, hotkey, icon, tip, text, px, py, order):
    """A channel button copied from the Talents one, so it keeps a shape that works."""
    obj = copy.deepcopy(objects[TALENTS])
    obj['id'] = raw
    for field, ftype, value, level in [('anam', 3, name, 0), ('aart', 3, icon, 0), ('ahky', 3, hotkey, 0),
                                       ('abpx', 0, px, 0), ('abpy', 0, py, 0),
                                       ('atp1', 3, tip, 1), ('aub1', 3, text, 1)]:
        setf(obj, field, ftype, value, level)
    setf(obj, 'Ncl6', 3, order, 1, ORDER_DATA)
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
    """A plain unit with an inventory, built from the stock footman.

    The map's casting dummy was the wrong parent: it is engineered to be invisible and
    unselectable (Locust, no model, no sight, no collision, hero defense type), and the
    game refused to select a holder that inherited those traits even standing beside the
    hero. This starts from a normal selectable unit and changes only what it must.
    """
    if HOLDER in {o['id'] for o in units['custom']}:
        raise ValueError(HOLDER + ' already exists.')
    # Invulnerability is set on the unit in code instead, so it adds no command button.
    abilities = ','.join([INVENTORY, RETURN, TALENTS])
    # (field, type, value); every type is one this map already writes for that field.
    fields = [('unam', 3, 'Backpack'), ('utip', 3, 'Backpack'), ('uabi', 3, abilities),
              ('uico', 3, BACKPACK_ICON), ('umdl', 3, HOLDER_MODEL),
              ('umvs', 0, 0), ('umvt', 3, ''), ('ufoo', 0, 0), ('upoi', 0, 0),
              ('ucbs', 2, 0.0), ('uhpm', 0, 1000)]
    mods = [dict(field=f, type=ty, level=0, data=0, value=v, end=0) for f, ty, v in fields]
    units['custom'].append(dict(base=HOLDER_BASE, id=HOLDER, sets=[dict(flag=0, mods=mods)]))
    return units


# Moving the Shrine's Reset Talents button by its Button Position fields did not move it and
# left the shop showing one button's tooltip over another's action, so it stays where it
# shipped until the shop's real layout rule is known.


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
