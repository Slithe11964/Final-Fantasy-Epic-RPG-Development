"""Phase 2: make startup readable. Kept as a record of exactly what changed.

    python tools/refactor/phase2_startup.py SRC_DIR BASE_RUNTIME.j OUT_RUNTIME.j

1. main_old (3,700+ lines) becomes a short list of named startup steps (Startup_* functions in
   MapBootstrap). Statements keep their exact order; player tech rules become one
   function called once per player in the original order.
2. The 1,602 per-trigger helpers RegisterR11_<Trigger> are renamed Register_<Trigger>; their
   unused "udg_InitTrigFromMain" guard is removed (nothing else ever called them).
3. Each module gets RegisterTriggers_<Module> (or _Part1.._PartN) that registers its triggers
   in their original order. Startup_RegisterTriggers calls these once each with ExecuteFunc,
   so each module still runs in its own thread, like before. A module is split into parts only
   where keeping it in one piece would change the firing order of triggers that react to
   the same event (or touch each other's trigger variables).
The same edits are applied to the compiled runtime (war3map.j) so the map is playable
without an editor save. tools/startup_audit.py proves the result against the baseline.
"""
import json, os, re, sys
HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, os.path.dirname(HERE))
from jfmt import reindent_function
from jtok import tokens, FUNC
from startup_audit import trigger_profile, conflict, norm

def lf(s): return s.replace('\r\n', '\n')
def crlf(s): return lf(s).replace('\n', '\r\n')

def load_src(src):
    entries = json.load(open(os.path.join(src, 'trigger-list.json'), encoding='utf-8'))
    mods = {}
    for e in entries:
        if e.get('library'):
            p = os.path.join(src, 'triggers', e['folder'], e['name'] + '.j')
            mods[e['name']] = dict(entry=e, path=p, text=lf(open(p, encoding='utf-8', newline='').read()))
    header_path = os.path.join(src, 'map-header.j')
    return entries, mods, header_path, lf(open(header_path, encoding='utf-8', newline='').read())

def func_map(text):
    return {m.group(1): m for m in FUNC.finditer(text)}

def body_lines(ftext):
    return [l.strip() for l in ftext.split('\n')[1:-1] if l.strip()]

GUARD = ['if not udg_InitTrigFromMain then', 'return', 'endif']

def plan_groups(segment, helper_info):
    """Greedy: a helper joins the latest group of its module if it does not have to jump
    over any helper it conflicts with. Returns [[module, [helpers]]]."""
    groups = []
    for h in segment:
        mod = helper_info[h]['module']
        idx = next((i for i in range(len(groups) - 1, -1, -1) if groups[i][0] == mod), None)
        ok = idx is not None and all(not conflict(helper_info[h]['profile'], helper_info[h2]['profile'])
                                     for g in groups[idx + 1:] for h2 in g[1])
        if ok:
            groups[idx][1].append(h)
        else:
            groups.append([mod, [h]])
    return groups

def indent(lines, base=1):
    text = 'function X takes nothing returns nothing\n' + '\n'.join(lines) + '\nendfunction'
    return reindent_function(text).split('\n')[1:-1]

def make_function(name, doc, lines, takes='nothing', locals_=()):
    out = ['// ' + d if d else '//' for d in doc]
    out.append('function %s takes %s returns nothing' % (name, takes))
    out += ['    local ' + l for l in locals_]
    out += indent(lines)
    out.append('endfunction')
    return '\n'.join(out)

def used_locals(lines, decls):
    used = []
    for typ, name in decls:
        pat = re.compile(r'\b%s\b' % re.escape(name))
        hits = [l for l in lines if pat.search(re.sub(r"'[^']*'", "''", re.sub(r'"(?:\\.|[^"\\])*"', '""', l)))]
        if hits:
            first = re.sub(r"'[^']*'", "''", re.sub(r'"(?:\\.|[^"\\])*"', '""', hits[0]))
            if not re.match(r'^set\s+%s\s*=' % re.escape(name), first):
                raise SystemExit('local %s is read before it is set in a startup step: %s' % (name, hits[0]))
            used.append('%s %s' % (typ, name))
    return used

