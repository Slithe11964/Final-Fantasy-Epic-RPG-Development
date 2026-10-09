"""Read-only permanent identity preflight; does not enable any game save route."""
import argparse
import json
from pathlib import Path
import sys

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT / 'tools'))
from check_save_compat import assignments
from source_checks import sources

REGISTRY = Path(__file__).with_name('save-identities.json')


def validate(registry, items, jobs, catalog):
    if registry['schema'] != 1:
        raise ValueError('unsupported identity registry schema')
    for kind, current in [('items', items), ('jobs', jobs)]:
        records = registry[kind]
        ids = [r['id'] for r in records]
        raws = [r['rawcode'] for r in records]
        if any(type(i) is not int or i <= 0 for i in ids):
            raise ValueError(kind + ': invalid permanent ID')
        if len(set(ids)) != len(ids) or len(set(raws)) != len(raws):
            raise ValueError(kind + ': duplicate identity')
        pinned = {str(r['legacy_index']): r['rawcode'] for r in records}
        if len(pinned) != len(records) or pinned != current:
            raise ValueError(kind + ': source differs from reviewed legacy mapping')
        for r in records:
            expected = r['legacy_index'] + (1 if kind == 'jobs' else 0)
            if r['id'] != expected:
                raise ValueError(kind + ': reassigned permanent ID')
    canonical = {r['rawcode']: r['id'] for r in registry['items']}
    aliases = dict(canonical)
    reviewed_catalog = json.loads((ROOT / 'src/armory-hints.json').read_text(encoding='utf-8'))
    expected_order = [entry['item'] for entry in reviewed_catalog.values()]
    if catalog and list(catalog) != expected_order:
        raise ValueError('runtime mapping differs from armory catalog order/coverage')
    for number, entry in enumerate(catalog.values()):
        raw = entry['item']
        if raw not in canonical:
            raise ValueError('catalog item lacks permanent identity: ' + raw)
        # Same insertion order and category policy as prepare_objects. Runtime
        # aliases are build products, never permanent IDs or registry entries.
        if entry.get('slot') == 'Inventory':
            if entry.get('variant') or entry.get('offhand'):
                raise ValueError('inventory item has gear alias')
            continue
        if entry.get('slot') not in ('Head', 'Chest', 'Gloves', 'Boots', 'Ring', 'Primary', 'Offhand', 'Trinket'):
            raise ValueError('invalid equipment slot')
        if entry.get('variant') != 'f%03d' % number:
            raise ValueError('variant differs from builder allocation')
        expected_offhand = 'g%03d' % number if entry['slot'] == 'Primary' else None
        if entry.get('offhand') != expected_offhand:
            raise ValueError('offhand differs from builder allocation')
        for key in ('variant', 'offhand'):
            alias = entry.get(key)
            if alias:
                if alias in aliases:
                    raise ValueError('colliding runtime alias: ' + alias)
                aliases[alias] = canonical[raw]
    return aliases


def check(mapping=None):
    _, texts = sources()
    items, errors = assignments(texts, 'udg_ItemIdTable')
    jobs, extra = assignments(texts, 'udg_JobUnitType')
    errors += extra
    if errors:
        raise ValueError('; '.join(errors))
    registry = json.loads(REGISTRY.read_text(encoding='utf-8'))
    if mapping is None:
        # Read reviewed output from the current checkpoint, when supplied by CLI.
        catalog = {}
    else:
        if not mapping:
            raise ValueError('empty runtime mapping')
        catalog = {}
        for raw, entry in mapping.items():
            catalog[raw] = dict(entry, item=raw)
    aliases = validate(registry, items, jobs, catalog)
    return registry, aliases


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--mapping', type=Path, help='gear-slots-STAGE.json from builder')
    args = parser.parse_args()
    mapping = json.loads(args.mapping.read_text(encoding='utf-8')) if args.mapping else None
    registry, aliases = check(mapping)
    print(f"PASS: {len(registry['items'])} permanent items, "
          f"{len(registry['jobs'])} permanent jobs, {len(aliases)} runtime identities")


if __name__ == '__main__':
    main()
