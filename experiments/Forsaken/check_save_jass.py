"""Compile isolated codec and in-memory runtime/editor probes. Never writes a map."""
import argparse
import hashlib
import json
from pathlib import Path
import re
import subprocess
import sys
import tempfile

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
sys.path.insert(0, str(ROOT / 'tools'))
from check_map import declared
from mpq import MPQ
from vjass_lite import flatten, GLOBALS_RE
from wct import read_wct, text_of
from wtg import read_wtg


def identity(path):
    return dict(path=str(path.resolve()), sha256=hashlib.sha256(path.read_bytes()).hexdigest())


def check(map_path, common, blizzard, compiler):
    source_path = HERE / 'Forsaken-save-codec.j'
    source = source_path.read_text(encoding='utf-8')
    archive = MPQ(str(map_path))
    runtime = archive.read('war3map.j').decode('utf-8').replace('\r\n', '\n')
    wct = read_wct(archive.read('war3map.wct'))
    wtg = read_wtg(archive.read('war3map.wtg'))
    header = text_of(wct['header'])
    disabled = {i['name'] for i in wtg['items'] if i.get('kind') == 8 and not i.get('enabled', 1)}
    texts = [text_of(e) for e in wct['entries'] if text_of(e)]
    texts = [t for t in texts if not any(re.search(r'^\s*library\s+T%s\b' % re.escape(n), t, re.M)
                                        for n in disabled)]
    custom = set()
    for text in [header]+texts+[source]:
        for block in GLOBALS_RE.finditer(text.replace('\r\n', '\n')):
            custom.update(n for n, _ in declared(block.group(1)))
    runtime_globals = GLOBALS_RE.search(runtime).group(1)
    generated = [line for name, line in declared(runtime_globals)
                 if name not in custom and not name.startswith('LIBRARY_')]
    tail = ('function Trig_MainDeprotected_Actions takes nothing returns nothing\ncall main_old()\nendfunction\n'
            'function main takes nothing returns nothing\ncall Trig_MainDeprotected_Actions()\nendfunction\n'
            'function config takes nothing returns nothing\nendfunction\n')
    standalone, _ = flatten('', [source], tail='function main takes nothing returns nothing\nendfunction\n'
                             'function config takes nothing returns nothing\nendfunction\n')
    runtime_probe, _ = flatten(runtime, [source])
    editor_probe, _ = flatten(header, texts+[source], extra_globals='\n'.join(generated)+'\n', tail=tail)
    scratch = Path(tempfile.mkdtemp(prefix='save-codec-compile-', dir=ROOT / 'build'))
    report = dict(source=identity(source_path), map=identity(map_path), common=identity(common),
                  blizzard=identity(blizzard), compiler=identity(compiler),
                  disabled_editor_libraries=sorted(disabled), checks=[],
                  scope='Compilation probes only; map untouched, no codec wiring or engine execution.')
    for name, text in [('standalone', standalone), ('runtime-with-isolated-codec', runtime_probe),
                       ('editor-with-isolated-codec', editor_probe)]:
        path = scratch / (name+'.j')
        path.write_bytes(text.replace('\r\n', '\n').replace('\n', '\r\n').encode('utf-8'))
        result = subprocess.run([str(compiler), str(common), str(blizzard), str(path)],
                                capture_output=True, text=True, errors='replace')
        report['checks'].append(dict(name=name, passed=result.returncode == 0,
                                     script=identity(path), output=result.stdout+result.stderr))
    report['passed'] = all(row['passed'] for row in report['checks'])
    output = scratch / 'report.json'
    output.write_text(json.dumps(report, indent=2)+'\n', encoding='utf-8')
    return output, report


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--map', type=Path, required=True)
    parser.add_argument('--common', type=Path, required=True)
    parser.add_argument('--blizzard', type=Path, required=True)
    parser.add_argument('--compiler', type=Path, default=ROOT / 'tools/bin/pjass.exe')
    args = parser.parse_args()
    output, report = check(args.map.resolve(), args.common.resolve(), args.blizzard.resolve(), args.compiler.resolve())
    for row in report['checks']:
        print(('PASS ' if row['passed'] else 'FAIL ')+row['name'])
        if not row['passed']: print(row['output'])
    print('Report: '+str(output))
    return 0 if report['passed'] else 1


if __name__ == '__main__':
    raise SystemExit(main())
