"""Read (and write) FF Epic RPG -save codes outside the game.

    python tools/savecode.py decode CODE [--items itemtable.txt] [--name PLAYERNAME]
    python tools/savecode.py checkname CODE NAME
    python tools/savecode.py rename CODE NEWNAME [--old OLDNAME]
    python tools/savecode.py selftest

checkname says whether CODE belongs to the player NAME. rename gives the same code for a new
account name (a player who changed their Battle.net name keeps their progress): only the 20-bit
name hash and the checksum change (plus the armory part's link to them); everything else stays. With --old,
the code is only rewritten if it really belongs to OLDNAME. Names are used like the game does:
anything from "#" on (the BattleTag number) is ignored, and case doesn't matter.

decode prints what a code holds: difficulty, gold, every job level, Freelancer/Gaya, the three
inventories, weapon/armor upgrades, titles and the other flags. It mirrors the game's reader
(Cmd.j, Trig_Cmd_Load_Code_LoadCodeV3) step by step, for code versions G and H (the current ones).

Item charges: a charged item (potions ...) stores 7 extra bits, and only the game knows which
items are charged. In game, the developer command -dumpitems writes
Documents/Warcraft III/CustomMapData/FFERPG/itemtable.txt; pass it with --items. Without it the
tool guesses from the map's object data (src/items-guess.json, made by tools/objects.py) and
says so.

selftest writes random codes with the Python writer (a copy of Save.j's writer) and reads them
back: it proves the reader and writer agree. It cannot prove they match the game exactly - for
that, decode a real code and compare with what the game shows.
"""
import json, os, random, re, sys
ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
ALPHABET = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890$#'
JOBS = ['Squire', 'Knight', 'Archer', 'Monk', 'Thief', 'Geomancer', 'Samurai', 'Lancer', 'Ninja', 'Holy Swordsman',
        'Chemist', 'Wizard', 'Priest', 'Summoner', 'Time Mage', 'Mediator', 'Oracle', 'Calculator', 'Prophet',
        'Sorcerer', 'Dark Knight', 'Necromancer']
UPGRADES = ['Tools', 'Sword', 'Bow', 'Rod', 'Staff', 'Plate Armor', 'Leather Armor', 'Mystic Armor', 'Axe', 'Spear',
            'Katana', 'Dagger', 'Gun', 'Greatsword', 'Inner Mana']
DIFFICULTY = {0: 'blank (new game+ code)', 1: 'Simple / Very Easy', 2: 'Normal', 3: 'Hard or above'}

# ---------------------------------------------------------------- player names
def _mix(a, b, c):
    M = 0xFFFFFFFF
    a = (a - b - c) & M; a ^= c >> 13
    b = (b - c - a) & M; b ^= (a << 8) & M
    c = (c - a - b) & M; c ^= b >> 13
    a = (a - b - c) & M; a ^= c >> 12
    b = (b - c - a) & M; b ^= (a << 16) & M
    c = (c - a - b) & M; c ^= b >> 5
    a = (a - b - c) & M; a ^= c >> 3
    b = (b - c - a) & M; b ^= (a << 10) & M
    c = (c - a - b) & M; c ^= b >> 15
    return a, b, c

def string_hash(text):
    """The game's StringHash (Storm's SStrHash2: Bob Jenkins' 1997 hash of the text with a-z upper-cased and
    / turned into \\). Exact for plain ASCII names; for other letters 1.29 and Reforged may differ."""
    k = bytes(ch - 32 if 97 <= ch <= 122 else (92 if ch == 47 else ch) for ch in text.encode('utf-8'))
    a = b = 0x9E3779B9; c = 0
    n, i = len(k), 0
    while n - i >= 12:
        a = (a + int.from_bytes(k[i:i + 4], 'little')) & 0xFFFFFFFF
        b = (b + int.from_bytes(k[i + 4:i + 8], 'little')) & 0xFFFFFFFF
        c = (c + int.from_bytes(k[i + 8:i + 12], 'little')) & 0xFFFFFFFF
        a, b, c = _mix(a, b, c); i += 12
    c = (c + n) & 0xFFFFFFFF
    rest = k[i:]
    for j, byte in enumerate(rest):
        if j < 4:
            a = (a + (byte << (8 * j))) & 0xFFFFFFFF
        elif j < 8:
            b = (b + (byte << (8 * (j - 4)))) & 0xFFFFFFFF
        else:
            c = (c + (byte << (8 * (j - 7)))) & 0xFFFFFFFF
    _, _, c = _mix(a, b, c)
    return c - (1 << 32) if c >= 1 << 31 else c

