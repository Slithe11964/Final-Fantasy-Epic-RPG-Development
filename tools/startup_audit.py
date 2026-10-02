"""Prove that a map's startup still does what the baseline map's startup did.

    python tools/startup_audit.py BASELINE.w3x|war3map.j  CANDIDATE.w3x|war3map.j

Both playable scripts (war3map.j) are expanded from main_old: startup step functions
(Startup_*), trigger registration groups (RegisterTriggers_*), per-trigger registration
helpers (Register_*, or the older RegisterR11_*) and ExecuteFunc calls to them are inlined,
giving the exact list of statements startup executes. Local variable names are compared by type
only (so renaming a local, or moving code into its own function with its own locals, is fine).

Pass criteria:
  1. Every statement outside trigger registration runs in exactly the same order.
  2. Every trigger is registered by exactly the same statements (helper renames ignored).
  3. Each trigger is registered in the same startup block (no trigger moves across other
     startup code), and two triggers that react to the same event, or that read each other's
     trigger variables, keep their original relative order (that is the order in which
     Warcraft fires them).
Anything else is reported as a failure.
"""
import re, sys, os, json, itertools
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from jtok import tokens, strip_comments

INLINE = re.compile(r'^(main_old|Startup_\w+|RegisterTriggers_\w+|Register_\w+|RegisterR11_\w+|RegisterLegacy_\w+)$')
HELPER = re.compile(r'^(Register_|RegisterR11_)\w+$')
FUNC = re.compile(r'^\s*function\s+(\w+)\s+takes\s+(.*?)\s+returns\s+\w+\s*$')

def load_script(path):
    if path.lower().endswith(('.w3x', '.w3m')):
        from mpq import MPQ
        return MPQ(path).read('war3map.j').decode('utf-8', 'replace')
    return open(path, encoding='utf-8', errors='replace').read()

def parse_functions(script):
    funcs, cur = {}, None
    for line in strip_comments(script.replace('\r\n', '\n')).split('\n'):
        s = line.strip()
        if not s:
            continue
        m = FUNC.match(s)
        if m and not s.startswith('//'):
            params = [] if m.group(2) == 'nothing' else [p.split()[-1] for p in m.group(2).split(',')]
            cur = funcs[m.group(1)] = dict(params=params, body=[])
            continue
        if s.startswith('endfunction'):
            cur = None
            continue
        if cur is not None:
            lm = re.match(r'local\s+(\w+)\s+(?:array\s+)?(\w+)', s)
            if lm:
                cur.setdefault('locals', {})[lm.group(2)] = 'local:' + lm.group(1)
            cur['body'].append(s)
    return funcs

def norm(stmt, subst):
    toks = tokens(stmt)
    return ' '.join(subst.get(t, t) for t in toks)

GUARD = ['if not udg_InitTrigFromMain then', 'return', 'endif']

def expand(funcs, name='main_old'):
    """Return list of items: ('stmt', text) or ('trigger', helper_name, [stmts])."""
    out = []
    def run(fname, subst, depth, sink):
        if depth > 20:
            raise RecursionError(fname)
        body = funcs[fname]['body']
        i = 0
        while i < len(body):
            s = body[i]
            if [b.strip() for b in body[i:i + 3]] == GUARD:
                i += 3
                continue
            if s.startswith('local ') or s == 'set udg_InitTrigFromMain=true' or s == 'set udg_InitTrigFromMain = true':
                i += 1
                continue
            m = re.match(r'call\s+ExecuteFunc\s*\(\s*"(\w+)"\s*\)$', s)
            target, args = None, []
            if m and m.group(1) in funcs and INLINE.match(m.group(1)):
                target = m.group(1)
            else:
                m2 = re.match(r'call\s+(\w+)\s*\((.*)\)$', s)
                if m2 and m2.group(1) in funcs and INLINE.match(m2.group(1)):
                    target = m2.group(1)
                    args = [a.strip() for a in split_args(m2.group(2))] if m2.group(2).strip() else []
            if target:
                inner = dict(funcs[target].get('locals', {}))
                inner.update(zip(funcs[target]['params'], [norm(a, subst) for a in args]))
                if HELPER.match(target):
                    unit = []
                    run(target, inner, depth + 1, unit)
                    sink.append(('trigger', target, [x[1] for x in unit]))
                else:
                    run(target, inner, depth + 1, sink)
            else:
                sink.append(('stmt', norm(s, subst)))
            i += 1
    run(name, dict(funcs[name].get('locals', {})), 0, out)
    return out

def split_args(s):
    depth, cur, out = 0, '', []
    for ch in s:
        if ch == '(':
            depth += 1
        elif ch == ')':
            depth -= 1
        if ch == ',' and depth == 0:
            out.append(cur); cur = ''
        else:
            cur += ch
    out.append(cur)
    return out

