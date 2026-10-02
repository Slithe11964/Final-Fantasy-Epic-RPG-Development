"""Automated checks for an FF Epic RPG map. Run after every change, before testing in game.

    python tools/check_map.py MAP.w3x [--baseline BASELINE.w3x] [--pjass PATH] [--common common.j --blizzard blizzard.j]

Checks:
  1. Playable script (war3map.j) passes pjass.
  2. Trigger-editor source (war3map.wct) compiles: libraries are flattened like JassHelper
     does (tools/vjass_lite.py) and the result passes pjass. World Editor's own Save As is
     still the final word.
  3. Startup wiring: every ExecuteFunc("Name") target exists; each RegisterTriggers_* group
     is started exactly once; each Register_* trigger helper is called exactly once; no
     function is defined twice.
  4. Source and playable script agree on the startup functions (main_old, Startup_*,
     RegisterTriggers_*, Register_*).
  5. Native save/load text safety: no compiled string literal over 1000 bytes. (An editor-saved
     map fails this until Build Play Copy has finalized it - that is expected.)
  6. With --baseline: tools/startup_audit.py comparison of the startup sequence.
Exit code 0 only when every check passes.
"""
import argparse, json, os, re, subprocess, sys, tempfile
HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
from mpq import MPQ
from wct import read_wct, text_of
from vjass_lite import flatten, GLOBALS_RE
from jtok import tokens, functions, strip_comments
import startup_audit

ROOT = os.path.dirname(HERE)
DEFAULT_TOOLS = [os.path.join(ROOT, 'tools', 'bin'), os.path.join(ROOT, '..', 'Builder24', 'tools', 'JassHelper')]

def find(name, explicit):
    if explicit:
        return explicit
    for d in DEFAULT_TOOLS + [ROOT, os.path.join(ROOT, '..')]:
        for cand in ((name + '.exe', name) if os.name == 'nt' else (name, name + '.exe')):
            p = os.path.join(d, cand)
            if os.path.exists(p):
                return p
    return name

def pjass(pj, common, blizzard, script_text, label):
    with tempfile.NamedTemporaryFile('w', suffix='.j', delete=False, encoding='utf-8') as f:
        f.write(script_text)
        path = f.name
    try:
        r = subprocess.run([pj, common, blizzard, path], capture_output=True, text=True, errors='replace')
    finally:
        os.unlink(path)
    out = (r.stdout + r.stderr).strip().splitlines()
    errors = [l for l in out if 'Parse successful' not in l and l.strip()]
    return r.returncode == 0, errors[:30]

DECL = re.compile(r'^\s*(?:constant\s+)?\w+\s+(?:array\s+)?(\w+)')

def declared(globals_text):
    names = []
    for l in globals_text.split('\n'):
        l = l.split('//')[0].strip()
        if l:
            m = DECL.match(l)
            if m:
                names.append((m.group(1), l))
    return names

