"""Verify hint stock objects exist and agree with the armory source/catalogue."""
import argparse
import json
from pathlib import Path

from armory_catalog import hint_id, ICON
from mpq import MPQ
from objdata import read_objects, fields
from source_checks import ROOT, sources
from check_save_compat import assignments


def check(path):
    archive = MPQ(str(path))
    table = read_objects(archive.read('war3map.w3u'), 'w3u')
    units = {o['id'] or o['base']: fields(o) for group in ('original', 'custom') for o in table[group]}
    catalog = json.loads((ROOT / 'src/armory-hints.json').read_text(encoding='utf-8'))
    _, texts = sources()
    flags, errors = assignments(texts, 'udg_SaveFlagUnitID', repeated=True)
    flags = {k: v[-1] for k, v in flags.items()}
    items, extra = assignments(texts, 'udg_ItemIdTable')
    errors += extra
    expected = {k for k, raw in flags.items() if int(k) <= 500 and units[raw].get('upoi', 0) > 0}
    if set(catalog) != expected:
        errors.append('catalogue coverage does not match collectible armory entries')
    for key, entry in catalog.items():
        if entry['unit'] != flags.get(key) or entry['item'] != items.get(key):
            errors.append('catalogue save mapping changed: ' + key)
        f = units.get(hint_id(int(key)), {})
        original = units[flags[key]]
        for field, value in dict(umpm=int(key), upoi=original['upoi'], ulev=0,
                                 ugol=0, ulum=0, uico=ICON).items():
            if f.get(field) != value:
                errors.append(f'{key}: missing/wrong hint object field {field}')
        if entry['hint'] not in f.get('utub', ''):
            errors.append('object tooltip hint differs: ' + key)
        wanted = f'    set ArmoryHint[{key}]=' + json.dumps(entry['hint'])
        if wanted not in texts['Armory']:
            errors.append('source click hint differs: ' + key)
        if f"set ArmoryMissingUnit[{key}]='{hint_id(int(key))}'" not in texts['Armory']:
            errors.append('source stock mapping differs: ' + key)
    for raw in ['zNXT', 'zPRV']:
        if raw not in units or any(units[raw].get(field) != 0 for field in ['ugol', 'ulum', 'ulev', 'umpm']):
            errors.append('missing/incorrect page control: ' + raw)
    return errors


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--map', type=Path, required=True)
    args = parser.parse_args()
    errors = check(args.map)
    for error in errors[:20]:
        print('FAIL ' + error)
    print(('FAIL' if errors else 'PASS') + ' armory catalogue: hint coverage, stock objects, zero cost and source text')
    return int(bool(errors))


if __name__ == '__main__':
    raise SystemExit(main())
