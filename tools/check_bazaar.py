"""Check Bazaar browser objects, recipe layout and prices against current item data."""
import argparse
from pathlib import Path
import re
from bazaar_catalog import BUTTON, ICON, prices
from check_save_compat import assignments, literal_int
from jtok import functions
from mpq import MPQ
from objdata import fields, read_objects
from source_checks import sources


def recipe_data(source):
    table = {}
    body = functions(source)['Trig_Bazaar_Recipes_Actions']
    for value, child, parent in re.findall(r'call SaveIntegerBJ\(([^,]+),([^,]+),([^,]+),udg_BazaarRecipeHash\)', body):
        values = tuple(literal_int(x.strip()) for x in (parent, child, value))
        if None in values:
            raise ValueError('nonliteral recipe data')
        p, k, v = values
        if (p, k) in table and table[p, k] != v:
            raise ValueError('conflicting recipe field')
        table[p, k] = v
    return table


def check(path):
    archive = MPQ(str(path))
    table = read_objects(archive.read('war3map.w3u'), 'w3u')
    units = {o['id'] or o['base']: fields(o) for g in ('original', 'custom') for o in table[g]}
    _, texts = sources()
    source = texts['Bazaar']
    goods, errors = assignments(texts, 'udg_BazaarGoodItem')
    results, extra = assignments(texts, 'udg_BazaarResultItem')
    materials, extra2 = assignments(texts, 'udg_DropItemIdTable')
    errors += extra + extra2
    f = units.get(BUTTON, {})
    for field, value in dict(ubpx=3, ubpy=2, ugol=0, ulum=0, ulev=0, upoi=0, umpm=0, uico=ICON).items():
        if f.get(field) != value:
            errors.append('recipe button missing/wrong field: ' + field)
    if 'Asud' not in units['n030'].get('uabi', '').split(','):
        errors.append('Bazaar shop cannot sell recipe button')
    for key, (gold, shards) in prices(archive, goods).items():
        for name, value in [('BazaarGoldCost', gold), ('BazaarShardCost', shards)]:
            if f'set {name}[{key}]={value}' not in source:
                errors.append(f'recipe {key}: browser price differs from bundle price')
    data = recipe_data(source)
    for recipe in map(int, goods):
        seen = set()
        for slot in range(3, 3+2*data[recipe, 1], 2):
            amount, material = data[recipe, slot], data[recipe, slot+1]
            if amount <= 0 or str(material) not in materials or material in seen:
                errors.append(f'recipe {recipe}: invalid/duplicate ingredient')
            seen.add(material)
        start = 4+2*data[recipe, 1]
        for slot in range(start, start+2*data[recipe, 2], 2):
            if str(data[recipe, slot]) not in results:
                errors.append(f'recipe {recipe}: invalid result')
    return errors


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--map', type=Path, required=True)
    args = parser.parse_args()
    errors = check(args.map)
    for error in errors[:20]:
        print('FAIL ' + error)
    print(('FAIL' if errors else 'PASS') + ' Bazaar browser: last slot, all recipes, ingredients and unchanged prices')
    return int(bool(errors))


if __name__ == '__main__':
    raise SystemExit(main())
