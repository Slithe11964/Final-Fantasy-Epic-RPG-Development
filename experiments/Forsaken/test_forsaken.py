"""Check the experimental mapping, immutable item fields and save boundary."""
from pathlib import Path
import sys
import tempfile
import unittest

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
import build_forsaken as build
sys.path.insert(0, str(build.ROOT/'tools/tests'))
from test_shared_context import mocks
from test_armory_materia import execute
from mpq import MPQ
from objdata import read_objects, fields
from jtok import functions


class ForsakenTests(unittest.TestCase):
    def test_native_slots_and_accessories(self):
        for category, slot in [(12, 'Primary'), (24, 'Offhand'), (28, 'Head'), (30, 'Chest')]:
            self.assertEqual(build.slot_for({'name': 'Example'}, category), slot)
        for name, slot in [('Sprint Shoes', 'Boots'), ('Genji Gloves', 'Gloves'),
                           ('Memento Ring', 'Ring'), ('Rosetta Stone', 'Trinket')]:
            self.assertEqual(build.slot_for({'name': name}, 33), slot)
        self.assertIsNone(build.slot_for({'name': 'Aeroga Materia'}, 8))

    def test_object_patch_only_changes_equipment_types_and_adds_two_abilities(self):
        base = build.ROOT/'release/FFERPG_0.9.7.3-r16-stageAS.w3x'
        with tempfile.TemporaryDirectory(dir=build.ROOT/'build') as folder:
            out = Path(folder)/'gear.w3x'
            mapping = build.prepare_objects(base, out, Path(folder)/'mapping.json')
            old, new = MPQ(base), MPQ(out)
            for filename in old.read('(listfile)').decode().splitlines():
                if filename not in ('war3map.w3t', 'war3map.w3a'):
                    self.assertEqual(old.read(filename), new.read(filename), filename)
            def items(archive):
                t = read_objects(archive.read('war3map.w3t'), 'w3t')
                return {o['id'] or o['base']: fields(o) for g in ('original', 'custom') for o in t[g]}
            before, after = items(old), items(new)
            self.assertEqual(len(after)-len(before),277)
            for raw, original in before.items():
                self.assertEqual(original, after[raw], raw)
                if raw in mapping and mapping[raw]['slot']!='Inventory':
                    updated = after[mapping[raw]['variant']].copy()
                    self.assertEqual(updated.pop('iequ'), mapping[raw]['slot'])
                    self.assertEqual(original, updated, raw)
            self.assertEqual(after['fBpk']['iabi'],'AIni,AEqu')
            self.assertEqual(after['fBpk']['idrp'],0)
            self.assertEqual(len(mapping), 280)

    def test_equipment_validation_uses_event_item_and_save_serializers_are_untouched(self):
        source = (build.ROOT/'src/triggers/05 Items crafting and shops/Equip.j').read_text(encoding='utf-8')
        overlay = build.equip_overlay(source)
        fs = functions(overlay)
        self.assertIn('Forsaken_ValidateEquipment', fs)
        self.assertIn('GetTriggerUnit', fs['Forsaken_ValidateEquipment'])
        self.assertNotIn('GetManipulatingUnit', fs['Forsaken_ValidateEquipment'])
        self.assertIn('GetItemEquipmentType', fs['Trig_Equip_Restrictions_Conditions'])
        self.assertNotIn('Save_WriteCode', overlay)
        self.assertNotIn('Save_WriteNewGameCode', overlay)
        self.assertIn('TriggerClearActions', fs['Forsaken_PrepareInventories'])
        self.assertIn('UnitUnequipItem', fs['Forsaken_RejectEquipment'])

    def test_native_equip_checks_level_and_rejects_the_event_item(self):
        source = (build.ROOT/'src/triggers/05 Items crafting and shops/Equip.j').read_text(encoding='utf-8')
        overlay = build.equip_overlay(source)
        selected = ['Forsaken_EventItem', 'Forsaken_RejectEquipment',
                    'Trig_Equip_Restrictions_GaiaLevelTooLow',
                    'Trig_Equip_Restrictions_JobGatedItem',
                    'Forsaken_ValidateEquipment', 'Forsaken_OnEquip']
        for gaya_level, rejected in [(10, True), (30, False)]:
            calls = []
            state = mocks(overlay)
            state.update(ForsakenEquippedItem=None, GetTriggerUnit=lambda:'hero', GetOwningPlayer=lambda u:0,
                         Player_GetHero=lambda p:'hero', GetEquippedItem=lambda:'gear',
                         GetManipulatedItem=lambda:None, IsPlayerInForce=lambda *a:True,
                         udg_PlayingPlayers='players', udg_SpiritOfGaya={1:'gaya'},
                         udg_PlayerName={1:'Slithe'}, GetConvertedPlayerId=lambda p:1,
                         I2R=float, R2I=int, I2S=str,
                         GetHeroLevel=lambda u:gaya_level, GetItemLifeBJ=lambda i:20.,
                         GetItemName=lambda i:'Example helmet',
                         UnitUnequipItem=lambda u,i:calls.append(('unequip',u,i)),
                         UnitRemoveItem=lambda u,i:calls.append(('remove',u,i)))
            runtime = execute(overlay, selected, state)
            runtime['Forsaken_OnEquip']()
            self.assertEqual(calls, [('unequip','hero','gear'), ('remove','hero','gear')] if rejected else [])
            self.assertIsNone(runtime['ForsakenEquippedItem'])

    def test_conversion_preserves_original_when_the_bag_refuses_the_variant(self):
        overlay = build.equip_overlay((build.ROOT/'src/triggers/05 Items crafting and shops/Equip.j').read_text(encoding='utf-8'))
        for accepts in [False, True]:
            removed, copied = [], []
            state = mocks(overlay)
            state.update(ForsakenGearTypes='types', UnitItemInSlot=lambda u,s:'original' if s==0 else None,
                         GetItemTypeId=lambda i:1 if i=='original' else 0,
                         LoadInteger=lambda h,p,c:123 if c==1 else 0,
                         CreateItem=lambda *a:'variant', GetItemCharges=lambda i:4,
                         GetItemUserData=lambda i:2,
                         SetItemCharges=lambda i,v:copied.append(('charges',i,v)),
                         SetItemUserData=lambda i,v:copied.append(('owner',i,v)),
                         UnitAddItem=lambda *a:accepts, RemoveItem=lambda i:removed.append(i))
            runtime = execute(overlay, ['Forsaken_ConvertCarriedGear'], state)
            runtime['Forsaken_ConvertCarriedGear']('hero')
            self.assertEqual(removed, ['original'] if accepts else ['variant'])
            self.assertEqual(copied, [('charges','variant',4),('owner','variant',2)])


if __name__=='__main__':
    unittest.main()
