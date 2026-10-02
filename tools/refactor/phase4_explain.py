"""Phase 4: explain the systems. Kept as a record of exactly what changed.

    python tools/refactor/phase4_explain.py SRC_DIR BASE_RUNTIME.j OUT_RUNTIME.j

A. Trigger registration helpers (Register_X) that lived in a parent module (Quest, Boss, Hunt ...)
   while the trigger's own code lives in a feature module (Quest_SaveTimmy ...) move to the feature
   module together with their gg_trg_ variable, so everything about one trigger is in one file.
   The parent's RegisterTriggers_* still calls them, in the same order.
B. Each call in RegisterTriggers_* gets a short note: starts off / which other modules turn the
   trigger on or off or run it.
C. Generic local names (l_integer_01, l_x_2 ...) get descriptive names.
D. Startup_LegacySpellTriggers calls the spell modules' RegisterLegacy_* functions instead of
   repeating their code inline (the code was identical; those functions were unused copies).
E. Trig_Damage_Engine_CalcDamage gets a header and step-by-step section comments.
F. The map header (top of the Trigger Editor) gets a short developer guide.
Code changes (A, C, D) are applied to the compiled runtime too; B, E, F are comments only.
"""
import collections, json, os, re, sys
HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, os.path.dirname(HERE))
from jtok import tokens, strip_comments
import gen_docs

def lf(s): return s.replace('\r\n', '\n')
def crlf(s): return lf(s).replace('\n', '\r\n')
FUNC = re.compile(r'^(?:constant\s+)?function\s+(\w+)\s+takes.*?^endfunction[^\n]*\n?', re.M | re.S)

def fspan(text, name):
    m = re.search(r'^(?:constant\s+)?function\s+%s\s+takes.*?^endfunction[^\n]*\n?' % re.escape(name), text, re.M | re.S)
    assert m, name
    return m

def requires_closure(mods_lib, reqs, lib):
    seen, stack = set(), [lib]
    while stack:
        x = stack.pop()
        for r in reqs.get(x, []):
            if r not in seen:
                seen.add(r); stack.append(r)
    return seen

def rename_in(text, fname, mapping):
    m = fspan(text, fname)
    body = m.group(0)
    for old, new in mapping.items():
        assert not re.search(r'\b%s\b' % re.escape(new), body), (fname, new)
        body = re.sub(r'\b%s\b' % re.escape(old), new, body)
    return text[:m.start()] + body + text[m.end():]

