"""Reader/writer for war3map.wtg (the Trigger Editor's tree: folders, triggers, GUI actions)
in the Reforged format this map uses (sub-version 0x80000004, format 7).

Only the GUI functions this project uses are known (ARG_COUNTS); reading a map that contains
other GUI actions raises an error instead of guessing.
"""
import struct

# number of parameters of each GUI function (from World Editor's TriggerData.txt)
ARG_COUNTS = {
    'MapInitializationEvent': 0, 'CustomScriptCode': 1, 'KillUnit': 1, 'CreateQuestBJ': 4,
    'TriggerExecute': 1, 'DoNothing': 0, 'CommentString': 1,
}
ROOT, CATEGORY, GUI, COMMENT, SCRIPT, VARIABLE = 1, 4, 8, 16, 32, 64
ITEM_TYPES = [1, 2, 4, 8, 16, 32, 64, 128]

class R:
    def __init__(s, d): s.d, s.o = d, 0
    def i(s):
        v, = struct.unpack_from('<i', s.d, s.o); s.o += 4; return v
    def s(s):
        e = s.d.index(b'\0', s.o); v = s.d[s.o:e].decode('utf-8'); s.o = e + 1; return v

class W:
    def __init__(s): s.b = bytearray()
    def i(s, v): s.b += struct.pack('<i', v)
    def s(s, v): s.b += v.encode('utf-8') + b'\0'

def read_param(r):
    p = dict(type=r.i(), value=r.s())
    p['function'] = read_function(r, False) if r.i() else None
    p['index'] = read_param(r) if r.i() else None
    return p

def write_param(w, p):
    w.i(p['type']); w.s(p['value'])
    w.i(1 if p.get('function') else 0)
    if p.get('function'):
        write_function(w, p['function'])
    w.i(1 if p.get('index') else 0)
    if p.get('index'):
        write_param(w, p['index'])

def read_function(r, child):
    f = dict(type=r.i())
    f['branch'] = r.i() if child else None
    f['name'] = r.s(); f['enabled'] = r.i()
    if f['name'] not in ARG_COUNTS:
        raise ValueError('unknown GUI function %r: add its parameter count to ARG_COUNTS' % f['name'])
    f['params'] = [read_param(r) for _ in range(ARG_COUNTS[f['name']])]
    f['children'] = [read_function(r, True) for _ in range(r.i())]
    return f

def write_function(w, f):
    w.i(f['type'])
    if f.get('branch') is not None:
        w.i(f['branch'])
    w.s(f['name']); w.i(f['enabled'])
    for p in f['params']:
        write_param(w, p)
    w.i(len(f['children']))
    for c in f['children']:
        write_function(w, c)

def read_wtg(d):
    r = R(d)
    assert d[:4] == b'WTG!'; r.o = 4
    sub, fmt = r.i(), r.i()
    assert sub == -2147483644 and fmt == 7, (hex(sub), fmt)
    t = dict(counts={}, deleted={}, items=[])
    for typ in ITEM_TYPES:
        t['counts'][typ] = r.i()
        t['deleted'][typ] = [r.i() for _ in range(r.i())]
    t['game_version'] = r.i()
    t['variables'] = []
    for _ in range(r.i()):
        v = dict(name=r.s(), type=r.s(), unk=r.i(), is_array=r.i(), size=r.i(), is_init=r.i(), init=r.s(), id=r.i(), parent=r.i())
        t['variables'].append(v)
    for _ in range(r.i()):
        typ = r.i()
        if typ in (ROOT, CATEGORY):
            it = dict(kind=typ, id=r.i(), name=r.s(), is_comment=r.i(), expanded=r.i(), parent=r.i())
        elif typ in (GUI, COMMENT, SCRIPT):
            it = dict(kind=typ, name=r.s(), desc=r.s(), is_comment=r.i(), id=r.i(), enabled=r.i(), custom=r.i(),
                      initially_off=r.i(), run_on_init=r.i(), parent=r.i())
            it['functions'] = [read_function(r, False) for _ in range(r.i())]
        elif typ == VARIABLE:
            it = dict(kind=typ, id=r.i(), name=r.s(), parent=r.i())
        else:
            raise ValueError('unknown trigger item type %d' % typ)
        t['items'].append(it)
    t['tail'] = d[r.o:]
    return t

def write_wtg(t):
    w = W()
    w.b += b'WTG!'; w.i(-2147483644); w.i(7)
    for typ in ITEM_TYPES:
        w.i(t['counts'][typ]); w.i(len(t['deleted'][typ]))
        for x in t['deleted'][typ]:
            w.i(x)
    w.i(t['game_version'])
    w.i(len(t['variables']))
    for v in t['variables']:
        w.s(v['name']); w.s(v['type']); w.i(v['unk']); w.i(v['is_array']); w.i(v['size']); w.i(v['is_init']); w.s(v['init']); w.i(v['id']); w.i(v['parent'])
    w.i(len(t['items']))
    for it in t['items']:
        w.i(it['kind'])
        if it['kind'] in (ROOT, CATEGORY):
            w.i(it['id']); w.s(it['name']); w.i(it['is_comment']); w.i(it['expanded']); w.i(it['parent'])
        elif it['kind'] in (GUI, COMMENT, SCRIPT):
            w.s(it['name']); w.s(it['desc']); w.i(it['is_comment']); w.i(it['id']); w.i(it['enabled']); w.i(it['custom'])
            w.i(it['initially_off']); w.i(it['run_on_init']); w.i(it['parent'])
            w.i(len(it['functions']))
            for f in it['functions']:
                write_function(w, f)
        else:
            w.i(it['id']); w.s(it['name']); w.i(it['parent'])
    w.b += t['tail']
    return bytes(w.b)

def string_param(value):
    return dict(type=3, value=value, function=None, index=None)

def preset_param(value):
    return dict(type=0, value=value, function=None, index=None)

def action(name, params):
    return dict(type=2, branch=None, name=name, enabled=1, params=params, children=[])
