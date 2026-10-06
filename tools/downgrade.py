"""Make a Warcraft III 1.29.2 copy of a map saved by the Reforged World Editor.

    python tools/downgrade.py REFORGED.w3x OUT_129.w3x --w3i-template OLDER.w3x [--keep-editor-files]

What it converts (each file type was checked against the same map saved by an older editor):
  war3map.w3e        terrain      v12 -> v11  (ground texture + flags packed back into one byte)
  war3map.doo        doodads      v13 -> v8   (Reforged skin id and extra fields dropped)
  war3mapUnits.doo   placed units v13 -> v8   (same)
  war3map.w3u/t/a/b/d/h/q objects v3 -> v2    (the war3mapSkin.* part merged back in)
  war3map.w3i        map info     -> v25      (built from --w3i-template, a w3i v25/v28/v31 of the same
                                               map, with names/texts taken from the Reforged map)
  war3map.j          script       Reforged-only calls in World Editor's generated code are removed
                                  or replaced (units with skins, HD fog/water, camera fields,
                                  race skins); then pjass checks it against 1.29.2's common.j.
  war3map.wtg/.wct   triggers     Reforged -> classic (one folder level; variables kept)
  war3map.w3r/.w3c   regions/cameras -> v5 / v0 (editor files)
Removed: war3mapSkin.* and other Reforged-only files. --no-editor-files makes a play-only map.
The map's code is vJass: saving it in the 1.29 World Editor needs JassHelper there.
Every conversion is checked by reading the result back. Untested in the 1.29 game itself until
someone plays it.
"""
import argparse, os, re, struct, subprocess, sys, tempfile
HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
from mpq import MPQ, write_files, compact
from objdata import read_objects, write_objects

# ---------------------------------------------------------------- terrain
def w3e_v11(d):
    ver, = struct.unpack_from('<i', d, 4)
    if ver == 11:
        return d
    assert ver == 12, ver
    o = 9
    o += 4                                   # custom tilesets flag
    n, = struct.unpack_from('<i', d, o); o += 4 + 4 * n
    n, = struct.unpack_from('<i', d, o); o += 4 + 4 * n
    w, h = struct.unpack_from('<ii', d, o); o += 8 + 8
    assert len(d) == o + 8 * w * h, 'unexpected terrain size'
    out = bytearray(d[:o]); out[4:8] = struct.pack('<i', 11)
    for i in range(w * h):
        p = d[o + 8 * i:o + 8 * i + 8]
        v, = struct.unpack_from('<H', p, 4)
        tex, flags = v & 0x3F, (v >> 6) & 0x0F
        if tex > 15 or v >> 10:
            raise ValueError('terrain point %d uses texture %d (> 15) or unknown flags; 1.29 cannot store it' % (i, tex))
        out += p[:4] + bytes([tex | (flags << 4)]) + p[6:8]
    return bytes(out)

# ---------------------------------------------------------------- doodads / units
def _skip_sets(d, o):
    n, = struct.unpack_from('<i', d, o); o += 4
    for _ in range(n):
        k, = struct.unpack_from('<i', d, o); o += 4 + 8 * k
    return o

def doo_v8(d):
    mag, ver, sub, n = struct.unpack_from('<4siii', d, 0)
    if ver == 8:
        return d
    assert mag == b'W3do' and ver >= 13, (mag, ver)
    o, out = 16, bytearray(struct.pack('<4siii', b'W3do', 8, 11, n))
    for _ in range(n):
        base = d[o:o + 36]; o += 36 + 8                       # + skin id, -1
        mid = d[o:o + 6]; o += 6                               # flags, life, item table
        s = o; o = _skip_sets(d, o); sets = d[s:o]
        o += 4                                                 # -1
        eid = d[o:o + 4]; o += 4
        k, = struct.unpack_from('<i', d, o + 8); o += 12 + 36 * k   # Reforged extra block
        out += base + mid + sets + eid
    out += d[o:]                                               # special doodads section (same format)
    return bytes(out)

