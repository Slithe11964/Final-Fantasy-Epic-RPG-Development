"""Add the hero "Talents" button ability (tTal) before building a stage with the Talents module.

python tools/talents_catalog.py BASE OUT
Channel-based, no target, no cost or cooldown; command-card slot (0,1), the slot left empty on
every job hero. The Talents module adds it to each player's hero and opens the talent window.
"""
import argparse
import copy
from pathlib import Path

from mpq import MPQ, write_files
from objdata import read_objects, write_objects

RAW = 'tTal'
ICON = r'ReplaceableTextures\CommandButtons\BTNStatUp.blp'
TEXT = ('Choose job talents: one per row. Row 1 is open from the start, row 2 at mastery (level 50), '
        'row 3 at ultimate mastery (level 99) and row 4 at legendary master (level 100). '
        'Picks last for this game; the Shrine of Individuality can reset them.')
# (field, type, level, data, value): type 0 int, 2 real, 3 string.
FIELDS = [
    ('anam', 3, 0, 0, 'Talents'), ('aart', 3, 0, 0, ICON), ('ahky', 3, 0, 0, 'T'),
    ('abpx', 0, 0, 0, 0), ('abpy', 0, 0, 0, 1), ('aher', 0, 0, 0, 0), ('alev', 0, 0, 0, 1),
    ('atp1', 3, 1, 0, 'Talen|cffffcc00t|rs'), ('aub1', 3, 1, 0, TEXT),
    ('amcs', 0, 1, 0, 0), ('acdn', 2, 1, 0, 0.0), ('acas', 2, 1, 0, 0.0),
    ('adur', 2, 1, 0, 0.0), ('ahdu', 2, 1, 0, 0.0),
    ('Ncl1', 2, 1, 1, 0.0), ('Ncl2', 0, 1, 2, 0), ('Ncl3', 0, 1, 3, 1), ('Ncl4', 2, 1, 4, 0.0),
    ('Ncl5', 0, 1, 5, 0), ('Ncl6', 3, 1, 6, 'darkportal'),
]


# Dummy-cast copies for Priest talents: (new id, template, name, seconds), free, long range.
DUMMIES = [('tDpr', 'A040', 'Deprotect', 15.0), ('tDsh', 'A11D', 'Deshell', 15.0),
           ('tBln', 'A08K', 'Blind', 15.0), ('tBl5', 'A08K', 'Blind', 5.0)]
# Priest spells that may now be aimed at enemies (the Talents module stops the cast without the talent).
ENEMY_TARGETABLE = ['A00G', 'A0TZ']  # Protect, Shell


def setf(obj, field, ftype, value, level=0, data=0):
    mods = obj['sets'][0]['mods']
    mods[:] = [m for m in mods if not (m['field'] == field and m['level'] == level)]
    mods.append(dict(field=field, type=ftype, level=level, data=data, value=value, end=0))


def prepare(table):
    ids = {o['id'] for o in table['custom']}
    if ids & ({RAW} | {d[0] for d in DUMMIES}):
        raise ValueError('Talent objects already exist in this map.')
    objects = {o['id']: o for o in table['custom']}
    for raw, template, name, seconds in DUMMIES:
        obj = copy.deepcopy(objects[template])
        obj['id'] = raw
        obj['sets'] = obj['sets'][:1]
        obj['sets'][0]['mods'] = [m for m in obj['sets'][0]['mods'] if m['level'] in (0, 1)]
        for field, ftype, value, level in [('anam', 3, 'Talent ' + name, 0), ('alev', 0, 1, 0), ('aher', 0, 0, 0),
                                           ('amcs', 0, 0, 1), ('acdn', 2, 0.0, 1), ('adur', 2, seconds, 1),
                                           ('ahdu', 2, seconds, 1), ('aran', 2, 99999.0, 1)]:
            setf(obj, field, ftype, value, level)
        if template == 'A08K':
            setf(obj, 'atar', 3, 'air,ground,enemy,neutral', 1)
        table['custom'].append(obj)
    for raw in ENEMY_TARGETABLE:
        obj = objects[raw]
        for m in obj['sets'][0]['mods']:
            if m['field'] == 'atar' and 'enemy' not in m['value'].split(','):
                m['value'] += ',enemy'

    for o in table['custom']:
        for m in o['sets'][0]['mods']:
            if m['field'] == 'Ncl6' and m['value'] == 'darkportal':
                raise ValueError('order string darkportal is already used by ' + o['id'])
    mods = [dict(field=f, type=t, level=lv, data=d, value=v, end=0) for f, t, lv, d, v in FIELDS]
    table['custom'].append(dict(base='ANcl', id=RAW, sets=[dict(flag=0, mods=mods)]))
    return table