def main(src, base_runtime, out_runtime):
    entries, mods, header_path, header = load_src(src)
    folder_of = {n: m['entry']['folder'] for n, m in mods.items()}
    lib_of = {n: m['entry']['library'] for n, m in mods.items()}
    # ---- helpers -------------------------------------------------------------------
    helper_info = {}
    for name, m in mods.items():
        for fname, fm in func_map(m['text']).items():
            if fname.startswith('RegisterR11_'):
                lines = body_lines(fm.group(0))
                assert lines[:3] == GUARD, fname
                trig = fname[len('RegisterR11_'):]
                assert lines[3] == 'set gg_trg_%s=CreateTrigger()' % trig, fname
                stmts = [norm(l, {}) for l in lines[3:] if not l.startswith('//')]
                helper_info[fname] = dict(module=name, trigger=trig, lines=lines[3:],
                                          profile=trigger_profile(stmts), new='Register_' + trig)
    # ---- main_old ------------------------------------------------------------------
    boot = mods['MapBootstrap']
    mo = func_map(boot['text'])['main_old']
    lines = body_lines(mo.group(0))
    decls = [tuple(l.split()[1:3]) for l in lines if l.startswith('local ')]
    code = [l for l in lines if not l.startswith('local ') and l != 'set udg_InitTrigFromMain=true']
    assert not any(l.startswith('//') for l in code)
    def idx(pred, start=0):
        return next(i for i in range(start, len(code)) if pred(code[i]))
    is_exec = lambda l: l.startswith('call ExecuteFunc(')
    is_helper_exec = lambda l: re.match(r'call ExecuteFunc\("RegisterR11_\w+"\)$', l) is not None
    i_snd = idx(lambda l: l.startswith('set gg_snd_'))
    i_tech = idx(lambda l: l.startswith('call SetPlayerTech'))
    i_dest = idx(lambda l: not l.startswith('call SetPlayerTech'), i_tech)
    i_units = idx(lambda l: l == 'call Units_CreateNeutralPassiveBuildings()')
    i_bj = idx(lambda l: l.startswith('set udg_FilterTrue='))
    assert code[i_bj - 1] == 'call ConfigureNeutralVictim()'
    i_shared = idx(is_exec)
    assert code[i_shared - 1] == 'call DetectGameStarted()'
    i_spells = idx(lambda l: not is_exec(l), i_shared)
    i_players = idx(lambda l: l == 'set udg_PlayingPlayers=CreateForce()')
    i_state = max(i for i in range(i_spells, i_players) if code[i].startswith('call Preload(')) + 1
    assert code[i_state] == 'set i=0'
    i_reg = idx(is_helper_exec)
    i_reg_end = max(i for i, l in enumerate(code) if is_helper_exec(l)) + 1
    assert all(not is_helper_exec(l) for l in code[:i_reg])
    sec = dict(env=code[:i_snd], sounds=code[i_snd:i_tech], tech=code[i_tech:i_dest], dest=code[i_dest:i_units],
               units=code[i_units:i_bj], bj=code[i_bj:i_shared], shared=code[i_shared:i_spells],
               spells=code[i_spells:i_state], state=code[i_state:i_reg], reg=code[i_reg:i_reg_end], run=code[i_reg_end:])
    assert sum(len(v) for v in sec.values()) == len(code)
    assert all(is_exec(l) for l in sec['shared']) and not any(is_helper_exec(l) for l in sec['shared'])
    assert all(l.startswith('set gg_snd_') or l.startswith('call SetSound') for l in sec['sounds'])
    assert all(l.startswith('call ConditionalTriggerExecute(') for l in sec['run'][:-1])
    # tech rules: identical list per player
    per = {}
    order = []
    for l in sec['tech']:
        m = re.match(r'call (SetPlayerTech\w+)\(Player\(([^)]*)\),(.*)\)(\s*//.*)?$', l)
        p = m.group(2)
        if p not in per:
            per[p] = []; order.append(p)
        per[p].append((m.group(1), m.group(3), m.group(4) or ''))
    first = per[order[0]]
    assert all([x[:2] for x in per[p]] == [x[:2] for x in first] for p in order)
    def dec(p): return str(int(p[1:], 16)) if p.startswith('$') else p
    # ---- registration grouping --------------------------------------------------------
    reg_lines, segment, group_names, module_groups = [], [], {}, {}
    plan_segments = []
    def flush():
        if segment:
            plan_segments.append(plan_groups(list(segment), helper_info))
            reg_lines.append(('SEG', len(plan_segments) - 1))
            segment.clear()
    for l in sec['reg']:
        m = re.match(r'call ExecuteFunc\("(RegisterR11_\w+)"\)$', l)
        if m:
            segment.append(m.group(1))
        else:
            flush(); reg_lines.append(('LINE', l))
    flush()
    for groups in plan_segments:
        for mod, hs in groups:
            module_groups.setdefault(mod, []).append(hs)
    def group_name(mod, k):
        n = len(module_groups[mod])
        return 'RegisterTriggers_%s' % mod if n == 1 else 'RegisterTriggers_%s_Part%d' % (mod, k + 1)
    counters, reg_body = {}, []
    for kind, val in reg_lines:
        if kind == 'LINE':
            if not reg_body or not reg_body[-1].startswith('call ') or 'ExecuteFunc' in reg_body[-1]:
                reg_body.append('// Runs here, between registration blocks, exactly where the original startup ran it.')
            reg_body.append(val)
            continue
        for mod, hs in plan_segments[val]:
            k = counters.get(mod, 0); counters[mod] = k + 1
            reg_body.append('call ExecuteFunc("%s") // %s' % (group_name(mod, k), folder_of[mod]))
    # ---- build new MapBootstrap section functions -------------------------------------
    S = []
    S.append(make_function('Startup_MapEnvironment', ['Startup step 1: camera bounds, day/night models, fog, ambient sounds and music.'],
                           sec['env'], locals_=used_locals(sec['env'], decls)))
    S.append(make_function('Startup_CreateSounds', ['Startup step 2: creates the gg_snd_ sound variables used by triggers.'],
                           sec['sounds'], locals_=used_locals(sec['sounds'], decls)))
    S.append(make_function('Startup_ApplyTechRulesForPlayer',
                           ['Upgrade/tech rules shared by every player slot that uses them (called by Startup_ApplyTechRules).'],
                           ['call %s(p,%s)%s' % (f, a, c) for f, a, c in first], takes='player p'))
    S.append(make_function('Startup_ApplyTechRules',
                           ['Startup step 3: applies the tech rules to each player slot, in the original order.',
                            'Player slot 8 is intentionally not included (it was not in the original list).'],
                           ['call Startup_ApplyTechRulesForPlayer(Player(%s))' % dec(p) for p in order]))
    S.append(make_function('Startup_CreateDestructables',
                           ['Startup step 4: creates script-placed destructables. Breakable barrels/crates get a death',
                            'trigger that drops their loot (Loot_* / Trig_Drop_* actions).'],
                           sec['dest'], locals_=used_locals(sec['dest'], decls)))
    S.append(make_function('Startup_CreateUnits', ['Startup step 5: creates the script-placed buildings, critters and units (see the Units module).'],
                           sec['units'], locals_=used_locals(sec['units'], decls)))
    S.append(make_function('Startup_BlizzardSupport',
                           ['Startup step 6: Blizzard library state the original map initialised here (player forces,',
                            'queued triggers, single-player detection, item stock, etc.).'],
                           sec['bj'], locals_=used_locals(sec['bj'], decls)))
    S.append(make_function('Startup_InitSharedSystems',
                           ['Startup step 7: shared system tables (paths, job heroes, music, save codes, missiles ...).',
                            'Each runs in its own thread (ExecuteFunc), as in the original map.'],
                           sec['shared'], locals_=used_locals(sec['shared'], decls)))
    S.append(make_function('Startup_LegacySpellTriggers',
                           ['Startup step 8: spell triggers the original map registered directly in its startup code,',
                            'with the effect models they preload.'],
                           sec['spells'], locals_=used_locals(sec['spells'], decls)))
    S.append(make_function('Startup_InitGameplayState',
                           ['Startup step 9: initial values of shared gameplay variables (udg_*): timers, groups,',
                            'per-player tables and quest state.'],
                           sec['state'], locals_=used_locals(sec['state'], decls)))
    S.append(make_function('Startup_RegisterTriggers',
                           ['Startup step 10: creates every gameplay trigger.',
                            '',
                            'Each line runs one module\'s RegisterTriggers_* function (defined at the end of that',
                            'module) in its own thread. The order is the original registration order. A few modules',
                            'are registered in several parts (_Part1, _Part2 ...) because some of their triggers',
                            'react to the same event as triggers of other modules, and Warcraft runs triggers on the',
                            'same event in the order they were registered - so those keep their original position.',
                            'New triggers you add in World Editor do not need to be listed here: World Editor creates',
                            'them itself through their InitTrig_ function.'],
                           reg_body, locals_=used_locals(sec['reg'], decls)))
    S.append(make_function('Startup_RunMapInitTriggers',
                           ['Startup step 11: runs the "map initialization" triggers (quest setup, hiding NPCs, etc.).'],
                           sec['run'], locals_=used_locals(sec['run'], decls)))
    main_new = '\n'.join([
        '// ==========================================================================================',
        '// main_old: the map\'s startup sequence.',
        '// MainDeprotected (a GUI trigger with a Map Initialization event) calls this once. Each step',
        '// is a function above, run in this exact order. Keep the order: later steps use what earlier',
        '// steps create (units, sounds, variables, triggers).',
        '// ==========================================================================================',
        'function main_old takes nothing returns nothing',
        '    call Startup_MapEnvironment()',
        '    call Startup_CreateSounds()',
        '    call Startup_ApplyTechRules()',
        '    call Startup_CreateDestructables()',
        '    call Startup_CreateUnits()',
        '    call Startup_BlizzardSupport()',
        '    call Startup_InitSharedSystems()',
        '    call Startup_LegacySpellTriggers()',
        '    call Startup_InitGameplayState()',
        '    call Startup_RegisterTriggers()',
        '    call Startup_RunMapInitTriggers()',
        'endfunction'])
    startup_block = '\n\n'.join(S) + '\n\n' + main_new
    # ---- per-module registration functions -----------------------------------------
    module_funcs = {}
    for mod, groups in module_groups.items():
        parts = []
        for k, hs in enumerate(groups):
            gname = group_name(mod, k)
            doc = ['Creates this module\'s triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).']
            if len(groups) > 1:
                doc = ['Creates part %d of %d of this module\'s triggers. Called once at startup from' % (k + 1, len(groups)),
                       'Startup_RegisterTriggers (MapBootstrap). The parts are registered at different points so that',
                       'triggers sharing an event with other modules keep their original firing order.']
            parts.append(make_function(gname, doc, ['call %s()' % helper_info[h]['new'] for h in hs]))
        module_funcs[mod] = '\n\n'.join(parts)
    # ---- rewrite sources ------------------------------------------------------------
    def new_helper_text(h):
        info = helper_info[h]
        return make_function(info['new'], [], info['lines'])
    for name, m in mods.items():
        text = m['text']
        fm = func_map(text)
        for fname in sorted([f for f in fm if f in helper_info], key=lambda f: -fm[f].start()):
            mm = fm[fname]
            before = text[:mm.start()].rstrip('\n')
            text = before + '\n\n' + new_helper_text(fname) + text[mm.end():]
        if name in module_funcs:
            k = text.rfind('endlibrary')
            text = text.rstrip('\n')
            k = text.rfind('endlibrary')
            text = text[:k].rstrip('\n') + '\n\n' + module_funcs[name] + '\n\n' + text[k:] + '\n'
            first = module_groups[name][0][0]
            gnames = [group_name(name, i) for i in range(len(module_groups[name]))]
            text = text.replace('// Registration ownership; called at the original bootstrap positions.\n',
                                '// World Editor calls InitTrig_%s automatically; it is intentionally empty. This module\'s\n'
                                '// triggers are created by %s (bottom of this module), which\n'
                                '// MapBootstrap\'s Startup_RegisterTriggers runs at the right point during startup.\n'
                                % (name, ' / '.join(gnames) if len(gnames) <= 2 else gnames[0] + ' ... ' + gnames[-1]))
        if name == 'MapBootstrap':
            mm = func_map(text)['main_old']
            text = text[:mm.start()] + startup_block + text[mm.end():]
        m['new_text'] = text
    for name, m in mods.items():
        if m['new_text'] != m['text']:
            open(m['path'], 'w', encoding='utf-8', newline='').write(crlf(m['new_text']))
    decl = re.compile(r'^[ \t]*boolean udg_InitTrigFromMain=false[ \t]*\n', re.M)
    assert len(decl.findall(header)) == 1
    open(header_path, 'w', encoding='utf-8', newline='').write(crlf(decl.sub('', header)))
    # ---- rewrite runtime ------------------------------------------------------------
    raw = open(base_runtime, 'rb').read()
    rt_crlf = b'\r\n' in raw
    rt = lf(raw.decode('utf-8'))
    rfm = func_map(rt)
    edits = []  # (start, end, replacement)
    for h, info in helper_info.items():
        mm = rfm[h]
        assert tokens(mm.group(0)) == tokens('\n'.join(['function %s takes nothing returns nothing' % h] + GUARD + info['lines'] + ['endfunction']))
        edits.append((mm.start(), mm.end(), new_helper_text(h)))
    mm = rfm['main_old']
    assert tokens(mm.group(0)) == tokens(mo.group(0)), 'runtime main_old differs from source'
    edits.append((mm.start(), mm.end(), startup_block))
    for mod, ftext in module_funcs.items():
        marker = '//library %s ends' % lib_of[mod]
        k = rt.find('\n' + marker + '\n')
        assert k >= 0 and rt.find('\n' + marker + '\n', k + 1) < 0, marker
        edits.append((k + 1, k + 1, ftext + '\n\n'))
    m = re.search(r'^boolean udg_InitTrigFromMain=false\n', rt, re.M)
    edits.append((m.start(), m.end(), ''))
    for s, e, r in sorted(edits, key=lambda x: -x[0]):
        rt = rt[:s] + r + rt[e:]
    out = rt.replace('\n', '\r\n') if rt_crlf else rt
    open(out_runtime, 'wb').write(out.encode('utf-8'))
    stats = dict(helpers=len(helper_info), registration_calls=sum(len(g) for g in plan_segments),
                 modules=len(module_groups), split_modules={k: len(v) for k, v in module_groups.items() if len(v) > 1},
                 main_old_lines_before=len(lines))
    json.dump(stats, open(os.path.join(os.path.dirname(out_runtime), 'phase2-stats.json'), 'w'), indent=1)
    print(json.dumps({k: (v if k != 'split_modules' else len(v)) for k, v in stats.items()}))

if __name__ == '__main__':
    main(*sys.argv[1:4])