def units_v8(d):
    mag, ver, sub, n = struct.unpack_from('<4siii', d, 0)
    if ver == 8:
        return d
    assert mag == b'W3do' and ver >= 13, (mag, ver)
    o, out = 16, bytearray(struct.pack('<4siii', b'W3do', 8, 11, n))
    for _ in range(n):
        s = o
        base = d[o:o + 36]; o += 36 + 8                       # + skin id, -1
        a = o
        o += 1 + 4 + 2 + 4 + 4 + 4                             # flags, owner, 2 bytes, hp, mp, item table
        o = _skip_sets(d, o)
        o += 4 + 4 + 4 + 12                                    # gold, acquisition, hero level, str/agi/int
        k, = struct.unpack_from('<i', d, o); o += 4 + 8 * k    # items
        k, = struct.unpack_from('<i', d, o); o += 4 + 12 * k   # abilities
        rf, = struct.unpack_from('<i', d, o); o += 4
        if rf == 0:
            o += 4
        elif rf == 1:
            o += 8
        else:
            k, = struct.unpack_from('<i', d, o); o += 4 + 8 * k
        o += 12                                                # color, waygate, creation number
        body = d[a:o]
        k, = struct.unpack_from('<i', d, o + 8); o += 12 + 36 * k  # Reforged extra block
        out += base + body
    if o != len(d):
        raise ValueError('units file: %d bytes left over' % (len(d) - o))
    return bytes(out)

# ---------------------------------------------------------------- objects
# ---------------------------------------------------------------- strings (war3map.wts)
WTS_ENTRY = re.compile(r'STRING (\d+)[^\n]*\n(?:\s*//[^\n]*\n)*\s*\{\r?\n(.*?)\r?\n\}', re.S)

def wts_read(d):
    text = d.decode('utf-8-sig', 'replace') if d else ''
    return {int(k): v for k, v in WTS_ENTRY.findall(text)}

def wts_write(strings):
    return ('\ufeff' + ''.join('STRING %d\r\n{\r\n%s\r\n}\r\n\r\n' % (k, strings[k]) for k in sorted(strings))).encode('utf-8')

def inline_strings(t, strings):
    """Reforged keeps object names/tooltips in war3map.wts as TRIGSTR_n. 1.29 crashes on a wts that big
    (38,000 entries), and its own editor stores them inline, so put the text back into the objects."""
    n = 0
    for table in ('original', 'custom'):
        for o in t[table]:
            for st in o['sets']:
                for x in st['mods']:
                    if x['type'] == 3:
                        mm = re.fullmatch(r'TRIGSTR_(\d+)', x['value'] or '')
                        if mm and int(mm.group(1)) in strings:
                            x['value'] = strings[int(mm.group(1))]; n += 1
    return n

def fill_missing(t, old):
    """Reforged's editor leaves out fields it considers default, e.g. ability values for levels above the
    base ability's own level count. 1.29 doesn't fill those the same way (a Channel-based spell at a high
    level can freeze its caster), so copy every field the older, classic-saved map had and this one lacks."""
    n = 0
    for table in ('original', 'custom'):
        by = {(o['base'], o['id']): o for o in old[table]}
        for o in t[table]:
            oo = by.get((o['base'], o['id']))
            if not oo:
                continue
            mods = o['sets'][0]['mods']
            have = {(x['field'], x['level']) for x in mods}
            add = [dict(x) for x in oo['sets'][0]['mods'] if (x['field'], x['level']) not in have]
            mods += add; n += len(add)
    return n

def objects_v2(m, ext, strings=None, old=None, report=None):
    main = m.read('war3map.' + ext)
    if not main:
        return None
    t = read_objects(main, ext)
    if t['version'] <= 2 and not strings:
        return main
    skin = m.read('war3mapSkin.' + ext)
    if skin:
        st = read_objects(skin, ext)
        for table in ('original', 'custom'):
            by = {(o['base'], o['id']): o for o in t[table]}
            for so in st[table]:
                key = (so['base'], so['id'])
                if key not in by:
                    by[key] = dict(base=so['base'], id=so['id'], sets=[dict(flag=0, mods=[])])
                    t[table].append(by[key])
                mods = by[key]['sets'][0]['mods']
                have = {(x['field'], x['level']) for x in mods}
                mods += [x for x in so['sets'][0]['mods'] if (x['field'], x['level']) not in have]
    for table in ('original', 'custom'):
        for o in t[table]:
            if len(o['sets']) > 1:
                raise ValueError('%s %s has %d sets; only the first can be kept' % (ext, o['id'] or o['base'], len(o['sets'])))
    if old is not None and old.read('war3map.' + ext):
        n = fill_missing(t, read_objects(old.read('war3map.' + ext), ext))
        if report is not None and n:
            report.append('  %s: %d fields restored from the older map' % (ext, n))
    if strings:
        inline_strings(t, strings)
    out = write_objects(t, 2, ext)
    assert read_objects(out, ext)['version'] == 2
    return out