CALC_STEPS = [
    ('if(l_amount<1.)then', ['Step 1 - Setup: negative amounts become 0; the target\'s armor becomes a multiplier',
                              '(1 + 0.02 per armor point) that later steps use to apply or undo armor.']),
    ('if l_unavoidable then', ['Unavoidable damage can never be evaded or blocked.']),
    ('if(l_heal and not l_healUndead', ['Step 2 - Healing an undead or Zombie target hurts it instead (x1.5, counts as holy).']),
    ('if(l_heal)then', ['Step 3 - Complete protection: Infinity (absorbs the hit and counts toward a job mastery),',
                         'Majin Barrier, Block All / Shield, protected quest and town NPCs (Player(8)),',
                         'Cup Arena outsiders, Null Sleep.']),
    ('if(l_amount>.0 and not l_heal and not l_noRedirect', ['Step 4 - Cover: the hit is redirected to the unit covering the target if it is alive and in range.']),
    ('if((l_physical or l_akashic)and not l_heal', ['Step 5 - Immunities: Physical Immunity; Inner Fire against magic.']),
    ('if(l_amount>.0 and not l_pure and(l_heal or l_akashic', ['Step 6 - Defense: heals, Akashic, holy and Pierce/Frog hits handle armor here. Magic that',
                                                               'hits a player\'s hero is scaled by 50 / (50 + that player\'s magic defense).']),
    ('if(l_ranged and IsPlayerInForce(up', ['A player hero\'s ranged shot restarts RangedShotTimer.']),
    ('if l_melee and l_amount>.0 then', ['Step 7 - Melee attacker bonuses: weapon proficiency, axe charge, Rengeki, mana on hit,',
                                          'Combo Strike, Two-Handed, Dragon Eye, splash, Momentum and other melee skills.']),
    ("set l_tmp=GetUnitAbilityLevel(u,'A0SF')", ['Command AI: melee AI units sometimes cast a spell at their target; each bit of the',
                                                 'ability level enables one spell.']),
    ('if(l_element<=0 and not l_pure)then', ['Step 8 - Elements: use the attacker\'s element when none was given, then apply the',
                                             'target\'s weakness / resistance / immunity / absorption.']),
    ("if(l_ranged and l_amount>.0 and GetUnitAbilityLevel(t,'A14C')", ['Rengeki Bonus on the target against ranged hits.']),
    ('if(u==gg_unit_n08D_0001 and u!=null)then', ['Special unit n08D_0001: its hit equals its own armor, then it expires.']),
    ('if(l_blockCode==0)then', ['Step 9 - Accuracy: effects that make the hit impossible to evade (Sharp Eye, Null Evasion,',
                                'Gun Accuracy ...).']),
    ('if(l_blockCode==0)then', ['Step 10 - Evasion and blocking: miss roll (Trig_Damage_Engine_RollMiss), Evade and Counter,',
                                'block abilities.']),
    ('if(l_amount>.0 and l_element>0)then', ['Step 11 - Remember the attacker\'s last element and apply its element damage bonus.']),
    ('if(l_blockCode>0)then', ['Show the evade / block effect and floating text when the hit was stopped.']),
    ('if(l_physical and l_amount>.0)then', ['Step 12 - Physical attacker skills: Aim, Killer / Artemis Arrows and other shot bonuses.']),
    ("if(l_amount>.0 and not l_heal and GetUnitAbilityLevel(t,'B07M')", ['Step 13 - Marked for Death and Undead Touch.']),
    ('if(not l_pure and udg_Difficulty!=3)then', ['Step 14 - Difficulty: hits from the enemy player (Player(11)) on active players are divided by',
                                                  'DifficultyScale; hits on the enemy player are multiplied by it.']),
    ('if(l_amount>.0 and udg_EternityMode)then', ['Eternity Mode bonuses.']),
    ('if(not l_pure and l_amount>.0)then', ['Step 15 - Random spread: normally x(15..16)/16; Gambler Spirit x(0.2..2).']),
    ('if(l_physical and l_amount>.0)then', ['Step 16 - Physical hit: critical hits, Devaluing Attack, Bravery / Pain buffs, Focus,',
                                            'Adrenaline, Physical Hardness, Deathblow, Ultima Blade.']),
    ("call UnitRemoveAbility(u,'B03N')", ['Backstab and Stealth end once the attacker hits.']),
    ('if(l_magical and l_amount>.0)then', ['Step 17 - Magic: Faith / Faithra and other spell-power modifiers.']),
    ('if l_amount>.0 then', ['Step 18 - Final modifiers from both sides: Night Might, Great Wall, Inner Fire, Death Screech,',
                             'Sleep, Oversoul, Adaptive Barrier, Sentinel, Divine Shield, Drain Attack ...']),
    ('set udg_LastDamageDealt=l_amount', ['Step 19 - Apply: heals and mana changes are applied here (with floating text) and return 0;',
                                          'normal damage is returned to the caller, which deals it.']),
    ('if(l_amount>.0 and l_fxCode>0)then', ['Cleave / critical-hit effect on the target.']),
    ('if(l_amount>.0 and IsUnitInGroup(t,udg_AbsorbShieldGroup))then', ['Absorb shields store the damage instead of taking it.']),
    ('if(IsPlayerInForce(up,udg_PlayingPlayers)and l_amount>.0 and l_amount<1000000.)then', ['DPS meter for players.']),
    ('if(l_amount>=1.)then', ['Floating damage text.']),
    ('if IsUnitIllusion(u)then', ['Illusions deal no damage.']),
]
CALC_HEADER = '''// ==========================================================================================
// Trig_Damage_Engine_CalcDamage - the combat formula used by the damage engine for attacks,
// spells and heals. It changes l_amount step by step, top to bottom (Step 1 ... Step 19 below), and returns
// the final damage (heals and mana changes are applied here directly).
//   l_amount     base damage or healing           u / t : source / target unit
//   l_dmgKind    1 melee, 2 ranged, 4 pure (skips most modifiers), anything else = magic
//   l_element    element id (0 = use the attacker's element)
//   l_blockCode  -1 cannot miss or be blocked, 0 normal, 1 evaded, 2 blocked, 3 nullified
//   l_fxCode     1 cleave effect, 2 critical-hit effect
// A hit can cause another hit (damage dealt from inside this function), so it runs nested;
// that is why everything is kept in locals. Keep it that way if you split it up.
// =========================================================================================='''

