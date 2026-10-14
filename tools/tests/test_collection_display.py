"""Classic collection tooltips and per-player collection/equipment summaries."""
from collections import defaultdict
from pathlib import Path
from unittest.mock import patch
import unittest
import sys

sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
import bazaar_legacy
import test_quest_lifecycle as harness

ROOT=Path(__file__).resolve().parents[2]
SOURCE=ROOT/'src/triggers/09 Player features/HeroStats.j'

class CollectionDisplayTests(unittest.TestCase):
    def test_classic_tooltip_indices_are_explicit_even_when_zero_reads_text(self):
        for folder,name,offset in [('09 Player features','Titles','ChroniclesTooltipOffset'),
                                   ('05 Items crafting and shops','Armory','ArmoryTooltipLevel')]:
            source=(ROOT/'src/triggers'/folder/(name+'.j')).read_text(encoding='utf-8')
            classic=bazaar_legacy.convert_editor_text(source)
            self.assertIn('if true then\n        set '+offset+'=1',classic)
            self.assertIn("StringLength(BlzGetAbilityExtendedTooltip(",source)
            self.assertNotIn("StringLength(BlzGetAbilityExtendedTooltip(",classic)

    def test_armory_counts_stored_collectibles_once_in_parent_category(self):
        env=dict(udg_SaveFlagCount=5,ArmoryMissingUnit=defaultdict(int,{1:101,2:102,3:103,4:104}),
            udg_SaveFlagUnitID={i:i for i in range(1,6)},
            udg_ArmoryParentCategory=defaultdict(int,{11:1,12:1,21:2}),
            udg_SaveFlagForce=defaultdict(set,{1:{0},2:{1},3:{0},4:{1}}),
            GetUnitPointValueByType=lambda raw:{1:11,2:12,3:1,4:21,5:11}[raw],
            IsPlayerInForce=lambda p,f:p in f,I2S=str)
        with patch.object(harness,'SELECTED',[]):
            e=harness.load_engine(SOURCE.read_text(encoding='utf-8'),['Stats_ArmoryCategoryProgress'],env)
        self.assertEqual(e['Stats_ArmoryCategoryProgress'](0,1),'2 / 3')
        self.assertEqual(e['Stats_ArmoryCategoryProgress'](1,1),'1 / 3')
        self.assertEqual(e['Stats_ArmoryCategoryProgress'](1,2),'1 / 1')

    def test_equipment_summary_includes_all_slots_and_empty_slots(self):
        shown=[]
        env=dict(Player_GetHero=lambda p:'hero',GetLocalPlayer=lambda:0,
            ClearTextMessages=lambda:None,DisplayTimedTextToPlayer=lambda p,x,y,t,s:shown.append((p,s)),
            SaveSlots_Equip=lambda h,s:'helm' if s==0 else None,GetItemName=lambda it:'Test helm')
        with patch.object(harness,'SELECTED',[]):
            e=harness.load_engine(SOURCE.read_text(encoding='utf-8'),['Stats_EquipmentName','Stats_Equipment'],env)
        e['Stats_Equipment'](0)
        rows=[s for p,s in shown]
        self.assertIn('Helm: Test helm',rows)
        for name in ('Chest','Gloves','Boots','Ring 1','Ring 2','Weapon','Offhand','Trinket'):
            self.assertIn(name+': Empty',rows)
        self.assertTrue(all(p==0 for p,s in shown))

if __name__=='__main__':unittest.main()