def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument('map'); ap.add_argument('--baseline')
    ap.add_argument('--pjass'); ap.add_argument('--common'); ap.add_argument('--blizzard')
    ap.add_argument('--runtime', help='check this war3map.j instead of the one inside the map')
    a = ap.parse_args()
    pj = find('pjass', a.pjass)
    common = find('common.j', a.common); blizzard = find('blizzard.j', a.blizzard)
    m = MPQ(a.map)
    runtime = open(a.runtime, encoding='utf-8').read() if a.runtime else m.read('war3map.j').decode('utf-8')
    runtime_lf = runtime.replace('\r\n', '\n')
    w = read_wct(m.read('war3map.wct'))
    header = text_of(w['header'])
    texts = [text_of(e) for e in w['entries'] if text_of(e)]
    results = {}

    ok, err = pjass(pj, common, blizzard, runtime, 'runtime')
    results['1 playable script compiles (pjass)'] = (ok, err)

    # 2. source compile
    hm = GLOBALS_RE.search(header.replace('\r\n', '\n'))
    custom = {n for n, _ in declared(hm.group(1))} if hm else set()
    for t in texts:
        for gm in GLOBALS_RE.finditer(t.replace('\r\n', '\n')):
            custom |= {n for n, _ in declared(gm.group(1))}
    rg = re.search(r'^globals\n(.*?)^endglobals', runtime_lf, re.M | re.S)
    generated = [l for n, l in declared(rg.group(1)) if n not in custom and not n.startswith('LIBRARY_')]
    tail = ('function Trig_MainDeprotected_Actions takes nothing returns nothing\ncall main_old()\nendfunction\n'
            'function main takes nothing returns nothing\ncall Trig_MainDeprotected_Actions()\nendfunction\n'
            'function config takes nothing returns nothing\nendfunction\n')
    try:
        flat, order = flatten(header, texts, extra_globals='\n'.join(generated) + '\n', tail=tail)
        ok, err = pjass(pj, common, blizzard, flat, 'source')
    except ValueError as e:
        ok, err = False, [str(e)]
    results['2 trigger-editor source compiles (vjass_lite + pjass)'] = (ok, err)

    # 3. wiring
    code = strip_comments(runtime_lf)
    names = re.findall(r'^\s*(?:constant\s+)?function\s+(\w+)', code, re.M)
    errs = []
    dup = sorted({n for n in names if names.count(n) > 1}) if len(set(names)) != len(names) else []
    if dup:
        errs.append('functions defined more than once: %s' % dup[:10])
    defined = set(names)
    execs = re.findall(r'ExecuteFunc\s*\(\s*"(\w+)"\s*\)', code)
    errs += ['ExecuteFunc target does not exist: ' + n for n in sorted(set(execs) - defined)]
    from collections import Counter
    calls = Counter(re.findall(r'\bcall\s+(\w+)\s*\(', code))
    ex = Counter(execs)
    for n in sorted(defined):
        if n.startswith('RegisterTriggers_') or n.startswith('RegisterR11_') or n.startswith('RegisterLegacy_'):
            c = ex[n] + calls[n]
            if c != 1 and not (c == 0 and n.startswith('RegisterLegacy_')):
                errs.append('%s is started %d times (expected once)' % (n, c))
        elif n.startswith('Register_'):
            c = calls[n] + ex[n]
            if c != 1:
                errs.append('%s is called %d times (expected once)' % (n, c))
    # trigger variables assigned by more than one function that is actually used
    refs = Counter(re.findall(r'\bfunction\s+(\w+)\b(?!\s+takes)', code))
    created = []
    for fm in re.finditer(r'^\s*function\s+(\w+)\s+takes.*?^\s*endfunction', code, re.M | re.S):
        f = fm.group(1)
        if f == 'main_old' or calls[f] or ex[f] or refs[f]:
            created += re.findall(r'set\s+(gg_trg_\w+)\s*=\s*CreateTrigger\(\)', fm.group(0))
    cc = Counter(created)
    multi = sorted(t for t, k in cc.items() if k > 1)
    if multi:
        errs.append('triggers created more than once: %s' % multi[:10])
    results['3 startup wiring'] = (not errs, errs[:30])

    # 4. source/runtime agreement on startup functions
    from vjass_lite import resolve_static_ifs, split_libraries
    present = set(split_libraries(texts)[0])
    src_funcs = {}
    for t in texts:
        src_funcs.update(functions(resolve_static_ifs(t.replace('\r\n', '\n'), present)))
    rt_funcs = functions(runtime_lf)
    pat = re.compile(r'^(main_old|Startup_\w+|RegisterTriggers_\w+|Register_\w+|RegisterR11_\w+|RegisterLegacy_\w+)$')
    errs = []
    for n, body in src_funcs.items():
        if pat.match(n):
            if n not in rt_funcs:
                errs.append('in source but not in playable script: ' + n)
            elif tokens(body) != tokens(rt_funcs[n]):
                errs.append('source and playable script differ: ' + n)
    for n in rt_funcs:
        if pat.match(n) and n not in src_funcs:
            errs.append('in playable script but not in source: ' + n)
    results['4 source matches playable script (startup functions)'] = (not errs, errs[:30])

    # 4b. globals: every variable declared in the source has the same declaration in the playable script
    def gdecls(text):
        out = {}
        for gm2 in GLOBALS_RE.finditer(text.replace('\r\n', '\n')):
            for l in gm2.group(1).split('\n'):
                c = strip_comments(l).strip()
                mm = re.match(r'^(constant\s+)?(\w+)\s+(array\s+)?(\w+)\s*(?:=(.*))?$', c)
                if mm:
                    init = re.sub(r'"\s*\+\s*"', '', mm.group(5) or '')
                    out[mm.group(4)] = (bool(mm.group(1)), mm.group(2), bool(mm.group(3)), tuple(tokens(init)))
        return out
    sg = gdecls(header)
    for t in texts:
        sg.update(gdecls(t))
    rg_all = gdecls(runtime_lf[:runtime_lf.index('\nendglobals') + 12])
    # Variable Editor variables: World Editor declares them (udg_ + name); compare type only
    from wtg import read_wtg
    for v in read_wtg(m.read('war3map.wtg'))['variables']:
        n = 'udg_' + v['name']
        sg[n] = rg_all.get(n, sg.get(n))
        if n not in rg_all or rg_all[n][1] != v['type'] or rg_all[n][2] != bool(v['is_array']):
            sg[n] = ('variable editor', v['type'], bool(v['is_array']), ())
    errs = ['declared in source but missing from playable script: ' + n for n in sorted(set(sg) - set(rg_all))]
    errs += ['declared differently in source and playable script: ' + n for n in sorted(set(sg) & set(rg_all)) if sg[n] != rg_all[n]]
    errs += ['playable script declares udg_ variable missing from source: ' + n for n in sorted(set(rg_all) - set(sg)) if n.startswith('udg_')]
    results['4b globals match playable script'] = (not errs, errs[:30])

    # 5. literal size
    big = [s for s in re.findall(r'"(?:\\.|[^"\\])*"', code) if len(s.encode('utf-8')) > 1000]
    unfinal = [n for n, b in functions(runtime_lf).items() if n.startswith('ModuleLongText_') and not re.search(r'return\s+"TRIGSTR_\d+"', b)]
    msgs = []
    if big:
        msgs.append('%d string literal(s) over 1000 bytes' % len(big))
    if unfinal:
        msgs.append('long quest text not finalized (%s)' % ', '.join(unfinal))
    wts_ids = set(int(x) for x in re.findall(r'^STRING (\d+)', m.read('war3map.wts').decode('utf-8-sig', 'replace'), re.M))
    missing = sorted(set(int(x) for x in re.findall(r'"TRIGSTR_(\d+)"', code)) - wts_ids)
    if missing:
        msgs.append('text references missing from the string table: %s' % missing[:10])
    if msgs and not missing:
        msgs.append('-> keep long text in GUI actions (see the QuestLog_Entries trigger), or run Build Play Copy on this map before playing; native saved games crash otherwise')
    results['5 native save/load text safety'] = (not msgs, msgs)

    if a.baseline:
        r = startup_audit.audit(startup_audit.load_script(a.baseline), runtime)
        results['6 startup sequence matches baseline'] = (r.get('passed', False),
            r['failures'][:20] or ['%d triggers checked, %d independent trigger pairs reordered' % (r.get('triggers_checked', 0), r.get('reordered_independent_pairs', 0))])

    all_ok = True
    for k, (ok, details) in results.items():
        all_ok &= ok
        print(('PASS ' if ok else 'FAIL ') + k)
        for d in details:
            print('     ' + d)
    sys.exit(0 if all_ok else 1)

if __name__ == '__main__':
    main()