def game_name(name):
    """udg_PlayerName: the account name up to the first '#' (Trig_Player_Init_StripTag)."""
    return name.split('#', 1)[0]

def name_hash(name):
    """What -save writes: abs(StringHash(name)) mod 2^20 (Trig_Cmd_Load_Code_PlayerNameHash)."""
    return abs(string_hash(game_name(name))) % (1 << 20)

class CodeError(Exception):
    pass

def value_of(ch):
    k = ALPHABET.find(ch)
    if k < 0:
        raise CodeError('character %r is not part of a save code' % ch)
    return k

def checksum(body):
    s = 11941
    for ch in body:
        if ch in '()':
            break
        s += value_of(ch)
    return s % (1 << 18) if s > (1 << 18) else s

class Reader:
    def __init__(self, version, body):
        self.key, self.buf, self.bits, self.pos, self.body = 13 * version, 0, 0, 0, body
        self.log = []
    def bits_(self, n, what=''):
        while self.bits < n:
            if self.pos >= len(self.body) or self.body[self.pos] in '()':
                raise CodeError('code ended too early (reading %s)' % (what or '%d bits' % n))
            self.buf = self.buf * 64 + value_of(self.body[self.pos]); self.pos += 1; self.bits += 6
        self.bits -= n
        v = self.buf >> self.bits
        self.buf -= v << self.bits
        v -= self.key % (1 << n)
        if v < 0:
            v += 1 << n
        self.key += 211
        self.log.append((what, n, v))
        return v

class Writer:
    def __init__(self, version):
        self.key, self.buf, self.bits, self.out = 13 * version, 0, 0, ''
    def bits_(self, value, n):
        m = (self.key + value) % (1 << n)
        self.key += 211
        self.buf = self.buf * (1 << n) + m
        self.bits += n
        while self.bits >= 6:
            self.bits -= 6
            c = self.buf >> self.bits
            self.buf -= c << self.bits
            self.out += ALPHABET[c]

# ---------------------------------------------------------------- reading
def read_level(r, cap, what):
    if r.bits_(1, what + ' (short form?)') == 1:
        return 99 + r.bits_(1, what + ' (99 or mastered)') if cap else 1
    return r.bits_(7, what)

def read_inventory(r, charged, what):
    n = r.bits_(3, what + ' item count')
    items = []
    for k in range(n):
        idx = r.bits_(9, '%s item %d' % (what, k + 1))
        ch = None
        is_charged = charged(idx)
        if is_charged:
            ch = r.bits_(7, '%s item %d charges' % (what, k + 1))
        items.append((idx, ch, is_charged))
    return items

