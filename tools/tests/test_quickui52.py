"""Exercise the actual job-style equipment lifecycle and item-click event order."""
import sys
import unittest
from collections import defaultdict
from pathlib import Path

sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from jtok import functions,tokens
from editor_pair import View
from test_armory_materia import execute
from test_shared_context import mocks
import test_wave_runes

ROOT=Path(__file__).resolve().parents[2]


class LoadedEquipmentTests(unittest.TestCase):
    def test_full_inventory_preserves_handles_slots_charges_and_rebinds_both(self):
        source=(ROOT/'experiments/Forsaken/GearRefresh52.j').read_text()
        e=mocks(source)
        worn={0:'weapon',1:'offhand'}
        quick={0:'quick0',1:'quick1',2:'quick2',3:'quick3',4:'quick4',5:'quick5'}
        bag=['bag'+str(i) for i in range(30)]
        charges={item:i+1 for i,item in enumerate(list(worn.values())+list(quick.values())+bag)}
        original=(dict(worn),dict(quick),list(bag),dict(charges))
        usable=set();operations=[]
        def unequip(hero,item):
            for slot,value in list(worn.items()):
                if value==item:del worn[slot]
            # Native unequip is allowed to spill into the reserved quick slot.
            self.assertNotIn(0,quick)
            quick[0]=item
            operations.append(('unequip',item))
        def remove(hero,item):
            for slot,value in list(quick.items()):
                if value==item:del quick[slot]
            operations.append(('remove',item))
        def add(hero,item):
            self.assertNotIn(0,quick)
            self.assertEqual(charges[item],0)
            quick[0]=item;usable.add(item)
            return True
        def equip(hero,item):
            self.assertEqual(quick.pop(0),item)
            worn[0 if item=='weapon' else 1]=item
            operations.append(('equip',item))
        e.update(QuickGearLoadData='load',ForsakenConvertingGear=False,GetExpiredTimer=lambda:'timer',GetHandleId=lambda value:1,LoadUnitHandle=lambda *args:'hero',
            GetPlayerId=lambda owner:0,GetOwningPlayer=lambda hero:0,Player_GetHero=lambda owner:'hero',
            FFL_Phase=defaultdict(int),FFN_State=defaultdict(int),QuickGearRevision=defaultdict(int),
            QuickGear_Item=lambda hero,slot:worn.get(slot),UnitItemInSlot=lambda hero,slot:quick.get(slot),
            GetItemCharges=lambda item:charges.get(item,0),SetItemCharges=lambda item,n:charges.__setitem__(item,n),
            BlzUnitUnequipItem=unequip,UnitRemoveItem=remove,UnitAddItem=add,BlzUnitEquipItem=equip,
            Forsaken_RestoreStoredItem=lambda item:None,Forsaken_SyncStoredEffects=lambda hero:None,
            Integrity_RefreshWorn=lambda hero:None,FlushChildHashtable=lambda *args:None,DestroyTimer=lambda timer:None,
            SetItemPosition=lambda *args:self.fail('equipment was dropped'))
        env=execute(source,list(functions(source)),e)
        env['QuickGear_LoadRefresh']()
        self.assertEqual((worn,quick,bag,charges),original)
        self.assertTrue({'weapon','offhand'}<=usable)
        self.assertEqual([x for x in operations if x[0]=='equip'],[('equip','weapon'),('equip','offhand')])
        self.assertFalse(env['ForsakenConvertingGear'])

    def test_packaged_both_load_formats_and_unconditional_live_redraw(self):
        v=View(ROOT/'release/development/QuickUI52/FFERPG-QuickUI52-Forsaken.w3x')
        f=functions(v.runtime)
        for name in ('Trig_Cmd_Load_Code_LoadCodeV2','Trig_Cmd_Load_Code_LoadCodeV3','FFL_Commit'):
            self.assertIn('call QuickGear_QueueLoaded(',f[name])
        self.assertIn('if true then\n            call QuickGear_Draw(hero,viewer)',f['QuickGear_Poll'])
        old=functions(View(ROOT/'release/development/QuickUI51/FFERPG-QuickUI51-Forsaken.w3x').runtime)
        for name in ('QuickGear_Request','QuickGear_Receive','QuickGear_Input','Aqua_Pulse','DG_Impact','Cuts_Damage'):
            self.assertEqual(tokens(f[name]),tokens(old[name]),name)


class NativeClickTests(unittest.TestCase):
    def test_native_item_click_survives_same_tick_mouse_event_with_stale_world_coordinates(self):
        env,data,pos,visible,mouse=test_wave_runes.WaveRuneTests().runtime()
        now=[10.]
        env.update(TimerGetElapsed=lambda timer:now[0],NativeCDClock='clock',Wave_ClickCount=0,
            GetTriggerEventId=lambda:2,BlzGetTriggerPlayerMouseButton=lambda:'left',MOUSE_BUTTON_TYPE_RIGHT='right')
        data[0,55]=100
        env['Wave_FrameClick']()
        env['Wave_MouseCommit']()
        self.assertEqual(env['Wave_Mode'],1)
        now[0]+=.2
        env['Wave_Draw'](1)
        self.assertEqual(sum(visible.values()),32)
        env['Wave_MouseCommit']()
        self.assertEqual(env['Wave_Mode'],0)

    def test_nested_native_bag_buttons_are_discovered_in_slot_order(self):
        source=(ROOT/'experiments/Dragoon/WaveRunes.j').read_text()
        env=mocks(source);hooked=[]
        children={'pane':['row0','row1'],'row0':['cell0','cell1'],'row1':['cell2','cell3']}
        env.update(BlzFrameGetChildrenCount=lambda f:len(children.get(f,[])),
            BlzFrameGetChild=lambda f,i:children[f][i],
            BlzFrameGetWidth=lambda f:.03125 if f.startswith('cell') else .2,
            BlzFrameGetHeight=lambda f:.03125 if f.startswith('cell') else .04,RAbsBJ=abs)
        env=execute(source,['Wave_BagChildren'],env)
        env['Wave_Hook']=lambda f,slot:hooked.append((f,slot))
        self.assertEqual(env['Wave_BagChildren']('pane',0,0),4)
        self.assertEqual(hooked,[('cell'+str(i),100+i) for i in range(4)])


if __name__=='__main__':unittest.main()
