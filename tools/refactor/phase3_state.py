"""Phase 3: each module owns its state. Kept as a record of exactly what changed.

    python tools/refactor/phase3_state.py SRC_DIR BASE_RUNTIME.j OUT_RUNTIME.j DOCS_DIR

1. The 1,581 trigger variables (gg_trg_*) the map header declared by hand move into the
   module whose Register_* function creates them.
2. Every other header global that only one module uses (MapBootstrap may additionally set its
   starting value) moves into that module, in a `globals` block at the top of its library.
   Only globals whose initial value does not read another variable are moved (vJass places
   library globals before the map header's, so such a value would not be ready yet).
3. The globals that stay in the map header (shared by several modules) are grouped into
   commented sections by the folder(s) that use them, keeping their original relative order,
   with a "used by" note when few modules use them.
4. Writes docs/GLOBALS.md: every global, where it is declared and which modules use it.
The same moves are applied to the compiled runtime (declarations only; no code changes).
"""
import collections, json, os, re, sys
HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, os.path.dirname(HERE))
from jtok import strip_comments

def lf(s): return s.replace('\r\n', '\n')
def crlf(s): return lf(s).replace('\n', '\r\n')
_DECL = re.compile(r'^\s*(constant\s+)?(\w+)\s+(array\s+)?(\w+)\s*(=.*)?$')
class DECL:
    @staticmethod
    def match(line):
        return _DECL.match(strip_comments(line).rstrip())
REF = re.compile(r'\b(udg_\w+|gg_\w+)\b')

