"""Regression checks for live slots, loaded active spells and Calculator previews."""
import sys
import unittest
from pathlib import Path
from collections import defaultdict

sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from jtok import functions,tokens
from test_armory_materia import execute
from editor_pair import View
from release_gear import reference
from gear_load_refresh import refresh
import test_equipment_quickcast as fixtures
import test_wave_runes as wave_fixtures

ROOT=Path(__file__).resolve().parents[2]


class GearRefreshTests(unittest.TestCase):
    def runtime(self):
        e,state,worn,data,calls,packets,visible,textures=fixtures.QuickCastTests().runtime()
        source=refresh(reference().modules['TEquip'])
        names=[n for n in functions(source) if n.startswith('QuickGear_')]
        binding={};metadata={'weapon':(4,7),'offhand':(1,8)};events=[]
        e.update(QuickGearSeenItem=defaultdict(lambda:None),QuickGearSeenRaw=defaultdict(int),QuickGearLoadData='load-data',
            LoadUnitHandle=lambda *args:'hero',GetExpiredTimer=lambda:'timer',GetHandleId=lambda *args:99,
            Forsaken_SyncStoredEffects=lambda hero:events.append(('stored',hero)),Integrity_RefreshWorn=lambda hero:events.append(('worn',hero)),
            BlzGetItemAbility=lambda item,raw:raw,BlzItemRemoveAbility=lambda item,raw:events.append(('remove',item,raw)),
            BlzItemAddAbility=lambda item,raw:binding.__setitem__(item,True),FlushChildHashtable=lambda *args:None,DestroyTimer=lambda *args:None,
            GetItemCharges=lambda item:metadata[item][0],GetItemUserData=lambda item:metadata[item][1],
            SetItemCharges=lambda *args:self.fail('refresh changed charges'),UnitRemoveItem=lambda *args:self.fail('refresh moved gear'),
            BlzUnitUnequipItem=lambda *args:self.fail('refresh unequipped gear'),BlzGetItemIconPath=lambda item:item+'-icon')
        return execute(source,names,e),state,worn,data,calls,packets,visible,textures,binding,metadata,events

    def test_weapon_and_offhand_refresh_without_event_or_job_change(self):
        e,s,w,db,calls,packets,v,icons,*_=self.runtime()
        e['QuickGear_Poll']();self.assertEqual((icons['fi'],icons['gi']),('weapon-icon','offhand-icon'))
        w[0]='newweapon';w[1]='newbook'
        raw={'newweapon':103,'newbook':104}
        e['GetItemTypeId']=lambda item:raw.get(item,0)
        db.update({(0,103):203,(0,104):204})
        e['QuickGear_Poll']()
        self.assertEqual((icons['fi'],icons['gi']),('newweapon-icon','newbook-icon'))
        self.assertEqual(e['QuickGearRevision'][0],0)
        w.clear();e['QuickGear_Poll']();self.assertFalse(v['F']);self.assertFalse(v['G'])

    def test_replacement_handle_with_same_raw_also_refreshes(self):
        e,s,w,db,calls,packets,v,icons,*_=self.runtime();e['QuickGear_Poll']()
        w[0]='same-type-new-handle'
        e['GetItemTypeId']=lambda item:101 if item=='same-type-new-handle' else 102
        e['QuickGear_Poll']()
        self.assertEqual(icons['fi'],'same-type-new-handle-icon')

    def test_after_load_rebinds_both_active_spells_without_moving_items_or_metadata(self):
        e,s,w,db,calls,packets,v,icons,binding,metadata,events=self.runtime()
        before=dict(metadata);e['QuickGear_LoadRefresh']()
        self.assertEqual(binding,{'weapon':True,'offhand':True})
        self.assertEqual(metadata,before)
        self.assertEqual(w,{0:'weapon',1:'offhand'})
        self.assertEqual(e['QuickGearRevision'][0],1)
        self.assertIn(('remove','weapon',201),events);self.assertIn(('remove','offhand',202),events)

    def test_load_callback_does_not_touch_replaced_or_still_loading_hero(self):
        e,s,w,db,calls,packets,v,icons,binding,*_=self.runtime()
        e['FFL_Phase'][0]=6;e['QuickGear_LoadRefresh']();self.assertFalse(binding)
        e['FFL_Phase'][0]=0;s['hero']='other';e['QuickGear_LoadRefresh']();self.assertFalse(binding)


class WaveActivationTests(unittest.TestCase):
    def test_bag_item_uses_actual_spell_even_for_unknown_alias(self):
        e,data,pos,visible,mouse=wave_fixtures.WaveRuneTests().runtime()
        data[0,55]=100
        e['BlzUnitItemInBagSlot']=lambda *args:'new-alias'
        data['wave','new-alias']=2
        e['Wave_FrameClick']();e['Wave_Draw'](1)
        self.assertEqual(e['Wave_Mode'],2);self.assertEqual(sum(visible.values()),63)

    def test_calculator_e_and_button_use_the_ice_wand_pattern_without_affecting_dragoon(self):
        e,data,pos,visible,mouse=wave_fixtures.WaveRuneTests().runtime()
        e.update(QuickGearChatOpen=False,QuickGearChatEdit=None,TravelVisible=defaultdict(bool),GetUnitAbilityLevel=lambda *args:1)
        e['Wave_CalculatorKey']();e['Wave_Draw'](1)
        self.assertEqual(sum(visible.values()),63)
        e['Wave_Mode']=0;data[0,55]=3;e['Wave_FrameClick']();self.assertEqual(e['Wave_Mode'],2)
        e['GetUnitAbilityLevel']=lambda *args:0;e['Wave_Mode']=0;e['DG_UIMode']=3
        e['Wave_FrameClick']();self.assertEqual(e['DG_UIMode'],3);self.assertEqual(e['Wave_Mode'],0)

    def test_packaged_controls_and_confirmed_combat_are_preserved(self):
        old=View(ROOT/'release/development/QuickUI50/FFERPG-QuickUI50-Forsaken.w3x')
        new=View(ROOT/'release/development/QuickUI51/FFERPG-QuickUI51-Forsaken.w3x')
        a,b=functions(old.runtime),functions(new.runtime)
        for name in ('QuickGear_Input','QuickGear_Request','QuickGear_Receive','QuickGear_Init','QuickGear_Mouse',
                     'Aqua_Pulse','DG_Impact','Cuts_Damage'):
            self.assertEqual(tokens(a[name]),tokens(b[name]),name)
        self.assertIn('QuickGear_EquipmentChanged(hero)',b['QuickGear_Poll'])
        self.assertIn('QuickGear_QueueLoaded(Player_GetHero(Player(pid)))',b['FFL_Commit'])
        self.assertGreater(b['FFL_Commit'].index('QuickGear_QueueLoaded'),b['FFL_Commit'].index('call FFL_Guard(false)'))
        self.assertIn('ExecuteFunc("Wave_Init")',b['Register_Forsaken_PanelAccess'])
        for raw,mode in [('I025',1),('f220',1),('q220',1),('f104',2),('g104',2),('q104',2)]:
            self.assertIn("SaveInteger(Wave_Spells,0,'"+raw+"',"+str(mode)+")",b['Wave_Init'])
        for name in ('war3map.w3a','war3mapSkin.w3a','war3map.w3u','war3mapSkin.w3u','war3map.w3h'):
            self.assertEqual(old.archive.read(name),new.archive.read(name))


if __name__=='__main__':unittest.main()
