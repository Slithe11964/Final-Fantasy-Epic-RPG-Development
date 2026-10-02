"""Phase 6: make modules safe to switch off in World Editor. Kept as a record of exactly what changed.

    python tools/refactor/phase6_optional.py SRC_DIR

When a custom-text trigger is disabled in World Editor, its code is left out of the map. Before
this change that always broke the map: MapBootstrap (and parent modules such as Quest or Boss)
named every module's functions and variables directly.

Now every line of the startup code (Startup_* in MapBootstrap) and of the RegisterTriggers_* lists
that uses another module is wrapped in `static if LIBRARY_T<Module> then ... endif`, and those
`requires` become `requires optional`. JassHelper keeps the line when the module is present and
drops it when the module is disabled. With every module present the compiled script is exactly
the same as before (no gameplay change). Disabling a module that other gameplay code still uses
fails at Save As with an error naming the missing function or variable; tools/disable_check.py
tells you that in advance.
"""
import collections, json, os, re, sys
HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, os.path.dirname(HERE))
from jtok import strip_comments

def lf(s): return s.replace('\r\n', '\n')
def crlf(s): return lf(s).replace('\n', '\r\n')
BLOCK = re.compile(r'^(if\b|if\(|elseif\b|else\b|endif\b|loop\b|endloop\b|exitwhen\b|local\b|return\b)')

def main(src):
    entries = json.load(open(os.path.join(src, 'trigger-list.json'), encoding='utf-8'))
    mods = collections.OrderedDict()
    for e in entries:
        if e.get('library'):
            p = os.path.join(src, 'triggers', e['folder'], e['name'] + '.j')
            mods[e['name']] = dict(e=e, path=p, text=lf(open(p, encoding='utf-8', newline='').read()))
    lib = {n: m['e']['library'] for n, m in mods.items()}
    owner = {}
    for n, m in mods.items():
        code = strip_comments(m['text'])
        for f in re.findall(r'^\s*(?:constant\s+)?function\s+(\w+)\s+takes', code, re.M):
            owner[f] = n
        for gm in re.finditer(r'^\s*globals\s*\n(.*?)^\s*endglobals', code, re.M | re.S):
            for v in re.findall(r'^\s*(?:constant\s+)?\w+\s+(?:array\s+)?(\w+)', gm.group(1), re.M):
                owner[v] = n
    for n in mods:      # World Editor declares gg_trg_<Module> itself, only while the module is enabled
        owner.setdefault('gg_trg_' + n, n)
    def users_of(line, here):
        code = strip_comments(line)
        names = set(re.findall(r'\b\w+\b', code))          # includes ExecuteFunc("Name") targets
        return sorted({owner[x] for x in names if x in owner} - {here})
    stats = collections.Counter()
    guarded_refs = collections.defaultdict(set)   # module -> modules referenced only from guarded lines (candidates)
    for n, m in mods.items():
        text = m['text']
        def guard_func(fm):
            fname = fm.group(1)
            if not (fname.startswith('RegisterTriggers_') or (n == 'MapBootstrap' and fname.startswith('Startup_'))):
                return fm.group(0)
            lines = fm.group(0).split('\n')
            out, i = [lines[0]], 1
            changed = False
            while i < len(lines) - 1:
                l = lines[i]
                us = users_of(l, n) if not BLOCK.match(l.strip()) and not l.strip().startswith('//') else []
                if not us:
                    if BLOCK.match(l.strip()) and users_of(l, n):
                        raise SystemExit('cannot guard block line in %s: %s' % (fname, l))
                    out.append(l); i += 1
                    continue
                j = i
                group = []
                while j < len(lines) - 1 and not BLOCK.match(lines[j].strip()) and not lines[j].strip().startswith('//') \
                        and users_of(lines[j], n) == us:
                    group.append(lines[j]); j += 1
                ind = re.match(r'^(\s*)', l).group(1)
                out.append('%sstatic if %s then' % (ind, ' and '.join('LIBRARY_' + lib[u] for u in us)))
                out += ['    ' + g for g in group]
                out.append(ind + 'endif')
                for u in us:
                    guarded_refs[n].add(u)
                stats['guards'] += 1
                stats['guarded_lines'] += len(group)
                changed = True
                i = j
            out.append(lines[-1])
            return '\n'.join(out)
        text = re.sub(r'^function (\w+) takes.*?^endfunction', guard_func, text, flags=re.M | re.S)
        # which requirements are only used inside guards?
        unguarded = re.sub(r'^\s*static if [^\n]*\n.*?^\s*endif\n', '', text, flags=re.M | re.S)
        used_outside = set(users_of(re.sub(r'^\s*globals\s*\n.*?^\s*endglobals', '', unguarded, flags=re.M | re.S), n))
        rm = re.search(r'^library (\w+) requires ([^\n]*)', text, re.M)
        if rm:
            reqs = [r.strip() for r in rm.group(2).split(',')]
            by_lib = {lib[k]: k for k in lib}
            new = []
            for r in reqs:
                bare = r.replace('optional ', '').strip()
                mod = by_lib.get(bare)
                if mod in guarded_refs[n] and mod not in used_outside:
                    new.append('optional ' + bare); stats['optional_requires'] += 1
                else:
                    new.append(r)
            text = text[:rm.start(2)] + ', '.join(new) + text[rm.end(2):]
        if n == 'MapBootstrap':
            text = text.replace('function main_old takes nothing returns nothing',
                                'function main_old takes nothing returns nothing', 1)
        if text != m['text']:
            m['text'] = text
            open(m['path'], 'w', encoding='utf-8', newline='').write(crlf(text))
            stats['files_changed'] += 1
    # explain the static ifs once, at the top of MapBootstrap's startup steps
    mb = mods['MapBootstrap']
    note = ('// ---- Modules can be switched off ----\n'
            '// Lines that use another module are wrapped in "static if LIBRARY_T<Module> then ... endif".\n'
            '// JassHelper keeps them while that module is enabled and leaves them out when you disable the\n'
            '// module in World Editor, so startup simply skips it. Run tools/disable_check.py first to see\n'
            '// whether other gameplay code still needs the module.\n\n')
    k = mb['text'].index('// Startup step 1:')
    mb['text'] = mb['text'][:k] + note + mb['text'][k:]
    open(mb['path'], 'w', encoding='utf-8', newline='').write(crlf(mb['text']))
    print(json.dumps(stats, indent=1))

if __name__ == '__main__':
    main(sys.argv[1])
