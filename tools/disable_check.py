"""Can I switch these modules off? Simulates disabling triggers in World Editor and compiles.

    python tools/disable_check.py MAP.w3x MODULE [MODULE ...]
    python tools/disable_check.py MAP.w3x --all          (writes docs/DISABLING.md)

A disabled custom-text trigger is left out of the map entirely, so anything else that still uses
its functions or variables stops the World Editor save. This tool removes the module(s) the same
way, compiles the rest (vjass_lite + pjass) and reports:
  * OK                     - the map compiles without it; startup skips its registration
  * NEEDED BY <modules>    - the code that still uses it (fix or disable those too)
It also warns about ExecuteFunc("...") strings that name the module's functions, which only fail
in game. Compiling is not the same as playing: test the feature areas around what you disabled.
"""
import collections, json, os, re, subprocess, sys, tempfile
HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
from mpq import MPQ
from wct import read_wct, text_of
from vjass_lite import flatten, split_libraries, GLOBALS_RE
from jtok import strip_comments
import check_map

ROOT = os.path.dirname(HERE)

class Map:
    def __init__(self, path, pj, common, blizzard):
        m = MPQ(path)
        self.runtime = m.read('war3map.j').decode('utf-8').replace('\r\n', '\n')
        w = read_wct(m.read('war3map.wct'))
        self.header = text_of(w['header'])
        self.texts = [text_of(e).replace('\r\n', '\n') for e in w['entries'] if text_of(e)]
        self.lib_of = {}
        for i, t in enumerate(self.texts):
            lm = re.search(r'^\s*library\s+(\w+)', t, re.M)
            if lm:
                self.lib_of[lm.group(1)] = i
        self.pj, self.common, self.blizzard = pj, common, blizzard
        custom = set()
        hm = GLOBALS_RE.search(self.header.replace('\r\n', '\n'))
        if hm:
            custom |= {n for n, _ in check_map.declared(hm.group(1))}
        for t in self.texts:
            for gm in GLOBALS_RE.finditer(t.replace('\r\n', '\n')):
                custom |= {n for n, _ in check_map.declared(gm.group(1))}
        rg = re.search(r'^globals\n(.*?)^endglobals', self.runtime, re.M | re.S)
        self.generated = [(n, l) for n, l in check_map.declared(rg.group(1)) if n not in custom and not n.startswith('LIBRARY_')]
        self.tail = ('function Trig_MainDeprotected_Actions takes nothing returns nothing\ncall main_old()\nendfunction\n'
                     'function main takes nothing returns nothing\ncall Trig_MainDeprotected_Actions()\nendfunction\n'
                     'function config takes nothing returns nothing\nendfunction\n')

    def module_name(self, lib):
        if lib in self.lib_of:
            it = re.search(r'^function InitTrig_(\w+)', self.texts[self.lib_of[lib]], re.M)
            if it:
                return it.group(1)
        return lib[1:] if lib.startswith('T') else lib

    def compile_without(self, libs):
        drop = {self.lib_of[l] for l in libs}
        texts = [t for i, t in enumerate(self.texts) if i not in drop]
        dropped_trg = set()
        for l in libs:   # World Editor no longer declares gg_trg_<TriggerName> for a disabled trigger
            t = self.texts[self.lib_of[l]]
            it = re.search(r'^function InitTrig_(\w+)', t, re.M)
            if it:
                dropped_trg.add('gg_trg_' + it.group(1))
        gen = '\n'.join(l for n, l in self.generated if n not in dropped_trg) + '\n'
        where = collections.defaultdict(list)
        from vjass_lite import split_libraries as _split
        for lib, info in _split(texts)[0].items():
            for r in info['requires']:
                if r in libs and r not in info.get('optional', ()):
                    where[self.module_name(lib)].append('requires %s' % self.module_name(r))
        try:
            flat, _ = flatten(self.header, texts, extra_globals=gen, tail=self.tail, lenient=True)
        except ValueError as e:
            return False, [str(e)], where
        with tempfile.NamedTemporaryFile('w', suffix='.j', delete=False, encoding='utf-8') as f:
            f.write(flat); path = f.name
        r = subprocess.run([self.pj, self.common, self.blizzard, path], capture_output=True, text=True, errors='replace')
        os.unlink(path)
        errors = [l for l in (r.stdout + r.stderr).splitlines() if re.search(r':\d+:', l)]
        # which module does each error come from?
        marks = [(i + 1, m.group(1)) for i, line in enumerate(flat.split('\n')) for m in [re.match(r'^//library (\w+):$', line)] if m]
        for e in errors:
            ln = int(re.search(r':(\d+):', e).group(1))
            owner = 'map header / other'
            for start, lib in marks:
                if start <= ln:
                    owner = self.module_name(lib)
                else:
                    break
            where[owner].append(re.sub(r'^.*?:\d+:\s*', '', e))
        return r.returncode == 0 and not where, errors, where

    def also_stops(self, libs):
        """Modules whose triggers are only registered through a RegisterTriggers_* list in libs."""
        out = set()
        regs = {}
        for lib, i in self.lib_of.items():
            for f in re.findall(r'^function (Register_\w+) takes', self.texts[i], re.M):
                regs[f] = lib
        for l in libs:
            for f in re.findall(r'call (Register_\w+)\(', self.texts[self.lib_of[l]]):
                if regs.get(f) and regs[f] not in libs:
                    out.add(self.module_name(regs[f]))
        return sorted(out)

    def _exec_index(self):
        if not hasattr(self, '_execs'):
            self._execs = []      # (lib, function name, libraries whose static if guards the call)
            self._funcs = {}
            for lib, i in self.lib_of.items():
                guards = []
                for line in strip_comments(self.texts[i]).split('\n'):
                    s = line.strip()
                    m = re.match(r'^static if (.*) then$', s)
                    if m:
                        guards.append(set(re.findall(r'LIBRARY_(\w+)', m.group(1)))); continue
                    if s == 'endif' and guards and guards[-1] is not None:
                        guards.pop(); continue
                    for n in re.findall(r'ExecuteFunc\s*\(\s*"(\w+)"', s):
                        self._execs.append((lib, n, set().union(*guards) if guards else set()))
                for f in re.findall(r'^\s*function\s+(\w+)', strip_comments(self.texts[i]), re.M):
                    self._funcs[f] = lib
        return self._execs

    def string_refs(self, libs):
        out = collections.defaultdict(set)
        for lib, n, guard in self._exec_index():
            if lib in libs or self._funcs.get(n) not in libs or guard & set(libs):
                continue
            out[self.module_name(lib)].add(n)
        return out

