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
LOCKED = 'tBlk'          # fills the slots 1.29.2 would otherwise hand out for free
LOCKED_SOURCE = 'I0ZB'   # the map's own "Fix slot filler": an item that cannot be moved
LOCKED_ICON = r'ReplaceableTextures\CommandButtons\BTNCancel.blp'
LOCKED_TEXT = ('Reforged gives nine equipment slots, so 1.29.2 gives nine as well. '
               'This slot is not one of them and cannot be used.')
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
NEXT = 'tBnx'
PREV = 'tBpv'
NEXT_ICON = r'ReplaceableTextures\CommandButtons\BTNPiercingArrows.blp'
PREV_ICON = r'ReplaceableTextures\CommandButtons\BTNWpArtemisArrows.blp'
BACKPACK_ORDER = 'cannibalize'
RETURN_ORDER = 'avatar'
NEXT_ORDER = 'divineshield'
PREV_ORDER = 'windwalk'


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
    if existing & {BACKPACK, RETURN, NEXT, PREV}:
        raise ValueError('Backpack objects already exist in this map.')
    orders = {m['value'] for o in table['custom'] for m in o['sets'][0]['mods'] if m['field'] == 'Ncl6'}
    for order in (BACKPACK_ORDER, RETURN_ORDER, NEXT_ORDER, PREV_ORDER):
        if order in orders:
            raise ValueError('order string %s is already used' % order)
    table['custom'].append(button(objects, BACKPACK, 'Backpack', 'B',
                                  BACKPACK_ICON, 'Backpac|cffffcc00k|r', BACKPACK_TEXT,
                                  0, 1, BACKPACK_ORDER))
    table['custom'].append(button(objects, RETURN, 'Back to hero', 'B',
                                  RETURN_ICON, '|cffffcc00B|rack to hero', RETURN_TEXT,
                                  3, 2, RETURN_ORDER))
    table['custom'].append(button(objects, NEXT, 'Next page', 'E', NEXT_ICON,
                                  'N|cffffcc00e|rxt page', 'Shows the next page of your gear.',
                                  2, 2, NEXT_ORDER))
    table['custom'].append(button(objects, PREV, 'Previous page', 'Q', PREV_ICON,
                                  'Pr|cffffcc00e|rvious page', 'Shows the previous page of your gear.',
                                  1, 2, PREV_ORDER))
    return table


def holder_fields():
    """(field, type, value) for the holder; every type is one this map already writes.

    Invulnerability is set in code instead, so it adds no command button. No attacks and no
    acquisition range, because a holder that goes hunting is busy attacking when the player
    clicks a page button, and no cast point, because the footman's third of a second of
    cast animation is felt as a page that turns late or not at all.
    """
    abilities = ','.join([INVENTORY, PREV, NEXT, RETURN, TALENTS])
    return [('unam', 3, 'Backpack'), ('utip', 3, 'Backpack'), ('uabi', 3, abilities),
            ('uico', 3, BACKPACK_ICON), ('umdl', 3, HOLDER_MODEL),
            ('umvs', 0, 0), ('umvt', 3, ''), ('ufoo', 0, 0), ('upoi', 0, 0),
            ('ucbs', 2, 0.0), ('uhpm', 0, 1000),
            ('uaen', 0, 0), ('uacq', 2, 0.0), ('ucpt', 2, 0.0),
            # A speck rather than a wisp: the holder stands on the hero and should not be
            # seen. Transparency alone was not enough - the wisp's model glows whatever its
            # vertex alpha says - so it is scaled down as well.
            ('ussc', 1, 0.01)]


def prepare_holder(units):
    """A plain unit with an inventory, built from the stock footman.

    The map's casting dummy was the wrong parent: it is engineered to be invisible and
    unselectable (Locust, no model, no sight, no collision, hero defense type), and the
    game refused to select a holder that inherited those traits even standing beside the
    hero. This starts from a normal selectable unit and changes only what it must.
    """
    if HOLDER in {o['id'] for o in units['custom']}:
        raise ValueError(HOLDER + ' already exists.')
    mods = [dict(field=f, type=ty, level=0, data=0, value=v, end=0) for f, ty, v in holder_fields()]
    units['custom'].append(dict(base=HOLDER_BASE, id=HOLDER, sets=[dict(flag=0, mods=mods)]))
    return units