GUIDE = '''// ==========================================================================================
// FINAL FANTASY EPIC RPG - developer guide (full docs: FFERPG/docs in the developer workspace)
//
// Trigger folders
//   01 Shared helpers        small utilities used everywhere: waits, groups, missiles, knockback
//   02 Map setup             world creation, pre-placed unit setup, Init_* startup triggers
//   03 Jobs and progression  jobs, job-change shrines, heroes, levels, legendary jobs
//   04 Combat and abilities  damage engine, spells, passives, bosses, summons, Gaya spirit
//   05 Items crafting shops  items, loot, armory, crafting, forge, materia, potions
//   06 Quests and story      quests, NPCs, story chapters, sieges, Kalm
//   07 Hunts and encounters  spawns, monster data, hunts, arena
//   08 World and travel      zones, teleports, gates, camera and cinematics, weather
//   09 Player features       chat commands, save/load codes, titles, chocobos, fishing, music
//   10 Startup coordinator   MapBootstrap: main_old, the startup sequence
//
// Conventions
//   * Each code module is a vJass library (T<Module>): keep JassHelper and vJass enabled.
//   * Trigger X: its code is Trig_X_* ; it is created by Register_X ; the module's
//     RegisterTriggers_* lists its triggers in startup order (called from MapBootstrap).
//   * A module's own variables are in the globals block at its top; shared ones are below.
//   * Object ids such as 'A0B3' carry a comment with the object's name.
//   * New triggers: just create them in World Editor (see docs/STARTUP.md for caveats).
//   * After saving in World Editor, run Build Play Copy before playing (long quest text).
// =========================================================================================='''

