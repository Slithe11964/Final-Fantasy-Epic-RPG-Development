"""Split Trig_Damage_Engine_CalcDamage (1,400 lines) into one function per documented step.

    python tools/refactor/phase8_split_damage.py SRC_DIR BASE_RUNTIME.j OUT_RUNTIME.j

How it stays identical:
* Every step function contains the original statements of that step, unchanged and with the
  same local variable names.
* A step starts by loading the variables it uses from the hit's "context" (arrays indexed by c)
  and ends by storing the ones it changes. CalcDamage can run inside itself (a hit that causes
  another hit), so each call gets its own context slot (a stack: DmgCtx_Depth).
* Step 4 (Cover) can end the hit early: it returns true and CalcDamage returns 0, as before.
The script verifies that the step bodies, put back together, are exactly the original body.
"""
import os, re, sys
HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, os.path.dirname(HERE))
from jtok import tokens, strip_comments

def lf(s): return s.replace('\r\n', '\n')
def crlf(s): return lf(s).replace('\n', '\r\n')

STEP_NAMES = ['Setup', 'HealingUndead', 'FullProtection', 'Cover', 'Immunities', 'Defense', 'MeleeBonuses', 'Elements',
              'Accuracy', 'EvasionAndBlocking', 'ElementBonus', 'PhysicalSkills', 'MarkedForDeath', 'Difficulty',
              'RandomSpread', 'PhysicalHit', 'Magic', 'FinalModifiers', 'Apply']
CTX = {  # variable -> (context array name, description)
    'l_amount': 'Amount', 'u': 'Source', 't': 'Target', 'l_unavoidable': 'Unavoidable', 'l_dmgKind': 'Kind',
    'l_noCrit': 'NoCrit', 'l_element': 'Element', 'l_manaDamage': 'ManaDamage', 'l_holy': 'Holy', 'l_heal': 'Heal',
    'l_noRedirect': 'NoRedirect', 'l_healUndead': 'HealUndead', 'l_pure': 'Pure', 'l_melee': 'Melee', 'l_ranged': 'Ranged',
    'l_physical': 'Physical', 'l_magical': 'Magical', 'l_akashic': 'Akashic', 'l_ignoreDef': 'IgnoreDefense',
    'l_fxCode': 'FxCode', 'l_blockCode': 'BlockCode', 'ux': 'SourceX', 'uy': 'SourceY', 'tx': 'TargetX', 'ty': 'TargetY',
    'uh': 'SourceHandle', 'th': 'TargetHandle', 'up': 'SourcePlayer', 'tp': 'TargetPlayer', 'l_armorMult': 'ArmorMult',
    'l_defScale': 'DefenseScale', 'l_tmp': 'Tmp', 'l_val': 'Val', 'l_val2': 'Val2', 'l_dummy': 'Dummy', 'l_tag': 'Tag',
    'l_resist': 'Resist'}
HANDLE_TYPES = {'unit', 'texttag', 'player'}

