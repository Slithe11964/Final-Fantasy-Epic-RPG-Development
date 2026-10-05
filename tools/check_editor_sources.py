"""Compile-check all repository editor modules, including disabled developer tools."""
from source_checks import ROOT, sources, map_sources
from wct import text_of
from vjass_lite import flatten, GLOBALS_RE
from check_map import declared, find, pjass
import argparse
import re


def main():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument('map')
    a = p.parse_args()
    archive, wct, _ = map_sources(a.map)
    _, texts = sources()
    header = (ROOT / 'src/map-header.j').read_text(encoding='utf-8')
    custom = set()
    for text in [header, *texts.values()]:
        for block in GLOBALS_RE.finditer(text):
            custom.update(n for n, _ in declared(block[1]))
    runtime = archive.read('war3map.j').decode('utf-8').replace('\r\n', '\n')
    block = re.search(r'^globals\n(.*?)^endglobals', runtime, re.M | re.S)
    generated = [line for name, line in declared(block[1]) if name not in custom and not name.startswith('LIBRARY_')]
    tail = 'function Trig_MainDeprotected_Actions takes nothing returns nothing\ncall main_old()\nendfunction\nfunction main takes nothing returns nothing\ncall Trig_MainDeprotected_Actions()\nendfunction\nfunction config takes nothing returns nothing\nendfunction\n'
    try:
        flat, order = flatten(header, list(texts.values()), extra_globals='\n'.join(generated) + '\n', tail=tail)
        ok, errors = pjass(find('pjass', None), find('common.j', None), find('blizzard.j', None), flat, 'all editor modules')
    except ValueError as exc:
        ok, errors = False, [str(exc)]
    for error in errors:
        print('FAIL ' + error)
    print(('PASS' if ok else 'FAIL') + ' all editor modules compile, including disabled developer tools')
    return int(not ok)


if __name__ == '__main__':
    raise SystemExit(main())
