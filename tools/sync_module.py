"""Put a changed module's code into the playable script, without a World Editor save.

    python tools/sync_module.py BASE_MAP.w3x OUT_MAP.w3x MODULE [MODULE ...]

For each module (World Editor trigger name, e.g. DevCommands):
* its source (src/triggers/<folder>/<Module>.j) goes into the map's Trigger Editor text, and
* its compiled code in war3map.j - the block JassHelper marks `//library T<Module>:` ...
  `//library T<Module> ends` - is replaced by the newly compiled module (static ifs resolved);
* new library variables are declared next to the library's `LIBRARY_` constant. Changing or
  removing an existing variable is refused (do that with a World Editor save).
Every other function of the playable script stays byte-for-byte the same; the script checks that.
Use it for changes inside a module. Adding a module or a trigger still needs its own step.
"""
import json, os, re, sys
HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
from mpq import MPQ, replace_files, compact
from vjass_lite import GLOBALS_RE, resolve_static_ifs
from jtok import functions, strip_comments
import build_map

ROOT = os.path.dirname(HERE)

def lf(s): return s.replace('\r\n', '\n')

def main(base_map, out_map, names):
    src = os.path.join(ROOT, 'src')
    entries = {e['name']: e for e in json.load(open(os.path.join(src, 'trigger-list.json'), encoding='utf-8'))}
    base = MPQ(base_map)
    raw = base.read('war3map.j')
    crlf = b'\r\n' in raw
    rt = lf(raw.decode('utf-8'))
    before = functions(rt)
    libs = set(re.findall(r'^constant boolean LIBRARY_(\w+)=true$', rt, re.M))
    touched = set()
    for name in names:
        e = entries[name]
        lib = e['library']
        text = lf(open(os.path.join(src, 'triggers', e['folder'], name + '.j'), encoding='utf-8').read())
        body = re.search(r'^library %s\b[^\n]*\n(.*?)^endlibrary' % lib, text, re.M | re.S).group(1)
        body = resolve_static_ifs(body, libs)
        gm = GLOBALS_RE.search(body)
        new_globals = [l.strip() for l in (gm.group(1) if gm else '').split('\n') if l.strip() and not l.strip().startswith('//')]
        code = (body[:gm.start()] + body[gm.end():]) if gm else body
        code = re.sub(r'^([ \t]*)(?:private|public)\s+(function|constant)', r'\1\2', code, flags=re.M)
        m = re.search(r'^// ?library %s:\n.*?^// ?library %s ends\n' % (lib, lib), rt, re.M | re.S)
        if not m:
            sys.exit('no compiled block for %s in the playable script' % lib)
        rt = rt[:m.start()] + '//library %s:\n%s//library %s ends\n' % (lib, code.strip('\n') + '\n', lib) + rt[m.end():]
        # globals
        gblock = re.search(r'^globals\n(.*?)^endglobals', rt, re.M | re.S)
        declared = {}
        for line in gblock.group(1).split('\n'):
            mm = re.match(r'\s*(?:constant\s+)?\w+\s+(?:array\s+)?(\w+)', line)
            if mm:
                declared[mm.group(1)] = line.strip()
        add = []
        for g in new_globals:
            n = re.match(r'(?:constant\s+)?\w+\s+(?:array\s+)?(\w+)', g).group(1)
            if n in declared:
                if re.sub(r'\s', '', strip_comments(declared[n])) != re.sub(r'\s', '', strip_comments(g)):
                    sys.exit('variable %s changed (%s -> %s); do that with a World Editor save' % (n, declared[n], g))
            else:
                add.append(g)
        if add:
            k = rt.index('constant boolean LIBRARY_%s=true\n' % lib) + len('constant boolean LIBRARY_%s=true\n' % lib)
            rt = rt[:k] + '\n'.join(add) + '\n' + rt[k:]
        touched |= set(functions(code))
    after = functions(rt)
    changed_elsewhere = [n for n in before if n not in touched and before[n] != after.get(n)]
    if changed_elsewhere:
        sys.exit('refusing: functions outside the modules changed: %s' % changed_elsewhere[:5])
    wct = build_map.build_wct(base.read('war3map.wct'), src)
    out = rt.replace('\n', '\r\n') if crlf else rt
    tmp = out_map + '.tmp'
    replace_files(base_map, tmp, {'war3map.j': out.encode('utf-8'), 'war3map.wct': wct})
    compact(tmp, out_map); os.remove(tmp)
    print('synced %s: %d functions now in the module(s); %d functions elsewhere unchanged' % (
        ', '.join(names), len(touched), len(before) - len([n for n in before if n in touched])))

if __name__ == '__main__':
    if len(sys.argv) < 4:
        sys.exit(__doc__)
    main(sys.argv[1], sys.argv[2], sys.argv[3:])
