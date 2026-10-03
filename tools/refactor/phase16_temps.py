"""Phase 16: find (and optionally apply) the safe conversions of shared udg_Temp* variables to locals.

    python tools/refactor/phase16_temps.py report [--json out.json]
    python tools/refactor/phase16_temps.py apply MODULE [MODULE ...]

Many functions use a shared global (udg_TempPoint, udg_TempInteger ...) just as scratch space. That is
fragile: anything that runs in the middle (a unit created, damage dealt, an event fired, a ForGroup
callback) can overwrite it. A function F may use a local instead of global T when:

  1. F's first use of T is a plain `set T = ...` outside any if/loop, and that line doesn't read T;
  2. nothing F calls - directly or further down, including ForGroup/ForForce/filter callbacks,
     ExecuteFunc and TriggerExecute targets - touches T (so F doesn't hand a value to a callee or get
     one back);
  3. no caller reads T after calling F before setting it again (F doesn't hand a value back out);
  4. F has no unresolvable calls (ExecuteFunc/TriggerExecute with a computed target);
  5. F is not part of the startup sequence (startup_audit.py keeps those byte-identical);
  6. for handle types (location, unit, group, force, player): every `return` in F can be preceded by
     `set local = null` (the return value doesn't use the local).

Everything else is a real hand-off and is listed in the report for manual work.
"""
import json, os, re, sys
HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(os.path.dirname(HERE))
sys.path.insert(0, os.path.dirname(HERE))
from jtok import strip_comments

TEMP = re.compile(r'\budg_Temp\w*\b')
TYPES = {'udg_TempPoint': 'location', 'udg_TempPoint2': 'location', 'udg_TempPoint3': 'location', 'udg_TempPoint4': 'location',
         'udg_TempPoint5': 'location', 'udg_TempInteger': 'integer', 'udg_TempInteger2': 'integer', 'udg_TempPlayer': 'player',
         'udg_TempForce': 'force', 'udg_TempReal': 'real', 'udg_TempGroup': 'group', 'udg_TempHandleId': 'integer',
         'udg_TempString': 'string', 'udg_TempItemId': 'integer', 'udg_TempUnit': 'unit', 'udg_TempUnit2': 'unit',
         'udg_TempBoolean': 'boolean'}
STARTUP = re.compile(r'^(main_old|Startup_\w+|RegisterTriggers_\w+|Register_\w+|RegisterR11_\w+|InitTrig_\w+)$')   # kept identical (startup_audit)
HANDLE = {'location', 'player', 'force', 'group', 'unit'}
FUNC_RE = re.compile(r'^([ \t]*)((?:constant\s+|private\s+|public\s+)*function\s+(\w+)\s+takes\b.*?)^[ \t]*endfunction\b[^\n]*\n?', re.M | re.S)
TOKEN = re.compile(r'"(?:\\.|[^"\\])*"|\'(?:\\.|[^\'\\])*\'|\w+|==|!=|<=|>=|\S')

def modules():
    out = {}
    for folder in sorted(os.listdir(os.path.join(ROOT, 'src', 'triggers'))):
        d = os.path.join(ROOT, 'src', 'triggers', folder)
        for f in sorted(os.listdir(d)):
            if f.endswith('.j'):
                out[f[:-2]] = os.path.join(d, f)
    return out

def parse_functions(path):
    text = open(path, encoding='utf-8').read().replace('\r\n', '\n')
    return text, [dict(name=m.group(3), start=m.start(), end=m.end(), text=m.group(0)) for m in FUNC_RE.finditer(text)]

def lines_of(ftext):
    """(depth, code_without_comment, raw_line) per body line; depth counts open if/loop blocks."""
    out, depth = [], 0
    for raw in ftext.split('\n'):
        code = strip_comments(raw).strip()
        w = code.split('(')[0].split()
        first = w[0] if w else ''
        if first in ('endif', 'endloop'):
            depth -= 1
        d = depth - (1 if first in ('else', 'elseif') else 0)
        out.append((d, code, raw))
        if first in ('if', 'loop') or (first == 'static' and len(w) > 1 and w[1] == 'if'):
            depth += 1
    return out

