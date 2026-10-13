"""Generate the item-to-equipment-slot table the 1.29.2 backpack enforces.

    python tools/gear_slots.py BASE_MAP.w3x

Writes src/triggers/05 Items crafting and shops/GearSlots.j: a hashtable of item type to
slot kind, so an item can only be worn in the slot it belongs in, and each equipment item's
passive abilities, which the hero is given while the item is worn. In 1.29.2 an item's
abilities only work on the unit carrying it, and worn gear is carried by a holder, so the
passives have to be granted to the hero by script.

The classification is the one the Forsaken gear work reviewed for all 276 equipment items
(experiments/Forsaken/build_forsaken.py slot_for): each armory item's category comes from
its armory unit's point-value field, and the loose categories 33 to 39 are split by name.
Anything the armory does not list is an ordinary inventory item and gets no slot.
"""
import argparse
import json
import os
import sys
from pathlib import Path

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
from mpq import MPQ
from objdata import fields, read_objects

ROOT = Path(HERE).parent
HINTS = ROOT / 'src/armory-hints.json'
OUT = ROOT / 'src/triggers/05 Items crafting and shops/GearSlots.j'

# Item abilities that are passive bonuses, from the reviewed Forsaken gear work
# (experiments/Forsaken/build_forsaken.py PASSIVE_ITEM_CODES). An active ability is left
# alone: it needs the item in hand to be cast, so wearing the item does not grant it.
PASSIVE_CODES = frozenset(('AEev', 'AHab', 'AIab', 'AIas', 'AIat', 'AIde',
                           'AIml', 'AImm', 'AIms', 'AIrm', 'AOac', 'AOae', 'AOcr',
                           'AUau', 'AUav', 'Aasl', 'Atru', 'Arel'))
BASE_CODES = ROOT / 'experiments/Forsaken/ability-base-codes.json'

# Where each kind of entry lives in the generated hashtable: a slot kind and a bonus count
# are keyed by item, the gear-ability marker by ability, and the bonuses themselves run from
# BONUS_KEY upwards, one key per position.
SLOT_KEY = 1
COUNT_KEY = 2
CAST_KEY = 3
BONUS_KEY = 10

# Slot kinds, in the order the equipment pages lay them out, with what a player sees them
# called. Equipment page 1 is laid out in this order, so slot 0 is the weapon.
KINDS = ['Primary', 'Offhand', 'Head', 'Chest', 'Gloves', 'Boots', 'Ring', 'Trinket']
LABELS = dict(Primary='Weapon', Offhand='Offhand', Head='Helm', Chest='Chest',
              Gloves='Gloves', Boots='Boots', Ring='Ring', Trinket='Trinket')


def slot_for(name, category):
    """Which slot an armory item belongs in, or None for an ordinary inventory item."""
    if category == 8:
        return None
    if name == 'Firefly':
        return 'Ring'
    if category in (28, 29):
        return 'Head'
    if category in (30, 31, 32):
        return 'Chest'
    if category in (24, 25, 26, 27, 38, 40):
        return 'Offhand'
    if category in (33, 34, 35, 36, 37, 39):
        lowered = name.lower()
        if any(word in lowered for word in ('boots', 'shoes', 'jackboots')):
            return 'Boots'
        if any(word in lowered for word in ('gloves', 'bracers', 'armguard')):
            return 'Gloves'
        if 'ring' in lowered.split():
            return 'Ring'
        return 'Trinket'
    if category in (7, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23):
        return 'Primary'
    raise ValueError('unreviewed armory category %r for %s' % (category, name))


def passive_abilities(archive):
    """Every ability raw code that is a passive item bonus."""
    codes = json.loads(BASE_CODES.read_text(encoding='utf-8'))
    table = read_objects(archive.read('war3map.w3a'), 'w3a')
    found = {raw for raw, code in codes.items() if code in PASSIVE_CODES}
    for group in ('original', 'custom'):
        for obj in table[group]:
            code = fields(obj).get('acod') or codes.get(obj['base'], obj['base'])
            if code in PASSIVE_CODES:
                found.add(obj['id'] or obj['base'])
    return found


def classify(base):
    archive = MPQ(str(base))
    table = read_objects(archive.read('war3map.w3u'), 'w3u')
    units = {o['id'] or o['base']: fields(o)
             for group in ('original', 'custom') for o in table[group]}
    itemtable = read_objects(archive.read('war3map.w3t'), 'w3t')
    items = {o['id'] or o['base']: fields(o)
             for group in ('original', 'custom') for o in itemtable[group]}
    passive = passive_abilities(archive)
    hints = json.loads(HINTS.read_text(encoding='utf-8'))
    out = []
    for entry in hints.values():
        unit = units.get(entry['unit'])
        if unit is None or 'upoi' not in unit:
            raise ValueError('no armory category for ' + entry['name'])
        slot = slot_for(entry['name'], int(unit['upoi']))
        if slot:
            carried = [a for a in items.get(entry['item'], {}).get('iabi', '').split(',') if a]
            bonuses = [a for a in carried if a in passive]
            actives = [a for a in carried if a not in passive]
            out.append((entry['item'], entry['name'], slot, bonuses, actives))
    return out


