"""Prepare Chronicle page two and Secrets before building the stage.

Run after armory_catalog.py and bazaar_catalog.py for a fresh baseline.
python tools/chronicles_catalog.py BASE OUT
"""
import argparse
import copy
from pathlib import Path

from mpq import MPQ, write_files
from objdata import read_objects, write_objects, fields

NEW_IDS = {'cPg2', 'cSec', 'cKeg'}
NEXT_PAGE_ICON = r'ReplaceableTextures\CommandButtons\BTNMove.blp'


def set_field(obj, key, value, level=0, data=0):
    mods = obj['sets'][0]['mods']
    for mod in mods:
        if mod['field'] == key and mod['level'] == level and mod['value'] == value and mod['data'] == data:
            return
    mods[:] = [m for m in mods if not (m['field'] == key and m['level'] == level)]
    mods.append(dict(field=key, type=3 if isinstance(value, str) else 0,
                     level=level, data=data, value=value, end=0))


def prepare(table):
    result = copy.deepcopy(table)
    objects = {o['id'] or o['base']: o for group in ('original', 'custom') for o in result[group]}
    present = NEW_IDS & objects.keys()
    if present:
        if present != NEW_IDS or fields(objects['A0AR']).get(('spb1', 1), '').split(',')[-1] != 'cPg2':
            raise ValueError('Incomplete Chronicle objects or conflicting IDs; review the input map.')
        # Keep the existing additive objects usable when preparing a later stage.
        # The replay-arrow icon makes the page control read as navigation instead of a locked entry.
        set_field(objects['cPg2'], 'aart', NEXT_PAGE_ICON)
        set_field(objects['cPg2'], 'aub1', '', 1)
        for level in (1, 2):
            set_field(objects['cKeg'], 'atp1', 'Keg Hunter', level)
            set_field(objects['cKeg'], 'aub1',
                      '|cff00ff00Keg Hunter|r|n|n- Increases rare drops in all areas.', level)
        return result
    root = objects['A0AR']
    spells = fields(root)[('spb1', 1)].split(',')
    if len(spells) != 11 or spells[-1] != 'A10C':
        raise ValueError('Expected original eleven Chronicle entries with Time Trial last.')
    def book(raw, name, spells, position, order, icon, description):
        obj = copy.deepcopy(root)
        obj['id'] = raw
        for key, value, level, data in [
            ('anam', name, 0, 0), ('atp1', name, 1, 0), ('aub1', description, 1, 0),
            ('aart', icon, 0, 0), ('abpx', position[0], 0, 0), ('abpy', position[1], 0, 0),
            ('spb1', ','.join(spells), 1, 1), ('spb3', len(spells), 1, 3),
            ('spb4', len(spells), 1, 4), ('spb5', order, 1, 5),
        ]:
            set_field(obj, key, value, level, data)
        return obj
    page = book('cPg2', 'Next page', ['A10C', 'cSec'], (2, 2), 'carrionswarm',
                NEXT_PAGE_ICON,
                '')
    secret = book('cSec', 'Secrets', ['cKeg'], (1, 0), 'breathoffire',
                  r'ReplaceableTextures\CommandButtons\BTNTome.blp',
                  'Hidden accomplishments. Discover all ten monographs to become a Keg Hunter.')
    keg = copy.deepcopy(objects['A10C'])
    keg['id'] = 'cKeg'
    keg['sets'][0]['mods'] = [m for m in keg['sets'][0]['mods'] if m['level'] <= 2]
    for key, value in [('anam', 'Keg Hunter'), ('alev', 2), ('abpx', 0), ('abpy', 0),
                       ('aart', r'ReplaceableTextures\CommandButtons\BTNBarrel.blp')]:
        set_field(keg, key, value)
    for level in (1, 2):
        set_field(keg, 'atp1', 'Keg Hunter', level)
        set_field(keg, 'aub1',
                  '|cff00ff00Keg Hunter|r|n|n- Increases rare drops in all areas.', level)
    set_field(root, 'spb1', ','.join(spells[:-1] + ['cPg2']), 1, 1)
    set_field(objects['A10C'], 'abpx', 0)
    set_field(objects['A10C'], 'abpy', 0)
    result['custom'] += [page, secret, keg]
    return result


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('base', type=Path)
    parser.add_argument('out', type=Path)
    args = parser.parse_args()
    if args.out.exists():
        parser.error('Output already exists; choose a new path.')
    archive = MPQ(str(args.base))
    table = read_objects(archive.read('war3map.w3a'), 'w3a')
    args.out.parent.mkdir(parents=True, exist_ok=True)
    write_files(str(args.base), str(args.out), {'war3map.w3a': write_objects(prepare(table), table['version'], 'w3a')})
    print('Prepared Chronicles: ten original entries + Next page; Time Trial and Secrets on page two; Keg Hunter inside Secrets.')


if __name__ == '__main__':
    main()