def trigger_key(stmts):
    for s in stmts:
        m = re.match(r'set (gg_trg_\w+) = CreateTrigger \( \)', s)
        if m:
            return m.group(1)
    return None

EVENT_KEYED = ('TriggerRegisterUnitInRangeSimple', 'TriggerRegisterTimerExpireEventBJ', 'TriggerRegisterTimerEventPeriodic',
               'TriggerRegisterTimerEventSingle', 'TriggerRegisterTimerEvent', 'TriggerRegisterDeathEvent', 'TriggerRegisterUnitLifeEvent')

def trigger_profile(stmts):
    keys, reads, writes = set(), set(), set()
    for s in stmts:
        m = re.match(r'call (TriggerRegister\w+) \( (.*) \)$', s)
        if m:
            nat, args = m.group(1), m.group(2)
            evs = re.findall(r'EVENT_\w+', args)
            if evs:
                keys |= {re.sub(r'^EVENT_(PLAYER_UNIT_|UNIT_|PLAYER_HERO_|HERO_)', 'EVENT_', e) for e in evs}
            elif nat in EVENT_KEYED:
                parts = [p.strip() for p in split_args(args.replace(' ', ''))]
                keys.add(nat + ':' + (parts[-1] if nat == 'TriggerRegisterUnitInRangeSimple' else ','.join(parts[1:])))
            else:
                keys.add(nat)
        w = re.match(r'set (\w+) =', s)
        if w:
            writes.add(w.group(1))
        reads |= set(re.findall(r'\b(gg_\w+|udg_\w+)\b', s))
    return dict(keys=keys, reads=reads - writes, writes=writes)

def conflict(a, b):
    return bool(a['keys'] & b['keys'] or a['writes'] & (b['reads'] | b['writes']) or b['writes'] & a['reads'])

def blocks(items):
    """Split into (non-trigger statement list, list of trigger blocks between those statements)."""
    stmts, groups, cur = [], [[]], None
    for it in items:
        if it[0] == 'stmt':
            stmts.append(it[1])
            groups.append([])
        else:
            groups[-1].append(it)
    return stmts, groups

def audit(base_script, cand_script, allow_new=None):
    """allow_new: regex of trigger variables that may be NEW in the candidate (added on purpose)."""
    b_items = expand(parse_functions(base_script))
    c_items = expand(parse_functions(cand_script))
    report = dict(baseline_statements=len(b_items), candidate_statements=len(c_items), failures=[])
    fail = report['failures'].append
    b_stmts, b_groups = blocks(b_items)
    c_stmts, c_groups = blocks(c_items)
    # compress consecutive empty groups so trigger blocks line up with the statement before them
    if b_stmts != c_stmts:
        for i, (x, y) in enumerate(itertools.zip_longest(b_stmts, c_stmts)):
            if x != y:
                fail('startup statement %d differs: baseline=%r candidate=%r' % (i, x, y)); break
        return report
    report['startup_statements_identical'] = True
    n_trig = n_moved = 0
    for gi, (bg, cg) in enumerate(zip(b_groups, c_groups)):
        bk = [trigger_key(t[2]) for t in bg]
        if allow_new:
            added = [t for t in cg if trigger_key(t[2]) not in bk and re.fullmatch(allow_new, trigger_key(t[2]))]
            report.setdefault('added', []).extend(trigger_key(t[2]) for t in added)
            cg = [t for t in cg if t not in added]
        ck = [trigger_key(t[2]) for t in cg]
        if sorted(bk) != sorted(ck):
            fail('startup block %d registers different triggers: missing=%s extra=%s' % (gi, sorted(set(bk) - set(ck))[:5], sorted(set(ck) - set(bk))[:5]))
            continue
        bmap = {trigger_key(t[2]): t[2] for t in bg}
        for t in cg:
            k = trigger_key(t[2])
            if t[2] != bmap[k]:
                fail('trigger %s is registered differently' % k)
        n_trig += len(bk)
        if bk == ck:
            continue
        pos = {k: i for i, k in enumerate(ck)}
        prof = {k: trigger_profile(bmap[k]) for k in bk}
        for i in range(len(bk)):
            for j in range(i + 1, len(bk)):
                a, b = bk[i], bk[j]
                if pos[a] > pos[b]:
                    n_moved += 1
                    if conflict(prof[a], prof[b]):
                        fail('order changed between %s and %s, which share an event or variable' % (a, b))
    report['triggers_checked'] = n_trig
    report['reordered_independent_pairs'] = n_moved
    report['passed'] = not report['failures']
    return report

if __name__ == '__main__':
    if len(sys.argv) != 3:
        sys.exit(__doc__)
    r = audit(load_script(sys.argv[1]), load_script(sys.argv[2]))
    r['failures'] = r['failures'][:50]
    print(json.dumps(r, indent=1))
    sys.exit(0 if r.get('passed') else 1)