def resolve(mp, name):
    if name in mp.lib_of:
        return name
    for lib in mp.lib_of:
        if mp.module_name(lib) == name:
            return lib
    if 'T' + name.replace('_', '') in mp.lib_of:
        return 'T' + name.replace('_', '')
    raise SystemExit('unknown module: ' + name)

def report(mp, names):
    libs = [resolve(mp, n) for n in names]
    ok, errors, where = mp.compile_without(libs)
    refs = mp.string_refs(libs)
    label = ', '.join(mp.module_name(l) for l in libs)
    if ok and not refs:
        print('OK: the map compiles without %s. Startup skips its registration automatically.' % label)
        stops = mp.also_stops(libs)
        if stops:
            print('  Note: it registers the triggers of %s, so those stop working too.' % ', '.join(stops))
    elif ok:
        print('COMPILES, but ExecuteFunc strings still name its functions (would fail in game):')
    else:
        print('NEEDED: %s is still used by other code. Disable or change these first:' % label)
    for mod, errs in sorted(where.items()):
        syms = sorted({re.sub(r'\.?\s*Maybe you meant.*$', '', re.sub(r'.*(?:Undeclared function|Undeclared variable|undefined|Undeclared)\s*', '', e)) for e in errs},
                      key=lambda x: (not x.startswith('requires'), x))
        print('  %s: %s' % (mod, ', '.join(syms[:8]) + (' ...' if len(syms) > 8 else '')))
    for mod, ns in sorted(refs.items()):
        print('  %s (ExecuteFunc): %s' % (mod, ', '.join(sorted(ns))))
    return ok and not refs

