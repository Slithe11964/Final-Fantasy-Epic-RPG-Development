"""Check every enabled library body against embedded source and playable runtime.

Tested historical source/runtime differences are frozen as exact hash pairs, not
general exclusions. New source changes must match newly synced runtime bodies.
"""
import argparse
import json
from pathlib import Path
from source_checks import ROOT, runtime_agreement
import hashlib


def main():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument('map', type=Path)
    p.add_argument('--record-tested-baseline', action='store_true', help='initialize the historical-difference contract once; never used by builds')
    a = p.parse_args()
    observed = {} if a.record_tested_baseline else None
    errors, count = runtime_agreement(a.map, capture=observed)
    if a.record_tested_baseline:
        path = ROOT / 'tools/contracts/runtime-baseline-differences.json'
        if path.exists():
            p.error('contract already exists; review historical differences explicitly before changing it')
        # A capture may accept function-body differences, but never missing libraries/editor source.
        other = [e for e in errors if ': source/runtime body differs' not in e]
        if other:
            raise SystemExit('\n'.join(other))
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(json.dumps({'baseline': a.map.name, 'sha256': hashlib.sha256(a.map.read_bytes()).hexdigest(),
                                    'note': 'Exact existing differences in the user-tested stage S; no semantic equivalence is claimed.',
                                    'functions': observed}, indent=2) + '\n', encoding='utf-8')
        print(f'Recorded {len(observed)} historical hash pairs from the tested baseline.')
        return 0
    for error in errors[:40]:
        print('FAIL ' + error)
    print(f'{"FAIL" if errors else "PASS"} complete source/runtime agreement: {count} enabled library functions; {len(errors)} new differences')
    return int(bool(errors))


if __name__ == '__main__':
    raise SystemExit(main())
