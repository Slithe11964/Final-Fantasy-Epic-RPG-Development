"""Prove the 1.29.2 game-cache delivery path carries transport packets intact.

Reforged shares a locally read save file with BlzSendSyncData. 1.29.2 has no such
native, so the same packets travel as synchronised game-cache integers. The cache is
simulated here: this checks the packing and reassembly, not real network timing.
"""
from pathlib import Path
import unittest

import save_vnext as codec
from test_save_jass import engine
from test_save_migration import native_sections

HERE = Path(__file__).resolve().parent
ALPHABET = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890$#'


def profile(account=42, slots=57):
    records = []
    for pos in range(slots):
        holder, slot = ((1, pos) if pos < 6 else (2, pos - 6) if pos < 36 else
                        (3, pos - 36) if pos < 45 else (4, pos - 45) if pos < 51 else (5, pos - 51))
        records.append((pos + 1, 1001 + pos, holder, slot, 120, True,
                        ((1, True, codec.life_words(145.25)), (2, True, codec.uint(5)))))
    sections = (codec.Section(1, 1, True, codec.inventory(records)),
                codec.Section(2, 1, True, codec.pairs([(i, 100) for i in range(1, 43)]))) + native_sections()
    return codec.encode(codec.Envelope(account, sections))


class CacheTransportTests(unittest.TestCase):
    def setUp(self):
        self.cache = {}
        natives = dict(
            InitGameCache=lambda name: self.cache,
            StoreInteger=lambda c, mission, key, value: c.__setitem__((mission, key), value),
            # Only a synced key is visible to the other clients, exactly as in game.
            SyncStoredInteger=lambda c, mission, key: self.synced.__setitem__(
                (mission, key), c[(mission, key)]),
            GetStoredInteger=lambda c, mission, key: self.synced.get((mission, key), 0),
            FSC_Index=lambda letter: ALPHABET.index(letter),
            FSC_Letter=lambda digit: ALPHABET[digit])
        self.synced = {}
        self.e = engine((HERE / 'Forsaken-save-cache.j').read_text(), natives)
        self.e['FSG_Store'] = self.cache
        self.e['FSG_Reset'](0)

    def send(self, packets):
        for packet in packets:
            self.assertTrue(self.e['FSG_Send'](0, packet), packet)

    def receive(self, count):
        return [self.e['FSG_Packet'](0, index) for index in range(count)]

    def test_a_whole_save_survives_the_cache_as_transport_packets(self):
        code = profile()
        self.assertGreater(len(code), 1500, 'wanted a realistic endgame code')
        # The packet stream the Reforged transport emits: header, 192-character data, end.
        packets = ['B' + '0' * 6 + f'{len(code):05d}' + '0' * 10 + '0' * 6 + '0' * 9]
        packets += ['D' + '0' * 6 + f'{n:03d}' + code[n * 192:(n + 1) * 192]
                    for n in range((len(code) + 191) // 192)]
        packets.append('E' + '0' * 6)
        self.send(packets)
        self.assertEqual(self.receive(len(packets)), packets)
        rebuilt = ''.join(p[10:] for p in self.receive(len(packets)) if p.startswith('D'))
        self.assertEqual(rebuilt, code, 'the save must come back character for character')

    def test_legacy_brackets_and_every_alphabet_character_survive(self):
        packets = ['D' + '0' * 6 + '000' + ALPHABET + '()']
        self.send(packets)
        self.assertEqual(self.receive(1), packets)

    def test_a_packet_is_unreadable_until_its_last_key_arrives(self):
        packet = 'D' + '0' * 6 + '000' + 'ABCDEFGHIJ'
        held = {}
        real = self.synced
        self.synced = held
        self.assertTrue(self.e['FSG_Send'](0, packet))
        # Drop the length key, which is written last, and the packet must stay incomplete.
        length_key = [k for k in held if k[1].endswith('_0')]
        self.assertEqual(len(length_key), 1)
        kept = held.pop(length_key[0])
        self.assertIsNone(self.e['FSG_Packet'](0, 0), 'incomplete packets must not be handed on')
        held[length_key[0]] = kept
        self.assertEqual(self.e['FSG_Packet'](0, 0), packet)
        self.synced = real

    def test_packet_count_tracks_what_was_published(self):
        self.send(['E' + '0' * 6, 'X' + '0' * 6])
        self.assertEqual(self.synced[('FSCUcache', 'p0_n')] - 1, 2)
        self.assertEqual(self.e['FSG_Sent'][0], 2)


if __name__ == '__main__':
    unittest.main()