_MP = None
def _one(l):
    ok, errors, where = _MP.compile_without([l])
    return l, ok, where

def run_all(mp, out_path):
    global _MP
    _MP = mp
    rows = []
    libs = sorted(mp.lib_of)
    import multiprocessing
    with multiprocessing.Pool() as pool:
        results = {l: (ok, where) for l, ok, where in pool.imap_unordered(_one, libs)}
    for i, l in enumerate(libs):
        ok, where = results[l]
        refs = mp.string_refs([l])
        rows.append((mp.module_name(l), ok and not refs, sorted(where) + sorted('%s (ExecuteFunc)' % k for k in refs), mp.also_stops([l])))
        if (i + 1) % 50 == 0:
            print('%d/%d' % (i + 1, len(libs)), file=sys.stderr)
    keep_folders = ('01 Shared helpers', '02 Map setup', '10 Startup coordinator')
    try:
        folders = {e['name']: e['folder'] for e in json.load(open(os.path.join(ROOT, 'src', 'trigger-list.json'), encoding='utf-8'))}
    except OSError:
        folders = {}
    rows = [(n, ('keep' if folders.get(n) in keep_folders else ok), u, st) for n, ok, u, st in rows]
    ok_n = sum(1 for r in rows if r[1] is True)
    md = ['# Switching modules off', '',
          'Generated by `python tools/disable_check.py MAP --all`. For every module (World Editor trigger) the tool',
          'removed it, as World Editor does when you untick "Enabled", and compiled the rest.', '',
          '**%d of %d modules can be switched off on their own.** Startup skips their triggers automatically.' % (ok_n, len(rows)),
          'The others are still used by the modules listed. Switch those off too, or change them, first.', '',
          'Compiling is not the same as playing: after switching a module off, test the features around it.',
          'Check combinations with `python tools/disable_check.py MAP ModuleA ModuleB ...`.', '',
          'Modules in 01 Shared helpers, 02 Map setup and 10 Startup coordinator are map infrastructure',
          '(startup, world creation, shared helpers) and are marked "no" even when the map would still compile.', '',
          'Modules such as Quest, Boss or Fishing hold the startup lists that create their feature modules\' triggers;',
          'switching one of those off also stops the triggers listed under "Also stops".', '',
          '| Module | Can switch off alone | Still used by | Also stops |', '|---|---|---|---|']
    for name, ok, users, stops in sorted(rows, key=lambda r: r[0].lower()):
        md.append('| %s | %s | %s | %s |' % (name, {True: 'yes', False: 'no', 'keep': 'no - map infrastructure'}[ok], ', '.join(users[:10]) + (' +%d more' % (len(users) - 10) if len(users) > 10 else ''),
                                           ', '.join(stops[:8]) + (' +%d more' % (len(stops) - 8) if len(stops) > 8 else '')))
    open(out_path, 'w', encoding='utf-8').write('\n'.join(md) + '\n')
    print('%d of %d modules can be switched off alone; wrote %s' % (ok_n, len(rows), out_path))

if __name__ == '__main__':
    if len(sys.argv) < 3:
        sys.exit(__doc__)
    mp = Map(sys.argv[1], check_map.find('pjass', None), check_map.find('common.j', None), check_map.find('blizzard.j', None))
    if sys.argv[2] == '--all':
        run_all(mp, os.path.join(ROOT, 'docs', 'DISABLING.md'))
    else:
        sys.exit(0 if report(mp, sys.argv[2:]) else 1)
