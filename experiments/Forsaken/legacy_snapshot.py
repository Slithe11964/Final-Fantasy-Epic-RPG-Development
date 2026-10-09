"""Strict, detached E/F/G/H decoding for migration research. No runtime writes.

Outputs saved values, not a claim that all engine side effects are simulated.
The layout is frozen; live job/item counts never drive parsing.
"""
import argparse
import json
from pathlib import Path
import re
import sys

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
sys.path.insert(0, str(ROOT / 'tools'))
import savecode

LAYOUT = HERE / 'legacy-layouts.json'
Error = savecode.CodeError


class Reader(savecode.Reader):
    def finish(self):
        if self.pos != len(self.body):
            raise Error('trailing payload characters')
        if self.bits and self.bits_(self.bits, 'padding') != 0:
            raise Error('nonzero padding')


def clean(code):
    code = re.sub(r'\|c[0-9a-fA-F]{8}|\|r|\s', '', code)
    # Save_Init also registers the URL-friendly aliases for alphabet values 62/63.
    code = code.replace('-', '$').replace('.', '#')
    if len(code) > 16384:
        raise Error('legacy input exceeds research parser bound')
    if len(code) < 8 or code[0] not in 'EFGH':
        raise Error('expected supported E/F/G/H code')
    return code


def value3(text):
    if len(text) != 3:
        raise Error('incomplete checksum')
    return sum(savecode.value_of(c) << (6 * (2 - i)) for i, c in enumerate(text))


def read_level(r, cap, version, label):
    if not r.bits_(1, label + '.short'):
        return r.bits_(7, label + '.value')
    if not cap:
        return 0  # Actual JASS ReadLevel, unlike savecode.py's display value 1.
    return 99 if version <= 5 else 99 + r.bits_(1, label + '.mastered')


def inventory(r, items, label):
    count = r.bits_(3, label + '.count')
    if count > 6:
        raise Error('legacy inventory count exceeds six')
    result = []
    for ordinal in range(count):
        item_id = r.bits_(9, label + '.item_id')
        record = items.get(str(item_id))
        if record is None:
            raise Error('unknown legacy item ID: ' + str(item_id))
        quantity = r.bits_(7, label + '.quantity') if record['charged'] else None
        result.append(dict(item_id=item_id, legacy_ordinal=ordinal, quantity=quantity))
    return result


def gaya_abilities(r):
    return {name: r.bits_(width, 'gaya.' + name) for name, width in
            [('break_stun', 2), ('mana_transfer', 2), ('mega_heal', 2),
             ('tarugaya', 1), ('sukugaya', 1), ('rakugaya', 1)]}


def read_titles_v3(r):
    titles = set()
    def flag(n):
        if r.bits_(1, 'title.' + str(n)):
            titles.add(n)
    def ladder(ids, extra=None):
        value = r.bits_(2, 'titles.' + '/'.join(map(str, ids)))
        titles.update(ids[:value])
        if extra and value == 3:
            flag(extra)
    flag(18)
    ignored = {'title19': r.bits_(1, 'title19.ignored')}
    ladder([15, 16, 17]); flag(20); flag(59)
    ladder([21, 22, 23], 24); flag(29); flag(54)
    ladder([25, 26, 27], 28); flag(53); flag(34)
    v = r.bits_(3, 'titles.30/31/32/33/49/51')
    if v >= 1: titles.add(30)
    if v == 2 or v >= 4: titles.add(51)
    if v >= 3: titles.add(31)
    if v >= 5: titles.add(32)
    if v >= 6: titles.add(33)
    if v >= 7: titles.add(49)
    flag(50); flag(43); ladder([39, 40, 41], 42); flag(55)
    return titles, ignored


def armory(r, segment, linked_checksum, layout, version):
    if len(segment) < 7:
        raise Error('armory segment too short')
    if value3(segment[:3]) != savecode.checksum(segment[3:]):
        raise Error('armory checksum mismatch')
    if value3(segment[3:6]) != linked_checksum:
        raise Error('armory/main checksum link mismatch')
    r.body, r.pos, r.buf, r.bits = segment, 0, 0, 0
    # The main reader's rolling key continues, including two ignored header reads.
    r.bits_(18, 'armory.checksum_header'); r.bits_(18, 'armory.link_header')
    order = layout['armory_order']
    owned, left, mode, ended = [], 0, 2, False
    for item_id in order:
        if left == 0:
            if r.bits_(1, 'armory.opcode'):
                mode = r.bits_(1, 'armory.run_value')
                left = r.bits_(6, 'armory.run_count')
                if left == 0:
                    raise Error('zero-length armory run')
            elif r.bits_(1, 'armory.opcode'):
                mode, left = 2, r.bits_(8, 'armory.literal_count')
                if left == 0:
                    raise Error('zero-length armory literals')
            elif r.bits_(1, 'armory.opcode'):
                owned.append(item_id)
                continue
            else:
                ended = True
                break
        if left:
            left -= 1
            if (r.bits_(1, 'armory.literal') if mode == 2 else mode):
                owned.append(item_id)
    if left:
        raise Error('armory run exceeds known layout')
    # Save_EncodeUnitFlags always writes its 000 terminator, even if the game's
    # reader has already reached the last catalogue entry and stops reading.
    if not ended:
        if any(r.bits_(1, 'armory.end') for _ in range(3)):
            raise Error('missing armory terminator or unsupported extension')
    r.finish()
    blocked = set(layout['legacy_rejected_items']) if version <= 5 else set()
    return dict(saved_item_ids=owned, effective_item_ids=[i for i in owned if i not in blocked],
                ended_early=ended)