def render(rows):
    lines = ['library TGearSlots',
             '// Generated by tools/gear_slots.py; edit that, not this file.',
             '// Which slot each piece of equipment belongs in. The backpack refuses an item in',
             '// the wrong slot, so a helm can never sit in the weapon slot.',
             'globals']
    for index, kind in enumerate(KINDS):
        lines.append('    constant integer GEAR_%s=%d' % (kind.upper(), index + 1))
    lines += ['    constant integer GEAR_KINDS=%d' % len(KINDS),
              '    hashtable GearSlotTable=null',
              'endglobals',
              '',
              'function Gear_KindName takes integer kind returns string']
    for index, kind in enumerate(KINDS):
        lines.append('    %s kind==%d then' % ('if' if index == 0 else 'elseif', index + 1))
        lines.append('        return "%s"' % LABELS[kind])
    lines += ['    endif',
              '    return "Bag"',
              'endfunction',
              '',
              '// Zero for anything that is not equipment, so unknown items stay in the bag.',
              'function Gear_KindOf takes integer itemType returns integer',
              '    if GearSlotTable==null then',
              '        return 0',
              '    endif',
              '    return LoadInteger(GearSlotTable,1,itemType)',
              'endfunction',
              '',
              '// How many passive bonuses an item carries, and each one in turn. In 1.29.2 the',
              '// hero has to be given these by script, because the item itself is held by a holder.',
              'function Gear_BonusCount takes integer itemType returns integer',
              '    if GearSlotTable==null then',
              '        return 0',
              '    endif',
              '    return LoadInteger(GearSlotTable,2,itemType)',
              'endfunction',
              '',
              'function Gear_Bonus takes integer itemType,integer index returns integer',
              '    return LoadInteger(GearSlotTable,%d+index,itemType)' % BONUS_KEY,
              'endfunction',
              '',
              '// True for an ability that belongs to a piece of equipment, so that casting one',
              '// can put the rest of the gear on the same cooldown.',
              'function Gear_IsGearAbility takes integer ability returns boolean',
              '    if GearSlotTable==null then',
              '        return false',
              '    endif',
              '    return LoadInteger(GearSlotTable,%d,ability)==1' % CAST_KEY,
              'endfunction',
              '',
              'function GearSlots_Init takes nothing returns nothing',
              '    set GearSlotTable=InitHashtable()']
    actives = sorted({a for _, _, _, _, casts in rows for a in casts})
    for raw, name, kind, bonuses, _casts in rows:
        lines.append("    call SaveInteger(GearSlotTable,1,'%s',GEAR_%s) // %s" % (raw, kind.upper(), name))
        if bonuses:
            lines.append("    call SaveInteger(GearSlotTable,2,'%s',%d)" % (raw, len(bonuses)))
            for index, ability in enumerate(bonuses):
                lines.append("    call SaveInteger(GearSlotTable,%d,'%s','%s')" % (BONUS_KEY + index, raw, ability))
    for ability in actives:
        lines.append("    call SaveInteger(GearSlotTable,%d,'%s',1)" % (CAST_KEY, ability))
    lines += ['endfunction',
              '',
              '// No startup registration of its own: the backpack fills the table before it',
              '// registers anything, because it is the only reader.',
              'function InitTrig_GearSlots takes nothing returns nothing',
              'endfunction',
              '',
              'endlibrary',
              '']
    return '\r\n'.join(lines)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('base', type=Path)
    args = parser.parse_args()
    rows = classify(args.base)
    OUT.write_bytes(render(rows).encode('utf-8'))
    counts = {}
    for _, _, kind, _bonuses, _casts in rows:
        counts[kind] = counts.get(kind, 0) + 1
    print('Wrote', OUT.name, 'with', len(rows), 'equipment items:',
          ', '.join('%s %d' % (k, counts[k]) for k in KINDS if k in counts),
          '- and', sum(len(b) for _, _, _, b, _c in rows), 'passive bonuses on',
          sum(1 for _, _, _, b, _c in rows if b), 'of them, plus',
          len({a for _, _, _, _, c in rows for a in c}), 'abilities they cast')


if __name__ == '__main__':
    main()
