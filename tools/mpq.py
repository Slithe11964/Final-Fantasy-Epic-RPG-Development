"""Minimal MPQ (Warcraft III map archive) reader/writer.

read:    MPQ(path).read(name) -> bytes
replace: replace_files(src_map, dst_map, {name: bytes}) writes a NEW archive where the
         named files are replaced and every other file is byte-for-byte preserved
         (including unnamed payloads).  The original archive is never modified.
"""
import struct, zlib, bz2, os, sys, hashlib

def _table():
    t = [0] * 0x500
    seed = 0x00100001
    for i in range(0x100):
        idx = i
        for _ in range(5):
            seed = (seed * 125 + 3) % 0x2AAAAB
            a = (seed & 0xFFFF) << 16
            seed = (seed * 125 + 3) % 0x2AAAAB
            b = seed & 0xFFFF
            t[idx] = a | b
            idx += 0x100
    return t

T = _table()

def hash_string(s, typ):
    s1, s2 = 0x7FED7FED, 0xEEEEEEEE
    for ch in s.upper().replace('/', '\\'):
        c = ord(ch)
        s1 = (T[(typ << 8) + c] ^ (s1 + s2)) & 0xFFFFFFFF
        s2 = (c + s1 + s2 + (s2 << 5) + 3) & 0xFFFFFFFF
    return s1

def decrypt(data, key):
    n = len(data) // 4
    v = list(struct.unpack('<%dI' % n, data[:n * 4]))
    s2 = 0xEEEEEEEE
    for i in range(n):
        s2 = (s2 + T[0x400 + (key & 0xFF)]) & 0xFFFFFFFF
        v[i] = (v[i] ^ (key + s2)) & 0xFFFFFFFF
        key = (((~key << 0x15) + 0x11111111) | (key >> 0x0B)) & 0xFFFFFFFF
        s2 = (v[i] + s2 + (s2 << 5) + 3) & 0xFFFFFFFF
    return struct.pack('<%dI' % n, *v) + data[n * 4:]

def encrypt(data, key):
    n = len(data) // 4
    v = list(struct.unpack('<%dI' % n, data[:n * 4]))
    s2 = 0xEEEEEEEE
    for i in range(n):
        s2 = (s2 + T[0x400 + (key & 0xFF)]) & 0xFFFFFFFF
        plain = v[i]
        v[i] = (plain ^ (key + s2)) & 0xFFFFFFFF
        key = (((~key << 0x15) + 0x11111111) | (key >> 0x0B)) & 0xFFFFFFFF
        s2 = (plain + s2 + (s2 << 5) + 3) & 0xFFFFFFFF
    return struct.pack('<%dI' % n, *v) + data[n * 4:]

FLAG_COMPRESS = 0x200
FLAG_IMPLODE = 0x100
FLAG_ENCRYPTED = 0x10000
FLAG_FIX_KEY = 0x20000
FLAG_SINGLE = 0x1000000
FLAG_EXISTS = 0x80000000