def decode(code, charged=lambda i: False):
    code = re.sub(r'\|c[0-9A-Fa-f]{8}|\|r|\s', '', code)
    if len(code) < 8:
        raise CodeError('too short')
    version = value_of(code[0])
    if version not in (6, 7):
        raise CodeError('version %s (%d): this tool reads G and H codes only' % (code[0], version))
    stored = 0
    for ch in code[1:4]:
        stored = stored * 64 + value_of(ch)
    body = code[4:]
    expect = checksum(body)
    if stored != expect:
        raise CodeError('checksum mismatch (stored %d, computed %d): the code is mistyped or incomplete' % (stored, expect))
    main, _, armory = body.partition('(')
    r = Reader(version, main)
    out = dict(version=code[0], armory_part=bool(armory), armory_chars=len(armory.rstrip(')')))
    out['name_hash'] = r.bits_(20, 'player name hash')
    out['difficulty'] = r.bits_(2, 'difficulty')
    out['gold_plus_1500_per_shard'] = r.bits_(20, 'gold')
    gaya_mastered = r.bits_(1, 'Gaya mastered') == 1
    ng = r.bits_(1, 'new game+ bit 1')
    cap = r.bits_(1, 'level list: mostly max?') == 1
    out['jobs'] = {j: read_level(r, cap, j) for j in JOBS}
    out['freelancer'] = read_level(r, cap, 'Freelancer')
    out['gaya'] = dict(mastered=gaya_mastered)
    if not gaya_mastered:
        out['gaya']['level'] = read_level(r, cap, 'Gaya')
        out['gaya']['abilities'] = dict(break_stun=r.bits_(2, 'Gaya Break Stun'), mana_transfer=r.bits_(2, 'Gaya Mana Transfer'),
                                        mega_heal=r.bits_(2, 'Gaya Mega Heal'), tarugaya=r.bits_(1, 'Tarugaya'),
                                        sukugaya=r.bits_(1, 'Sukugaya'), rakugaya=r.bits_(1, 'Rakugaya'))
    ng += 4 * r.bits_(1, 'new game+ bit 4')
    out['hero_items'] = read_inventory(r, charged, 'hero')
    out['gaya_items'] = read_inventory(r, charged, 'Gaya')
    out['house_items'] = read_inventory(r, charged, 'house')
    tcap = r.bits_(1, 'upgrade list: mostly max?') == 1
    ups = {}
    for u in UPGRADES:
        if r.bits_(1, u + ' (short form?)') == 1:
            ups[u] = 10 if tcap else 0
        else:
            ups[u] = r.bits_(4, u)
    out['upgrades'] = ups
    ng += 2 * r.bits_(1, 'new game+ bit 2')
    t = set()
    def flag(n):
        if r.bits_(1, 'title %d' % n):
            t.add(n)
    def ladder(nbits, names, extra=None):
        v = r.bits_(nbits, 'titles ' + '/'.join(map(str, names)))
        for k, n in enumerate(names, 1):
            if v >= k:
                t.add(n)
        if v >= len(names) and extra:
            flag(extra)
    flag(18); r.bits_(1, 'title 19 (not loaded)')
    ladder(2, [15, 16, 17]); flag(20); flag(59)
    ladder(2, [21, 22, 23], 24); flag(29); flag(54)
    ladder(2, [25, 26, 27], 28); flag(53); flag(34)
    v = r.bits_(3, 'titles 30/31/32/33/49/51')
    if v >= 1: t.add(30)
    if v == 2: t.add(51)
    if v >= 3: t.add(31)
    if v >= 4: t.add(51)
    if v >= 5: t.add(32)
    if v >= 6: t.add(33)
    if v >= 7: t.add(49)
    flag(50); flag(43)
    ladder(2, [39, 40, 41], 42); flag(55)
    out['titles'] = sorted(t)
    r.bits_(1, 'unused')
    out['speedrun_level'] = r.bits_(4, 'speedrun level')
    r.bits_(1, 'unused'); r.bits_(1, 'unused')
    out['miracle_stage'] = r.bits_(2, 'miracle stage')
    out['meta_fragments'] = r.bits_(3, 'meta fragments (+1)')
    ng += 8 * r.bits_(1, 'new game+ bit 8')
    out['legendary_guardian'] = r.bits_(1, 'Legendary Guardian') == 1
    out['new_game_plus'] = (15 - ng) if ng >= 11 else (5 + ng if ng <= 5 else 'invalid (%d): the game marks this player as a cheater' % ng)
    out['armory_allowed_on_hard'] = r.bits_(1, 'armory allowed on Hard+') == 1
    left = len(main) - r.pos
    if left != 0:
        raise CodeError('%d characters left over: the item-charge guess is probably wrong (use --items)' % left)
    return out, r

