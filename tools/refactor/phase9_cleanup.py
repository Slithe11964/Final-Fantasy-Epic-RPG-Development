"""Small hand-off cleanups on top of r15test.

    python tools/refactor/phase9_cleanup.py SRC_DIR BASE_MAP.w3x OUT_MAP.w3x VERSION

* Map name and loading-screen title (string table entries 0 and 4) become
  "Final Fantasy Epic RPG <VERSION>".
* The "Shared variables" folder of the Trigger Editor gets one sub-folder per code folder
  (Shared helpers, Map setup, Combat and abilities ...). Each variable goes into the folder of
  the modules that use it most (the grouping docs/GLOBALS.md already used).
The playable script is not changed.
"""
import json, os, re, sys
HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, os.path.dirname(HERE))
from mpq import MPQ, replace_files, compact
from wtg import read_wtg, write_wtg, CATEGORY, VARIABLE

def set_string(wts, n, text):
    pat = re.compile(r'(STRING %d\r?\n(?://[^\r\n]*\r?\n)?\{\r?\n)(.*?)(\r?\n\})' % n, re.S)
    assert pat.search(wts), n
    return pat.sub(lambda m: m.group(1) + text + m.group(3), wts, count=1)

def main(src, base_map, out_map, version):
    base = MPQ(base_map)
    raw = base.read('war3map.wts')
    bom = raw.startswith(b'\xef\xbb\xbf')
    wts = raw.decode('utf-8-sig')
    for n in (0, 4):
        wts = set_string(wts, n, 'Final Fantasy Epic RPG ' + version)
    wts_bytes = (b'\xef\xbb\xbf' if bom else b'') + wts.encode('utf-8')

    t = read_wtg(base.read('war3map.wtg'))
    shared = next(i for i in t['items'] if i['kind'] == CATEGORY and i['name'] == 'Shared variables')
    sections = {v['name']: v['section'] for v in json.load(open(os.path.join(src, 'variables.json'), encoding='utf-8'))}
    def folder_of(name):
        m = re.search(r'"(\d\d) ([^"]+)"', sections.get('udg_' + name, ''))
        return (m.group(1), m.group(2)) if m else ('99', 'Other')
    var_items = [i for i in t['items'] if i['kind'] == VARIABLE]
    groups = {}
    for it in var_items:
        groups.setdefault(folder_of(it['name']), []).append(it)
    new_items = []
    next_id = t['counts'][CATEGORY]
    used = {i['id'] for i in t['items'] if i['kind'] in (1, CATEGORY)}
    for key in sorted(groups):
        next_id += 1
        cid = 0x2000000 + next_id
        assert cid not in used
        new_items.append(dict(kind=CATEGORY, id=cid, name=key[1], is_comment=0, expanded=0, parent=shared['id']))
        for it in sorted(groups[key], key=lambda i: i['name'].lower()):
            it['parent'] = cid
            new_items.append(it)
    t['counts'][CATEGORY] = next_id
    by_name = {v['name']: v for v in t['variables']}
    for it in var_items:
        by_name[it['name']]['parent'] = it['parent']
    pos = t['items'].index(shared) + 1
    rest = [i for i in t['items'] if i['kind'] != VARIABLE]
    k = rest.index(shared) + 1
    t['items'] = rest[:k] + new_items + rest[k:]
    tmp = out_map + '.tmp'
    replace_files(base_map, tmp, {'war3map.wtg': write_wtg(t), 'war3map.wts': wts_bytes})
    compact(tmp, out_map); os.remove(tmp)
    assert read_wtg(MPQ(out_map).read('war3map.wtg')) == t
    print('%d sub-folders: %s' % (len(groups), ', '.join('%s (%d)' % (k[1], len(v)) for k, v in sorted(groups.items()))))

if __name__ == '__main__':
    main(*sys.argv[1:5])