def fferpg_visuals(files):
    """Pin inherited dummy-passive art without changing unit selection or UI geometry."""
    units = read_objects(files['war3map.w3u'], 'w3u')
    abilities = read_objects(files['war3map.w3a'], 'w3a')
    by_unit = {o['id']: o for o in units['custom']}
    by_ability = {o['id']: o for o in abilities['custom']}
    expected = {'H002': ('Hapm', 'A0HL'), 'H00F': ('Eill', 'A0HP')}
    for rawcode, (base, passive) in expected.items():
        obj = by_unit.get(rawcode)
        if not obj or obj['base'] != base:
            raise ValueError('FF Epic RPG visual profile: unexpected unit ' + rawcode)
        mods = {x['field']: x['value'] for x in obj['sets'][0]['mods']}
        if passive not in mods.get('uabi', '').split(','):
            raise ValueError('FF Epic RPG visual profile: missing passive on ' + rawcode)
    for rawcode in ('A0HL', 'A0HP'):
        obj = by_ability.get(rawcode)
        if not obj or obj['base'] != 'Amgl':
            raise ValueError('FF Epic RPG visual profile: unexpected passive ' + rawcode)
        mods = obj['sets'][0]['mods']
        have = {x['field'] for x in mods}
        for field in ('acat', 'atat', 'aeat', 'asat'):
            if field not in have:
                mods.append(dict(field=field, type=3, level=0, data=0, value='', end=0))
    files['war3map.w3a'] = write_objects(abilities, 2, 'w3a')

# ---------------------------------------------------------------- regions / cameras (editor only)
def w3r_v5(d):
    ver, n = struct.unpack_from('<ii', d, 0)
    if ver == 5:
        return d
    assert ver == 7, ver
    o, out = 8, bytearray(struct.pack('<ii', 5, n))
    for _ in range(n):
        s = o; o += 16
        o = d.index(b'\0', o) + 1          # name
        o += 4 + 4                          # index, weather
        o = d.index(b'\0', o) + 1          # ambient sound
        o += 4                              # colour + end byte
        out += d[s:o]; o += 8               # Reforged: 8 extra bytes
    if o != len(d):
        raise ValueError('regions: %d bytes left over' % (len(d) - o))
    return bytes(out)

def w3c_v0(d):
    ver, n = struct.unpack_from('<ii', d, 0)
    if ver == 0:
        return d
    assert ver == 3, ver
    o, out = 8, bytearray(struct.pack('<ii', 0, n))
    for _ in range(n):
        out += d[o:o + 40]; o += 40 + 24    # 10 classic values; Reforged local pitch/yaw/roll, depth of field ...
        e = d.index(b'\0', o); out += d[o:e + 1]; o = e + 1 + 4   # name; Reforged camera type
    if o != len(d):
        raise ValueError('cameras: %d bytes left over' % (len(d) - o))
    return bytes(out)