# ---------------------------------------------------------------- writing (copy of Save.j)
def encode(d, charged=lambda i: False, armory=''):
    version = 7 if armory else 6
    w = Writer(version)
    w.bits_(d['name_hash'], 20); w.bits_(d['difficulty'], 2); w.bits_(d['gold_plus_1500_per_shard'], 20)
    g = d['gaya']
    w.bits_(1 if g['mastered'] else 0, 1)
    ng_bits = d['_ng_bits']
    w.bits_(ng_bits & 1, 1)
    levels = [d['jobs'][j] for j in JOBS] + [d['freelancer']] + ([] if g['mastered'] else [g['level']])
    mostly_max = sum(1 for l in levels if l >= 99) > sum(1 for l in levels if l <= 1)
    w.bits_(1 if mostly_max else 0, 1)
    for l in levels:
        if mostly_max and l >= 99:
            w.bits_(1, 1); w.bits_(0 if l == 99 else 1, 1)
        elif not mostly_max and l <= 1:
            w.bits_(1, 1)
        else:
            w.bits_(0, 1); w.bits_(l, 7)
    if not g['mastered']:
        a = g['abilities']
        for k, n in (('break_stun', 2), ('mana_transfer', 2), ('mega_heal', 2), ('tarugaya', 1), ('sukugaya', 1), ('rakugaya', 1)):
            w.bits_(a[k], n)
    w.bits_((ng_bits >> 2) & 1, 1)
    for inv in ('hero_items', 'gaya_items', 'house_items'):
        w.bits_(len(d[inv]), 3)
        for idx, ch, _ in d[inv]:
            w.bits_(idx, 9)
            if charged(idx):
                w.bits_(ch, 7)
    ups = [d['upgrades'][u] for u in UPGRADES]
    tmax = sum(1 for u in ups if u >= 10) > sum(1 for u in ups if u <= 0)
    w.bits_(1 if tmax else 0, 1)
    for u in ups:
        if tmax and u >= 10:
            w.bits_(1, 1)
        elif not tmax and u <= 0:
            w.bits_(1, 1)
        else:
            w.bits_(0, 1); w.bits_(u, 4)
    w.bits_((ng_bits >> 1) & 1, 1)
    t = set(d['titles'])
    f = lambda n: w.bits_(1 if n in t else 0, 1)
    def ladder(names, nbits, extra=None):
        v = 0
        for k, n in enumerate(names, 1):
            if n in t:
                v = k
        w.bits_(v, nbits)
        if extra and v == len(names):
            f(extra)
    f(18); f(19); ladder([15, 16, 17], 2); f(20); f(59)
    ladder([21, 22, 23], 2, 24); f(29); f(54); ladder([25, 26, 27], 2, 28); f(53); f(34)
    if 49 in t: v = 7
    elif 33 in t: v = 6
    elif 32 in t: v = 5
    elif 31 in t: v = 4 if 51 in t else 3
    elif 51 in t: v = 2
    elif 30 in t: v = 1
    else: v = 0
    w.bits_(v, 3); f(50); f(43); ladder([39, 40, 41], 2, 42); f(55)
    w.bits_(0, 1); w.bits_(d['speedrun_level'], 4); w.bits_(0, 1); w.bits_(0, 1)
    w.bits_(d['miracle_stage'], 2); w.bits_(d['meta_fragments'], 3)
    w.bits_((ng_bits >> 3) & 1, 1)
    w.bits_(1 if d['legendary_guardian'] else 0, 1)
    w.bits_(1 if d['armory_allowed_on_hard'] else 0, 1)
    if w.bits > 0:
        w.bits_(0, 6 - w.bits)
    body = w.out
    cs = checksum(body)
    cs_chars = ''.join(ALPHABET[(cs >> s) & 63] for s in (12, 6, 0))
    if armory:      # armory bits as code characters: header = own checksum + copy of the main checksum
        rest = cs_chars + armory
        acs = checksum(rest)
        armory = ''.join(ALPHABET[(acs >> s) & 63] for s in (12, 6, 0)) + rest
    return ALPHABET[version] + cs_chars + body + (('(' + armory + ')') if armory else '')

