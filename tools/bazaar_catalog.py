"""Prepare a map's last-slot Bazaar recipe button and synchronize existing prices.

Run after armory_catalog.py on a fresh clone, or use the latest reviewed Reforged build.
python tools/bazaar_catalog.py BASE OUT
"""
import argparse
import copy
from pathlib import Path
import re

from armory_catalog import set_field
from check_save_compat import assignments
from mpq import MPQ, write_files
from objdata import fields, read_objects, write_objects
from source_checks import ROOT, sources

BUTTON = 'bRcp'
ICON = r'ReplaceableTextures\CommandButtons\BTNEngineeringUpgrade.blp'


def prepare(table):
    result = copy.deepcopy(table)
    units = {o['id'] or o['base']: o for g in ('original', 'custom') for o in result[g]}
    if BUTTON in units:
        raise ValueError('recipe button already exists; use a base without Bazaar browser objects')
    shop = units['n030']
    abilities = fields(shop)['uabi'].split(',')
    if 'Asud' not in abilities:
        abilities.append('Asud')
    set_field(shop, 'uabi', ','.join(abilities))
    button = copy.deepcopy(units['z012'])
    button['id'] = BUTTON
    for field, value in dict(unam='Recipes', utip='Browse recipes',
                             utub='Browse every bazaar recipe and its ingredients. Satisfied ingredients are green. Rewards stay hidden until crafted. Only your chosen recipe spends sold parts.',
                             uico=ICON, ugol=0, ulum=0, ulev=0, upoi=0, umpm=0,
                             ubpx=3, ubpy=2, usma=1, usrg=1, uhot='').items():
        set_field(button, field, value)
    result['custom'].append(button)
    return result


def prices(archive, goods):
    table = read_objects(archive.read('war3map.w3t'), 'w3t')
    items = {o['id'] or o['base']: o for g in ('original', 'custom') for o in table[g]}
    result = {}
    for key, raw in goods.items():
        obj = items[raw]
        f = fields(obj)
        if obj['base'] != 'sclp' or 'igol' not in f:
            raise ValueError('review inherited bundle costs: ' + raw)
        result[key] = (f['igol'], f.get('ilum', 0))
    return result


def sync_prices(costs):
    path = ROOT / 'src/triggers/05 Items crafting and shops/Bazaar.j'
    source = path.read_text(encoding='utf-8')
    lines = ['function Bazaar_InitBrowserData takes nothing returns nothing']
    for key, (gold, shards) in sorted(costs.items(), key=lambda pair: int(pair[0])):
        lines += [f'    set BazaarGoldCost[{key}]={gold}', f'    set BazaarShardCost[{key}]={shards}']
    lines.append('endfunction')
    source, count = re.subn(r'function Bazaar_InitBrowserData takes nothing returns nothing\n.*?^endfunction',
                            lambda m: '\n'.join(lines), source, flags=re.S | re.M)
    if count != 1:
        raise ValueError('expected one Bazaar_InitBrowserData function')
    path.write_bytes(source.replace('\n', '\r\n').encode('utf-8'))


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('base', type=Path)
    parser.add_argument('out', type=Path)
    args = parser.parse_args()
    _, texts = sources()
    goods, errors = assignments(texts, 'udg_BazaarGoodItem')
    if errors:
        raise ValueError(errors)
    archive = MPQ(str(args.base))
    table = read_objects(archive.read('war3map.w3u'), 'w3u')
    updated = prepare(table)
    costs = prices(archive, goods)
    args.out.parent.mkdir(parents=True, exist_ok=True)
    write_files(str(args.base), str(args.out), {'war3map.w3u': write_objects(updated, table['version'], 'w3u')})
    sync_prices(costs)
    print(f'Added last-slot recipe button; synchronized {len(costs)} unchanged bundle prices.')


if __name__ == '__main__':
    main()