def main(src, base_runtime, out_runtime, docs):
    entries = json.load(open(os.path.join(src, 'trigger-list.json'), encoding='utf-8'))
    mods = {}
    for e in entries:
        if e.get('library'):
            p = os.path.join(src, 'triggers', e['folder'], e['name'] + '.j')
            mods[e['name']] = dict(e=e, path=p, text=lf(open(p, encoding='utf-8', newline='').read()))
    hpath = os.path.join(src, 'map-header.j')
    header = lf(open(hpath, encoding='utf-8', newline='').read())
    gm = re.search(r'^globals\n(.*?)^endglobals', header, re.M | re.S)
    decls = []
    for line in gm.group(1).split('\n'):
        if not line.strip():
            continue
        m = DECL.match(line)
        assert m, line
        decls.append(dict(name=m.group(4), line=line.strip(), init=(m.group(5) or '').strip()))
    names = {d['name'] for d in decls}
    users = collections.defaultdict(set)
    for n, m in mods.items():
        for v in set(REF.findall(strip_comments(m['text']))):
            if v in names:
                users[v].add(n)
    reg_owner = {}
    for n, m in mods.items():
        for trg in re.findall(r'^function Register_(\w+) takes', m['text'], re.M):
            reg_owner['gg_trg_' + trg] = n
    owned = collections.defaultdict(lambda: dict(trg=[], var=[]))
    shared = []
    for d in decls:
        n = d['name']
        if n in reg_owner:
            d['owner'] = reg_owner[n]
            owned[reg_owner[n]]['trg'].append(d)
            continue
        others = users[n] - {'MapBootstrap'}
        if len(others) <= 1 and users[n] and not REF.search(d['init']):
            d['owner'] = next(iter(others)) if others else 'MapBootstrap'
            owned[d['owner']]['var'].append(d)
        else:
            shared.append(d)
    # ---- module globals blocks ----
    for n, o in owned.items():
        m = mods[n]
        lines = ['globals']
        if o['trg']:
            lines.append('    // Trigger variables. Each is created by the matching Register_* function in this module.')
            lines += ['    ' + d['line'] for d in o['trg']]
        if o['var']:
            lines.append('    // Variables only this module uses' + (' (MapBootstrap sets some starting values).' if n != 'MapBootstrap' and any('MapBootstrap' in users[d['name']] for d in o['var']) else '.'))
            lines += ['    ' + d['line'] for d in o['var']]
        lines.append('endglobals')
        lm = re.search(r'^library \w+[^\n]*\n', m['text'], re.M)
        m['text'] = m['text'][:lm.end()] + '\n'.join(lines) + '\n\n' + m['text'][lm.end():]
        open(m['path'], 'w', encoding='utf-8', newline='').write(crlf(m['text']))
    # ---- header sections ----
    folder_of = {n: m['e']['folder'] for n, m in mods.items()}
    def section(d):
        fs = sorted({folder_of[u] for u in users[d['name']] - {'MapBootstrap'}})
        if len(fs) == 1:
            return fs[0]
        if not fs:
            return '10 Startup coordinator'
        if re.match(r'gg_(dest|snd|unit|rct|cam)_', d['name']):
            return 'zz world'
        cnt = collections.Counter(folder_of[u] for u in users[d['name']] - {'MapBootstrap'})
        top = sorted(cnt.items(), key=lambda x: (-x[1], x[0]))[0][0]
        return 'zz shared ' + top
    groups = collections.OrderedDict()
    for d in shared:
        groups.setdefault(section(d), []).append(d)
    order = sorted(groups)
    out = ['globals',
           '    // ======================================================================================',
           '    // Map-wide variables that several modules share.',
           '    // Variables used by only one module are declared at the top of that module instead,',
           '    // and trigger variables (gg_trg_*) live in the module that creates the trigger.',
           '    // docs/GLOBALS.md lists every variable with where it is declared and who uses it.',
           '    // ======================================================================================']
    placed = set()
    for sec in order:
        if sec.startswith('zz shared '):
            title = 'Shared across folders, mostly by "%s"' % sec[len('zz shared '):]
        elif sec == 'zz world':
            title = 'Script-created world objects (destructables, sounds, units) used by several modules'
        else:
            title = 'Shared by modules in "%s"' % sec
        if sec == '10 Startup coordinator':
            title = 'Set up during startup (MapBootstrap)'
        out.append('')
        out.append('    // ---- %s ----' % title)
        for d in groups[sec]:
            us = sorted(users[d['name']])
            note = ''
            if 1 <= len(us) <= 4:
                note = 'used by: ' + ', '.join(us)
            elif len(us) > 4:
                note = 'used by %d modules' % len(us)
            line = d['line']
            if note:
                line += (' ; ' if '//' in line else ' // ') + note
            out.append('    ' + line)
            placed.add(d['name'])
    out.append('endglobals')
    # initial values may only read variables declared earlier: check
    seen = set()
    for d in decls:
        pass
    order_names = []
    for l in out:
        m = DECL.match(l)
        if m and m.group(4) in names:
            order_names.append(m.group(4))
    pos = {n: i for i, n in enumerate(order_names)}
    for d in shared:
        for r in REF.findall(d['init']):
            if r in pos and pos[r] > pos[d['name']]:
                raise SystemExit('header order would break initial value of %s (reads %s)' % (d['name'], r))
            if r in names and r not in pos:
                raise SystemExit('%s reads %s, which moved into a library' % (d['name'], r))
    new_header = header[:gm.start()] + '\n'.join(out) + '\n' + header[gm.end() + len('endglobals\n'):] if header[gm.end():].startswith('\n') else None
    new_header = header[:gm.start()] + '\n'.join(out) + header[gm.end() + len('endglobals'):]
    open(hpath, 'w', encoding='utf-8', newline='').write(crlf(new_header))
    # ---- runtime ----
    raw = open(base_runtime, 'rb').read()
    rt = lf(raw.decode('utf-8'))
    first_decl = decls[0]['name']
    start = re.search(r'^[^\n]*\b%s\b[^\n]*\n' % re.escape(first_decl), rt, re.M).start()
    end = rt.index('//JASSHelper struct globals:')
    region = rt[start:end]
    rlines = {}
    for l in region.split('\n'):
        m = DECL.match(l)
        if m:
            rlines[m.group(4)] = l
    assert set(rlines) == names, (len(rlines), len(names))
    new_region = []
    for l in out[1:-1]:
        m = DECL.match(l)
        if m and m.group(4) in names:
            new_region.append(rlines[m.group(4)])
        elif l.strip().startswith('//') or not l.strip():
            new_region.append(l.strip())
    rt = rt[:start] + '\n'.join(new_region) + '\n\n\n' + rt[end:]
    for n, o in owned.items():
        lib = mods[n]['e']['library']
        marker = 'constant boolean LIBRARY_%s=true\n' % lib
        k = rt.index(marker) + len(marker)
        add = ''.join(rlines[d['name']] + '\n' for d in o['trg'] + o['var'])
        rt = rt[:k] + add + rt[k:]
    open(out_runtime, 'wb').write((rt.replace('\n', '\r\n') if b'\r\n' in raw else rt).encode('utf-8'))
    # ---- docs ----
    rows = []
    for d in decls:
        where = 'map header (%s)' % ('shared' if d in shared else '?')
        if d.get('owner'):
            where = d['owner']
        us = sorted(users[d['name']])
        rows.append((d['name'], d['line'].split('=')[0].split('//')[0].strip().rsplit(' ', 1)[0], where,
                     ', '.join(us) if len(us) <= 12 else '%d modules: %s, ...' % (len(us), ', '.join(us[:12]))))
    rows.sort(key=lambda r: r[0].lower())
    md = ['# Global variables', '',
          'Generated by tools/refactor/phase3_state.py. "Declared in" is the module (World Editor trigger)',
          'whose `globals` block declares it, or the map header (Trigger Editor > map entry at the top).', '',
          '| Variable | Type | Declared in | Used by |', '|---|---|---|---|']
    md += ['| `%s` | %s | %s | %s |' % r for r in rows]
    open(os.path.join(docs, 'GLOBALS.md'), 'w', encoding='utf-8').write('\n'.join(md) + '\n')
    stats = dict(header_globals_before=len(decls), trigger_vars_moved=sum(len(o['trg']) for o in owned.values()),
                 module_vars_moved=sum(len(o['var']) for o in owned.values()), modules_with_globals=len(owned),
                 header_globals_after=len(shared), header_sections={k: len(v) for k, v in groups.items()})
    print(json.dumps(stats, indent=1))
    json.dump(stats, open(os.path.join(os.path.dirname(out_runtime), 'phase3-stats.json'), 'w'), indent=1)

if __name__ == '__main__':
    main(*sys.argv[1:5])
