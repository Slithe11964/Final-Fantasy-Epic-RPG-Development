"""Build a new stage with automatic module selection and mandatory development gates.

python tools/build_stage.py T [--base release/previous-stage.w3x]
No release file is overwritten. Failed scratch builds/logs remain under build/.
"""
import argparse
from datetime import datetime, timezone
import hashlib
import json
from pathlib import Path
import platform
import re
import shutil
import subprocess
import sys
import tempfile

from source_checks import ROOT, sources, map_sources
from wct import text_of
from jtok import tokens
import check_map


def sha(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def outputs(stage, root=ROOT):
    if not re.fullmatch(r'[A-Z][A-Z0-9]*', stage):
        raise ValueError('stage must be uppercase letters/digits, starting with a letter (e.g. T, AA)')
    config = json.loads((root / 'tools/build-config.json').read_text(encoding='utf-8'))
    release = root / 'release'
    return (release / (config['prefix'] + stage + '.w3x'),
            release / ('checks-r16-stage' + stage + '.txt'),
            release / ('build-r16-stage' + stage + '.json'))


def refuse_existing(paths):
    for path in paths:
        if path.exists():
            raise ValueError('refusing to overwrite ' + str(path))


def changes(base):
    archive, wct, disabled = map_sources(base)
    entries, texts = sources()
    if len(entries) != len(wct['entries']) or any(e['index'] != i for i, e in enumerate(entries)):
        raise ValueError('trigger layout changed; use add_module/remove_module or World Editor and export first')
    if tokens((ROOT / 'src/map-header.j').read_text(encoding='utf-8')) != tokens(text_of(wct['header'])):
        raise ValueError('map-header.j changed; compile through World Editor and export before using this module builder')
    modified = []
    for entry in entries:
        if not entry.get('library'):
            continue
        embedded = text_of(wct['entries'][entry['index']])
        if not re.search(r'^\s*library\s+' + re.escape(entry['library']) + r'\b', embedded, re.M):
            raise ValueError('trigger layout/library mismatch: ' + entry['name'])
        if tokens(texts[entry['name']]) != tokens(embedded) and entry['name'] not in disabled:
            modified.append(entry['name'])
    from build_map import build_wct
    wct_bytes = build_wct(archive.read('war3map.wct'), str(ROOT / 'src'))
    return modified, wct_bytes != archive.read('war3map.wct')


def git_state():
    def run(*args):
        result = subprocess.run(['git', *args], cwd=ROOT, capture_output=True, text=True)
        if result.returncode:
            raise ValueError('cannot record Git state: ' + result.stderr.strip())
        return result.stdout.strip()
    return {'commit': run('rev-parse', 'HEAD'), 'status': run('status', '--short')}


def identity(path):
    path = Path(path).resolve()
    return {'path': str(path), 'sha256': sha(path)}


def main():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument('stage')
    p.add_argument('--base', type=Path, help='explicit baseline; its hash is recorded')
    p.add_argument('--allow-new')
    p.add_argument('--allow-removed')
    a = p.parse_args()
    scratch, lock, owns_lock = None, None, False
    logs = []
    try:
        config = json.loads((ROOT / 'tools/build-config.json').read_text(encoding='utf-8'))
        final, report, manifest_path = outputs(a.stage)
        refuse_existing((final, report, manifest_path))
        base = (a.base or ROOT / config['base']).resolve()
        if not a.base and sha(base) != config['base_sha256']:
            raise ValueError('configured baseline hash changed; supply the reviewed --base explicitly')
        if base.read_bytes()[:4] != b'HM3W':
            raise ValueError('baseline needs an HM3W header; finalize the map with add_header first')
        header_tool = (ROOT / config['header_tool']).resolve()
        if not header_tool.is_file():
            raise ValueError('missing sibling MapToolkit header tool: ' + str(header_tool))
        (ROOT / 'build').mkdir(exist_ok=True)
        lock = ROOT / 'build' / ('stage' + a.stage + '.lock')
        # Exclusive creation also protects builds in separate processes.
        with lock.open('x', encoding='utf-8') as f:
            f.write(datetime.now(timezone.utc).isoformat())
        owns_lock = True
        scratch = Path(tempfile.mkdtemp(prefix='stage' + a.stage + '-', dir=ROOT / 'build'))

        def run(script, *args):
            command = [sys.executable, str(script), *map(str, args)]
            label = Path(script).name
            logs.append('\n$ ' + subprocess.list2cmdline(command) + '\n')
            print('Running ' + label, flush=True)
            result = subprocess.run(command, cwd=ROOT, capture_output=True, text=True, errors='replace')
            output = result.stdout + result.stderr
            logs.append(output)
            (scratch / 'checks.txt').write_text(''.join(logs), encoding='utf-8')
            print(output, end='' if output.endswith('\n') else '\n', flush=True)
            if result.returncode:
                raise ValueError(f'{label} failed ({result.returncode}); release was not published')

        modules, editor_changed = changes(base)
        print('Changed enabled modules: ' + (', '.join(modules) or 'none'), flush=True)
        run(ROOT / 'tools/check_quests.py', '--map', base)
        run(ROOT / 'tools/check_save_compat.py', '--map', base)
        run(ROOT / 'tools/check_content.py', '--map', base)
        run(ROOT / 'tools/check_editor_sources.py', base)
        run(ROOT / 'tools/tests/run_tests.py')
        run(ROOT / 'tools/savecode.py', 'selftest')
        synced, ordered, ready = [scratch / name for name in ('synced.w3x', 'ordered.w3x', 'ready.w3x')]
        if modules:
            run(ROOT / 'tools/sync_module.py', base, synced, *modules)
        elif editor_changed:
            run(ROOT / 'tools/build_map.py', base, synced)
        else:
            shutil.copyfile(base, synced)
            logs.append('No source changes: copied the tested baseline without resyncing historical differences.\n')
        run(ROOT / 'tools/order_libraries.py', synced, ordered)
        # For a tooling-only stage, retain the exact tested archive if ordering changed no code.
        archive_unchanged = not modules and not editor_changed and map_sources(ordered)[0].read('war3map.j') == map_sources(base)[0].read('war3map.j')
        if archive_unchanged:
            shutil.copyfile(base, ordered)
            logs.append('Ordering changed no code; retained the exact tested MPQ archive.\n')
        extra = []
        for flag, value in [('--allow-new', a.allow_new), ('--allow-removed', a.allow_removed)]:
            if value:
                extra += [flag, value]
        run(ROOT / 'tools/check_map.py', ordered, '--baseline', base, *extra)
        run(ROOT / 'tools/check_sources.py', ordered)
        run(ROOT / 'tools/check_quests.py', '--map', ordered)
        run(ROOT / 'tools/check_save_compat.py', '--map', ordered)
        run(ROOT / 'tools/check_content.py', '--map', ordered)
        run(header_tool, ordered, ready, '--from', base, '--name', config['title'] + ' stage' + a.stage + ' (Reforged)')
        before, after = ordered.read_bytes(), ready.read_bytes()
        if before[before.index(b'MPQ\x1a'):] != after[after.index(b'MPQ\x1a'):]:
            raise ValueError('header finalization changed the checked MPQ archive')
        source_files = sorted((ROOT / 'src').rglob('*.j')) + [ROOT / 'src/trigger-list.json', ROOT / 'src/itemtable.txt']
        tool_files = sorted((ROOT / 'tools').rglob('*.py')) + sorted((ROOT / 'tools/contracts').glob('*.json')) + [ROOT / 'tools/build-config.json', ROOT / 'build.ps1', header_tool, ROOT / 'tools/tests/fixtures/savecodes.json']
        native = {name: identity(check_map.find(name, None)) for name in ['pjass', 'common.j', 'blizzard.j']}
        helper = ROOT.parent / 'Builder24/tools/JassHelper/jasshelper.exe'
        versions = {'python': platform.python_version(), 'python_executable': str(Path(sys.executable).resolve()),
                    'platform': platform.platform(), 'pjass': {**native['pjass'], 'version': 'no embedded version; SHA256 identifies the exact binary'},
                    'JassHelper': {'used': False, 'note': 'sync_module/vjass_lite used; binary identity if installed',
                                   'binary': identity(helper) if helper.is_file() else None}}
        manifest = {'stage': a.stage, 'built_utc': datetime.now(timezone.utc).isoformat(),
                    'base': identity(base), 'output': {'file': final.name, 'sha256': sha(ready)},
                    'archive_identical_to_base': archive_unchanged, 'modules_synced': modules,
                    'checks_sha256': hashlib.sha256(''.join(logs).encode()).hexdigest(),
                    'git': git_state(), 'versions': versions, 'native_inputs': native,
                    'source_sha256': {str(f.relative_to(ROOT)): sha(f) for f in source_files},
                    'tool_sha256': {str(f.relative_to(ROOT)) if f.is_relative_to(ROOT) else str(f): sha(f) for f in tool_files}}
        refuse_existing((final, report, manifest_path))
        final.parent.mkdir(exist_ok=True)
        with report.open('x', encoding='utf-8', newline='\n') as f:
            f.write(''.join(logs))
        with manifest_path.open('x', encoding='utf-8', newline='\n') as f:
            json.dump(manifest, f, indent=2); f.write('\n')
        with final.open('xb') as f:
            f.write(after)
        print('Published ' + str(final))
        print('Checks: ' + str(report) + '\nManifest: ' + str(manifest_path))
        return 0
    except (ValueError, OSError) as exc:
        print('BUILD STOPPED: ' + str(exc), file=sys.stderr)
        if scratch:
            print('Scratch files and logs: ' + str(scratch), file=sys.stderr)
        return 1
    finally:
        if owns_lock:
            lock.unlink()


if __name__ == '__main__':
    raise SystemExit(main())
