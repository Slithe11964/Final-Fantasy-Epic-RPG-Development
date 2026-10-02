"""Export the trigger-editor source of a map into src/ so it can be reviewed and diffed in Git.

    python tools/export_sources.py MAP.w3x [SRC_DIR]

Writes:
  src/map-header.j              the map's custom script (Trigger Editor > map name entry)
  src/triggers/<folder>/<Name>.j one file per custom-text trigger, in its editor folder
  src/trigger-list.json         editor order + folder of every trigger (used by build_map.py)

Trigger names/folders come from the existing src/trigger-list.json (matched through each
module's `library T<Name>` line). Triggers the list does not know yet (e.g. ones you just added
in World Editor) are exported to src/triggers/_new/ and appended to the list - move them to the
right folder entry in trigger-list.json afterwards.
"""
import json, os, re, sys
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from mpq import MPQ
from wct import read_wct, text_of

def library_name(text):
    m = re.search(r'^\s*library\s+(\w+)', text, re.M)
    return m.group(1) if m else None

def export(map_path, src_dir):
    w = read_wct(MPQ(map_path).read('war3map.wct'))
    list_path = os.path.join(src_dir, 'trigger-list.json')
    known = json.load(open(list_path, encoding='utf-8')) if os.path.exists(list_path) else []
    by_lib = {e['library']: e for e in known if e.get('library')}
    trig_dir = os.path.join(src_dir, 'triggers')
    os.makedirs(trig_dir, exist_ok=True)
    with open(os.path.join(src_dir, 'map-header.j'), 'w', encoding='utf-8', newline='') as f:
        f.write(text_of(w['header']))
    result = []
    for index, raw in enumerate(w['entries']):
        text = text_of(raw)
        if not text:
            old = known[index] if index < len(known) and not known[index].get('library') else {}
            result.append(dict(index=index, name=old.get('name', 'gui-entry-%d' % index),
                               folder=old.get('folder', ''), library=None,
                               note=old.get('note', 'GUI trigger (no custom text); edit it in World Editor')))
            continue
        lib = library_name(text)
        entry = by_lib.get(lib)
        if entry is None:
            name = lib[1:] if lib and lib.startswith('T') else 'trigger-%d' % index
            entry = dict(name=name, folder='_new', library=lib)
        folder_dir = os.path.join(trig_dir, entry['folder'])
        os.makedirs(folder_dir, exist_ok=True)
        with open(os.path.join(folder_dir, entry['name'] + '.j'), 'w', encoding='utf-8', newline='') as f:
            f.write(text)
        result.append(dict(index=index, name=entry['name'], folder=entry['folder'], library=lib))
    with open(list_path, 'w', encoding='utf-8') as f:
        json.dump(result, f, indent=1)
    return result

if __name__ == '__main__':
    if len(sys.argv) < 2:
        sys.exit(__doc__)
    src = sys.argv[2] if len(sys.argv) > 2 else os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), 'src')
    r = export(sys.argv[1], src)
    print('exported %d trigger entries to %s' % (len(r), src))
