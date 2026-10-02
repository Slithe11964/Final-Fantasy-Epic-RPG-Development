"""Remove dead code. Kept as a record of exactly what changed.

    python tools/refactor/phase7_dead_code.py SRC_DIR BASE_MAP.w3x BASE_RUNTIME.j OUT_MAP.w3x OUT_RUNTIME.j

Dead = a function or variable that nothing in the compiled map refers to: its name appears only
in its own definition (counted over the whole playable script, including the parts World Editor
generates, and over every string, so ExecuteFunc("Name") counts as a use). Removing one can make
others dead, so this repeats until nothing changes. Modules (triggers) left with no code are
deleted from the Trigger Editor, together with every mention of them (requires lists,
World Editor's generated InitTrig call and trigger variable).
"""
import collections, json, os, re, sys
HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, os.path.dirname(HERE))
from jtok import strip_comments
from mpq import MPQ, replace_files, compact
from wct import read_wct, write_wct
from wtg import read_wtg, write_wtg, GUI
import build_map

def lf(s): return s.replace('\r\n', '\n')
def crlf(s): return lf(s).replace('\n', '\r\n')
KEEP = re.compile(r'^(InitTrig_\w+|main|config|main_old)$')

def func_re(name):
    # the function plus the comment lines directly above it
    return re.compile(r'(?:^[ \t]*//[^\n]*\n)*^(?:constant\s+)?function\s+%s\s+takes.*?^endfunction[^\n]*\n?' % re.escape(name), re.M | re.S)

def remove_func(text, name):
    m = func_re(name).search(text)
    if not m:
        return text, False
    before, after = text[:m.start()], text[m.end():]
    return before.rstrip('\n') + ('\n\n' if before.strip() else '') + after.lstrip('\n'), True

def word_counts(text):
    return collections.Counter(re.findall(r'\b\w+\b', strip_comments(text)))