def analyse():
    mods = modules()
    funcs = {}
    for mod, path in mods.items():
        _, fl = parse_functions(path)
        for f in fl:
            f['module'] = mod
            funcs[f['name']] = f
    trig_funcs = {}
    for f in funcs.values():
        for m in re.finditer(r'TriggerAdd(?:Action|Condition)\s*\(\s*(gg_trg_\w+)\s*,\s*(?:Condition\s*\(\s*)?function\s+(\w+)', f['text']):
            trig_funcs.setdefault(m.group(1), set()).add(m.group(2))
    names = set(funcs)
    for f in funcs.values():
        code = strip_comments(f['text'])
        body = code.split('\n', 1)[1] if '\n' in code else ''
        calls, unknown = set(), False
        for m in re.finditer(r'\bfunction\s+(\w+)', body):
            calls.add(m.group(1))
        for m in re.finditer(r'\b(\w+)\s*\(', body):
            if m.group(1) in names:
                calls.add(m.group(1))
        for m in re.finditer(r'\bExecuteFunc\s*\(\s*("?)(\w*)', body):
            if m.group(1) and m.group(2) in names:
                calls.add(m.group(2))
            elif not m.group(1):
                unknown = True
        for m in re.finditer(r'\b(?:Conditional)?Trigger(?:Execute|Evaluate)(?:BJ)?\s*\(\s*(\w+)', body):
            if m.group(1) in trig_funcs:
                calls |= trig_funcs[m.group(1)]
            else:
                unknown = True
        f['calls'] = calls & names
        f['unknown'] = unknown
        f['temps'] = set(TEMP.findall(body))
    callers = {n: set() for n in funcs}
    for f in funcs.values():
        for c in f['calls']:
            callers[c].add(f['name'])
    # transitive temps touched by callees
    memo = {}
    def deep(n, stack=()):
        if n in memo:
            return memo[n]
        if n in stack:
            return set()
        s = set(funcs[n]['temps'])
        for c in funcs[n]['calls']:
            s |= deep(c, stack + (n,))
        memo[n] = s
        return s
    results = []
    for f in funcs.values():
        if not f['temps'] or STARTUP.match(f['name']):
            continue
        below = set()
        for c in f['calls']:
            if c != f['name']:
                below |= deep(c)
        ls = lines_of(f['text'])
        for t in sorted(f['temps']):
            reason = None
            if t not in TYPES:
                reason = 'unknown type'
            elif f['unknown']:
                reason = 'has a computed ExecuteFunc/TriggerExecute'
            elif t in below:
                reason = 'a called function also uses it (hand-off)'
            else:
                first = next(((d, c) for d, c, _ in ls[1:] if re.search(r'\b%s\b' % t, c)), None)
                if not first:
                    continue
                d, c = first
                if not re.match(r'set\s+%s\s*=' % t, c):
                    reason = 'read before it is set (value comes from outside)'
                elif d != 0:
                    reason = 'first set is inside an if/loop'
                elif re.search(r'\b%s\b' % t, c.split('=', 1)[1]):
                    reason = 'first set reads the old value'
                elif TYPES[t] in HANDLE and any(re.match(r'return\b.*\b%s\b' % t, c2) for _, c2, _ in ls):
                    reason = 'returned value uses it'
            if not reason:
                for cn in callers[f['name']]:
                    if cn == f['name']:
                        continue
                    if t in funcs[cn]['temps'] and reads_after_call(funcs[cn], f['name'], t):
                        reason = 'caller %s reads it after the call (hand-off out)' % cn
                        break
            results.append(dict(function=f['name'], module=f['module'], temp=t, ok=reason is None, reason=reason))
    return funcs, results

