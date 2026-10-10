"""Actual JASS hidden-allocation lifecycle with mocked modern native behavior."""
import struct
import subprocess
import tempfile
import unittest
from pathlib import Path

from test_save_jass import engine, ROOT, SOURCE, flatten
from test_save_life import LIFE, Real32

NATIVE = SOURCE.with_name('Forsaken-save-native.j')


class World:
    def __init__(self):
        self.items = []
        self.calls = []
        self.silent = None
        self.fail_create = 0
        self.stale_drop = None
        self.callback = None
        self.refuse_delete = set()
        self.clamp_life = None

    def create(self, raw, x, y):
        self.calls.append(('create', raw))
        if len(self.items)+1 == self.fail_create:
            return None
        item = dict(raw=raw, charges=5, binding=99, life=Real32(99.), owner=15,
                    visible=True, owned=False, invulnerable=False, droppable=True, pawnable=False)
        self.items.append(item)
        return item

    def set(self, field, item, value):
        self.calls.append((field, id(item)))
        if self.callback:
            self.callback()
        if field != self.silent:
            if field == 'life' and self.clamp_life is not None:
                value = Real32(min(float(value), self.clamp_life))
            item[field] = value

    def remove(self, item):
        self.calls.append(('remove', id(item)))
        if self.callback:
            self.callback()
        if id(item) not in self.refuse_delete:
            item['raw'] = 0

    def natives(self):
        return dict(I2R=Real32, R2I=lambda v: int(float(v)), R2S=lambda v:format(float(v),'.3f'), I2S=str, Player=lambda pid: pid,
            CreateItem=self.create, RemoveItem=self.remove,
            GetItemTypeId=lambda i: i['raw'] if i else 0,
            GetItemCharges=lambda i: i['charges'], GetItemUserData=lambda i: i['binding'],
            GetWidgetLife=lambda i: i['life'], GetItemPlayer=lambda i: i['owner'],
            IsItemVisible=lambda i: i['visible'], IsItemOwned=lambda i: i['owned'],
            IsItemInvulnerable=lambda i: i['invulnerable'], IsItemPawnable=lambda i: i['pawnable'],
            ITEM_BF_CAN_BE_DROPPED='drop',
            ITEM_IF_MAX_HIT_POINTS='maxlife',
            BlzGetItemIntegerField=lambda i,field: int(self.clamp_life if self.clamp_life is not None else 75),
            BlzGetItemBooleanField=lambda i, field: i['droppable'] if self.stale_drop is None else self.stale_drop,
            SetItemVisible=lambda i, v: self.set('visible', i, v),
            SetItemCharges=lambda i, v: self.set('charges', i, v),
            SetItemUserData=lambda i, v: self.set('binding', i, v),
            SetWidgetLife=lambda i, v: self.set('life', i, v),
            SetItemPlayer=lambda i, p, color: self.set('owner', i, p),
            SetItemInvulnerable=lambda i, v: self.set('invulnerable', i, v),
            SetItemDroppable=lambda i, v: self.set('droppable', i, v),
            SetItemPawnable=lambda i, v: self.set('pawnable', i, v))


