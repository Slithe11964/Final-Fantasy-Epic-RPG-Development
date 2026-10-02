"""Stage B: add the developer test commands module (11 Developer tools / DevCommands).

    python tools/refactor/stageB_devcommands.py SRC_DIR BASE_MAP.w3x OUT_MAP.w3x OUT_RUNTIME.j

The module source must already be at src/triggers/11 Developer tools/DevCommands.j.
This script:
* adds a "11 Developer tools" folder and a custom-text trigger "DevCommands" to the trigger tree
  (at the end, so every existing trigger keeps its position) and to src/trigger-list.json;
* makes MapBootstrap start it: `requires optional TDevCommands` and a guarded
  ExecuteFunc("RegisterTriggers_DevCommands") at the end of Startup_RegisterTriggers;
* adds the compiled module to the playable script, the way JassHelper + World Editor would
  (library constant and globals, trigger variable, functions, InitTrig call), so the map plays
  without an editor save first.
Every existing function is unchanged except Startup_RegisterTriggers and InitCustomTriggers (one
call added to each).
"""
import json, os, re, sys
HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, os.path.dirname(HERE))
from mpq import MPQ, replace_files, compact
from wct import read_wct, write_wct
from wtg import read_wtg, write_wtg, CATEGORY, GUI
from vjass_lite import GLOBALS_RE, resolve_static_ifs
import build_map

FOLDER, NAME, LIB = '11 Developer tools', 'DevCommands', 'TDevCommands'

def lf(s): return s.replace('\r\n', '\n')
def crlf(s): return lf(s).replace('\n', '\r\n')

def main(src, base_map, out_map, out_runtime):
    mod_path = os.path.join(src, 'triggers', FOLDER, NAME + '.j')
    module = lf(open(mod_path, encoding='utf-8').read())
    # --- trigger-list.json
    lpath = os.path.join(src, 'trigger-list.json')
    entries = json.load(open(lpath, encoding='utf-8'))
    assert not any(e['name'] == NAME for e in entries)
    entries.append(dict(index=len(entries), name=NAME, folder=FOLDER, library=LIB))
    json.dump(entries, open(lpath, 'w', encoding='utf-8'), indent=1)
    # --- MapBootstrap source
    bpath = os.path.join(src, 'triggers', '10 Startup coordinator', 'MapBootstrap.j')
    boot = lf(open(bpath, encoding='utf-8').read())
    first = boot.split('\n', 1)
    assert first[0].startswith('library TMapBootstrap requires ')
    first[0] += ', optional ' + LIB
    boot = '\n'.join(first)
    m = re.search(r'^function Startup_RegisterTriggers takes.*?\n(?=endfunction)', boot, re.M | re.S)
    call_src = ('    static if LIBRARY_%s then\n        call ExecuteFunc("RegisterTriggers_%s") // %s (test commands; '
                'single player only)\n    endif\n') % (LIB, NAME, FOLDER)
    boot = boot[:m.end()] + call_src + boot[m.end():]
    open(bpath, 'w', encoding='utf-8', newline='').write(crlf(boot))
    # --- trigger tree
    base = MPQ(base_map)
    t = read_wtg(base.read('war3map.wtg'))
    cat_id = 0x2000000 + t['counts'][CATEGORY] + 1
    assert all(i['id'] != cat_id for i in t['items'] if i['kind'] in (1, CATEGORY))
    t['counts'][CATEGORY] += 1
    trig_items = [i for i in t['items'] if i['kind'] in (8, 16, 32)]
    new_id = max(i['id'] for i in trig_items) + 1
    t['items'].append(dict(kind=CATEGORY, id=cat_id, name=FOLDER, is_comment=0, expanded=0, parent=0))
    t['items'].append(dict(kind=GUI, name=NAME, desc='Developer test commands (-dev). Single player only. '
                           'Untick this trigger for a public release.', is_comment=0, id=new_id, enabled=1, custom=1,
                           initially_off=0, run_on_init=0, parent=cat_id, functions=[]))
    t['counts'][GUI] += 1
    assert [i for i in t['items'] if i['kind'] in (8, 16, 32)].index(t['items'][-1]) == len(entries) - 1
    w = read_wct(base.read('war3map.wct'))
    w['entries'] = list(w['entries']) + [b'']   # slot for the new trigger
    wct = build_map.build_wct(write_wct(w), src)
    # --- playable script
    rt = lf(base.read('war3map.j').decode('utf-8'))
    body = re.search(r'^library %s[^\n]*\n(.*?)^endlibrary' % LIB, module, re.M | re.S).group(1)
    libs = set(re.findall(r'^constant boolean LIBRARY_(\w+)=true$', rt, re.M)) | {LIB}
    body = resolve_static_ifs(body, libs)
    gm = GLOBALS_RE.search(body)
    mod_globals = [l.strip() for l in gm.group(1).split('\n') if l.strip() and not l.strip().startswith('//')]
    funcs = body[gm.end():].strip('\n') + '\n'
    gpos = rt.index('globals\n') + len('globals\n')
    rt = rt[:gpos] + 'constant boolean LIBRARY_%s=true\n' % LIB + '\n'.join(mod_globals) + '\n' + rt[gpos:]
    # trigger variable World Editor declares for every trigger
    k = rt.index('trigger gg_trg_Help= null\n')
    rt = rt[:k] + 'trigger gg_trg_%s= null\n' % NAME + rt[k:]
    ict = rt.index('function InitCustomTriggers takes nothing returns nothing\n')
    lead = rt.rfind('\n//====', 0, ict)
    insert_at = lead + 1 if lead != -1 and ict - lead < 120 else ict
    rt = rt[:insert_at] + '// library %s:\n' % LIB + funcs + '// library %s ends\n' % LIB + rt[insert_at:]
    m = re.search(r'^function InitCustomTriggers takes nothing returns nothing\n.*?(?=^endfunction)', rt, re.M | re.S)
    rt = rt[:m.end()] + '    call InitTrig_%s()\n' % NAME + rt[m.end():]
    m = re.search(r'^function Startup_RegisterTriggers takes nothing returns nothing\n.*?(?=^endfunction)', rt, re.M | re.S)
    rt = rt[:m.end()] + '        call ExecuteFunc("RegisterTriggers_%s") // %s (test commands; single player only)\n' % (NAME, FOLDER) + rt[m.end():]
    open(out_runtime, 'w', encoding='utf-8', newline='').write(crlf(rt))
    tmp = out_map + '.tmp'
    replace_files(base_map, tmp, {'war3map.wtg': write_wtg(t), 'war3map.wct': wct, 'war3map.j': crlf(rt).encode('utf-8')})
    compact(tmp, out_map); os.remove(tmp)
    print('added %s (%d functions) in folder %s; trigger id %#x' % (NAME, len(re.findall(r'^function ', funcs, re.M)), FOLDER, new_id))

if __name__ == '__main__':
    main(*sys.argv[1:5])
