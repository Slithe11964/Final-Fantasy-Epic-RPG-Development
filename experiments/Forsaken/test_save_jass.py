"""Execute actual JASS control flow with mocked native strings/hashtables; compile separately."""
from collections import defaultdict
import json
from pathlib import Path
import random
import re
import subprocess
import sys
import tempfile
import unittest

import save_progression as progression
import save_vnext as codec

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
SOURCE = HERE / 'Forsaken-save-codec.j'
sys.path.insert(0, str(ROOT / 'tools/tests'))
from test_armory_materia import execute
from test_quest_lifecycle import expression
from jtok import functions, strip_comments
from vjass_lite import flatten


class JassArray(defaultdict):
    def __getitem__(self, index):
        assert type(index) is int and 0 <= index < 8192, index
        return super().__getitem__(index)

    def __setitem__(self, index, value):
        assert type(index) is int and 0 <= index < 8192, index
        if type(value) is int:
            assert -2147483648 <= value <= 2147483647, value
        super().__setitem__(index, value)


def engine(extra_source='', extra_env=None):
    source = SOURCE.read_text(encoding='utf-8')+'\n'+extra_source
    env = dict(I2S=str, StringLength=lambda s: len(s or ''), SubString=lambda s, a, b: (s or '')[a:b],
               ModuloInteger=lambda a, b: a % b, InitHashtable=dict,
               StringCase=lambda s, upper: s.upper() if upper else s.lower(),
               StringHash=lambda s: sum((i+1)*ord(c) for i,c in enumerate(s.upper())),
               SaveInteger=lambda t, p, k, v: t.__setitem__((p, k), v),
               LoadInteger=lambda t, p, k: t.get((p, k), 0),
               LoadBoolean=lambda t, p, k: t.get((p, k), False),
               SaveBoolean=lambda t, p, k, v: t.__setitem__((p, k), v))
    def flush(table, parent):
        for key in list(table):
            if key[0] == parent: del table[key]
    env['FlushChildHashtable'] = flush
    env.update(extra_env or {})
    for name in functions(source): env[name] = lambda *args: None
    defaults = dict(integer=0, real=0., string=None, boolean=False, hashtable=None, item=None, unit=None, player=None, ability=None, force=None, timer=None, trigger=None)
    blocks = '\n'.join(m[1] for m in re.finditer(r'\nglobals\n(.*?)\nendglobals', source, re.S))
    for line in strip_comments(blocks).splitlines():
        match = re.fullmatch(r'\s*(?:constant\s+)?(\w+)\s+(array\s+)?(\w+)(?:=(.*))?\s*', line)
        if not match:
            assert not line.strip(), line
            continue
        kind, array, name, value = match.groups()
        default = defaults[kind]
        env[name] = JassArray(lambda d=default: d) if array else eval(expression(value), env) if value else default
    return execute(source, list(functions(source)), env)


def unchecked(sections, account=42, body=None, count=None):
    if body is None:
        body = ''.join(codec.uint(s.id)+codec.uint(s.version)+codec.uint(int(s.required))+
                       codec.uint(len(s.payload))+s.payload for s in sections)
    header = 'FSVB'+codec.uint(account)+codec.uint(len(body))+codec.uint(len(sections) if count is None else count)
    return header+codec.uint(codec.checksum(header+body))+body


def reference_accepts(text, account=-1, profile=False):
    try:
        envelope = codec.decode(text, None if account == -1 else account)
        if profile: progression.snapshot(envelope)
        return True
    except codec.Error:
        return False


class JassCodecTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.e = engine()

    def setUp(self):
        for pid in range(8): self.e['FSC_Reset'](pid)

    def parity(self, text, account=-1, profile=False, pid=0):
        expected = reference_accepts(text, account, profile)
        before = self.e['FSC_Code'][pid]
        actual = self.e['FSC_Decode'](pid, text, account, profile)
        self.assertEqual(actual, expected, text[:100])
        if expected:
            envelope = codec.decode(text)
            self.assertEqual(self.e['FSC_Reencode'](pid), text)
            self.assertEqual(self.e['FSC_Count'][pid+1], len(envelope.sections))
            self.assertEqual(self.e['FSC_Account'][pid+1], envelope.account_hash)
            for i, section in enumerate(envelope.sections):
                index = (pid+1)*32+i
                self.assertEqual((self.e['FSC_Id'][index], self.e['FSC_Version'][index],
                                  self.e['FSC_Required'][index], self.e['FSC_Payload'][index]),
                                 (section.id, section.version, section.required, section.payload))
        else:
            self.assertEqual(self.e['FSC_Code'][pid], before)
        self.assertEqual(self.e['FSC_Seen'], {})
        self.assertFalse(self.e['FSC_Busy'][pid])
        self.assertEqual(self.e['FSC_Text'][pid+9], None)

    def write(self, envelope, profile=False, pid=0):
        self.assertTrue(self.e['FSC_Begin'](pid, envelope.account_hash))
        for s in envelope.sections:
            self.assertTrue(self.e['FSC_Add'](pid, s.id, s.version, s.required, s.payload))
        self.assertEqual(self.e['FSC_Finish'](pid, profile), codec.encode(envelope))

    def test_alphabet_lookup_preserves_case_and_rejects_hash_collisions(self):
        for value, char in enumerate(codec.ALPHABET):
            self.assertEqual(self.e['FSC_Value'](char), value)
        for char in ['', 'AA', '!', ' ', 'ÃƒÂ©']:
            self.assertEqual(self.e['FSC_Value'](char), -1)
        # An unexpected colliding key still has to match the alphabet character.
        self.e['FSC_Characters'][(self.e['StringHash']('!'), 0)] = 1
        self.assertEqual(self.e['FSC_Value']('!'), -1)

    def test_long_alphabet_validation_uses_bounded_lookup_work(self):
        env = engine()
        env['FSC_InitCharacters']()
        original = env['SubString']
        calls = []
        def substring(*args):
            calls.append(args)
            return original(*args)
        env['SubString'] = substring
        text = codec.ALPHABET * 256
        self.assertTrue(env['FSC_AlphabetValid'](text))
        self.assertEqual(len(calls), 2 * len(text))

    def test_integer_and_checksum_boundaries(self):
        for value in [0, 1, 31, 32, 1023, 65535, 1048575, codec.MAX_INT]:
            text = self.e['FSC_Uint'](value)
            self.assertEqual(text, codec.uint(value))
            self.e['FSC_Text'][9] = text
            self.e['FSC_Pos'][9] = 0
            self.e['FSC_End'][9] = len(text)
            self.e['FSC_Ok'][9] = True
            self.assertEqual(self.e['FSC_Read'](9), value)
            self.assertTrue(self.e['FSC_Ok'][9])
        for text in ['gA', 'g'*8, 'ggggggC', 'ggggggg', '']:
            self.e['FSC_Text'][9] = text
            self.e['FSC_Pos'][9] = 0
            self.e['FSC_End'][9] = len(text)
            self.e['FSC_Ok'][9] = True
            self.e['FSC_Read'](9)
            self.assertFalse(self.e['FSC_Ok'][9])
        self.assertIsNone(self.e['FSC_Uint'](-1))
        for text in ['', codec.ALPHABET, codec.ALPHABET*64]:
            self.assertEqual(self.e['FSC_Checksum'](text), codec.checksum(text))

    def test_all_pinned_reference_and_migration_goldens(self):
        for filename in ['vnext-fixtures.json', 'migration-fixtures.json']:
            for case in json.loads((HERE/filename).read_text())['cases']:
                profile = filename.startswith('migration')
                self.parity(case['code'], profile=profile)
                self.write(codec.decode(case['code']), profile)

    def test_full_positions_sparse_rings_quantities_and_binary_life_words(self):
        records = []
        for holder, count in codec.HOLDERS.items():
            for slot in range(count):
                records.append((len(records)+1, 1000+slot, holder, slot,
                                [None, 0, 120, 121, 127][slot % 5], True,
                                ((1, True, codec.life_words(145.25)), (2, True, codec.uint(5)))))
        envelope = codec.Envelope(1048575, (codec.Section(1, 1, True, codec.inventory(records)),))
        self.parity(codec.encode(envelope), 1048575)
        self.write(envelope)
        sparse = [records[6+slot] for slot in [1, 7, 18, 29]] + [records[36+4], records[36+5]]
        self.parity(codec.encode(codec.Envelope(42, (codec.Section(1, 1, True, codec.inventory(sparse)),))))
        for high, low in [(0, 1), (0x7f7f, 65535), (0, 0), (0x7f80, 0), (0x7fc0, 0), (0x8000, 0), (65536, 0)]:
            record = (1, 1, 2, 0, None, True, ((1, True, codec.uint(high)+codec.uint(low)),))
            # Assemble without the reference encoder's metadata validation.
            metadata = codec.uint(1)+'B'+codec.uint(len(record[6][0][2]))+record[6][0][2]
            # ordinal1, ID1, holder2, slot0, no quantity, binding1, metadata count1.
            raw = 'BBCAABB'+metadata
            payload = 'B'+codec.uint(len(raw))+raw
            self.parity(unchecked([codec.Section(1, 1, True, payload)]))

    def test_unknown_sections_versions_metadata_and_budgets(self):
        for section in [codec.Section(99, 1, False, 'ABC'), codec.Section(1, 2, False, 'XYZ'),
                        codec.Section(codec.MAX_INT, codec.MAX_INT, False, 'A'*4096)]:
            envelope = codec.Envelope(42, (section,))
            self.parity(codec.encode(envelope))
            self.write(envelope)
            self.parity(unchecked([codec.Section(section.id, section.version, True, section.payload)]))
        for size in [4096, 4097]:
            self.parity(unchecked([codec.Section(99, 1, False, 'A'*size)]))
        record = (1, 29, 2, 29, 127, True, ((99, False, 'A'*2000),))
        inventory = codec.Section(1, 1, True, codec.inventory([record]))
        for size in [2096, 2097]:
            self.parity(unchecked([inventory, codec.Section(99, 1, False, 'B'*size)]))
        for count in [256, 257, 2048]:
            payload = codec.pairs([(i+1, codec.MAX_INT) for i in range(count)])
            self.parity(unchecked([codec.Section(3, 1, False, payload)]))
        self.parity(unchecked([codec.Section(3, 1, True, 'A')]))

    def test_malformed_framing_and_every_golden_truncation(self):
        text = json.loads((HERE/'migration-fixtures.json').read_text())['cases'][-1]['code']
        self.parity(text, profile=True)
        for length in range(len(text)): self.parity(text[:length], profile=True)
        for changed in [text+'A', text[:-1]+'A', text.replace('FSV', 'FSX', 1), 'FSV'+('A'*16449),
                        text[:10]+'!'+text[11:]]:
            self.parity(changed)
        self.parity(text, 0, True)
        for count in [0, 33]: self.parity(unchecked([], body='', count=count))
        section = codec.Section(2, 1, True, codec.pairs([(1, 99)]))
        self.parity(unchecked([section, section]))
        self.parity(unchecked([codec.Section(0, 1, False, '')]))
        self.parity(unchecked([codec.Section(2, 0, False, '')]))
        # Recomputed checksums expose malformed flags/lengths/varints to parsers.
        for body in ['BBCBA', 'BBBEA', 'BBBAAA', 'gABA', 'BBAgA']:
            self.parity(unchecked([], body=body, count=1))

    def test_known_fields_ranges_duplicates_and_evidence(self):
        for sid, rows in [(2, [(1, 101)]), (4, [(99, 0)]), (4, [(5, 11)]),
                          (5, [(3, 4)]), (6, [(16, 0)]), (6, [(1, 16)]),
                          (7, [(59, 0)]), (8, [(1, 2)]), (2, [(1, 0), (1, 1)])]:
            payload = codec.uint(len(rows))+''.join(codec.uint(i)+codec.uint(v) for i, v in rows)
            self.parity(unchecked([codec.Section(sid, 1, True, payload)]))
        for payload in ['BCA', 'BA'+codec.uint(4097), 'BAB'+codec.uint(69),
                        'BAI'+codec.uint(69)+codec.uint(33)*7]:
            self.parity(unchecked([codec.Section(9, 1, True, payload)]))

    def test_malformed_item_records_and_required_metadata(self):
        def record(ordinal=1, identity=29, holder=2, slot=0, quantity='A', binding='B', metadata=()):
            text = ''.join(codec.uint(v) for v in (ordinal, identity, holder, slot))
            text += quantity+binding+codec.uint(len(metadata))
            text += ''.join(codec.uint(i)+codec.uint(flags)+codec.uint(len(data))+data
                            for i, flags, data in metadata)
            return text
        valid = record()
        invalid = [record(ordinal=0), record(identity=0), record(holder=6), record(slot=30),
                   record(quantity='C'), record(quantity='BAC'), record(binding='C'),
                   record(metadata=((99, 1, 'A'),)), record(metadata=((0, 0, 'A'),)),
                   record(metadata=((99, 2, 'A'),)), record(metadata=((2, 0, 'I'),)),
                   record(metadata=((99, 0, 'A'), (99, 0, 'B'))),
                   record(metadata=tuple((i+100, 0, '') for i in range(17))), valid+'A']
        for raw in invalid:
            payload = 'B'+codec.uint(len(raw))+raw
            self.parity(unchecked([codec.Section(1, 1, True, payload)]))
        # Distinct ordinals cannot share a position; distinct positions cannot share an ordinal.
        for second in [record(ordinal=2), record(slot=1)]:
            payload = 'C'+codec.uint(len(valid))+valid+codec.uint(len(second))+second
            self.parity(unchecked([codec.Section(1, 1, True, payload)]))

    def test_profile_requirements_and_native_profile(self):
        from test_save_migration import native_sections
        jobs = codec.Section(2, 1, True, codec.pairs([(i, 100) for i in range(1, 43)]))
        item = (1, 1001, 2, 29, 120, True,
                ((1, True, codec.life_words(145.25)), (2, True, codec.uint(5))))
        sections = (codec.Section(1, 1, True, codec.inventory([item])), jobs)+native_sections()
        envelope = codec.Envelope(42, sections)
        self.parity(codec.encode(envelope), 42, True)
        self.write(envelope, True)
        for s in sections:
            for replacement in [None, codec.Section(s.id, 1, False, s.payload)]:
                changed = tuple(x for x in sections if x.id != s.id)
                if replacement: changed += (replacement,)
                self.parity(unchecked(changed), profile=True)
        for sid in [2, 4, 5, 6]:
            s = next(x for x in sections if x.id == sid)
            rows = codec.read_pairs(s.payload)
            for removed in [rows[0][0], rows[-1][0]]:
                changed = codec.Section(sid, 1, True, codec.pairs([(i, v) for i, v in rows if i != removed]))
                self.parity(unchecked(tuple(changed if x.id == sid else x for x in sections)), profile=True)
        no_metadata = codec.Section(1, 1, True, codec.inventory([item[:6]+((),)]))
        self.parity(unchecked((no_metadata,)+sections[1:]), profile=True)
        gaya = next(s for s in sections if s.id == 5)
        rows = [(i, 98 if i == 2 else v) for i, v in codec.read_pairs(gaya.payload)]
        changed = codec.Section(5, 1, True, codec.pairs(rows))
        self.parity(unchecked(tuple(changed if s.id == 5 else s for s in sections)), profile=True)

    def test_per_player_failure_preserves_accepted_buffers_and_builders(self):
        cases = json.loads((HERE/'migration-fixtures.json').read_text())['cases']
        for pid in range(8): self.parity(cases[pid]['code'], profile=True, pid=pid)
        before = [self.e['FSC_Reencode'](pid) for pid in range(8)]
        for pid in range(8):
            self.parity('FSVB', profile=True, pid=pid)
            self.assertTrue(self.e['FSC_Begin'](pid, pid))
        self.assertFalse(self.e['FSC_Decode'](0, cases[0]['code'], -1, True))
        self.assertFalse(self.e['FSC_Begin'](0, 42))
        for pid in range(8):
            self.assertTrue(self.e['FSC_Add'](pid, 99, 1, False, 'A'))
        # Poison one writer. It cannot export the partial valid prefix.
        self.assertFalse(self.e['FSC_Add'](3, 0, 1, False, 'A'))
        self.assertIsNone(self.e['FSC_Finish'](3, False))
        self.assertEqual(self.e['FSC_Reencode'](3), before[3])
        for pid in range(8):
            if pid != 3:
                self.assertEqual(self.e['FSC_Finish'](pid, False),
                                 codec.encode(codec.Envelope(pid, (codec.Section(99, 1, False, 'A'),))))
        for pid in [-1, 8, 2147483647]:
            self.assertFalse(self.e['FSC_Decode'](pid, cases[0]['code'], -1, True))
            self.assertFalse(self.e['FSC_Begin'](pid, 42))
            self.assertIsNone(self.e['FSC_Reencode'](pid))
        self.e['FSC_Busy'][0] = True
        self.assertFalse(self.e['FSC_Reset'](0))
        self.assertFalse(self.e['FSC_Decode'](0, cases[0]['code'], -1, True))
        self.e['FSC_Busy'][0] = False

    def test_builder_duplicate_invalid_and_payload_budget_refusals(self):
        self.assertTrue(self.e['FSC_Begin'](0, 42))
        for _ in range(2): self.assertTrue(self.e['FSC_Add'](0, 99, 1, False, 'A'))
        self.assertIsNone(self.e['FSC_Finish'](0, False))
        for payload in ['!', 'A'*(codec.MAX_PAYLOAD+1)]:
            self.assertTrue(self.e['FSC_Begin'](0, 42))
            self.assertFalse(self.e['FSC_Add'](0, 99, 1, False, payload))
            self.assertIsNone(self.e['FSC_Finish'](0, False))
        self.assertTrue(self.e['FSC_Begin'](0, 42))
        self.assertTrue(self.e['FSC_Add'](0, 99, 1, False, 'A'*4097))
        self.assertIsNone(self.e['FSC_Finish'](0, False))
        self.assertFalse(self.e['FSC_Writing'][0])

    def test_section_record_and_payload_limits(self):
        for count in [32, 33]:
            sections = tuple(codec.Section(i+100, 1, False, '') for i in range(count))
            self.parity(unchecked(sections))
        # 2046 MAX_INT-sized IDs approach the 16384-character body bound.
        # One more record crosses it once framing is included. Never truncate.
        for count in [2046, 2047, 2048]:
            payload = codec.pairs([(codec.MAX_INT-i, 1) for i in range(count)])
            self.parity(unchecked([codec.Section(7, 1, True, payload)]))
        self.parity(unchecked([codec.Section(2, 1, True, codec.uint(2049))]))

    def test_seeded_differential_envelopes_and_mutations(self):
        rng = random.Random(20261010)
        for _ in range(150):
            slots = rng.sample(range(30), rng.randrange(31))
            records = [(i+1, rng.randrange(1, 50000), 2, slot,
                        rng.choice([None, 0, 120, 127]), bool(rng.randrange(2)),
                        ((1, True, codec.life_words(rng.randrange(1, 1000)+.25)),
                         (99, False, 'ABC'))) for i, slot in enumerate(slots)]
            sections = (codec.Section(1, 1, True, codec.inventory(records)),
                        codec.Section(2, 1, True, codec.pairs([(i, rng.randrange(101)) for i in range(1, 43)])),
                        codec.Section(100, 1, False, 'ABC'))
            envelope = codec.Envelope(rng.randrange(1048576), sections)
            text = codec.encode(envelope)
            self.parity(text)
            self.write(envelope)
            index = rng.randrange(len(text))
            changed = text[:index]+rng.choice(codec.ALPHABET)+text[index+1:]
            self.parity(changed)

    def test_isolation_bounds_crlf_and_compile(self):
        raw = SOURCE.read_bytes()
        self.assertNotIn(b'\n', raw.replace(b'\r\n', b''))
        source = raw.decode()
        for forbidden in ['CreateItem', 'SetHeroLevel', 'SetPlayerState', 'TriggerRegister',
                          'Preload', 'ExecuteFunc', 'GetLocalPlayer', 'TriggerSleepAction']:
            self.assertNotRegex(strip_comments(source), r'\b'+forbidden+r'\b')
        self.assertLess(24*32+31, 8192)
        self.assertLess(16*16+15, 8192)
        flat, _ = flatten('', [source], tail='function config takes nothing returns nothing\nendfunction\n'
                       'function main takes nothing returns nothing\nendfunction\n')
        with tempfile.TemporaryDirectory(dir=ROOT/'build') as folder:
            script = Path(folder)/'codec.j'
            script.write_text(flat, encoding='utf-8')
            for libraries in [ROOT/'tools/bin', ROOT/'tools/versions/1.29.2']:
                command = [str(ROOT/'tools/bin/pjass.exe'), str(libraries/'common.j'),
                           str(libraries/'blizzard.j'), str(script)]
                result = subprocess.run(command, capture_output=True, text=True)
                self.assertEqual(result.returncode, 0, str(libraries)+'\n'+result.stdout+result.stderr)


if __name__ == '__main__':
    unittest.main()