class NativeTests(unittest.TestCase):
    def setUp(self):
        self.world = World()
        self.e = engine(LIFE.read_text()+'\n'+NATIVE.read_text(), self.world.natives())

    def stage(self, pid=0, raw=1234, charges=127, bound=True, flags=7, life=145.25):
        bits = struct.unpack('>I', struct.pack('>f', life))[0]
        return self.e['FSN_Stage'](pid, raw, charges, bound, flags, bits >> 16, bits & 65535, 0., 0.)

    def assert_clean(self, pid=0):
        self.assertEqual(self.e['FSN_Count'][pid], 0)
        self.assertFalse(self.e['FSN_Busy'][pid])
        for slot in range(57):
            self.assertIsNone(self.e['FSN_Item'][pid*57+slot])

    def test_all_players_full_57_metadata_and_isolation(self):
        for pid in range(8):
            self.assertTrue(self.e['FSN_Begin'](pid))
            for slot in range(57):
                flags = slot % 8
                self.assertTrue(self.stage(pid, 1000+slot, slot % 128, slot % 2 == 1, flags, 20.+slot/4))
                item = self.e['FSN_Item'][pid*57+slot]
                self.assertEqual(item['owner'], pid)
                self.assertEqual(item['binding'], pid+1 if slot % 2 else 0)
                self.assertEqual(item['invulnerable'], bool(flags & 1))
                self.assertEqual(item['droppable'], bool(flags & 2))
                self.assertEqual(item['pawnable'], bool(flags & 4))
            self.assertTrue(self.e['FSN_Verify'](pid))
        self.assertTrue(self.e['FSN_Abort'](3))
        self.assert_clean(3)
        for pid in [0, 1, 2, 4, 5, 6, 7]:
            self.assertTrue(self.e['FSN_Verify'](pid))
            self.assertEqual(self.e['FSN_Count'][pid], 57)
            self.assertTrue(self.e['FSN_Abort'](pid))
        self.assertTrue(all(i['raw'] == 0 for i in self.world.items))

    def test_null_allocation_at_each_of_57_positions(self):
        for position in range(1, 58):
            with self.subTest(position=position):
                self.setUp()
                self.world.fail_create = position
                self.assertTrue(self.e['FSN_Begin'](0))
                for _ in range(position-1): self.assertTrue(self.stage())
                self.assertFalse(self.stage())
                self.assertEqual(self.e['FSN_State'][0], 2)
                self.assertFalse(self.e['FSN_Begin'](0))
                self.assertTrue(all(i['raw'] == 0 for i in self.world.items))
                self.assert_clean()
                self.assertTrue(self.e['FSN_Abort'](0))
                self.assertTrue(self.e['FSN_Begin'](0))

    def test_each_silent_setter_failure_removes_batch(self):
        for field in ['visible', 'charges', 'binding', 'life', 'owner', 'invulnerable', 'droppable', 'pawnable']:
            with self.subTest(field=field):
                self.setUp()
                self.assertTrue(self.e['FSN_Begin'](0))
                self.assertTrue(self.stage())
                self.world.silent = field
                self.assertFalse(self.stage())
                self.assertTrue(all(i['raw'] == 0 for i in self.world.items))
                self.assert_clean()
                self.assertFalse(self.e['FSN_Verify'](0))

    def test_object_default_drop_getter_is_refused_for_both_defaults(self):
        for default in [False, True]:
            self.setUp()
            self.world.stale_drop = default
            self.assertTrue(self.e['FSN_Begin'](0))
            self.assertFalse(self.stage(flags=2 if default else 0))
            self.assert_clean()
            self.assertEqual(self.world.items[0]['raw'], 0)

    def test_life_clamping_is_refused_by_exact_word_readback(self):
        self.assertTrue(self.e['FSN_Begin'](0))
        self.world.clamp_life = 145.
        self.assertFalse(self.stage(life=145.25))
        self.assert_clean()
        self.assertEqual(self.world.items[0]['raw'], 0)

    def test_failed_hiding_and_deletion_report_blocked_with_retained_handle(self):
        self.assertTrue(self.e['FSN_Begin'](0))
        self.world.silent = 'visible'
        create = self.world.create
        def create_refusing_cleanup(raw, x, y):
            item = create(raw, x, y)
            self.world.refuse_delete.add(id(item))
            return item
        self.e['CreateItem'] = create_refusing_cleanup
        self.assertFalse(self.stage())
        self.assertEqual(self.e['FSN_State'][0], 3)
        self.assertEqual(self.e['FSN_Count'][0], 1)
        self.assertIs(self.e['FSN_Item'][0], self.world.items[0])
        self.assertTrue(self.world.items[0]['visible'])
        self.assertFalse(self.e['FSN_Begin'](0))
        self.world.refuse_delete.clear()
        self.assertTrue(self.e['FSN_Abort'](0))
        self.assert_clean()

    def test_readback_detects_later_metadata_or_accessibility_changes(self):
        changes = dict(raw=999, charges=126, binding=0, life=Real32(145.), owner=1,
                       visible=True, owned=True, invulnerable=False, droppable=False, pawnable=False)
        for field, value in changes.items():
            with self.subTest(field=field):
                self.setUp()
                self.assertTrue(self.e['FSN_Begin'](0))
                self.assertTrue(self.stage())
                self.world.items[0][field] = value
                self.assertFalse(self.e['FSN_Verify'](0))
                self.assert_clean()
                self.assertEqual(self.world.items[0]['raw'], 0)

    def test_failed_cleanup_retains_handle_and_blocks_reuse_until_retry(self):
        self.assertTrue(self.e['FSN_Begin'](0))
        self.assertTrue(self.stage())
        kept = self.world.items[0]
        self.world.refuse_delete.add(id(kept))
        self.assertFalse(self.e['FSN_Abort'](0))
        self.assertEqual(self.e['FSN_State'][0], 3)
        self.assertIs(self.e['FSN_Item'][0], kept)
        self.assertEqual(self.e['FSN_Count'][0], 1)
        self.assertFalse(self.e['FSN_Begin'](0))
        self.assertFalse(self.stage())
        self.assertFalse(self.e['FSN_Verify'](0))
        self.assertFalse(kept['visible'])
        self.world.refuse_delete.clear()
        self.assertTrue(self.e['FSN_Abort'](0))
        self.assert_clean()
        self.assertEqual(self.e['FSN_State'][0], 0)

    def test_partial_cleanup_retry_preserves_only_failed_allocation(self):
        self.assertTrue(self.e['FSN_Begin'](7))
        for _ in range(3): self.assertTrue(self.stage(pid=7))
        self.world.refuse_delete.add(id(self.world.items[1]))
        self.assertFalse(self.e['FSN_Abort'](7))
        self.assertIsNone(self.e['FSN_Item'][399])
        self.assertIs(self.e['FSN_Item'][400], self.world.items[1])
        self.assertIsNone(self.e['FSN_Item'][401])
        self.world.refuse_delete.clear()
        self.assertTrue(self.e['FSN_Abort'](7))
        self.assert_clean(7)

    def test_reentrant_native_callbacks_cannot_replace_or_delete_current_batch(self):
        self.assertTrue(self.e['FSN_Begin'](0))
        reentries = []
        def callback():
            reentries.extend([self.e['FSN_Begin'](0), self.stage(),
                              self.e['FSN_Abort'](0), self.e['FSN_Verify'](0)])
        self.world.callback = callback
        self.assertTrue(self.stage())
        self.assertTrue(reentries)
        self.assertFalse(any(reentries))
        self.assertEqual(self.e['FSN_Count'][0], 1)
        self.assertTrue(self.e['FSN_Abort'](0))
        self.assertFalse(any(reentries))
        self.assert_clean()

    def test_invalid_inputs_and_overflow_fail_without_untracked_items(self):
        for pid in [-1, 8, 2147483647]:
            self.assertFalse(self.e['FSN_Begin'](pid))
            self.assertFalse(self.stage(pid=pid))
            self.assertFalse(self.e['FSN_Verify'](pid))
            self.assertFalse(self.e['FSN_Abort'](pid))
        self.assertEqual(self.world.calls, [])
        for kwargs in [dict(raw=0), dict(charges=-1), dict(charges=128), dict(flags=-1),
                       dict(flags=8), dict(life=0.), dict(life=-1.), dict(life=float('inf'))]:
            self.assertTrue(self.e['FSN_Begin'](0))
            self.assertFalse(self.stage(**kwargs))
            self.assert_clean()
            self.assertTrue(self.e['FSN_Abort'](0))
        self.assertTrue(self.e['FSN_Begin'](0))
        for _ in range(57): self.assertTrue(self.stage())
        self.assertFalse(self.stage())
        self.assertEqual(len(self.world.items), 57)
        self.assert_clean()

    def test_no_original_inventory_apis_or_accepted_codec_mutation(self):
        self.e['FSC_Code'][0] = 'previous accepted envelope'
        self.assertTrue(self.e['FSN_Begin'](0))
        self.assertTrue(self.stage())
        self.assertTrue(self.e['FSN_Verify'](0))
        self.assertTrue(self.e['FSN_Abort'](0))
        self.assertEqual(self.e['FSC_Code'][0], 'previous accepted envelope')
        text = NATIVE.read_text()
        for forbidden in ['UnitAddItem', 'UnitRemoveItem', 'UnitEquipItem', 'UnitUnequipItem',
                          'FSC_Decode(', 'FSC_Reset(', 'initializer ', 'GetLocalPlayer']:
            self.assertNotIn(forbidden, text)

    def test_crlf_and_extracted_modern_standalone_compile(self):
        self.assertNotIn(b'\n', NATIVE.read_bytes().replace(b'\r\n', b''))
        flat, _ = flatten('', [SOURCE.read_text(), LIFE.read_text(), NATIVE.read_text()],
                          tail='function main takes nothing returns nothing\nendfunction\n'
                               'function config takes nothing returns nothing\nendfunction\n')
        with tempfile.TemporaryDirectory(dir=ROOT/'build') as directory:
            path = Path(directory)/'native-stage.j'
            path.write_text(flat, encoding='utf-8')
            libs = ROOT.parent/'war3.w3mod/scripts'
            result = subprocess.run([str(ROOT/'tools/bin/pjass.exe'), str(libs/'common.j'),
                                     str(libs/'blizzard.j'), str(path)], capture_output=True, text=True)
            self.assertEqual(result.returncode, 0, result.stdout+result.stderr)


if __name__ == '__main__': unittest.main()