# ---------------------------------------------------------------- trigger editor (classic format)
def triggers_classic(wtg_data, wct_data):
    from wtg import read_wtg, write_function
    import wtg as W
    from wct import read_wct, write_wct
    t = read_wtg(wtg_data)
    def s_(x): return x.encode('utf-8') + b'\0'
    def i_(x): return struct.pack('<i', x)
    cats = [i for i in t['items'] if i['kind'] == W.CATEGORY and i['parent'] == 0 and i['name'] != 'Shared variables']
    trig = [i for i in t['items'] if i['kind'] in (W.GUI, W.COMMENT, W.SCRIPT)]
    top = {c['id'] for c in cats}
    out = bytearray(b'WTG!' + i_(7) + i_(len(cats)))
    for c in cats:
        out += i_(c['id']) + s_(c['name']) + i_(c['is_comment'])
    out += i_(2) + i_(len(t['variables']))
    for v in t['variables']:
        out += s_(v['name']) + s_(v['type']) + i_(v['unk']) + i_(v['is_array']) + i_(v['size']) + i_(v['is_init']) + s_(v['init'])
    out += i_(len(trig))
    for it in trig:
        if it['parent'] not in top:
            raise ValueError('trigger %s is in a sub-folder; the classic format has one folder level' % it['name'])
        out += s_(it['name']) + s_(it['desc']) + i_(it['is_comment']) + i_(it['enabled']) + i_(it['custom'])
        out += i_(it['initially_off']) + i_(it['run_on_init']) + i_(it['parent']) + i_(len(it['functions']))
        w = W.W()
        for f in it['functions']:
            write_function(w, f)
        out += bytes(w.b)
    c = read_wct(wct_data)
    if len(c['entries']) != len(trig):
        raise ValueError('custom text entries (%d) do not match triggers (%d)' % (len(c['entries']), len(trig)))
    c['format'] = 'classic'
    return bytes(out), write_wct(c)

# ---------------------------------------------------------------- map info
class R:
    def __init__(s, d): s.d, s.o = d, 0
    def i(s):
        v, = struct.unpack_from('<i', s.d, s.o); s.o += 4; return v
    def z(s):
        e = s.d.index(b'\0', s.o); v = s.d[s.o:e]; s.o = e + 1; return v
    def raw(s, k):
        v = s.d[s.o:s.o + k]; s.o += k; return v

def w3i_v25(template, reforged):
    """Map info v25 from an older w3i of the same map; names and loading texts from the Reforged one."""
    t = R(template)
    ver = t.i()
    if ver not in (25, 28, 31):
        raise ValueError('w3i template version %d not supported' % ver)
    out = bytearray(struct.pack('<i', 25))
    out += t.raw(8)                                    # saves, editor version
    if ver >= 28:
        t.raw(16)                                      # game version (dropped)
    rf = R(reforged)
    rver = rf.i(); rf.raw(8)
    if rver >= 28:
        rf.raw(16)
    texts = [rf.z() for _ in range(4)]                 # name, author, description, players
    for _ in range(4):
        t.z()
    out += b''.join(x + b'\0' for x in texts)
    out += t.raw(32 + 16 + 12 + 1 + 4)                 # camera bounds, complements, playable w/h, flags, tileset, loading index
    rf.raw(32 + 16 + 12 + 1 + 4)
    if rver >= 33:
        rf.raw(4)                                      # Reforged: an extra loading-screen value
    loading = [rf.z() for _ in range(4)]               # loading screen model/text/title/subtitle (from the Reforged map)
    for _ in range(4):
        t.z()
    out += b''.join(x + b'\0' for x in loading)
    out += t.raw(4)                                    # game data set
    for _ in range(4):
        out += t.z() + b'\0'                           # prologue
    out += t.raw(4 + 12 + 4 + 4)                       # fog style, start/end/density, colour, weather
    out += t.z() + b'\0'                               # sound environment
    out += t.raw(1 + 4)                                # light tileset, water colour
    if ver >= 28:
        t.raw(4)                                       # script language
    if ver >= 31:
        t.raw(8)                                       # supported modes, game data version
    np = t.i(); out += struct.pack('<i', np)
    for _ in range(np):
        out += t.raw(16) + t.z() + b'\0' + t.raw(16)
        if ver >= 31:
            t.raw(8)                                   # enemy priorities (Reforged)
    out += t.d[t.o:]                                   # forces, upgrades, tech, random groups, item tables
    return bytes(out)

# ---------------------------------------------------------------- script
def split_args(s):
    depth, cur, out = 0, '', []
    for ch in s:
        if ch == ',' and depth == 0:
            out.append(cur); cur = ''
            continue
        depth += ch == '('
        depth -= ch == ')'
        cur += ch
    out.append(cur)
    return out

