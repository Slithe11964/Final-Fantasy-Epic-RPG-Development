"""Preservation audit for an armory stage against the public paired r16 baseline."""
import argparse
import hashlib
import json
from pathlib import Path
import sys

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
from source_checks import ROOT
from mpq import MPQ
from objdata import read_objects
from jtok import functions, tokens
from check_armory import check


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--stage', default='AD')
    args = parser.parse_args()
    if not args.stage.isalpha() or not args.stage.isupper():
        parser.error('expected an uppercase stage name')
    base = ROOT / 'baseline/Reforged/FFERPG_0.9.7.3-r16.w3x'
    final = ROOT / f'release/FFERPG_0.9.7.3-r16-stage{args.stage}.w3x'
    classic = ROOT / f'release/1.29.2/FFERPG_0.9.7.3-r16-stage{args.stage}.w3x'
    a, b = MPQ(str(base)), MPQ(str(final))
    names = set(a.read('(listfile)').decode().splitlines()) | set(b.read('(listfile)').decode().splitlines())
    changed = sorted(n for n in names if a.read(n) != b.read(n))
    assert set(changed) <= {'war3map.j', 'war3map.wct', 'war3map.w3u'}, changed
    old = read_objects(a.read('war3map.w3u'), 'w3u')
    new = read_objects(b.read('war3map.w3u'), 'w3u')
    assert old['original'] == new['original']
    for before_obj, after_obj in zip(old['custom'], new['custom']):
        for obj in (before_obj, after_obj):
            for group in obj['sets']:
                group['mods'][:] = [m for m in group['mods'] if m['field'] not in ('ubpx', 'ubpy')]
        assert before_obj == after_obj
    assert len(new['custom']) - len(old['custom']) == 276
    before = functions(a.read('war3map.j').decode('utf-8'))
    after = functions(b.read('war3map.j').decode('utf-8'))
    different = sorted(name for name in before if tokens(before[name]) != tokens(after.get(name, '')))
    assert all(name.startswith('Trig_Armory_') for name in different), different
    assert not set(before) - set(after)
    assert not check(final) and not check(classic)
    report = dict(changed_assets=changed, changed_runtime_functions=different,
                  new_runtime_functions=sorted(set(after) - set(before)),
                  original_unit_objects_preserved_except_stock_positions=True, added_unit_objects=276,
                  outside_armory_functions_unchanged=True,
                  hashes={str(p.relative_to(ROOT)): hashlib.sha256(p.read_bytes()).hexdigest()
                          for p in [base, final, classic]})
    (ROOT / f'release/preservation-r16-stage{args.stage}.json').write_text(json.dumps(report, indent=2)+'\n', encoding='utf-8')
    print('PASS preservation: only armory runtime/editor source and 276 added hint units and stock button positions differ.')


if __name__ == '__main__':
    main()
