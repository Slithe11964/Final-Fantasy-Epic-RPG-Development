"""Build a separate classic ATS diagnostic; never modify the gameplay source tree."""
from pathlib import Path
import os
import shutil
import subprocess
import sys
import tempfile

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT / 'tools'))
import add_module
from mpq import MPQ
from objdata import read_objects


def main():
    base = ROOT / 'release/FFERPG_0.9.7.3-r16-stageATS.w3x'
    output = ROOT / 'release/1.29.2/FFERPG_0.9.7.3-r16-ATS-StringProbe.w3x'
    if output.exists():
        raise ValueError('refusing to overwrite ' + str(output))
    work = Path(tempfile.mkdtemp(prefix='CheckpointStrings-', dir=ROOT / 'build'))
    shutil.copytree(ROOT / 'src', work / 'src')
    source = Path(__file__).with_name('CheckpointStrings.j').read_text(encoding='utf-8')
    target = work / 'src/triggers/12 Save system/CheckpointStrings.j'
    target.write_bytes(source.replace('\r\n', '\n').replace('\n', '\r\n').encode('utf-8'))
    original_root, arguments = add_module.ROOT, sys.argv
    try:
        add_module.ROOT = str(work)
        sys.argv = ['add_module.py', str(base), str(work / 'probe.w3x'),
                    '12 Save system', 'CheckpointStrings']
        add_module.main()
    finally:
        add_module.ROOT, sys.argv = original_root, arguments
    checked = subprocess.run([sys.executable, str(ROOT / 'tools/check_map.py'),
                              str(work / 'probe.w3x'), '--baseline', str(base),
                              '--allow-new', '^gg_trg_CheckpointStrings$'],
                             cwd=ROOT, capture_output=True, text=True)
    (work / 'checks.txt').write_text(checked.stdout + checked.stderr, encoding='utf-8')
    if checked.returncode:
        raise RuntimeError(checked.stdout + checked.stderr)
    old, new = MPQ(str(base)), MPQ(str(work / 'probe.w3x'))
    # The probe does not alter the objects, terrain, placed units, imports or map text.
    for name in old.read('(listfile)').decode('utf-8-sig').splitlines():
        if name.lower() not in {'war3map.j', 'war3map.wtg', 'war3map.wct', '(attributes)', '(listfile)'}:
            if old.read(name) != new.read(name):
                raise ValueError('unexpected archive change: ' + name)
    template = ROOT / 'baseline/1.29.2/FFERPG_0.9.7.3-r16.w3x'
    env = dict(os.environ)
    env['PATH'] = str(ROOT / 'tools/bin') + os.pathsep + env.get('PATH', '')
    converted = subprocess.run([sys.executable, str(ROOT / 'tools/downgrade.py'),
                                str(work / 'probe.w3x'), str(work / 'classic.w3x'),
                                '--w3i-template', str(template), '--fill-from', str(template),
                                '--name', 'ATS String Diagnostic', '--fferpg-visuals'],
                               cwd=ROOT, env=env, capture_output=True, text=True)
    (work / 'classic-checks.txt').write_text(converted.stdout + converted.stderr, encoding='utf-8')
    if converted.returncode:
        raise RuntimeError(converted.stdout + converted.stderr)
    normal = MPQ(str(ROOT / 'release/1.29.2/FFERPG_0.9.7.3-r16-stageATS.w3x'))
    probe = MPQ(str(work / 'classic.w3x'))
    for ext in ('w3a', 'w3u', 'w3t', 'w3q'):
        if read_objects(normal.read('war3map.' + ext), ext) != read_objects(probe.read('war3map.' + ext), ext):
            raise ValueError('classic object data changed: ' + ext)
    with output.open('xb') as destination:
        destination.write((work / 'classic.w3x').read_bytes())
    print('Diagnostic map:', output)


if __name__ == '__main__':
    main()
