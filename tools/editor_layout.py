"""Keep WTG/WCT source pairs in the folder traversal order used by World Editor."""
import argparse
from collections import defaultdict
from pathlib import Path
import re

from mpq import MPQ, replace_files, compact
from wtg import read_wtg, write_wtg
from wct import read_wct, write_wct, text_of

TRIGGERS = (8, 16, 32)


def trigger_items(tree):
    return [item for item in tree['items'] if item['kind'] in TRIGGERS]


def folder_order(tree):
    children = defaultdict(list)
    for item in tree['items']:
        if item['kind'] != 1:
            children[item['parent']].append(item)
    roots = [item for item in tree['items'] if item['kind'] == 1]
    if len(roots) != 1:
        raise ValueError('expected exactly one editor root')
    ordered, seen = [roots[0]], {roots[0]['id']}

    def visit(parent):
        for item in children[parent]:
            if item['id'] in seen:
                raise ValueError('duplicate/cyclic editor item ID')
            seen.add(item['id'])
            ordered.append(item)
            visit(item['id'])

    visit(roots[0]['id'])
    if len(ordered) != len(tree['items']):
        raise ValueError('orphaned editor items')
    return ordered


def paired_text(tree, wct):
    triggers = trigger_items(tree)
    if len(triggers) != len(wct['entries']):
        raise ValueError('WTG/WCT entry counts differ')
    if len({item['name'] for item in triggers}) != len(triggers):
        raise ValueError('duplicate editor trigger names')
    return {item['name']: raw for item, raw in zip(triggers, wct['entries'])}


def layout_errors(tree, wct):
    try:
        pairs = paired_text(tree, wct)
        physical = [item['name'] for item in trigger_items(tree)]
        traversed = [item['name'] for item in folder_order(tree) if item['kind'] in TRIGGERS]
        errors = []
        if physical != traversed:
            errors.append('trigger/source storage is not in editor folder order; run editor_layout.py')
        for item in trigger_items(tree):
            text = text_of(pairs[item['name']])
            if item.get('custom') and text and not re.search(
                    r'\bfunction\s+InitTrig_' + re.escape(item['name']) + r'\s+takes\b', text):
                errors.append(item['name'] + ': custom source does not own its InitTrig function')
        return errors
    except ValueError as exc:
        return [str(exc)]


def normalize(tree, wct):
    pairs = paired_text(tree, wct)
    tree = {**tree, 'items': folder_order(tree)}
    wct = {**wct, 'entries': [pairs[item['name']] for item in trigger_items(tree)]}
    errors = layout_errors(tree, wct)
    if errors:
        raise ValueError('; '.join(errors))
    return tree, wct


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('base')
    parser.add_argument('output')
    args = parser.parse_args()
    if Path(args.output).exists():
        raise ValueError('output exists')
    archive = MPQ(args.base)
    tree = read_wtg(archive.read('war3map.wtg'))
    wct = read_wct(archive.read('war3map.wct'))
    tree, wct = normalize(tree, wct)
    temporary = args.output + '.tmp'
    replace_files(args.base, temporary, {'war3map.wtg': write_wtg(tree), 'war3map.wct': write_wct(wct)})
    compact(temporary, args.output)
    Path(temporary).unlink()
    print(f'PASS editor layout: {len(wct["entries"])} paired triggers in folder order; source bytes preserved')


if __name__ == '__main__':
    main()