def main(src, base_runtime, out_runtime):
    path = os.path.join(src, 'triggers', '04 Combat and abilities', 'Damage.j')
    text = lf(open(path, encoding='utf-8', newline='').read())
    hdr = re.search(r'(?:^//[^\n]*\n)*^function Trig_Damage_Engine_CalcDamage takes (.*?) returns real\n(.*?)^endfunction\n', text, re.M | re.S)
    params = [p.strip().split() for p in hdr.group(1).split(',')]
    body = hdr.group(2).split('\n')[:-1]
    types = {n: ty for ty, n in params}
    local_inits = []
    i = 0
    while body[i].strip().startswith('local '):
        m = re.match(r'\s*local\s+(\w+)\s+(\w+)\s*(?:=(.*?))?\s*(//.*)?$', body[i])
        types[m.group(2)] = m.group(1)
        local_inits.append((m.group(2), m.group(3), m.group(4)))
        i += 1
    rest = body[i:]
    starts = [k for k, l in enumerate(rest) if re.match(r'    // Step \d+ ', l)]
    assert len(starts) == len(STEP_NAMES) and starts[0] == 0, starts
    assert set(types) == set(CTX), set(types) ^ set(CTX)
    segs = [rest[a:b] for a, b in zip(starts, starts[1:] + [len(rest)])]
    # the last statement of the function is "return l_amount"
    assert segs[-1][-1].strip() == 'return l_amount'
    segs[-1] = segs[-1][:-1]
    word = lambda seg: set(re.findall(r'\b\w+\b', strip_comments('\n'.join(seg))))
    assigned = lambda seg: set(re.findall(r'^\s*set\s+(\w+)\s*=', strip_comments('\n'.join(seg)), re.M))
    out = []
    G = lambda v: 'DmgCtx_%s[c]' % CTX[v]
    for n, (name, seg) in enumerate(zip(STEP_NAMES, segs), 1):
        uses = [v for v in CTX if v in word(seg)]
        sets = [v for v in uses if v in assigned(seg)]
        early = any(re.match(r'\s*return\s+\.0\s*$', strip_comments(l)) for l in seg)
        title = seg[0].strip()[3:]
        doc = []
        for l in seg:
            if not l.strip().startswith('//'):
                break
            doc.append(l.strip()[3:])
        fn = 'Trig_Damage_Engine_Step%02d_%s' % (n, name)
        lines = ['// ' + d for d in doc]
        if early:
            lines.append('// Returns true when the hit was redirected: CalcDamage then stops and returns 0.')
        lines.append('function %s takes integer c returns %s' % (fn, 'boolean' if early else 'nothing'))
        lines += ['    local %s %s=%s' % (types[v], v, G(v)) for v in uses]
        k = len(doc)
        body_lines = []
        for l in seg[k:]:
            if early and re.match(r'\s*return\s+\.0\s*$', strip_comments(l)):
                l = l.replace('return .0', 'return true')
            body_lines.append(l)
        lines += body_lines
        lines += ['    set %s=%s' % (G(v), v) for v in sets]
        lines += ['    set %s=null' % v for v in uses if types[v] in ('unit', 'texttag')]
        if early:
            lines.append('    return false')
        lines.append('endfunction')
        out.append(dict(name=fn, early=early, text='\n'.join(lines), body=body_lines))
    # verify: step bodies put back together are exactly the original statements (comments aside)
    rebuilt = '\n'.join(l.replace('return true', 'return .0') for o in out for l in o['body'])
    assert tokens(rebuilt) == tokens('\n'.join(l for seg in segs for l in seg)), 'step bodies differ!'
    # each step's own locals: loaded at the start, stored at the end, nothing else added
    for o in out:
        assert re.search(r'\breturn\b', '\n'.join(o['body'])) is None or o['early']
    # context storage and the new CalcDamage
    glob = ['    // Per-hit context for Trig_Damage_Engine_CalcDamage (one slot per nested call, see DmgCtx_Depth).',
            '    integer DmgCtx_Depth=0']
    for v, nm in CTX.items():
        glob.append('    %s array DmgCtx_%s' % (types[v], nm))
    calc = ['// ==========================================================================================',
            '// Trig_Damage_Engine_CalcDamage - the combat formula used by the damage engine for attacks,',
            '// spells and heals. It runs the steps below in order; each step is a function above',
            '// (Trig_Damage_Engine_StepNN_*) that changes the hit\'s values (amount, block code, ...).',
            '//   l_amount     base damage or healing           u / t : source / target unit',
            '//   l_dmgKind    1 melee, 2 ranged, 4 pure (skips most modifiers), anything else = magic',
            '//   l_element    element id (0 = use the attacker\'s element)',
            '//   DmgCtx_BlockCode  -1 cannot miss or be blocked, 0 normal, 1 evaded, 2 blocked, 3 nullified',
            '//   DmgCtx_FxCode     1 cleave effect, 2 critical-hit effect',
            '// A hit can cause another hit while it is being calculated, so every call gets its own slot',
            '// c in the DmgCtx_* arrays. To add a modifier, put it in the step where it belongs, or add a',
            '// new step function and call it here.',
            '// ==========================================================================================',
            'function Trig_Damage_Engine_CalcDamage takes %s returns real' % hdr.group(1),
            '    local integer c',
            '    local real result',
            '    if DmgCtx_Depth>=8000 then',
            '        // safety: a crashed call never released its slot; start over instead of running past the arrays',
            '        set DmgCtx_Depth=0',
            '    endif',
            '    set DmgCtx_Depth=DmgCtx_Depth+1',
            '    set c=DmgCtx_Depth']
    calc += ['    set %s=%s' % (G(n), n) for ty, n in params]
    for v, init, cmt in local_inits:
        if init is not None:
            calc.append('    set %s=%s%s' % (G(v), re.sub(r'\b(%s)\b' % '|'.join(map(re.escape, CTX)), lambda m: G(m.group(1)), init), (' ' + cmt) if cmt else ''))
    for s in out:
        if s['early']:
            calc += ['    if %s(c) then' % s['name'],
                     '        call Trig_Damage_Engine_FreeContext(c)',
                     '        return .0',
                     '    endif']
        else:
            calc.append('    call %s(c)' % s['name'])
    calc += ['    set result=DmgCtx_Amount[c]', '    call Trig_Damage_Engine_FreeContext(c)', '    return result', 'endfunction']
    free = ['// Releases the context slot of a finished CalcDamage call.',
            'function Trig_Damage_Engine_FreeContext takes integer c returns nothing'] + \
           ['    set DmgCtx_%s[c]=null' % nm for v, nm in CTX.items() if types[v] in HANDLE_TYPES] + \
           ['    set DmgCtx_Depth=c-1', 'endfunction']
    new_funcs = '\n'.join(free) + '\n\n' + '\n\n'.join(s['text'] for s in out) + '\n\n' + '\n'.join(calc) + '\n'
    text = text[:hdr.start()] + new_funcs + text[hdr.end():]
    gm = re.search(r'^globals\n', text, re.M)
    text = text[:gm.end()] + '\n'.join(glob) + '\n' + text[gm.end():]
    open(path, 'w', encoding='utf-8', newline='').write(crlf(text))
    # runtime
    raw = open(base_runtime, 'rb').read()
    rt = lf(raw.decode('utf-8'))
    m = re.search(r'^function Trig_Damage_Engine_CalcDamage takes.*?^endfunction\n', rt, re.M | re.S)
    rt = rt[:m.start()] + new_funcs + rt[m.end():]
    marker = 'constant boolean LIBRARY_TDamage=true\n'
    k = rt.index(marker) + len(marker)
    rt = rt[:k] + '\n'.join(g.strip() for g in glob[1:]) + '\n' + rt[k:]
    open(out_runtime, 'wb').write((rt.replace('\n', '\r\n') if b'\r\n' in raw else rt).encode('utf-8'))
    print('split CalcDamage into %d steps; longest step %d lines' % (len(out), max(len(s['text'].split('\n')) for s in out)))

if __name__ == '__main__':
    main(*sys.argv[1:4])