def replace_calls(text, name, fn):
    out, pos = [], 0
    for m in re.finditer(r'\b%s\s*\(' % name, text):
        if m.start() < pos:
            continue
        i, depth = m.end(), 1
        while depth:
            depth += text[i] == '('
            depth -= text[i] == ')'
            i += 1
        out.append(text[pos:m.start()]); out.append(fn(split_args(text[m.end():i - 1]))); pos = i
    out.append(text[pos:])
    return ''.join(out)

DROP_LINE = re.compile(r'^\s*call\s+(BlzSetTerrainFogMaxLinearDensity|BlzSetTerrainFogDrawOverSky|SetHDWaterParamsEx|SetPlayerRaceSkin|'
                       r'BlzCameraSetupSetCameraType)\s*\(.*$|^\s*call\s+CameraSetupSetField\s*\(\s*\w+\s*,\s*CAMERA_FIELD_(LOCAL_\w+|NEARZ|'
                       r'DEPTH_OF_FIELD_\w+|ZABSOLUTE)\b.*$', re.M)

def script_129(text):
    text = replace_calls(text, 'BlzCreateUnitWithSkin', lambda a: 'CreateUnit(%s)' % ','.join(a[:5]))
    text = replace_calls(text, 'SetTerrainFogExV', lambda a: 'SetTerrainFogEx(%s)' % ','.join(a[:4] + a[8:]))
    text, n = DROP_LINE.subn('', text)
    return text, n

def pjass(text, ver='1.29.2'):
    d = os.path.join(HERE, 'versions', ver)
    if not os.path.exists(os.path.join(d, 'common.j')):
        raise FileNotFoundError('Missing bundled 1.29.2 common.j')
    with tempfile.NamedTemporaryFile('w', suffix='.j', delete=False, encoding='utf-8') as f:
        f.write(text); p = f.name
    exe = os.path.join(HERE, 'bin', 'pjass.exe')
    exe = exe if os.name == 'nt' and os.path.exists(exe) else 'pjass'   # Windows: the copy in tools/bin
    r = subprocess.run([exe, os.path.join(d, 'common.j'), os.path.join(d, 'blizzard.j'), p], capture_output=True, text=True)
    os.unlink(p)
    return r.returncode == 0, [l for l in (r.stdout + r.stderr).splitlines() if 'Parse successful' not in l][:20]

REFORGED_ONLY = ['war3mapSkin.w3u', 'war3mapSkin.w3t', 'war3mapSkin.w3a', 'war3mapSkin.w3b', 'war3mapSkin.w3d',
                 'war3mapSkin.w3h', 'war3mapSkin.w3q', 'war3map.w3l', 'war3map.w3grp']
# war3mapSkin.txt is NOT Reforged-only: it is the Game Interface (resource icons, UI texts) and 1.29 reads it.

def skin_txt(d, strings):
    """Game Interface file: keep it, with its TRIGSTR_ references written out (one-line texts only)."""
    text = d.decode('utf-8-sig', 'replace')
    def sub(m):
        v = strings.get(int(m.group(1)))
        return v if v is not None and '\n' not in v and '\r' not in v else m.group(0)
    return re.sub(r'TRIGSTR_(\d+)', sub, text).encode('utf-8')