def update_holder(units):
    """Bring a holder this map already carries up to date, leaving its other fields alone."""
    holder = next((o for o in units['custom'] if o['id'] == HOLDER), None)
    if holder is None:
        return prepare_holder(units)
    for field, ftype, value in holder_fields():
        setf(holder, field, ftype, value)
    return units


# Reset Talents belongs under the left column of the Shrine's card. It was copied from the
# Ability Menu, and Reforged keeps a second object table (war3mapSkin.w3u) that it reads
# display data from: with no entry of its own there, Reset Talents fell back to the Ability
# Menu's name, tooltip and position. Both tables get the same values here.
RESET_UNIT = 'nTRt'
RESET_NAME = 'Reset Talents'
RESET_TIP = 'Reset Talents (current job)'
RESET_TEXT = ('Resets the talents of your |cffffcc00current job only|r. Other jobs keep their talents. '
              'If this job has no talents picked, the gold is refunded.')
RESET_ICON = r'ReplaceableTextures\CommandButtons\BTNTomeOfRetraining.blp'
RESET_SLOT = (0, 2)


def prepare_locked_item(items, skin):
    """A slot blocker with a clear icon, copied from the map's own immovable filler item.

    The filler the map already had wears the icon of the item it was built from, which reads
    as a gem sitting in the slot. This is the same object with a name, a tooltip and a red
    cancel icon, so a blocked slot looks blocked.
    """
    source = next((o for o in items['custom'] if o['id'] == LOCKED_SOURCE), None)
    if source is None:
        raise ValueError('the map no longer carries ' + LOCKED_SOURCE)
    for table in (items, skin):
        if table is None:
            continue
        entry = next((o for o in table['custom'] if o['id'] == LOCKED), None)
        if entry is None:
            entry = copy.deepcopy(source)
            entry['id'] = LOCKED
            table['custom'].append(entry)
        for field, ftype, value in [('unam', 3, 'Locked slot'), ('utip', 3, 'Locked slot'),
                                    ('utub', 3, LOCKED_TEXT), ('ides', 3, LOCKED_TEXT),
                                    ('iico', 3, LOCKED_ICON)]:
            setf(entry, field, ftype, value)
    return items


def place_reset_button(units, skin):
    reset = next((o for o in units['custom'] if o['id'] == RESET_UNIT), None)
    if reset is None:
        return
    fields = [('unam', 3, RESET_NAME), ('utip', 3, RESET_TIP), ('utub', 3, RESET_TEXT),
              ('uico', 3, RESET_ICON), ('ugol', 0, 1000),
              ('ubpx', 0, RESET_SLOT[0]), ('ubpy', 0, RESET_SLOT[1])]
    for field, ftype, value in fields:
        setf(reset, field, ftype, value)
    if skin is None:
        return
    entry = next((o for o in skin['custom'] if o['id'] == RESET_UNIT), None)
    if entry is None:
        entry = dict(base=reset['base'], id=RESET_UNIT, sets=[dict(flag=0, mods=[])])
        skin['custom'].append(entry)
    for field, ftype, value in fields:
        setf(entry, field, ftype, value)


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
    items = read_objects(archive.read('war3map.w3t'), 'w3t')
    raw_skin = archive.read('war3mapSkin.w3u')
    skin = read_objects(raw_skin, 'w3u') if raw_skin else None
    raw_item_skin = archive.read('war3mapSkin.w3t')
    item_skin = read_objects(raw_item_skin, 'w3t') if raw_item_skin else None
    if {BACKPACK, RETURN, NEXT, PREV} <= {o['id'] for o in table['custom']}:
        print('Backpack buttons already present; leaving them as they are.')
    else:
        prepare_abilities(table)
    update_holder(units)
    prepare_locked_item(items, item_skin)
    place_reset_button(units, skin)
    files = {'war3map.w3a': write_objects(table, table['version'], 'w3a'),
             'war3map.w3u': write_objects(units, units['version'], 'w3u'),
             'war3map.w3t': write_objects(items, items['version'], 'w3t')}
    if skin is not None:
        files['war3mapSkin.w3u'] = write_objects(skin, skin['version'], 'w3u')
    if item_skin is not None:
        files['war3mapSkin.w3t'] = write_objects(item_skin, item_skin['version'], 'w3t')
    write_files(str(args.base), str(args.out), files)
    print('Backpack objects written: buttons, holder (no attacks, no cast point) and Reset Talents.')


if __name__ == '__main__':
    main()
