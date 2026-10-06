"""Add a new custom-text module (trigger) to a map, without a World Editor save.

    python tools/add_module.py BASE_MAP.w3x OUT_MAP.w3x "FOLDER" NAME [--before LIB,LIB...]

The module's source must already be at src/triggers/<FOLDER>/<NAME>.j and define `library T<NAME>`.
This
* adds a custom-text trigger NAME to the Trigger Editor (at the end of the trigger list, inside the existing
  category FOLDER, or a new category of that name), and to src/trigger-list.json;
* puts its source into the Trigger Editor text (war3map.wct);
* adds its compiled code to the playable script (war3map.j) the way JassHelper + World Editor would: the
  library constant and globals, the trigger variable gg_trg_NAME, the functions, and the InitTrig_NAME call.
  The functions go after every library it requires and before the libraries listed in --before (the
  libraries that will use it), so JASS sees each function before it is called.
A module that needs startup registration must still be called from somewhere (MapBootstrap or a parent
registration list) - this tool does not add that. Modules that later change (e.g. to use the new one) are
put in with tools/sync_module.py.
The output file must not exist yet.
"""
import argparse, json, os, re, sys
HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
from mpq import MPQ, replace_files, compact
from wct import read_wct, write_wct
from wtg import read_wtg, write_wtg, CATEGORY, GUI
from vjass_lite import GLOBALS_RE, resolve_static_ifs
import build_map

ROOT = os.path.dirname(HERE)

def lf(s): return s.replace('\r\n', '\n')
def crlf(s): return lf(s).replace('\n', '\r\n')

def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument('base'); ap.add_argument('out'); ap.add_argument('folder'); ap.add_argument('name')
    ap.add_argument('--before', default='', help='comma-separated libraries that must come after the new one')
    ap.add_argument('--desc', default='', help='trigger comment shown in the Trigger Editor')
    a = ap.parse_args()
    if os.path.exists(a.out):
        sys.exit('output exists: ' + a.out)
    src = os.path.join(ROOT, 'src')
    module = lf(open(os.path.join(src, 'triggers', a.folder, a.name + '.j'), encoding='utf-8').read())
    lm = re.search(r'^library\s+(\w+)(?:\s+requires\s+([^\n/]*))?', module, re.M)
    lib = lm.group(1)
    requires = [r.strip() for r in (lm.group(2) or '').split(',') if r.strip()]
    # --- trigger-list.json
    lpath = os.path.join(src, 'trigger-list.json')
    entries = json.load(open(lpath, encoding='utf-8'))
    if any(e['name'] == a.name for e in entries):
        sys.exit('trigger-list.json already has ' + a.name)
    # --- trigger tree
    base = MPQ(a.base)
    t = read_wtg(base.read('war3map.wtg'))
    cats = [i for i in t['items'] if i['kind'] == CATEGORY and i['name'] == a.folder]
    if cats:
        cat_id = cats[0]['id']
    else:
        cat_id = 0x2000000 + t['counts'][CATEGORY] + 1
        t['counts'][CATEGORY] += 1
        t['items'].append(dict(kind=CATEGORY, id=cat_id, name=a.folder, is_comment=0, expanded=0, parent=0))
    trig_items = [i for i in t['items'] if i['kind'] in (8, 16, 32)]
    if len(trig_items) != len(entries):
        sys.exit('trigger-list.json (%d) does not match the map (%d triggers)' % (len(entries), len(trig_items)))
    new_id = max(i['id'] for i in t['items']) + 1
    t['items'].append(dict(kind=GUI, name=a.name, desc=a.desc, is_comment=0, id=new_id, enabled=1, custom=1,
                           initially_off=0, run_on_init=0, parent=cat_id, functions=[]))
    t['counts'][GUI] += 1
    entries.append(dict(index=len(entries), name=a.name, folder=a.folder, library=lib))
    json.dump(entries, open(lpath, 'w', encoding='utf-8'), indent=1)
    w = read_wct(base.read('war3map.wct'))
    w['entries'] = list(w['entries']) + [b'']
    wct = build_map.build_wct(write_wct(w), src, write_wtg(t))
    from editor_layout import normalize, trigger_items
    t, w = normalize(t, read_wct(wct))
    wct = write_wct(w)
    by_name = {entry['name']: entry for entry in entries}
    entries = [{**by_name[item['name']], 'index': index}
               for index, item in enumerate(trigger_items(t))]
    json.dump(entries, open(lpath, 'w', encoding='utf-8'), indent=1)
    # --- playable script
    rt = lf(base.read('war3map.j').decode('utf-8'))
    pos = {m.group(1): (m.start(), rt.index('//library %s ends' % m.group(1), m.start())) for m in re.finditer(r'^//library (\w+):', rt, re.M)}
    if lib in pos:
        sys.exit('the playable script already has library ' + lib)
    after = max([pos[r.replace('optional ', '').strip()][1] for r in requires if r.replace('optional ', '').strip() in pos] or [0])
    befores = [pos[b][0] for b in a.before.split(',') if b and b in pos]
    at = min(befores) if befores else None
    if at is None:
        at = rt.index('\n', after) + 1 if after else rt.index('//library ')
    if at <= after:
        sys.exit('cannot place %s: a library it requires comes after one that uses it' % lib)
    body = re.search(r'^library %s[^\n]*\n(.*?)^endlibrary' % lib, module, re.M | re.S).group(1)
    libs = set(re.findall(r'^constant boolean LIBRARY_(\w+)=true$', rt, re.M)) | {lib}
    body = resolve_static_ifs(body, libs)
    gm = GLOBALS_RE.search(body)
    mod_globals = [l.strip() for l in gm.group(1).split('\n') if l.strip() and not l.strip().startswith('//')] if gm else []
    funcs = (body[gm.end():] if gm else body).strip('\n') + '\n'
    block = '//library %s:\n%s//library %s ends\n' % (lib, funcs, lib)
    rt = rt[:at] + block + rt[at:]
    gpos = rt.index('globals\n') + len('globals\n')
    rt = rt[:gpos] + 'constant boolean LIBRARY_%s=true\n' % lib + ''.join(g + '\n' for g in mod_globals) + rt[gpos:]
    k = rt.index('trigger gg_trg_')
    rt = rt[:k] + 'trigger gg_trg_%s= null\n' % a.name + rt[k:]
    m = re.search(r'^function InitCustomTriggers takes nothing returns nothing\n.*?(?=^endfunction)', rt, re.M | re.S)
    rt = rt[:m.end()] + '    call InitTrig_%s()\n' % a.name + rt[m.end():]
    tmp = a.out + '.tmp'
    replace_files(a.base, tmp, {'war3map.wtg': write_wtg(t), 'war3map.wct': wct, 'war3map.j': crlf(rt).encode('utf-8')})
    compact(tmp, a.out); os.remove(tmp)
    print('added %s (%s, %d functions) in folder "%s"; trigger id %#x' % (a.name, lib, len(re.findall(r'^function ', funcs, re.M)), a.folder, new_id))

if __name__ == '__main__':
    main()