def main(src, base_runtime, out_runtime):
    entries = json.load(open(os.path.join(src, 'trigger-list.json'), encoding='utf-8'))
    mods = collections.OrderedDict()
    for e in entries:
        if e.get('library'):
            p = os.path.join(src, 'triggers', e['folder'], e['name'] + '.j')
            mods[e['name']] = dict(e=e, path=p, text=lf(open(p, encoding='utf-8', newline='').read()))
    lib = {n: m['e']['library'] for n, m in mods.items()}
    reqs = {}
    for n, m in mods.items():
        r = re.search(r'^library \w+(?:\s+requires\s+([^\n]*))?', m['text'], re.M)
        reqs[lib[n]] = [x.strip() for x in (r.group(1) or '').split(',') if x.strip()]
    raw = open(base_runtime, 'rb').read()
    rt = lf(raw.decode('utf-8'))
    fown = {}
    for n, m in mods.items():
        for f in re.findall(r'^function (\w+) takes', m['text'], re.M):
            fown[f] = n
    stats = collections.Counter()

    # ---- A. move registration helpers next to their trigger code --------------------------
    moves = collections.defaultdict(list)   # feature -> [(parent, helper)]
    for n, m in mods.items():
        for fm in FUNC.finditer(m['text']):
            h = fm.group(1)
            if not h.startswith('Register_'):
                continue
            owners = {fown[r] for r in re.findall(r'function (\w+)\)', fm.group(0)) if r in fown}
            if len(owners) == 1:
                f = next(iter(owners))
                if f != n and lib[f] in requires_closure(None, reqs, lib[n]):
                    moves[f].append((n, h))
    caller = {}
    for n, m in mods.items():
        for fm in FUNC.finditer(m['text']):
            if fm.group(1).startswith('RegisterTriggers_'):
                for h in re.findall(r'call (Register_\w+)\(', fm.group(0)):
                    caller[h] = fm.group(1)
    for feat, items in moves.items():
        moved_text, moved_globals, parents = [], [], collections.OrderedDict()
        for parent, h in items:
            pt = mods[parent]['text']
            mm = fspan(pt, h)
            moved_text.append(mm.group(0).rstrip('\n'))
            pt = pt[:mm.start()].rstrip('\n') + '\n\n' + pt[mm.end():].lstrip('\n')
            trig = h[len('Register_'):]
            g = re.search(r'^[ \t]*trigger gg_trg_%s=null[ \t]*\n' % re.escape(trig), pt, re.M)
            if g:   # (a few trigger variables are generated by World Editor itself and declared nowhere)
                moved_globals.append(g.group(0).strip())
                pt = pt[:g.start()] + pt[g.end():]
            # drop a now-empty globals block / its comment
            pt = re.sub(r'globals\n    // Trigger variables\. Each is created by the matching Register_\* function in this module\.\nendglobals\n\n?', '', pt)
            pt = re.sub(r'    // Trigger variables\. Each is created by the matching Register_\* function in this module\.\n(?=    // |endglobals)', '', pt)
            mods[parent]['text'] = pt
            parents.setdefault(parent, set()).add(caller[h])
            # runtime: move function + global
            rm = fspan(rt, h)
            rtext = rm.group(0)
            rt = rt[:rm.start()] + rt[rm.end():]
            if g:
                gl = re.search(r'^trigger gg_trg_%s=null\n' % re.escape(trig), rt, re.M)
                rt = rt[:gl.start()] + rt[gl.end():]
                marker = 'constant boolean LIBRARY_%s=true\n' % lib[feat]
                k = rt.index(marker) + len(marker)
                rt = rt[:k] + gl.group(0) + rt[k:]
            endm = '\n//library %s ends\n' % lib[feat]
            k = rt.index(endm) + 1
            rt = rt[:k] + rtext.rstrip('\n') + '\n\n' + rt[k:]
            stats['helpers_moved'] += 1
        ft = mods[feat]['text']
        who = '; '.join('%s (module %s)' % (', '.join(sorted(gs)), p) for p, gs in parents.items())
        block = ('// ---- Trigger registration ----\n'
                 '// These create this module\'s triggers. They run at startup from %s,\n'
                 '// which keeps the original registration order.\n\n' % who) + '\n\n'.join(moved_text)
        ft = ft.rstrip('\n')
        k = ft.rfind('endlibrary')
        ft = ft[:k].rstrip('\n') + '\n\n' + block + '\n\n' + ft[k:] + '\n'
        decl = '\n'.join('    ' + g for g in moved_globals)
        if not moved_globals:
            pass
        elif re.search(r'^globals\n', ft, re.M):
            gm = re.search(r'^globals\n', ft, re.M)
            ft = ft[:gm.end()] + '    // Trigger variables. Each is created by the matching Register_* function in this module.\n' + decl + '\n' + ft[gm.end():] \
                if 'Trigger variables. Each is created' not in ft else re.sub(r'(    // Trigger variables\. Each is created by the matching Register_\* function in this module\.\n)', lambda mm: mm.group(1) + decl + '\n', ft, count=1)
        else:
            lm = re.search(r'^library \w+[^\n]*\n', ft, re.M)
            ft = ft[:lm.end()] + 'globals\n    // Trigger variables. Each is created by the matching Register_* function in this module.\n' + decl + '\nendglobals\n\n' + ft[lm.end():]
        mods[feat]['text'] = ft

    # ---- C. descriptive local names --------------------------------------------------
    renames = [('MapBootstrap', 'Startup_BlizzardSupport', {'l_integer_01': 'index', 'l_integer_02': 'humanPlayerCount', 'l_integer_03': 'itemLevel'}),
               ('Unit', 'Unit_AngleToPoint', {'l_x_2': 'l_x'})]
    for fm in FUNC.finditer(mods['Zone']['text']):
        if re.search(r'\bl_x_2\b', fm.group(0)):
            renames.append(('Zone', fm.group(1), {'l_x_2': 'l_x'}))
    for mod, fname, mp in renames:
        mods[mod]['text'] = rename_in(mods[mod]['text'], fname, mp)
        rt = rename_in(rt, fname, mp)
        stats['functions_with_renamed_locals'] += 1

    # ---- D. legacy spell triggers ----------------------------------------------------
    legacy = {}
    for n, m in mods.items():
        for f in re.findall(r'^function (RegisterLegacy_\w+) takes', m['text'], re.M):
            body = fspan(m['text'], f).group(0)
            key = re.search(r'function (Trig_\w+)', body).group(1)
            legacy[f] = (n, key)
            # each local must be set before it is read
            for loc in re.findall(r'^\s*local\s+\w+\s+(\w+)', body, re.M):
                first = [l for l in body.split('\n') if re.search(r'\b%s\b' % loc, l) and not l.strip().startswith('local ')][0]
                assert re.match(r'\s*set\s+%s\s*=' % loc, first), (f, loc)
    sec = fspan(mods['MapBootstrap']['text'], 'Startup_LegacySpellTriggers').group(0)
    order = sorted(legacy, key=lambda f: sec.index(legacy[f][1]))
    new_sec = ('// Startup step 8: spell triggers the original map registered directly in its startup code.\n'
               '// Each RegisterLegacy_* function lives in its spell\'s module and also preloads its effects.\n'
               'function Startup_LegacySpellTriggers takes nothing returns nothing\n' +
               ''.join('    call %s() // %s\n' % (f, legacy[f][0]) for f in order) + 'endfunction\n')
    t = mods['MapBootstrap']['text']
    m = re.search(r'// Startup step 8:.*?\n(?://[^\n]*\n)*function Startup_LegacySpellTriggers takes.*?^endfunction\n', t, re.M | re.S)
    mods['MapBootstrap']['text'] = t[:m.start()] + new_sec + t[m.end():]
    rm = fspan(rt, 'Startup_LegacySpellTriggers')
    rt = rt[:rm.start()] + new_sec.split('\n', 2)[2] + rt[rm.end():]
    for f in order:   # these now run, so mark them in their own modules
        n = legacy[f][0]
        tt = mods[n]['text']
        mm = fspan(tt, f)
        tt = tt[:mm.start()] + '// Called once at startup by Startup_LegacySpellTriggers (MapBootstrap).\n' + tt[mm.start():]
        mods[n]['text'] = tt

    # ---- E. damage engine comments ---------------------------------------------------
    t = mods['Damage']['text']
    m = fspan(t, 'Trig_Damage_Engine_CalcDamage')
    lines = m.group(0).split('\n')
    out, si = [], 0
    for l in lines:
        if si < len(CALC_STEPS) and l.startswith('    ') and not l.startswith('     ') and l.strip() == l.strip() and l[4:].split(' //')[0].startswith(CALC_STEPS[si][0]):
            out += ['    // ' + c for c in CALC_STEPS[si][1]]
            si += 1
        out.append(l)
    assert si == len(CALC_STEPS), 'only %d of %d damage steps placed' % (si, len(CALC_STEPS))
    mods['Damage']['text'] = t[:m.start()] + CALC_HEADER + '\n' + '\n'.join(out) + t[m.end():]

    # ---- F. developer guide at the top of the map header -----------------------------------
    hpath = os.path.join(src, 'map-header.j')
    header = lf(open(hpath, encoding='utf-8', newline='').read())
    if 'developer guide' not in header[:300]:
        open(hpath, 'w', encoding='utf-8', newline='').write(crlf(GUIDE + '\n' + header))

    # ---- B. notes on RegisterTriggers calls (computed on the final layout) ------------------
    gmods = collections.OrderedDict((n, dict(folder=m['e']['folder'], text=m['text'])) for n, m in mods.items())
    info = gen_docs.trigger_info(gmods)
    for n, m in mods.items():
        def note(mm):
            trig = mm.group(2)
            txt = gen_docs.link_text(info[trig]) if trig in info else ''
            return mm.group(1) + (' // ' + txt if txt else '')
        defined_here = set(re.findall(r'^function (Register_\w+) takes', m['text'], re.M))
        def per_func(fm):
            if not fm.group(1).startswith('RegisterTriggers_'):
                return fm.group(0)
            return re.sub(r'^(    call Register_(\w+)\(\))[^\n]*$', note, fm.group(0), flags=re.M)
        m['text'] = FUNC.sub(per_func, m['text'])
        # groups whose helpers now live in feature modules get an accurate description
        def redoc(mm):
            doc, fname, body = mm.group(1), mm.group(2), mm.group(0)
            helpers = re.findall(r'call (Register_\w+)\(', body)
            if all(h in defined_here for h in helpers):
                return body
            part = re.search(r'_Part(\d+)$', fname)
            total = len(re.findall(r'^function %s_Part\d+ takes' % re.escape(fname[:part.start()]), m['text'], re.M)) if part else 0
            lines = ['// Startup registration%s: creates the triggers below, in this order. Called once from' % (', part %s of %d' % (part.group(1), total) if part else ''),
                     '// Startup_RegisterTriggers (MapBootstrap). Each Register_* function sits in the module that',
                     '// holds that trigger\'s code (search for its name).']
            if part:
                lines.append('// Registered in parts so triggers sharing an event with other modules keep their firing order.')
            return '\n'.join(lines) + '\n' + body[len(doc):]
        m['text'] = re.sub(r'((?://[^\n]*\n)+)function (RegisterTriggers_\w+) takes.*?^endfunction', redoc, m['text'], flags=re.M | re.S)

    for n, m in mods.items():
        old = open(m['path'], encoding='utf-8', newline='').read()
        if crlf(m['text']) != old:
            open(m['path'], 'w', encoding='utf-8', newline='').write(crlf(m['text']))
            stats['files_changed'] += 1
    open(out_runtime, 'wb').write((rt.replace('\n', '\r\n') if b'\r\n' in raw else rt).encode('utf-8'))
    stats['features_receiving_helpers'] = len(moves)
    print(json.dumps(stats, indent=1))
    json.dump(stats, open(os.path.join(os.path.dirname(out_runtime), 'phase4-stats.json'), 'w'), indent=1)

if __name__ == '__main__':
    main(*sys.argv[1:4])