def main(src, base_map, base_runtime, out_map, out_runtime):
    entries = json.load(open(os.path.join(src, 'trigger-list.json'), encoding='utf-8'))
    mods = collections.OrderedDict()
    for e in entries:
        if e.get('library'):
            p = os.path.join(src, 'triggers', e['folder'], e['name'] + '.j')
            mods[e['name']] = dict(e=e, path=p, text=lf(open(p, encoding='utf-8', newline='').read()))
    hpath = os.path.join(src, 'map-header.j')
    header = lf(open(hpath, encoding='utf-8', newline='').read())
    raw = open(base_runtime, 'rb').read()
    rt = lf(raw.decode('utf-8'))
    removed_funcs, removed_globals = [], []
    FUNC_START = re.compile(r'^(?:constant\s+)?function\s+(\w+)\s+takes', re.M)
    def remove_many(text, names):
        """Remove the named functions (and the comment lines directly above each) in one pass."""
        if not names:
            return text, set()
        lines = text.split('\n')
        out, i, done = [], 0, set()
        while i < len(lines):
            m = FUNC_START.match(lines[i])
            if m and m.group(1) in names:
                while out and (out[-1].lstrip().startswith('// ') or out[-1].strip() == '//') and not out[-1].lstrip().startswith('//='):
                    out.pop()
                j = i
                while not lines[j].startswith('endfunction'):
                    j += 1
                done.add(m.group(1))
                i = j + 1
                while i < len(lines) and not lines[i].strip() and out and not out[-1].strip():
                    i += 1
                continue
            out.append(lines[i]); i += 1
        return '\n'.join(out), done
    def dead_global_names(text, counts):
        names = set()
        for gm in re.finditer(r'^[ \t]*globals[ \t]*\n(.*?)^[ \t]*endglobals', text, re.M | re.S):
            for l in gm.group(1).split('\n'):
                d = re.match(r'^(?:constant\s+)?\w+\s+(?:array\s+)?(\w+)', strip_comments(l).strip())
                if d and counts[d.group(1)] == 1:
                    names.add(d.group(1))
        return names
    def drop_decls(text, names, within_globals=True):
        def block(gm):
            keep = [l for l in gm.group(1).split('\n')
                    if not (re.match(r'^(?:constant\s+)?\w+\s+(?:array\s+)?(\w+)', strip_comments(l).strip()) and
                            re.match(r'^(?:constant\s+)?\w+\s+(?:array\s+)?(\w+)', strip_comments(l).strip()).group(1) in names)]
            return gm.group(0).replace(gm.group(1), '\n'.join(keep))
        return re.sub(r'^[ \t]*globals[ \t]*\n(.*?)^[ \t]*endglobals', block, text, flags=re.M | re.S)
    while True:
        # A name is used if it appears more than once in the sources (JassHelper inlines small
        # functions, so the compiled script alone under-counts), or anywhere else in the compiled
        # script (World Editor's generated code).
        src_counts = word_counts(header + '\n' + '\n'.join(m['text'] for m in mods.values()))
        rt_counts = word_counts(rt)
        counts = collections.Counter({k: max(v, rt_counts[k]) for k, v in src_counts.items()})
        dead_f = {}
        for n, m in mods.items():
            for f in re.findall(r'^\s*(?:constant\s+)?function\s+(\w+)\s+takes', strip_comments(m['text']), re.M):
                if not KEEP.match(f) and counts[f] == 1:
                    dead_f[f] = n
        dead_g = {}
        for g in dead_global_names(header, counts):
            dead_g[g] = 'map header'
        for n, m in mods.items():
            for g in dead_global_names(m['text'], counts):
                dead_g[g] = n
        if not dead_f and not dead_g:
            break
        rt, done = remove_many(rt, set(dead_f))
        assert done == set(dead_f), set(dead_f) - done
        for n, m in mods.items():
            m['text'], _ = remove_many(m['text'], {f for f, o in dead_f.items() if o == n})
        rt = drop_decls(rt, set(dead_g))
        header = drop_decls(header, {g for g, o in dead_g.items() if o == 'map header'})
        for n, m in mods.items():
            m['text'] = drop_decls(m['text'], {g for g, o in dead_g.items() if o == n})
        removed_funcs += sorted(dead_f.items()); removed_globals += sorted(dead_g.items())
        print('pass: %d functions, %d variables' % (len(dead_f), len(dead_g)), file=sys.stderr)
    # tidy: comment-only lines left at the end of a globals block, empty globals blocks
    def tidy(text):
        text = re.sub(r'((?:^[ \t]*//[^\n]*\n)+)(?=^[ \t]*endglobals)', '', text, flags=re.M)
        text = re.sub(r'^globals\nendglobals\n\n?', '', text, flags=re.M)
        return text
    for m in mods.values():
        m['text'] = tidy(m['text'])
    # ---- modules with no code left --------------------------------------------------
    empty = []
    for n, m in mods.items():
        body = re.sub(r'^library[^\n]*\n|^endlibrary[^\n]*$', '', strip_comments(m['text']), flags=re.M)
        body = re.sub(r'^\s*globals\s*\n.*?^\s*endglobals', '', body, flags=re.M | re.S)
        funcs = re.findall(r'^\s*(?:constant\s+)?function\s+(\w+)', body, re.M)
        if funcs == ['InitTrig_' + n] and not re.search(r'^\s*globals', strip_comments(m['text']), re.M):
            empty.append(n)
    lib = {n: m['e']['library'] for n, m in mods.items()}
    for n in empty:
        L = lib[n]
        for o, m in mods.items():   # drop it from requires lists
            if o in empty:
                continue
            m['text'] = re.sub(r'^(library \w+ requires )([^\n]*)', lambda mm: mm.group(1) + ', '.join(
                r for r in (x.strip() for x in mm.group(2).split(',')) if r.replace('optional ', '').strip() != L), m['text'], count=1, flags=re.M)
            m['text'] = re.sub(r'^library (\w+) requires \s*$', r'library \1', m['text'], flags=re.M)
            assert 'LIBRARY_%s ' % L not in m['text'] and 'LIBRARY_%s\n' % L not in m['text'], (n, o)
        # runtime: library sections, generated trigger variable and InitTrig call
        rt = re.sub(r'^//globals from %s:\n.*?^//endglobals from %s\n' % (L, L), '', rt, flags=re.M | re.S)
        rt = re.sub(r'^//library %s:\n.*?^//library %s ends\n' % (L, L), '', rt, flags=re.M | re.S)
        rt = re.sub(r'^trigger gg_trg_%s= null\n' % re.escape(n), '', rt, flags=re.M)
        rt = re.sub(r'^    call InitTrig_%s\(\)\n' % re.escape(n), '', rt, flags=re.M)
        left = re.search(r'\b(%s|InitTrig_%s|gg_trg_%s)\b' % (L, n, n), strip_comments(rt))
        assert not left, (n, strip_comments(rt)[left.start()-200:left.end()+100])
    # ---- write sources -----------------------------------------------------------------
    for n, m in mods.items():
        if n in empty:
            os.remove(m['path'])
        else:
            open(m['path'], 'w', encoding='utf-8', newline='').write(crlf(m['text']))
    open(hpath, 'w', encoding='utf-8', newline='').write(crlf(header))
    base = MPQ(base_map)
    t = read_wtg(base.read('war3map.wtg'))
    w = read_wct(base.read('war3map.wct'))
    trig_items = [i for i in t['items'] if i['kind'] in (8, 16, 32)]
    assert len(trig_items) == len(w['entries']) == len(entries)
    keep_idx = [k for k, e in enumerate(entries) if e['name'] not in empty]
    for k, e in enumerate(entries):
        if e['name'] in empty:
            item = trig_items[k]
            assert item['name'] == e['name']
            t['items'].remove(item)
            t['deleted'][GUI].append(item['id'])
    w['entries'] = [w['entries'][k] for k in keep_idx]
    new_entries = [entries[k] for k in keep_idx]
    for i, e in enumerate(new_entries):
        e['index'] = i
    json.dump(new_entries, open(os.path.join(src, 'trigger-list.json'), 'w', encoding='utf-8'), indent=1)
    new_wct = build_map.build_wct(write_wct(w), src)
    open(out_runtime, 'wb').write((rt.replace('\n', '\r\n') if b'\r\n' in raw else rt).encode('utf-8'))
    tmp = out_map + '.tmp'
    replace_files(base_map, tmp, {'war3map.wtg': write_wtg(t), 'war3map.wct': new_wct, 'war3map.j': open(out_runtime, 'rb').read()})
    compact(tmp, out_map); os.remove(tmp)
    report = dict(functions_removed=len(removed_funcs), variables_removed=len(removed_globals), triggers_deleted=empty,
                  functions=removed_funcs, variables=removed_globals)
    json.dump(report, open(os.path.join(os.path.dirname(out_runtime), 'dead-code-removed.json'), 'w'), indent=1)
    print(json.dumps({k: v for k, v in report.items() if k not in ('functions', 'variables')}, indent=1))

if __name__ == '__main__':
    main(*sys.argv[1:6])