class MPQ:
    def __init__(self, path):
        self.d = open(path, 'rb').read()
        self.o = self.d.find(b'MPQ\x1a')
        (self.hdr_size, self.arch_size, self.fmt, bss, self.hto, self.bto,
         hc, bc) = struct.unpack('<IIHHIIII', self.d[self.o + 4:self.o + 32])
        self.bss = bss
        self.ss = 512 << bss
        ht = decrypt(self.d[self.o + self.hto:self.o + self.hto + hc * 16], hash_string('(hash table)', 3))
        bt = decrypt(self.d[self.o + self.bto:self.o + self.bto + bc * 16], hash_string('(block table)', 3))
        self.ht = [list(struct.unpack('<IIHHI', ht[i * 16:i * 16 + 16])) for i in range(hc)]
        self.bt = [list(struct.unpack('<IIII', bt[i * 16:i * 16 + 16])) for i in range(bc)]

    def hash_index(self, name):
        a, b = hash_string(name, 1), hash_string(name, 2)
        start = hash_string(name, 0) % len(self.ht)
        for k in range(len(self.ht)):
            i = (start + k) % len(self.ht)
            e = self.ht[i]
            if e[4] == 0xFFFFFFFF:
                return None
            if e[0] == a and e[1] == b and e[4] < len(self.bt):
                return i
        return None

    def block_index(self, name):
        i = self.hash_index(name)
        return None if i is None else self.ht[i][4]

    def read(self, name):
        bi = self.block_index(name)
        if bi is None:
            return None
        return self.read_block(bi, name)

    def read_block(self, bi, name):
        pos, csize, fsize, flags = self.bt[bi]
        raw = self.d[self.o + pos:self.o + pos + csize]
        key = None
        if flags & FLAG_ENCRYPTED:
            key = hash_string(os.path.basename(name.replace('\\', '/')), 3)
            if flags & FLAG_FIX_KEY:
                key = ((key + pos) ^ fsize) & 0xFFFFFFFF
        if flags & FLAG_SINGLE:
            data = decrypt(raw, key) if key is not None else raw
            return self._dc(data) if (flags & FLAG_COMPRESS and csize < fsize) else data
        n = (fsize + self.ss - 1) // self.ss
        if flags & (FLAG_COMPRESS | FLAG_IMPLODE):
            off = raw[:(n + 1) * 4]
            if key is not None:
                off = decrypt(off, (key - 1) & 0xFFFFFFFF)
            offs = struct.unpack('<%dI' % (n + 1), off)
        else:
            offs = [min(i * self.ss, csize) for i in range(n + 1)]
        out = []
        for i in range(n):
            blk = raw[offs[i]:offs[i + 1]]
            if key is not None:
                blk = decrypt(blk, (key + i) & 0xFFFFFFFF)
            exp = min(self.ss, fsize - i * self.ss)
            out.append(self._dc(blk) if len(blk) < exp else blk)
        return b''.join(out)

    @staticmethod
    def _dc(blk):
        m, d = blk[0], blk[1:]
        if m == 0x02:
            return zlib.decompress(d)
        if m == 0x10:
            return bz2.decompress(d)
        raise ValueError('unsupported compression %#x' % m)

