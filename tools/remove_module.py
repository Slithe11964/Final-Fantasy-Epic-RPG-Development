"""Remove a custom-text module (trigger) from a map, without a World Editor save. The reverse of add_module.py.

    python tools/remove_module.py BASE_MAP.w3x OUT_MAP.w3x NAME [NAME ...]

For each module this
* removes trigger NAME from the Trigger Editor (war3map.wtg; its id is recorded as deleted, the way World
  Editor does it) and from src/trigger-list.json;
* removes its Trigger Editor text (war3map.wct);
* removes its compiled code from the playable script (war3map.j): the library block, the library constant,
  the library's globals, the trigger variable gg_trg_NAME and the InitTrig_NAME call.
Nothing else may still use the module: change those callers first (and put them in with sync_module.py
afterwards, e.g. MapBootstrap's RegisterTriggers_NAME call). tools/check_map.py then confirms that the
playable script still compiles.
The source file src/triggers/<folder>/NAME.j is left for you to delete (git rm).
The output file must not exist yet.
"""
import argparse, collections, json, os, re, sys
HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
from mpq import MPQ, replace_files, compact
from wct import read_wct, write_wct
from wtg import read_wtg, write_wtg, GUI
from vjass_lite import GLOBALS_RE

ROOT = os.path.dirname(HERE)

def lf(s): return s.replace('\r\n', '\n')
def crlf(s): return lf(s).replace('\n', '\r\n')

def remove_line(rt, line, what):
    n = rt.count(line)
    if n != 1:
        sys.exit('expected exactly one %s line %r in the playable script, found %d' % (what, line.strip(), n))
    return rt.replace(line, '', 1)

def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument('base'); ap.add_argument('out'); ap.add_argument('names', nargs='+')
    a = ap.parse_args()
    if os.path.exists(a.out):
        sys.exit('output exists: ' + a.out)
    src = os.path.join(ROOT, 'src')
    lpath = os.path.join(src, 'trigger-list.json')
    entries = json.load(open(lpath, encoding='utf-8'))
    base = MPQ(a.base)
    t = read_wtg(base.read('war3map.wtg'))
    w = read_wct(base.read('war3map.wct'))
    rt = lf(base.read('war3map.j').decode('utf-8'))
    trig_items = [i for i in t['items'] if i['kind'] in (8, 16, 32)]
    if not (len(trig_items) == len(entries) == len(w['entries'])):
        sys.exit('trigger-list.json (%d), the trigger tree (%d) and the trigger text (%d) do not match'
                 % (len(entries), len(trig_items), len(w['entries'])))
    removed_words = set()
    for name in a.names:
        k = next((i for i, e in enumerate(entries) if e['name'] == name), None)
        if k is None:
            sys.exit('trigger-list.json has no ' + name)
        e = entries[k]
        if trig_items[k]['name'] != name:
            sys.exit('trigger %d in the map is %r, not %r' % (k, trig_items[k]['name'], name))
        lib = e['library']
        # --- trigger tree and text
        item = trig_items.pop(k)
        t['items'].remove(item)
        t['deleted'][item['kind']].append(item['id'])
        w['entries'] = list(w['entries'][:k]) + list(w['entries'][k + 1:])
        entries.pop(k)
        # --- playable script
        m = re.search(r'^//library %s:\n.*?^//library %s ends\n' % (lib, lib), rt, re.M | re.S)
        if not m:
            sys.exit('the playable script has no library ' + lib)
        removed_words |= set(re.findall(r'\w+', m.group(0)))
        rt = rt[:m.start()] + rt[m.end():]
        rt = remove_line(rt, 'constant boolean LIBRARY_%s=true\n' % lib, 'library constant')
        text = lf(open(os.path.join(src, 'triggers', e['folder'], name + '.j'), encoding='utf-8').read())
        gm = GLOBALS_RE.search(text)
        for g in (gm.group(1).split('\n') if gm else []):
            g = g.strip()
            if g and not g.startswith('//'):
                var = re.match(r'(?:constant\s+)?\w+\s+(?:array\s+)?(\w+)', g).group(1)
                decl = re.search(r'^[^\n/]*\b%s\b[^\n]*\n' % var, rt[:re.search(r'^endglobals$', rt, re.M).start()], re.M)
                if not decl:
                    sys.exit('global %s of %s is not declared in the playable script' % (var, name))
                rt = rt[:decl.start()] + rt[decl.end():]
        rt = re.sub(r'^//globals from %s:\n(?:[ \t]*//[^\n]*\n)*//endglobals from %s\n' % (lib, lib), '', rt, flags=re.M)
        rt = re.sub(r'^//=+\n// Trigger: %s\n//=+\n\n' % name, '', rt, flags=re.M)
        rt = remove_line(rt, 'trigger gg_trg_%s= null\n' % name, 'trigger variable')
        rt = remove_line(rt, '    call InitTrig_%s()\n' % name, 'InitTrig call')
        left = sorted(set(re.findall(r'\b(?:%s)\b' % '|'.join(
            ['LIBRARY_' + lib] + re.findall(r'^function (\w+)', text, re.M)), rt)))
        if left:
            sys.exit('%s is still used by the playable script: %s' % (name, ', '.join(left)))
        print('removed %s (%s), trigger id %#x' % (name, lib, item['id']))
    # variables only the removed code used (e.g. another module's trigger it enabled): drop them too
    sources = set(re.findall(r'\w+', ' '.join(lf(open(os.path.join(src, 'triggers', e['folder'], e['name'] + '.j'),
                                                      encoding='utf-8').read()) for e in entries if e.get('library'))))
    uses = collections.Counter(re.findall(r'\w+', rt))
    end = re.search(r'^endglobals$', rt, re.M).start()
    dropped = []
    for line in re.findall(r'^[^\n]*\n', rt[:end], re.M):
        mm = re.match(r'\s*(?:constant\s+)?\w+\s+(?:array\s+)?(\w+)\s*(?:=|$)', line)
        if mm and mm.group(1) in removed_words and uses[mm.group(1)] == 1 and mm.group(1) not in sources:
            dropped.append(mm.group(1))
    for v in dropped:
        rt = re.sub(r'^[^\n/]*\b%s\b[^\n]*\n' % v, '', rt, count=1, flags=re.M)
    if dropped:
        print('dropped variables only the removed code used:', ', '.join(dropped))
    for i, e in enumerate(entries):
        e['index'] = i
    tmp = a.out + '.tmp'
    replace_files(a.base, tmp, {'war3map.wtg': write_wtg(t), 'war3map.wct': write_wct(w), 'war3map.j': crlf(rt).encode('utf-8')})
    compact(tmp, a.out); os.remove(tmp)
    json.dump(entries, open(lpath, 'w', encoding='utf-8'), indent=1)

if __name__ == '__main__':
    main()