def decode(code, player=None):
    code = clean(code)
    version = savecode.value_of(code[0])
    body = code[4:]
    if '(' in body:
        if code[0] not in 'FH' or body.count('(') != 1 or body.count(')') != 1 or not body.endswith(')'):
            raise Error('malformed armory envelope')
        main, segment = body[:-1].split('(')
    else:
        if ')' in body:
            raise Error('malformed armory envelope')
        main, segment = body, None
    checksum = value3(code[1:4])
    if checksum != savecode.checksum(main):
        raise Error('main checksum mismatch')
    if any(c not in savecode.ALPHABET for c in main):
        raise Error('invalid main alphabet')
    layout = json.loads(LAYOUT.read_text(encoding='utf-8'))
    r = Reader(version, main)
    out = dict(snapshot_schema=1, source_version=code[0])
    out['account_hash'] = r.bits_(20, 'account_hash')
    if player is not None and out['account_hash'] != savecode.name_hash(player):
        raise Error('code belongs to another account')
    out['difficulty'] = r.bits_(2, 'difficulty')
    out['currency'] = r.bits_(20, 'gold_plus_shards')
    if version >= 6:
        mastered = bool(r.bits_(1, 'gaya.mastered'))
        ng = r.bits_(1, 'ng.bit1')
    else:
        mastered, ng = False, 0
    cap = bool(r.bits_(1, 'levels.cap'))
    order = layout['job_order_v2' if version <= 5 else 'job_order_v3']
    out['jobs'] = {str(i): read_level(r, cap, version, 'job.' + str(i)) for i in order}
    out['freelancer'] = read_level(r, cap, version, 'freelancer')
    out['gaya'] = dict(mastered=mastered)
    if mastered:
        out['gaya'].update(level=99, abilities=dict(break_stun=3, mana_transfer=3,
            mega_heal=3, tarugaya=1, sukugaya=1, rakugaya=1))
    else:
        out['gaya']['level'] = read_level(r, cap, version, 'gaya.level')
        if version >= 6:
            out['gaya']['abilities'] = gaya_abilities(r)
    if version >= 6:
        ng += 4 * r.bits_(1, 'ng.bit4')
    out['inventories'] = {name: inventory(r, layout['items'], name)
                          for name in ('hero', 'gaya', 'house')}
    out['upgrades'] = {}
    if version >= 6:
        upgrade_cap = bool(r.bits_(1, 'upgrades.cap'))
    for i in range(1, 16):
        if version >= 6 and r.bits_(1, 'upgrade.' + str(i) + '.short'):
            value = 10 if upgrade_cap else 0
        else:
            value = r.bits_(4, 'upgrade.' + str(i) + '.value')
        out['upgrades'][str(i)] = value
    if version <= 5:
        out['gaya']['abilities'] = gaya_abilities(r)
        titles, ignored = set(), {}
        for i in list(range(15, 35)) + list(range(39, 44)):
            value = r.bits_(1, 'title.' + str(i))
            if i == 19:
                ignored['title19'] = value
            elif value:
                titles.add(i)
        if 32 in titles:
            titles.add(51)
        out['miracle_stage'] = r.bits_(2, 'miracle_stage')
        out['meta_fragments'] = r.bits_(2, 'meta_fragments')
        ng = r.bits_(3, 'ng.level')
        out['new_game_plus'] = ng if ng <= 5 else None
        out['cheater_flag'] = bool(r.bits_(1, 'cheater'))
        out['speedrun_level'] = None
        out['legendary_guardian'] = None
        out['armory_allowed_on_hard'] = None
    else:
        ng += 2 * r.bits_(1, 'ng.bit2')
        titles, ignored = read_titles_v3(r)
        ignored['reserved1'] = r.bits_(1, 'reserved1')
        out['speedrun_level'] = r.bits_(4, 'speedrun_level')
        ignored['reserved2'] = r.bits_(1, 'reserved2')
        ignored['reserved3'] = r.bits_(1, 'reserved3')
        out['miracle_stage'] = r.bits_(2, 'miracle_stage')
        out['meta_fragments'] = r.bits_(3, 'meta_fragments')
        ng += 8 * r.bits_(1, 'ng.bit8')
        out['legendary_guardian'] = bool(r.bits_(1, 'legendary_guardian'))
        out['new_game_plus'] = 15 - ng if ng >= 11 else 5 + ng if ng <= 5 else None
        out['cheater_flag'] = 6 <= ng <= 10
        out['armory_allowed_on_hard'] = bool(r.bits_(1, 'armory_allowed_on_hard'))
    out['ng_wire_value'] = ng
    out['titles'] = sorted(titles)
    out['ignored_wire_fields'] = ignored
    r.finish()
    out['armory'] = armory(r, segment, checksum, layout, version) if segment is not None else None
    out['armory_pending'] = code[0] in 'FH' and segment is None
    out['validation'] = 'detached decode only; runtime eligibility not evaluated'
    return out, r.log


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--input', type=Path, required=True, help='plain code text, not a preload script')
    parser.add_argument('--player', help='optional account binding check')
    parser.add_argument('--trace', action='store_true')
    args = parser.parse_args()
    snapshot, trace = decode(args.input.read_text(encoding='utf-8'), args.player)
    print(json.dumps(dict(snapshot=snapshot, trace=trace) if args.trace else snapshot, indent=2))


if __name__ == '__main__':
    main()