def reads_after_call(caller, callee, t):
    ls = lines_of(caller['text'])
    sites = [i for i, (d, c, _) in enumerate(ls) if re.search(r'\b%s\b' % callee, c)]
    for i in sites:
        if ls[i][0] > 0 and any('loop' == c.split('(')[0].strip() for _, c, _ in ls[:i]) and any(
                re.search(r'\b%s\b' % t, c) and not re.match(r'set\s+%s\s*=' % t, c) for _, c, _ in ls):
            return True          # call inside a loop: be conservative
        for d, c, _ in ls[i + 1:]:
            if re.search(r'\b%s\b' % t, c):
                if re.match(r'set\s+%s\s*=' % t, c) and not re.search(r'\b%s\b' % t, c.split('=', 1)[1]):
                    break
                return True
    return False

def local_name(t, taken):
    base = 'l_temp' + t[len('udg_Temp'):]
    n = base
    k = 2
    while n in taken:
        n = '%s_%d' % (base, k); k += 1
    return n

def convert(ftext, temps):
    """Rewrite one function: declare locals, replace the globals, null handle locals before returns/end."""
    lines = ftext.split('\n')
    taken = set(re.findall(r'\w+', ftext))
    newnames = {t: local_name(t, taken) for t in temps}
    # header is line 0; locals come first
    i = 1
    while i < len(lines) and (re.match(r'\s*local\b', lines[i]) or (lines[i].strip().startswith('//') and i + 1 < len(lines) and re.match(r'\s*local\b', lines[i + 1]))):
        i += 1
    body_indent = re.match(r'\s*', lines[i] if i < len(lines) else '    ').group(0) or '    '
    decl = ['%slocal %s %s' % (body_indent, TYPES[t], newnames[t]) for t in temps]
    out = lines[:i] + decl
    handles = [newnames[t] for t in temps if TYPES[t] in HANDLE]
    for ln in lines[i:]:
        code = strip_comments(ln)
        for t in temps:
            # replace in code and in the explanatory comments, never inside string literals
            parts = re.split(r'("(?:\\.|[^"\\])*")', ln)
            ln = ''.join(p if p.startswith('"') else re.sub(r'\b%s\b' % t, newnames[t], p) for p in parts)
        stripped = code.strip()
        ind = re.match(r'\s*', ln).group(0)
        if handles and (re.match(r'return\b', stripped)):
            out += ['%sset %s=null' % (ind, h) for h in handles]
        if handles and re.match(r'endfunction\b', stripped):
            prev = strip_comments(out[-1]).strip() if out else ''
            if not re.match(r'return\b', prev):
                out += ['%sset %s=null' % (body_indent, h) for h in handles]
        out.append(ln)
    return '\n'.join(out)

def main():
    funcs, res = analyse()
    if sys.argv[1] == 'report':
        ok = [r for r in res if r['ok']]
        print('function/temp pairs: %d; safe to make local: %d' % (len(res), len(ok)))
        from collections import Counter
        print('kept (hand-offs and others):', Counter(r['reason'].split(' (')[0] if not r['reason'].startswith('caller') else 'caller reads it after the call' for r in res if not r['ok']).most_common())
        print('safe per temp:', Counter(r['temp'] for r in ok).most_common())
        if '--json' in sys.argv:
            json.dump(res, open(sys.argv[sys.argv.index('--json') + 1], 'w'), indent=1)
        return
    if sys.argv[1] == 'apply':
        mods = modules()
        want = set(sys.argv[2:]) or set(mods)
        by = {}
        for r in res:
            if r['ok'] and r['module'] in want:
                by.setdefault(r['module'], {}).setdefault(r['function'], []).append(r['temp'])
        total = 0
        for mod, fs in sorted(by.items()):
            crlf = b'\r\n' in open(mods[mod], 'rb').read()
            text, fl = parse_functions(mods[mod])
            for f in sorted(fl, key=lambda f: -f['start']):
                if f['name'] in fs:
                    text = text[:f['start']] + convert(f['text'].rstrip('\n'), sorted(fs[f['name']])) + ('\n' if f['text'].endswith('\n') else '') + text[f['end']:]
                    total += 1
            open(mods[mod], 'w', encoding='utf-8', newline='').write(text.replace('\n', '\r\n') if crlf else text)
        print('converted %d functions in %d modules' % (total, len(by)))

if __name__ == '__main__':
    main()