# Shrine of Individuality (n04U) sells "Reset Talents" in its bottom-left slot; the Legendary
# Bonus Menu (after legendary master) stays bottom-right, as the Forsaken line arranged them.
RESET_UNIT = 'nTRt'
RESET_TEXT = ('Resets the talents of your |cffffcc00current job only|r. Other jobs keep their talents. '
              'If this job has no talents picked, the gold is refunded.')


def prepare_units(table, skin):
    if RESET_UNIT in {o['id'] for o in table['custom']}:
        raise ValueError(RESET_UNIT + ' already exists.')
    objects = {o['id']: o for o in table['custom']}
    unit = copy.deepcopy(objects['n07I'])
    unit['id'] = RESET_UNIT
    for field, ftype, value in [('unam', 3, 'Reset Talents'), ('utip', 3, 'Reset Talents (current job)'),
                                ('utub', 3, RESET_TEXT), ('ugol', 0, 1000), ('ulum', 0, 0),
                                ('uico', 3, r'ReplaceableTextures\CommandButtons\BTNTomeOfRetraining.blp'),
                                ('ubpx', 0, 0), ('ubpy', 0, 2), ('usma', 0, 1), ('upoi', 0, 0)]:
        setf(unit, field, ftype, value)
    table['custom'].append(unit)
    shrine = objects['n04U']
    for m in shrine['sets'][0]['mods']:
        if m['field'] == 'useu' and RESET_UNIT not in m['value'].split(','):
            m['value'] += ',' + RESET_UNIT
    for t in (table, skin):
        for o in t['custom']:
            if o['id'] == 'n0KL':
                setf(o, 'ubpx', 0, 3)
                setf(o, 'ubpy', 0, 2)


# Cure (A00M) was Holy Light-based, and Warcraft only lets Holy Light target allies or undead
# enemies. Blinding Light needs any enemy, so Cure becomes Channel-based with the same order
# string ("holybolt"), costs, cooldowns, range, targets and text. Its healing was already done by
# script (Spell_Cure); Holy Light's own heal was 0. Every level gets explicit values, because
# 1.29.2 can freeze a caster on Channel levels with missing fields.
CURE = 'A00M'


def rebase_cure(table, skin):
    cure = next(o for o in table['custom'] if o['id'] == CURE)
    if cure['base'] != 'AHhb':
        raise ValueError('Cure is not Holy Light-based any more; review the input map.')
    levels = next(m['value'] for m in cure['sets'][0]['mods'] if m['field'] == 'alev')
    cure['base'] = 'ANcl'
    cure['sets'][0]['mods'] = [m for m in cure['sets'][0]['mods'] if not m['field'].startswith('Hhb')]
    # Holy Light's stock values that the map relied on as defaults.
    for field, ftype, value in [('aher', 0, 1), ('arlv', 0, 1), ('alsk', 0, 2), ('abpx', 0, 0), ('abpy', 0, 2),
                                ('arpx', 0, 0), ('arpy', 0, 0), ('aani', 3, 'spell'), ('arac', 3, 'human')]:
        setf(cure, field, ftype, value)
    for level in range(1, levels + 1):
        for field, ftype, value, data in [('aran', 2, 800.0, 0), ('acas', 2, 0.0, 0), ('adur', 2, 0.0, 0),
                                          ('ahdu', 2, 0.0, 0), ('aare', 2, 0.0, 0),
                                          ('Ncl1', 2, 0.0, 1), ('Ncl2', 0, 1, 2), ('Ncl3', 0, 1, 3),
                                          ('Ncl4', 2, 0.0, 4), ('Ncl5', 0, 0, 5), ('Ncl6', 3, 'holybolt', 6)]:
            setf(cure, field, ftype, value, level, data)
    for o in skin['custom']:
        if o['id'] == CURE:
            o['base'] = 'ANcl'


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
    skin = read_objects(archive.read('war3mapSkin.w3u'), 'w3u') if archive.read('war3mapSkin.w3u') else None
    prepare_units(units, skin or {'custom': []})
    skin_a = read_objects(archive.read('war3mapSkin.w3a'), 'w3a') if archive.read('war3mapSkin.w3a') else None
    rebase_cure(table, skin_a or {'custom': []})
    files = {'war3map.w3a': write_objects(prepare(table), table['version'], 'w3a'),
             'war3map.w3u': write_objects(units, units['version'], 'w3u')}
    if skin:
        files['war3mapSkin.w3u'] = write_objects(skin, skin['version'], 'w3u')
    if skin_a:
        files['war3mapSkin.w3a'] = write_objects(skin_a, skin_a['version'], 'w3a')
    write_files(str(args.base), str(args.out), files)
    print('Added the Talents button, Priest talent dummy spells and the Shrine "Reset Talents" option.')


if __name__ == '__main__':
    main()
