"""Add reviewed armory hint objects to a new map before running build.ps1.

python tools/armory_catalog.py BASE OUT
Hints live in src/armory-hints.json. Only stock button positions change on existing objects;
save indexes and item requirements are preserved.
"""
import argparse
import copy
import json
from pathlib import Path
import re

from mpq import MPQ, write_files
from objdata import read_objects, write_objects, fields
from source_checks import ROOT, sources
from check_save_compat import assignments

ICON = r'ReplaceableTextures\CommandButtons\BTNSelectHeroOn.blp'


def set_field(obj, key, value):
    mods = obj['sets'][0]['mods']
    mods[:] = [m for m in mods if m['field'] != key]
    mods.append(dict(field=key, type=3 if isinstance(value, str) else 0,
                     level=None, data=None, value=value, end=0))


def hint_id(index):
    return 'z%03d' % index


def sync_hint_source(catalog):
    path = ROOT / 'src/triggers/05 Items crafting and shops/Armory.j'
    source = path.read_text(encoding='utf-8')
    lines = ['function Armory_InitHints takes nothing returns nothing']
    for index, entry in sorted(catalog.items(), key=lambda pair: int(pair[0])):
        lines.append(f"    set ArmoryMissingUnit[{index}]='{hint_id(int(index))}'")
        lines.append(f'    set ArmoryHint[{index}]=' + json.dumps(entry['hint']))
    lines.append('endfunction')
    source, count = re.subn(r'function Armory_InitHints takes nothing returns nothing\n.*?\nendfunction',
                            lambda match: '\n'.join(lines), source, flags=re.S)
    if count != 1:
        raise ValueError('expected one Armory_InitHints function')
    path.write_bytes(source.replace('\n', '\r\n').encode('utf-8'))


def catalog_objects(table, catalog, flags, item_fields):
    result = copy.deepcopy(table)
    original = {o['id'] or o['base']: o for group in ('original', 'custom') for o in table[group]}
    expected = {int(k) for k, raw in flags.items() if int(k) <= 500 and fields(original[raw]).get('upoi', 0) > 0}
    if set(map(int, catalog)) != expected:
        raise ValueError('hint coverage must match every armory item with a category')
    additions = []
    categories = {}
    for key, entry in catalog.items():
        f = fields(original[flags[key]])
        categories.setdefault(f['upoi'], []).append(key)
    positions = {}
    for keys in categories.values():
        if len(keys) > 11:
            raise ValueError('armory category exceeds eleven item slots')
        keys.sort(key=lambda key: (item_fields[catalog[key]['item']].get('ihtp', 1),
                                  fields(original[flags[key]]).get('ubpy', 0) * 4 +
                                  fields(original[flags[key]]).get('ubpx', 0), int(key)))
        positions.update({key: slot for slot, key in enumerate(keys)})
    for group in ('original', 'custom'):
        for obj in result[group]:
            key = next((k for k in catalog if flags[k] == (obj['id'] or obj['base'])), None)
            if key is not None:
                set_field(obj, 'ubpx', positions[key] % 4)
                set_field(obj, 'ubpy', positions[key] // 4)
    for key, entry in sorted(catalog.items(), key=lambda pair: int(pair[0])):
        index = int(key)
        if not entry['hint'].strip() or not entry['evidence']:
            raise ValueError('missing hint/evidence: ' + key)
        obj = copy.deepcopy(original[flags[key]])
        obj['id'] = hint_id(index)
        for field, value in dict(unam='Missing: ' + entry['name'], utip='? - Missing item',
                                 utub='|cffffcc00Not stored|r|n|nHint: ' + entry['hint'] +
                                      '|n|nStore this item in your house to unlock it in the armory.',
                                 uico=ICON, ugol=0, ulum=0, ulev=0,
                                 ubpx=positions[key] % 4, ubpy=positions[key] // 4,
                                 umpm=index, usma=1, usrg=1).items():
            set_field(obj, field, value)
        additions.append(obj)
    if any(o['id'] in original for o in additions):
        raise ValueError('hint object ID already exists; use an unmodified base')
    result['custom'].extend(additions)
    return result


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('base', type=Path)
    parser.add_argument('out', type=Path)
    args = parser.parse_args()
    _, texts = sources()
    flags, errors = assignments(texts, 'udg_SaveFlagUnitID', repeated=True)
    flags = {k: v[-1] for k, v in flags.items()}
    if errors:
        raise ValueError(errors)
    catalog = json.loads((ROOT / 'src/armory-hints.json').read_text(encoding='utf-8'))
    archive = MPQ(str(args.base))
    table = read_objects(archive.read('war3map.w3u'), 'w3u')
    items = read_objects(archive.read('war3map.w3t'), 'w3t')
    item_fields = {o['id'] or o['base']: fields(o) for group in ('original', 'custom') for o in items[group]}
    updated = catalog_objects(table, catalog, flags, item_fields)
    args.out.parent.mkdir(parents=True, exist_ok=True)
    write_files(str(args.base), str(args.out), {'war3map.w3u': write_objects(updated, table['version'], 'w3u')})
    sync_hint_source(catalog)
    print(f'Added {len(catalog)} hint entries; stock button positions sorted by required level.')


if __name__ == '__main__':
    main()