# ---------------------------------------------------------------- names
def load_items(path):
    """itemtable.txt written by the in-game -dumpitems command: lines 'index rawcode charged name'."""
    table = {}
    for line in open(path, encoding='utf-8', errors='replace'):
        m = re.search(r'ITEM (\d+) (\S{4}) ([01]) (.*?)(?:"\s*\)|$)', line)
        if m:
            table[int(m.group(1))] = dict(id=m.group(2), charged=m.group(3) == '1', name=m.group(4).strip())
    return table

def titles():
    names = {}
    for root, _, files in os.walk(os.path.join(ROOT, 'src', 'triggers')):
        for f in files:
            for m in re.finditer(r'set udg_TitleName\[(\d+)\]="([^"]*)"', open(os.path.join(root, f), encoding='utf-8').read()):
                names[int(m.group(1))] = m.group(2)
    return names

def clean(code):
    return re.sub(r'\|c[0-9A-Fa-f]{8}|\|r|\s', '', code)

def code_name_hash(code):
    """Check the code's checksum and return (version, stored name hash)."""
    code = clean(code)
    if len(code) < 8:
        raise CodeError('too short')
    version = value_of(code[0])
    stored = 0
    for ch in code[1:4]:
        stored = stored * 64 + value_of(ch)
    if stored != checksum(code[4:]):
        raise CodeError('checksum mismatch: the code is mistyped or incomplete')
    return version, Reader(version, code[4:]).bits_(20)

def rename_armory(old_cs3, armory, new_cs3):
    """The armory part (between the brackets) starts with its own 3-character checksum, then a copy of
    the main code's checksum (that is how -loada knows the two parts belong together), then the armory
    bits. When the main checksum changes, the copy and the armory checksum must change too
    (Save_EncodeUnitFlags / Trig_Cmd_Load_Code_LoadArmory)."""
    if len(armory) < 7:
        raise CodeError('the armory part (in brackets) is too short')
    stored = 0
    for ch in armory[:3]:
        stored = stored * 64 + value_of(ch)
    if stored != checksum(armory[3:]):
        raise CodeError('the armory part (in brackets) has a checksum error: it was changed or cut off')
    if armory[3:6] != old_cs3:
        raise CodeError('the armory part (in brackets) does not belong to this code')
    rest = new_cs3 + armory[6:]
    acs = checksum(rest)
    return ''.join(ALPHABET[(acs >> sh) & 63] for sh in (12, 6, 0)) + rest

def rename(code, new_name):
    """The same code for another player name. The name hash is the first field (bits 0-19 of the body,
    key 13*version), so only body characters 0-3 and the checksum change - and with them the armory
    part's header (its checksum and its copy of the main checksum)."""
    code = clean(code)
    version, _ = code_name_hash(code)
    if version not in (6, 7):
        raise CodeError('version %s: only G and H codes are supported' % code[0])
    body = code[4:]
    first = 0
    for ch in body[:4]:
        first = first * 64 + value_of(ch)            # 24 bits: name hash (20) + 4 bits of the next field
    low4 = first & 0xF
    w = Writer(version); w.bits_(name_hash(new_name), 20)
    first = (ALPHABET.index(w.out[0]) << 18 | ALPHABET.index(w.out[1]) << 12 | ALPHABET.index(w.out[2]) << 6) | (w.buf << 4) | low4
    main, sep, armory = body.partition('(')
    new_main = ''.join(ALPHABET[(first >> sh) & 63] for sh in (18, 12, 6, 0)) + main[4:]
    cs = checksum(new_main)
    cs3 = ''.join(ALPHABET[(cs >> sh) & 63] for sh in (12, 6, 0))
    if sep:
        armory = rename_armory(code[1:4], armory, cs3)
    out = code[0] + cs3 + new_main + sep + armory
    if code_name_hash(out)[1] != name_hash(new_name):
        raise CodeError('internal error: rewritten code does not check out')
    return out

