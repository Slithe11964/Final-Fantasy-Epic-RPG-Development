"""Move the shared map-header variables that GUI triggers can use into the Variable Editor.

    python tools/refactor/phase8_variable_editor.py SRC_DIR BASE_MAP.w3x OUT_MAP.w3x

Moved: udg_ variables declared in the map header whose type the Variable Editor supports and that
start empty (no initial value, or the type's default: 0, false, null, ""). They become normal
Variable Editor variables (the name without "udg_") in a "Shared variables" folder of the Trigger
Editor, so GUI triggers can pick them. World Editor declares them itself, with the same defaults.

Not moved (stay in the map header):
* types World Editor creates automatically (group, force, timer, dialog ...): moving them would
  create objects the code does not expect;
* string arrays and strings without a starting value (World Editor would make them "" instead of null);
* variables with a real starting value, constants, and types GUI cannot use.
The playable script is unchanged: it already declares the same variables with the same values.
"""
import json, os, re, sys
HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, os.path.dirname(HERE))
from jtok import strip_comments
from mpq import MPQ, replace_files, compact
from wtg import read_wtg, write_wtg, CATEGORY, VARIABLE
import build_map

GUI_TYPES = {'integer', 'real', 'boolean', 'string', 'unit', 'destructable', 'item', 'player', 'location', 'effect',
             'texttag', 'rect', 'trigger', 'quest', 'questitem', 'lightning', 'weathereffect', 'button', 'sound'}
DEFAULTS = {'0', '.0', '0.', '0.0', 'false', 'null', '""'}

def lf(s): return s.replace('\r\n', '\n')
def crlf(s): return lf(s).replace('\n', '\r\n')

def main(src, base_map, out_map):
    hpath = os.path.join(src, 'map-header.j')
    header = lf(open(hpath, encoding='utf-8', newline='').read())
    gm = re.search(r'^globals\n(.*?)^endglobals', header, re.M | re.S)
    keep, moved = [], []
    section = ''
    for l in gm.group(1).split('\n'):
        c = strip_comments(l).strip()
        sm = re.match(r'^\s*// ---- (.*) ----$', l)
        if sm:
            section = sm.group(1)
        m = re.match(r'^(constant\s+)?(\w+)\s+(array\s+)?(udg_\w+)\s*(?:=(.*))?$', c)
        if m and not m.group(1) and m.group(2) in GUI_TYPES and (m.group(5) is None or m.group(5).strip() in DEFAULTS) \
                and not (m.group(2) == 'string' and (m.group(3) or m.group(5) is None)):
            moved.append(dict(name=m.group(4)[4:], type=m.group(2), array=bool(m.group(3)), section=section))
            continue
        keep.append(l)
    # drop section headings left without variables
    out = []
    for i, l in enumerate(keep):
        if re.match(r'^\s*// ---- .* ----$', l):
            nxt = next((x for x in keep[i + 1:] if x.strip()), '')
            if not nxt.strip() or re.match(r'^\s*// ---- .* ----$', nxt) or nxt.strip() == '':
                continue
        out.append(l)
    body = '\n'.join(out)
    old_block = re.search(r'    // =+\n(?:    //[^\n]*\n)+?    // =+\n', body)
    new_block = (
        '    // ======================================================================================\n'
        '    // Map-wide variables that several modules share.\n'
        '    // * Most of them are in the Variable Editor (Ctrl+B), in the "Shared variables" folder of\n'
        '    //   the Trigger Editor, so GUI triggers can use them. Code uses them with the udg_ prefix.\n'
        '    // * The ones below stay here because World Editor cannot hold them the same way: groups,\n'
        '    //   timers, forces, dialogs and hashtables (it would create them automatically), string\n'
        '    //   arrays, constants and variables with a starting value.\n'
        '    // * Variables used by only one module are declared at the top of that module, and trigger\n'
        '    //   variables (gg_trg_*) live in the module that creates the trigger.\n'
        '    // docs/GLOBALS.md lists every variable with where it is declared and who uses it.\n'
        '    // ======================================================================================\n')
    body = body[:old_block.start()] + new_block + body[old_block.end():]
    body = re.sub(r'\n{3,}', '\n\n', body)
    header = header[:gm.start(1)] + body + ('\n' if not body.endswith('\n') else '') + header[gm.end(1):]
    open(hpath, 'w', encoding='utf-8', newline='').write(crlf(header))
    # trigger tree: a category and one variable record + tree item per variable
    base = MPQ(base_map)
    t = read_wtg(base.read('war3map.wtg'))
    assert not t['variables'] and t['counts'][VARIABLE] == 0
    cat_id = 0x2000000 + t['counts'][CATEGORY] + 1
    assert all(i['id'] != cat_id for i in t['items'] if i['kind'] in (1, CATEGORY))
    t['counts'][CATEGORY] += 1
    cat = dict(kind=CATEGORY, id=cat_id, name='Shared variables', is_comment=0, expanded=0, parent=0)
    items = []
    for n, v in enumerate(moved):
        vid = 0x6000000 + n
        t['variables'].append(dict(name=v['name'], type=v['type'], unk=1, is_array=int(v['array']), size=1, is_init=0, init='',
                                   id=vid, parent=cat_id))
        items.append(dict(kind=VARIABLE, id=vid, name=v['name'], parent=cat_id))
    t['counts'][VARIABLE] = len(moved)
    t['items'] = t['items'][:1] + [cat] + items + t['items'][1:]
    wct = build_map.build_wct(base.read('war3map.wct'), src)
    tmp = out_map + '.tmp'
    replace_files(base_map, tmp, {'war3map.wtg': write_wtg(t), 'war3map.wct': wct})
    compact(tmp, out_map); os.remove(tmp)
    assert read_wtg(MPQ(out_map).read('war3map.wtg')) == t
    json.dump([dict(name='udg_' + v['name'], type=v['type'] + (' array' if v['array'] else ''), section=v['section']) for v in moved],
              open(os.path.join(src, 'variables.json'), 'w', encoding='utf-8'), indent=1)
    print('moved %d variables to the Variable Editor; %d declarations stay in the map header' %
          (len(moved), sum(1 for l in out if re.match(r'^\s*(constant\s+)?\w+\s+(array\s+)?\w+', strip_comments(l)))))

if __name__ == '__main__':
    main(*sys.argv[1:4])
