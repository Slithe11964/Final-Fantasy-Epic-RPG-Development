"""Build a map from src/ (the reverse of export_sources.py).

    python tools/build_map.py BASE_MAP.w3x OUTPUT.w3x [--runtime war3map.j] [--src SRC_DIR]

Copies BASE_MAP and replaces its trigger-editor source (war3map.wct) with src/map-header.j and
src/triggers/**. Every other archive file is preserved byte-for-byte. With --runtime, the
playable script (war3map.j) is replaced too; without it the base map's compiled script stays,
so open the output in World Editor and save it (JassHelper + vJass enabled) to recompile,
then play the saved map.

The output file must not exist yet (nothing is ever overwritten).
"""
import argparse, json, os, sys
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from mpq import MPQ, replace_files, compact
from wct import read_wct, write_wct, raw_of

def crlf(text):
    return text.replace('\r\n', '\n').replace('\n', '\r\n')

def build_wct(base_wct_bytes, src_dir, tree_bytes=None):
    w = read_wct(base_wct_bytes)
    entries = json.load(open(os.path.join(src_dir, 'trigger-list.json'), encoding='utf-8'))
    if tree_bytes is not None:
        from wtg import read_wtg
        from editor_layout import trigger_items
        by_name = {entry['name']: entry for entry in entries}
        names = [item['name'] for item in trigger_items(read_wtg(tree_bytes))]
        if set(names) != set(by_name) or len(names) != len(by_name):
            raise ValueError('map/source trigger names differ')
        entries = [by_name[name] for name in names]
    if len(entries) != len(w['entries']):
        raise SystemExit('trigger-list.json has %d entries but the base map has %d trigger-editor entries. '
                         'Add/remove triggers in World Editor first, then export_sources.py.' % (len(entries), len(w['entries'])))
    w['header'] = raw_of(crlf(open(os.path.join(src_dir, 'map-header.j'), encoding='utf-8', newline='').read()))
    new_entries = []
    for e, raw in zip(entries, w['entries']):
        if not e.get('library'):
            new_entries.append(raw)          # GUI trigger: keep exactly as stored
            continue
        path = os.path.join(src_dir, 'triggers', e['folder'], e['name'] + '.j')
        new_entries.append(raw_of(crlf(open(path, encoding='utf-8', newline='').read())))
    w['entries'] = new_entries
    return write_wct(w)

def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument('base'); ap.add_argument('output')
    ap.add_argument('--runtime', help='compiled war3map.j to package as the playable script')
    ap.add_argument('--src', default=os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), 'src'))
    a = ap.parse_args()
    base = MPQ(a.base)
    files = {'war3map.wct': build_wct(base.read('war3map.wct'), a.src, base.read('war3map.wtg'))}
    if a.runtime:
        files['war3map.j'] = open(a.runtime, 'rb').read()
    if os.path.exists(a.output):
        raise SystemExit('output exists: ' + a.output)
    tmp = a.output + '.tmp'
    if os.path.exists(tmp):
        os.remove(tmp)
    replace_files(a.base, tmp, files)
    compact(tmp, a.output)     # drop the space the replaced files used to occupy
    os.remove(tmp)
    print('wrote', a.output, '(' + ', '.join(sorted(files)) + ' replaced; all other files preserved)')

if __name__ == '__main__':
    main()
