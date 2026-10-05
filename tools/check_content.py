"""Check typed literal item/unit/ability references and duplicate map object IDs.

Unmodified stock IDs absent from map object tables cannot be resolved here. Exact
unresolved calls from tested stage S are recorded by location/count; new unresolved
calls are rejected. This does not infer computed rawcodes or dynamic references.
"""
import argparse
from collections import Counter
import hashlib
import json
from pathlib import Path
import re
from source_checks import ROOT, sources, calls, object_ids
from jtok import functions

CONTRACT = ROOT / 'tools/contracts/content-references.json'
# Native/BJ signatures identify the argument's object kind; no prefix guessing.
TYPED = {
    'CreateItem': ('item', 0), 'CreateItemLoc': ('item', 0),
    'UnitAddItemById': ('item', 1), 'UnitAddItemByIdSwapped': ('item', 0),
    'UnitAddItemToSlotById': ('item', 1), 'GetItemOfTypeFromUnitBJ': ('item', 1),
    'UnitHasItemOfTypeBJ': ('item', 1), 'Quest_Deliver': ('item', 2),
    'CreateUnit': ('unit', 1), 'CreateUnitAtLoc': ('unit', 1),
    'CreateNUnitsAtLoc': ('unit', 1), 'CreateNUnitsAtLocFacingLocBJ': ('unit', 1),
    'Quest_HuntTarget': ('unit', 1),
    'UnitAddAbility': ('ability', 1), 'UnitRemoveAbility': ('ability', 1),
    'SetUnitAbilityLevel': ('ability', 1), 'GetUnitAbilityLevel': ('ability', 1),
    'IncUnitAbilityLevel': ('ability', 1), 'DecUnitAbilityLevel': ('ability', 1),
    'BlzGetUnitAbility': ('ability', 1), 'UnitMakeAbilityPermanent': ('ability', 2),
    'SetPlayerAbilityAvailable': ('ability', 1),
}


def references(texts):
    result = Counter()
    for module, text in texts.items():
        for fn, body in functions(text).items():
            for _, api, args in calls(body):
                if api not in TYPED:
                    continue
                kind, arg = TYPED[api]
                if len(args) > arg and re.fullmatch(r"'[^']{4}'", args[arg]):
                    result[(module, fn, api, kind, args[arg][1:-1])] += 1
    return result


def unresolved(texts, ids):
    out = {}
    for key, count in references(texts).items():
        known = ids.get(key[-2], set())
        # These natives also accept buff IDs (e.g. removing a stun/debuff).
        if key[2] in ('UnitRemoveAbility', 'GetUnitAbilityLevel'):
            known = known | ids.get('buff', set())
        if key[-1] not in known:
            out['/'.join(key)] = count
    return out


def compare(current, baseline):
    return [f'{key}: unresolved {count} call(s), tested baseline allows {baseline.get(key, 0)}'
            for key, count in current.items() if count > baseline.get(key, 0)]


def main():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument('--map', type=Path, required=True)
    p.add_argument('--record-tested-baseline', action='store_true')
    a = p.parse_args()
    _, texts = sources()
    ids, _, errors = object_ids(a.map)
    unknown = unresolved(texts, ids)
    if a.record_tested_baseline:
        if CONTRACT.exists() or errors:
            p.error('contract exists or duplicate object IDs found; baseline not recorded')
        CONTRACT.parent.mkdir(exist_ok=True)
        CONTRACT.write_text(json.dumps({'baseline': a.map.name, 'sha256': hashlib.sha256(a.map.read_bytes()).hexdigest(),
                                        'note': 'Exact existing unresolved typed literal calls; includes stock IDs absent from map modifications. No validity claim for unresolved IDs.',
                                        'unresolved': unknown}, indent=2) + '\n', encoding='utf-8')
        print(f'Recorded {len(unknown)} existing unresolved reference locations.')
        return 0
    errors += compare(unknown, json.loads(CONTRACT.read_text(encoding='utf-8'))['unresolved'])
    for error in errors[:40]:
        print('FAIL ' + error)
    print(f"{'FAIL' if errors else 'PASS'} object IDs and typed literal references: {sum(references(texts).values())} calls, {len(unknown)} preserved unresolved locations")
    return int(bool(errors))


if __name__ == '__main__':
    raise SystemExit(main())
