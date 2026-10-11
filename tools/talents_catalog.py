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
        'Picks last for this game; the talent trainer in town can reset them.')
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


# Dummy-cast copies for Priest talents: (new id, template, order note), all 15 s, free, long range.
DUMMIES = [('tDpr', 'A040', 'Deprotect'), ('tDsh', 'A11D', 'Deshell'), ('tBln', 'A08K', 'Blind')]
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
    for raw, template, name in DUMMIES:
        obj = copy.deepcopy(objects[template])
        obj['id'] = raw
        obj['sets'] = obj['sets'][:1]
        obj['sets'][0]['mods'] = [m for m in obj['sets'][0]['mods'] if m['level'] in (0, 1)]
        for field, ftype, value, level in [('anam', 3, 'Talent ' + name, 0), ('alev', 0, 1, 0), ('aher', 0, 0, 0),
                                           ('amcs', 0, 0, 1), ('acdn', 2, 0.0, 1), ('adur', 2, 15.0, 1),
                                           ('ahdu', 2, 15.0, 1), ('aran', 2, 99999.0, 1)]:
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


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('base', type=Path)
    parser.add_argument('out', type=Path)
    args = parser.parse_args()
    if args.out.exists():
        parser.error('Output already exists; choose a new path.')
    archive = MPQ(str(args.base))
    table = read_objects(archive.read('war3map.w3a'), 'w3a')
    version = table['version']
    write_files(str(args.base), str(args.out), {'war3map.w3a': write_objects(prepare(table), version, 'w3a')})
    print('Added the Talents button ability ' + RAW + '.')


if __name__ == '__main__':
    main()
