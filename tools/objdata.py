"""Read and write Warcraft III object data (war3map.w3u/.w3t/.w3a/.w3b/.w3d/.w3h/.w3q and war3mapSkin.*).

Formats: version 1/2 (classic, up to 1.31) and version 3 (Reforged, objects have "sets").

    read_objects(data, ext) -> dict(version, original=[obj], custom=[obj])
    obj = dict(base=rawcode, id=rawcode or None, sets=[dict(flag=int, mods=[mod])])
    mod = dict(field=rawcode, type=0 int/1 real/2 unreal/3 string, level=int|None, data=int|None, value, end=int)
    write_objects(table, version) -> bytes      (version 2 keeps only the first set of each object)
"""
import struct

LEVELED = {'w3d', 'w3a', 'w3q'}   # these files store level + data pointer for every field

def fourcc(b):
    return b.decode('latin1') if b != b'\0\0\0\0' else None

class R:
    def __init__(s, d): s.d, s.o = d, 0
    def i(s):
        v, = struct.unpack_from('<i', s.d, s.o); s.o += 4; return v
    def f(s):
        v, = struct.unpack_from('<f', s.d, s.o); s.o += 4; return v
    def c(s):
        v = s.d[s.o:s.o + 4]; s.o += 4; return v
    def z(s):
        e = s.d.index(b'\0', s.o); v = s.d[s.o:e].decode('utf-8', 'replace'); s.o = e + 1; return v

def _read_mod(r, leveled):
    m = dict(field=fourcc(r.c()), level=None, data=None)
    m['type'] = r.i()
    if leveled:
        m['level'] = r.i(); m['data'] = r.i()
    m['value'] = r.i() if m['type'] == 0 else (r.f() if m['type'] in (1, 2) else r.z())
    m['end'] = r.i()
    return m

def read_objects(data, ext):
    r = R(data)
    version = r.i()
    leveled = ext in LEVELED
    out = dict(version=version, original=[], custom=[])
    for table in ('original', 'custom'):
        for _ in range(r.i()):
            o = dict(base=fourcc(r.c()), id=fourcc(r.c()), sets=[])
            nsets = r.i() if version >= 3 else 1
            for _ in range(nsets):
                flag = r.i() if version >= 3 else 0
                mods = [_read_mod(r, leveled) for _ in range(r.i())]
                o['sets'].append(dict(flag=flag, mods=mods))
            out[table].append(o)
    if r.o != len(data):
        raise ValueError('%d trailing bytes in object data' % (len(data) - r.o))
    return out

def write_objects(t, version, ext):
    leveled = ext in LEVELED
    b = bytearray(struct.pack('<i', version))
    def c(x): return (x or '\0\0\0\0').encode('latin1')
    for table in ('original', 'custom'):
        b += struct.pack('<i', len(t[table]))
        for o in t[table]:
            b += c(o['base']) + c(o['id'])
            sets = o['sets'] if version >= 3 else o['sets'][:1]
            if version >= 3:
                b += struct.pack('<i', len(sets))
            for st in sets:
                if version >= 3:
                    b += struct.pack('<i', st['flag'])
                b += struct.pack('<i', len(st['mods']))
                for m in st['mods']:
                    b += c(m['field']) + struct.pack('<i', m['type'])
                    if leveled:
                        b += struct.pack('<ii', m['level'], m['data'])
                    if m['type'] == 0:
                        b += struct.pack('<i', m['value'])
                    elif m['type'] in (1, 2):
                        b += struct.pack('<f', m['value'])
                    else:
                        b += m['value'].encode('utf-8') + b'\0'
                    b += struct.pack('<i', m['end'])
    return bytes(b)

def fields(obj, set_index=0):
    """{field: value} of one object (first set); for leveled fields the key is (field, level)."""
    out = {}
    if not obj['sets']:
        return out
    for m in obj['sets'][min(set_index, len(obj['sets']) - 1)]['mods']:
        out[m['field'] if m['level'] in (None, 0) else (m['field'], m['level'])] = m['value']
    return out
