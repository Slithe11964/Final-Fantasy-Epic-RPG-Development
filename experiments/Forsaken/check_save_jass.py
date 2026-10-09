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


def check(map_path, common, blizzard, compiler, include_life=False, include_native=False, include_position=False, include_equipment=False, include_recovery=False, include_progression=False, include_heroes=False, include_session=False, include_units=False, include_references=False, include_body=False, include_ownership=False, include_prepared_heroes=False, include_activation=False, include_job_policy=False, include_gaya_policy=False):
    include_prepared_heroes = include_prepared_heroes or include_gaya_policy
    include_prepared_heroes = include_prepared_heroes or include_job_policy
    include_prepared_heroes = include_prepared_heroes or include_activation
    include_ownership = include_ownership or include_prepared_heroes
    include_body = include_body or include_ownership
    include_references = include_references or include_body
    include_units = include_units or include_references
    include_session = include_session or include_units
    include_heroes = include_heroes or include_session
    include_progression = include_progression or include_heroes
    include_recovery = include_recovery or include_progression
    source_path = HERE / 'Forsaken-save-codec.j'
    source_paths = [source_path]
    if include_life or include_native or include_position or include_equipment or include_recovery:
        source_paths.append(HERE / 'Forsaken-save-life.j')
    if include_native or include_position or include_equipment or include_recovery:
        source_paths.append(HERE / 'Forsaken-save-native.j')
    if include_position or include_equipment or include_recovery:
        source_paths.extend([HERE / 'Forsaken-save-journal.j', HERE / 'Forsaken-save-effects.j', HERE / 'Forsaken-save-position.j'])
    if include_equipment or include_recovery:
        source_paths.append(HERE / 'Forsaken-save-equipment.j')
    if include_recovery:
        source_paths.append(HERE / 'Forsaken-save-recovery.j')
    if include_progression:
        source_paths.append(HERE / 'Forsaken-save-progression.j')
    if include_heroes:
        source_paths.append(HERE / 'Forsaken-save-heroes.j')
    if include_session:
        source_paths.append(HERE / 'Forsaken-save-session.j')
    if include_units:
        source_paths.append(HERE / 'Forsaken-save-units.j')
    if include_references:
        source_paths.append(HERE / 'Forsaken-save-references.j')
    if include_body:
        source_paths.append(HERE / 'Forsaken-save-body.j')
    if include_ownership:
        source_paths.append(HERE / 'Forsaken-save-ownership.j')
    if include_prepared_heroes:
        source_paths.append(HERE / 'Forsaken-save-prepared-heroes.j')
    if include_activation:
        source_paths.append(HERE / 'Forsaken-save-activation.j')
    if include_job_policy:
        source_paths.append(HERE / 'Forsaken-save-job-policy.j')
    if include_gaya_policy:
        source_paths.append(HERE / 'Forsaken-save-gaya-policy.j')
    sources = [path.read_text(encoding='utf-8') for path in source_paths]
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
    for text in [header]+texts+sources:
        for block in GLOBALS_RE.finditer(text.replace('\r\n', '\n')):
            custom.update(n for n, _ in declared(block.group(1)))
    runtime_globals = GLOBALS_RE.search(runtime).group(1)
    generated = [line for name, line in declared(runtime_globals)
                 if name not in custom and not name.startswith('LIBRARY_')]
    tail = ('function Trig_MainDeprotected_Actions takes nothing returns nothing\ncall main_old()\nendfunction\n'
            'function main takes nothing returns nothing\ncall Trig_MainDeprotected_Actions()\nendfunction\n'
            'function config takes nothing returns nothing\nendfunction\n')
    # Standalone only: declarations come from the actual map, never guessed stubs.
    isolated_globals = {name for source in sources for block in GLOBALS_RE.finditer(source)
                        for name, _ in declared(block.group(1))}
    runtime_declarations = dict(declared(runtime_globals))
    used_tokens = set(re.findall(r'\b[A-Za-z_]\w*\b', '\n'.join(sources)))
    external = ((used_tokens & runtime_declarations.keys()) |
                set(re.findall(r'\budg_\w+\b', '\n'.join(sources)))) - isolated_globals
    external_lines = {name: line for name, line in runtime_declarations.items() if name in external}
    if external - external_lines.keys():
        raise ValueError('missing runtime globals: '+str(sorted(external - external_lines.keys())))
    standalone, _ = flatten('', sources, extra_globals='\n'.join(external_lines.values())+'\n', tail='function main takes nothing returns nothing\nendfunction\n'
                             'function config takes nothing returns nothing\nendfunction\n')
    runtime_probe, _ = flatten(runtime, sources)
    editor_probe, _ = flatten(header, texts+sources, extra_globals='\n'.join(generated)+'\n', tail=tail)
    scratch = Path(tempfile.mkdtemp(prefix='save-codec-compile-', dir=ROOT / 'build'))
    report = dict(source=identity(source_path), sources=[identity(path) for path in source_paths],
                  map=identity(map_path), common=identity(common),
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
    parser.add_argument('--life', action='store_true', help='include the isolated real/word conversion module')
    parser.add_argument('--native', action='store_true', help='include life and modern-client hidden item staging')
    parser.add_argument('--position', action='store_true', help='include native staging, item journal and storage placement')
    parser.add_argument('--equipment', action='store_true', help='include all save modules and prepared equipment placement')
    parser.add_argument('--recovery', action='store_true', help='include all modules and original-item quarantine/recovery')
    parser.add_argument('--progression', action='store_true', help='include original items and live progression table/force recovery')
    parser.add_argument('--heroes', action='store_true', help='include original hero progression, ability ranks and stat readback')
    parser.add_argument('--session', action='store_true', help='include talent/session and prior accepted-code recovery')
    parser.add_argument('--units', action='store_true', help='include owned replacement-unit allocation and cleanup')
    parser.add_argument('--references', action='store_true', help='include reversible staged hero reference switching')
    parser.add_argument('--body', action='store_true', help='include living original hero body recovery')
    parser.add_argument('--ownership', action='store_true', help='include reversible contained replacement ownership preparation')
    parser.add_argument('--prepared-heroes', action='store_true', help='include owned replacement core/ability preparation')
    parser.add_argument('--activation', action='store_true', help='include reversible empty replacement-pair exposure')
    parser.add_argument('--job-policy', action='store_true', help='include normal saved-job mastery/core planning bridge')
    parser.add_argument('--gaya-policy', action='store_true', help='include saved Gaya support/chant planning bridge')
    args = parser.parse_args()
    output, report = check(args.map.resolve(), args.common.resolve(), args.blizzard.resolve(), args.compiler.resolve(), args.life, args.native, args.position, args.equipment, args.recovery, args.progression, args.heroes, args.session, args.units, args.references, args.body, args.ownership, args.prepared_heroes, args.activation, args.job_policy, args.gaya_policy)
    for row in report['checks']:
        print(('PASS ' if row['passed'] else 'FAIL ')+row['name'])
        if not row['passed']: print(row['output'])
    print('Report: '+str(output))
    return 0 if report['passed'] else 1


if __name__ == '__main__':
    raise SystemExit(main())
