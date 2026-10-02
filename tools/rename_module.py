"""Rename a code module (World Editor trigger) everywhere: trigger tree, library name, requires
lists, static ifs, InitTrig_ function, gg_trg_ variable, src/ file and trigger-list.json.

    python tools/rename_module.py BASE_MAP.w3x OUT_MAP.w3x OLD_NAME NEW_NAME [OLD NEW ...] [--runtime-out FILE]

The compiled script inside BASE_MAP is renamed the same way, so OUT_MAP stays directly playable.
Refuses if a new name or library name already exists, or if an old name appears in an
unexpected place.
"""
import argparse, json, os, re, sys
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from mpq import MPQ, replace_files, compact
from wct import read_wct, write_wct
from wtg import read_wtg, write_wtg
import build_map

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('base'); ap.add_argument('out'); ap.add_argument('names', nargs='+')
    ap.add_argument('--src', default=os.path.join(ROOT, 'src'))
    ap.add_argument('--runtime-out')
    a = ap.parse_args()
    pairs = list(zip(a.names[0::2], a.names[1::2]))
    entries = json.load(open(os.path.join(a.src, 'trigger-list.json'), encoding='utf-8'))
    names = {e['name'] for e in entries}
    libs = {e['library'] for e in entries if e.get('library')}
    base = MPQ(a.base)
    rt = base.read('war3map.j').decode('utf-8')
    t = read_wtg(base.read('war3map.wtg'))
    reps = []
    for old, new in pairs:
        e = next(x for x in entries if x['name'] == old)
        new_lib = 'T' + new.replace('_', '')
        assert new not in names and new_lib not in libs, 'name already used: ' + new
        reps += [(e['library'], new_lib), (old, new)]
        old_path = os.path.join(a.src, 'triggers', e['folder'], old + '.j')
        os.rename(old_path, os.path.join(a.src, 'triggers', e['folder'], new + '.j'))
        e['name'], e['library'] = new, new_lib
        item = next(i for i in t['items'] if i.get('name') == old and i['kind'] == 8)
        item['name'] = new
    def apply(text):
        for o, n in reps:
            text = re.sub(r'(?<![A-Za-z0-9])%s(?![A-Za-z0-9])' % re.escape(o), n, text)
        return text
    for o, _ in reps:   # every occurrence must be one we understand
        for m in re.finditer(r'\w*%s\w*' % re.escape(o), rt):
            assert re.fullmatch(r'(InitTrig_|gg_trg_|LIBRARY_)?%s' % re.escape(o), m.group(0)), m.group(0)
    for e in entries:
        if e.get('library'):
            p = os.path.join(a.src, 'triggers', e['folder'], e['name'] + '.j')
            s = open(p, encoding='utf-8', newline='').read()
            s2 = apply(s)
            if s2 != s:
                open(p, 'w', encoding='utf-8', newline='').write(s2)
    json.dump(entries, open(os.path.join(a.src, 'trigger-list.json'), 'w', encoding='utf-8'), indent=1)
    rt = apply(rt)
    if a.runtime_out:
        open(a.runtime_out, 'w', encoding='utf-8', newline='').write(rt)
    wct = build_map.build_wct(base.read('war3map.wct'), a.src)
    tmp = a.out + '.tmp'
    replace_files(a.base, tmp, {'war3map.wtg': write_wtg(t), 'war3map.wct': wct, 'war3map.j': rt.encode('utf-8')})
    compact(tmp, a.out); os.remove(tmp)
    print('renamed', ', '.join('%s -> %s' % p for p in pairs))

if __name__ == '__main__':
    main()