def _compress_file(data, ss):
    n = max(1, (len(data) + ss - 1) // ss)
    sectors = []
    for i in range(n):
        chunk = data[i * ss:(i + 1) * ss]
        c = b'\x02' + zlib.compress(chunk, 9)
        sectors.append(c if len(c) < len(chunk) else chunk)
    table = []
    p = (n + 1) * 4
    for s in sectors:
        table.append(p)
        p += len(s)
    table.append(p)
    return struct.pack('<%dI' % (n + 1), *table) + b''.join(sectors)

def replace_files(src, dst, replacements):
    if os.path.exists(dst):
        raise FileExistsError(dst)
    m = MPQ(src)
    pre = m.d[:m.o]
    body = bytearray(m.d[m.o:m.o + m.arch_size])
    changed = {}
    for name, data in replacements.items():
        bi = m.block_index(name)
        if bi is None:
            raise KeyError('file not in archive: ' + name)
        payload = _compress_file(data, m.ss)
        pos = len(body)
        body += payload
        m.bt[bi] = [pos, len(payload), len(data), FLAG_EXISTS | FLAG_COMPRESS]
        changed[bi] = data
    # keep (attributes) consistent when present (CRC32 + MD5 per block)
    abi = m.block_index('(attributes)')
    if abi is not None and abi not in changed:
        attr = bytearray(m.read_block(abi, '(attributes)'))
        ver, aflags = struct.unpack_from('<II', attr, 0)
        nb = len(m.bt)
        p = 8
        crc_off = ft_off = md5_off = None
        if aflags & 1:
            crc_off = p; p += 4 * nb
        if aflags & 2:
            ft_off = p; p += 8 * nb
        if aflags & 4:
            md5_off = p; p += 16 * nb
        if p <= len(attr):
            for bi, data in changed.items():
                if crc_off is not None:
                    struct.pack_into('<I', attr, crc_off + 4 * bi, zlib.crc32(data) & 0xFFFFFFFF)
                if md5_off is not None:
                    attr[md5_off + 16 * bi:md5_off + 16 * bi + 16] = hashlib.md5(data).digest()
            payload = _compress_file(bytes(attr), m.ss)
            pos = len(body)
            body += payload
            m.bt[abi] = [pos, len(payload), len(attr), FLAG_EXISTS | FLAG_COMPRESS]
    # write new tables at end
    hto = len(body)
    ht = b''.join(struct.pack('<IIHHI', *e) for e in m.ht)
    body += encrypt(ht, hash_string('(hash table)', 3))
    bto = len(body)
    bt = b''.join(struct.pack('<IIII', *e) for e in m.bt)
    body += encrypt(bt, hash_string('(block table)', 3))
    struct.pack_into('<IIHHIIII', body, 4, m.hdr_size, len(body), m.fmt, m.bss, hto, bto, len(m.ht), len(m.bt))
    with open(dst, 'wb') as f:
        f.write(pre + bytes(body))
    # verify
    a, b = MPQ(src), MPQ(dst)
    for bi in range(len(a.bt)):
        if bi in changed or bi == abi:
            continue
        pa, pb = a.bt[bi], b.bt[bi]
        if a.d[a.o + pa[0]:a.o + pa[0] + pa[1]] != b.d[b.o + pb[0]:b.o + pb[0] + pb[1]] or pa[1:] != pb[1:]:
            raise RuntimeError('block %d changed unexpectedly' % bi)
    for name, data in replacements.items():
        if b.read(name) != data:
            raise RuntimeError('readback mismatch for ' + name)
    return dst

if __name__ == '__main__':
    m = MPQ(sys.argv[1])
    out = sys.argv[2]
    os.makedirs(out, exist_ok=True)
    for n in sys.argv[3:]:
        d = m.read(n)
        print(n, None if d is None else len(d))
        if d is not None:
            open(os.path.join(out, n.replace('\\', '__')), 'wb').write(d)

def _reencrypt(raw, flags, fsize, ss, name, old_pos, new_pos):
    """Re-key a position-keyed (FIX_KEY) encrypted block for a new position."""
    base = hash_string(os.path.basename(name.replace('\\', '/')), 3)
    ok, nk = ((base + old_pos) ^ fsize) & 0xFFFFFFFF, ((base + new_pos) ^ fsize) & 0xFFFFFFFF
    if flags & FLAG_SINGLE:
        return encrypt(decrypt(raw, ok), nk)
    n = (fsize + ss - 1) // ss
    if flags & (FLAG_COMPRESS | FLAG_IMPLODE):
        offs_raw = decrypt(raw[:(n + 1) * 4], (ok - 1) & 0xFFFFFFFF)
        offs = struct.unpack('<%dI' % (n + 1), offs_raw)
        out = bytearray(encrypt(offs_raw, (nk - 1) & 0xFFFFFFFF))
    else:
        offs = [min(i * ss, len(raw)) for i in range(n + 1)]
        out = bytearray()
    for i in range(n):
        blk = raw[offs[i]:offs[i + 1]]
        out += encrypt(decrypt(blk, (ok + i) & 0xFFFFFFFF), (nk + i) & 0xFFFFFFFF)
    return bytes(out)

def compact(src, dst):
    """Write a copy of the archive without the unused space left behind by replace_files."""
    if os.path.exists(dst):
        raise FileExistsError(dst)
    m = MPQ(src)
    names = {}
    lf = m.read('(listfile)')
    cands = (lf.decode('utf-8', 'replace').split('\r\n') if lf else []) + ['(listfile)', '(attributes)', '(signature)']
    for n in cands:
        if n:
            bi = m.block_index(n)
            if bi is not None:
                names[bi] = n
    body = bytearray(m.d[m.o:m.o + m.hdr_size])
    new_bt = []
    for bi, (pos, csize, fsize, flags) in enumerate(m.bt):
        raw = m.d[m.o + pos:m.o + pos + csize]
        if not flags & FLAG_EXISTS or csize == 0:
            new_bt.append([len(body) if flags & FLAG_EXISTS else pos, csize, fsize, flags]); body += raw; continue
        newpos = len(body)
        if flags & FLAG_ENCRYPTED and flags & FLAG_FIX_KEY:
            if bi not in names:
                raise RuntimeError('cannot move position-keyed block %d without its name' % bi)
            raw = _reencrypt(raw, flags, fsize, m.ss, names[bi], pos, newpos)
        body += raw
        new_bt.append([newpos, csize, fsize, flags])
    hto = len(body)
    body += encrypt(b''.join(struct.pack('<IIHHI', *e) for e in m.ht), hash_string('(hash table)', 3))
    bto = len(body)
    body += encrypt(b''.join(struct.pack('<IIII', *e) for e in new_bt), hash_string('(block table)', 3))
    struct.pack_into('<IIHHIIII', body, 4, m.hdr_size, len(body), m.fmt, m.bss, hto, bto, len(m.ht), len(new_bt))
    open(dst, 'wb').write(m.d[:m.o] + bytes(body))
    a, b = MPQ(src), MPQ(dst)
    for n in set(names.values()):
        if a.read(n) != b.read(n):
            raise RuntimeError('compaction changed ' + n)
    return dst