def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument('map'); ap.add_argument('out')
    ap.add_argument('--w3i-template', required=True)
    ap.add_argument('--name', help='map name shown in the map list (default: the template map\'s)')
    ap.add_argument('--fill-from', help='an older map saved by a classic-format editor (e.g. 1.32 or older): object '
                    'fields Reforged left out are copied from it. Strongly recommended')
    ap.add_argument('--no-editor-files', action='store_true', help='leave out trigger/region/camera editor files (play-only map)')
    ap.add_argument('--fferpg-visuals', action='store_true',
                    help='clear inherited Chemist/Ninja dummy-passive art, preserving unit UI settings')
    a = ap.parse_args()
    m = MPQ(a.map)
    files, report = {}, []
    files['war3map.w3e'] = w3e_v11(m.read('war3map.w3e')); report.append('terrain -> v11')
    files['war3map.doo'] = doo_v8(m.read('war3map.doo')); report.append('doodads -> v8')
    if m.read('war3mapUnits.doo'):
        files['war3mapUnits.doo'] = units_v8(m.read('war3mapUnits.doo')); report.append('placed units -> v8')
    strings = wts_read(m.read('war3map.wts'))
    for x in 'utabdhq':
        o = objects_v2(m, 'w3' + x, strings, MPQ(a.fill_from) if a.fill_from else None, report)
        if o is not None:
            files['war3map.w3' + x] = o
    report.append('object data -> v2 (skin files merged)')
    if a.fferpg_visuals:
        fferpg_visuals(files)
        report.append('FF Epic RPG: explicit dummy-passive art; unit selection/UI settings preserved')
    files['war3map.w3i'] = w3i_v25(MPQ(a.w3i_template).read('war3map.w3i'), m.read('war3map.w3i')); report.append('map info -> v25')
    text = m.read('war3map.j').decode('utf-8')
    crlf = '\r\n' in text
    text, dropped = script_129(text.replace('\r\n', '\n'))
    ok, errs = pjass(text)
    report.append('script: %d Reforged-only lines removed; units created without skins; compiles for 1.29.2: %s' % (dropped, ok))
    if not ok:
        print('\n'.join(errs))
        sys.exit('the script still uses something 1.29.2 does not have')
    files['war3map.j'] = (text.replace('\n', '\r\n') if crlf else text).encode('utf-8')
    if a.no_editor_files:
        for n in ('war3map.wtg', 'war3map.wct', 'war3map.w3r', 'war3map.w3c', 'war3map.w3s'):
            files[n] = None
    else:
        if m.read('war3map.w3r'):
            files['war3map.w3r'] = w3r_v5(m.read('war3map.w3r'))
        if m.read('war3map.w3c'):
            files['war3map.w3c'] = w3c_v0(m.read('war3map.w3c'))
        files['war3map.wtg'], files['war3map.wct'] = triggers_classic(m.read('war3map.wtg'), m.read('war3map.wct'))
        report.append('trigger editor files -> classic (wtg 7 / wct 1); regions -> v5; cameras -> v0')
    for n in REFORGED_ONLY:
        if m.read(n) is not None:
            files[n] = None
    if m.read('war3mapSkin.txt'):
        files['war3mapSkin.txt'] = skin_txt(m.read('war3mapSkin.txt'), strings)
        report.append('game interface (war3mapSkin.txt) kept')
    # keep only the strings something still points at (script, map info, trigger editor, ...)
    if strings:
        lf = m.read('(listfile)')
        names = set(x for x in (lf.decode('utf-8', 'replace').split('\r\n') if lf else []) if x) | set(files)
        used = set()
        for n in names:
            if n == 'war3map.wts':
                continue
            d = files[n] if n in files else m.read(n)
            if d:
                used |= {int(i) for i in re.findall(rb'TRIGSTR_(\d+)', d)}
        kept = {k: v for k, v in strings.items() if k in used}
        if a.name:   # the map list and lobby show the map info's name: make it the --name too
            w3i = files['war3map.w3i']
            mm = re.match(rb'TRIGSTR_(\d+)\0', w3i[12:])
            if mm and int(mm.group(1)) in kept:
                kept[int(mm.group(1))] = a.name
        files['war3map.wts'] = wts_write(kept)
        report.append('strings: object text put back inline; war3map.wts %d -> %d entries' % (len(strings), len(kept)))
    tmp = a.out + '.tmp'
    write_files(a.map, tmp, files)
    compact(tmp, a.out); os.remove(tmp)
    # 1.29's map list skips a map without the 512-byte HM3W header; copy it from the template if needed
    d = open(a.out, 'rb').read()
    if d[:4] != b'HM3W' or a.name:
        from add_header import read_header, build_header
        src = a.out if d[:4] == b'HM3W' else (a.w3i_template if open(a.w3i_template, 'rb').read(4) == b'HM3W' else None)
        name, flags, players = read_header(src) if src else (os.path.splitext(os.path.basename(a.out))[0], 0, 8)
        open(a.out, 'wb').write(build_header(a.name or name, flags, players) + d[d.find(b'MPQ\x1a'):])
        report.append('HM3W map header: "%s"' % (a.name or name))
    print('\n'.join(report))
    print('written', a.out)

if __name__ == '__main__':
    main()