def main():
    if len(sys.argv) < 2:
        sys.exit(__doc__)
    if sys.argv[1] == 'selftest':
        return selftest()
    if sys.argv[1] in ('checkname', 'rename'):
        import argparse
        ap = argparse.ArgumentParser(); ap.add_argument('cmd'); ap.add_argument('code'); ap.add_argument('name'); ap.add_argument('--old')
        a = ap.parse_args()
        try:
            _, h = code_name_hash(a.code)
            if a.cmd == 'checkname':
                ok = h == name_hash(a.name)
                print('%s: this code %s to "%s" (code hash %d, name hash %d)' % ('YES' if ok else 'NO', 'belongs' if ok else 'does not belong', game_name(a.name), h, name_hash(a.name)))
                sys.exit(0 if ok else 1)
            if a.old is not None and h != name_hash(a.old):
                sys.exit('refused: this code does not belong to "%s" (code hash %d, that name gives %d)' % (game_name(a.old), h, name_hash(a.old)))
            print(rename(a.code, a.name))
        except CodeError as e:
            sys.exit('cannot read this code: %s' % e)
        return
    import argparse
    ap = argparse.ArgumentParser(); ap.add_argument('cmd'); ap.add_argument('code'); ap.add_argument('--items'); ap.add_argument('--log', action='store_true'); ap.add_argument('--name')
    a = ap.parse_args()
    items, note = {}, ''
    if a.items:
        items = load_items(a.items)
    else:
        gp = os.path.join(ROOT, 'src', 'items-guess.json')
        if os.path.exists(gp):
            items = {int(k): v for k, v in json.load(open(gp, encoding='utf-8')).items()}
        note = '(item charges guessed from object data; pass --items itemtable.txt from -dumpitems to be sure)'
    charged = lambda i: bool(items.get(i, {}).get('charged'))
    try:
        d, r = decode(a.code, charged)
    except CodeError as e:
        sys.exit('cannot read this code: %s %s' % (e, note))
    tn = titles()
    print('Code version %s%s' % (d['version'], ' + armory part (%d chars, not decoded)' % d['armory_chars'] if d['armory_part'] else ''))
    print('Difficulty: %s   Gold (+1500 per Crystal Shard): %d   Name hash: %d' % (DIFFICULTY.get(d['difficulty']), d['gold_plus_1500_per_shard'], d['name_hash']))
    print('New Game+: %s   Speedrun level: %d   Miracle stage: %d   Meta fragments: %d   Legendary Guardian: %s' % (
        d['new_game_plus'], d['speedrun_level'], d['miracle_stage'], max(0, d['meta_fragments'] - 1), d['legendary_guardian']))
    print('Jobs: ' + ', '.join('%s %s' % (j, 'Master' if l >= 100 else l) for j, l in d['jobs'].items() if l > 1))
    print('Freelancer: %s   Gaya: %s' % (d['freelancer'], 'mastered' if d['gaya']['mastered'] else d['gaya']))
    for inv in ('hero_items', 'gaya_items', 'house_items'):
        print('%s: %s' % (inv.replace('_', ' '), ', '.join('%s%s' % (items.get(i, {}).get('name') or '#%d' % i, ' x%d' % c if c is not None else '') for i, c, _ in d[inv]) or '-'))
    print('Upgrades: ' + ', '.join('%s %d' % kv for kv in d['upgrades'].items() if kv[1]))
    print('Titles: ' + ', '.join(tn.get(n, '#%d' % n) for n in d['titles']))
    if a.name is not None:
        ok = d['name_hash'] == name_hash(a.name)
        print('Belongs to "%s": %s' % (game_name(a.name), 'yes' if ok else 'NO (that name gives %d)' % name_hash(a.name)))
    if note:
        print(note)
    if a.log:
        for what, n, v in r.log:
            print('  %-40s %2d bits = %d' % (what, n, v))

