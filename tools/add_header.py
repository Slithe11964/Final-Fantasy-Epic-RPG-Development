#!/usr/bin/env python3
"""Put the 512-byte "HM3W" map header in front of a .w3x/.w3m.

Warcraft III's map list (1.29 and older especially) reads the map name, flags and
player count from this header. A map that is only a bare MPQ is skipped by the
list, even though the archive itself is fine. MPQ offsets are relative to the MPQ
header, so prepending 512 bytes doesn't change anything inside the archive.

  python tools/add_header.py IN.w3x OUT.w3x --from OLD_MAP.w3x [--name "New name"]
  python tools/add_header.py IN.w3x OUT.w3x --name "My Map" --flags 61032 --players 8
"""
import argparse, struct, sys


def read_header(path):
    d = open(path, 'rb').read(512)
    if d[:4] != b'HM3W':
        sys.exit(f'{path} has no HM3W header')
    end = d.index(b'\0', 8)
    flags, players = struct.unpack('<2i', d[end + 1:end + 9])
    return d[8:end].decode('utf-8', 'replace'), flags, players


def build_header(name, flags, players):
    h = b'HM3W' + b'\0' * 4 + name.encode('utf-8') + b'\0' + struct.pack('<2i', flags, players)
    if len(h) > 512:
        sys.exit('name too long')
    return h + b'\0' * (512 - len(h))


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument('src'); ap.add_argument('out')
    ap.add_argument('--from', dest='tpl', help='copy name/flags/players from this map')
    ap.add_argument('--name'); ap.add_argument('--flags', type=int); ap.add_argument('--players', type=int)
    a = ap.parse_args()
    name, flags, players = read_header(a.tpl) if a.tpl else ('Map', 0, 1)
    name = a.name or name
    flags = a.flags if a.flags is not None else flags
    players = a.players if a.players is not None else players
    data = open(a.src, 'rb').read()
    i = data.find(b'MPQ\x1a')
    if i < 0:
        sys.exit('no MPQ header found')
    body = data[i:]
    if i % 512:
        sys.exit('MPQ header not on a 512-byte boundary')
    open(a.out, 'wb').write(build_header(name, flags, players) + body)
    print(f'{a.out}: "{name}" flags={flags} players={players}')


if __name__ == '__main__':
    main()