def selftest(rounds=2000):
    rnd = random.Random(7)
    charged = lambda i: i % 5 == 0
    for k in range(rounds):
        gm = rnd.random() < 0.3
        d = dict(name_hash=rnd.randrange(1 << 20), difficulty=rnd.randrange(4), gold_plus_1500_per_shard=rnd.randrange(1000000),
                 jobs={j: rnd.choice([1, 1, rnd.randrange(2, 99), 99, 100]) for j in JOBS}, freelancer=rnd.choice([1, 50, 99, 100]),
                 gaya=dict(mastered=True) if gm else dict(mastered=False, level=rnd.choice([1, 40, 99]),
                           abilities=dict(break_stun=rnd.randrange(4), mana_transfer=rnd.randrange(4), mega_heal=rnd.randrange(4),
                                          tarugaya=rnd.randrange(2), sukugaya=rnd.randrange(2), rakugaya=rnd.randrange(2))),
                 _ng_bits=rnd.choice([0, 1, 2, 3, 4, 5, 11, 12, 13, 14, 15]),
                 hero_items=[(rnd.randrange(1, 352), None, False) for _ in range(rnd.randrange(7))],
                 gaya_items=[(rnd.randrange(1, 352), None, False) for _ in range(rnd.randrange(7))],
                 house_items=[(rnd.randrange(1, 352), None, False) for _ in range(rnd.randrange(7))],
                 upgrades={u: rnd.choice([0, 0, 3, 10, 10]) for u in UPGRADES},
                 titles=sorted(rnd.sample([15, 16, 17, 18, 20, 59, 21, 22, 23, 24, 29, 54, 25, 26, 27, 28, 53, 34, 30, 50, 43, 39, 40, 41, 42, 55], 4)),
                 speedrun_level=rnd.randrange(16), miracle_stage=rnd.randrange(4), meta_fragments=rnd.randrange(8),
                 legendary_guardian=rnd.random() < .5, armory_allowed_on_hard=rnd.random() < .5)
        for inv in ('hero_items', 'gaya_items', 'house_items'):
            d[inv] = [(i, rnd.randrange(100) if charged(i) else None, charged(i)) for i, _, _ in d[inv]]
        # ladders in the format can only hold consistent sets: keep only representable titles
        code = encode(d, charged, armory='ABCxyz019$#' if k % 3 == 0 else '')
        back, _ = decode(code, charged)
        for key in ('name_hash', 'difficulty', 'gold_plus_1500_per_shard', 'jobs', 'freelancer', 'hero_items', 'gaya_items',
                    'house_items', 'upgrades', 'speedrun_level', 'miracle_stage', 'meta_fragments', 'legendary_guardian'):
            want = d[key]
            if key == 'jobs':
                want = {j: (l if l > 1 else 1) for j, l in want.items()}
            if back[key] != want:
                raise SystemExit('selftest FAILED on %s: wrote %r read %r' % (key, want, back[key]))
        nm = ''.join(rnd.choice('abcXYZ019_ ') for _ in range(rnd.randrange(1, 16)))
        moved = rename(code, nm)
        b2, _ = decode(moved, charged)
        if b2['name_hash'] != name_hash(nm) or {k: v for k, v in b2.items() if k != 'name_hash'} != {k: v for k, v in back.items() if k != 'name_hash'} \
                or moved.partition('(')[2][6:] != code.partition('(')[2][6:] or (('(' in moved) and moved.partition('(')[2][3:6] != moved[1:4]):
            raise SystemExit('selftest FAILED: rename changed more than the name')
        try:
            decode(code[:10] + ('A' if code[10] != 'A' else 'B') + code[11:], charged)
            raise SystemExit('selftest FAILED: a changed character was not detected')
        except CodeError:
            pass
    print('selftest passed: %d random codes written and read back identically; renamed codes keep everything but the name; changed characters are rejected' % rounds)

if __name__ == '__main__':
    main()
