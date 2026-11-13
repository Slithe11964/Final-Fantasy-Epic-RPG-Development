"""Recovery regression: input gating, no item mutation, no native bag frame walking."""
import sys
import unittest
from pathlib import Path
from collections import defaultdict

sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from jtok import functions,tokens
from editor_pair import View
from release_gear import reference
from gear_recovery53 import refresh
from test_armory_materia import execute
import test_equipment_quickcast as fixtures

ROOT=Path(__file__).resolve().parents[2]


class RecoveryTests(unittest.TestCase):
    def runtime(self):
        env,state,worn,db,calls,packets,visible,textures=fixtures.QuickCastTests().runtime()
        env.update(QuickGearObservedItem=defaultdict(lambda:None),QuickGearObservedRaw=defaultdict(int),
            QuickGearKeyEvents=0,QuickGearRequests=0,QuickGearReceives=defaultdict(int),QuickGearReason='',
            QuickGearChatEdit='edit',Player=lambda pid:pid,QuickGearChatSentAt=-100.,
            UnitRemoveItem=lambda *args:self.fail('read-only refresh moved an item'),
            BlzUnitUnequipItem=lambda *args:self.fail('read-only refresh unequipped an item'),
            BlzItemAddAbility=lambda *args:self.fail('read-only refresh changed abilities'))
        source=refresh(reference().modules['TEquip'])
        env=execute(source,[n for n in functions(source) if n.startswith('QuickGear_')],env)
        return env,state,worn,db,calls,packets,visible,textures

    def test_visible_edit_child_does_not_block_weapon_or_offhand(self):
        env,state,worn,db,calls,packets,visible,icons=self.runtime()
        visible['edit']=True
        env['QuickGearChatOpen']=False
        env['QuickGear_Input']()
        self.assertEqual(len(packets),1)
        state['now']+=1.;state['key']='G'
        env['QuickGear_Input']()
        self.assertEqual(env['QuickGearPending'],1)
        self.assertEqual(env['QuickGearRequests'],2)

    def test_actual_chat_still_blocks_and_load_resets_stale_chat_without_touching_items(self):
        env,state,worn,db,calls,packets,visible,icons=self.runtime()
        env['QuickGearChatOpen']=True
        env['QuickGear_Input']();self.assertEqual(env['QuickGearRequests'],0)
        before=dict(worn)
        env['QuickGear_Loaded'](0)
        self.assertFalse(env['QuickGearChatOpen'])
        self.assertEqual(worn,before)
        state['now']+=1.;env['QuickGear_Input']()
        self.assertEqual(env['QuickGearRequests'],1)

    def test_live_slot_change_is_observed_without_an_equipment_event(self):
        env,state,worn,db,calls,packets,visible,icons=self.runtime()
        env['QuickGear_Poll']();self.assertFalse(env['QuickGear_SlotsChanged']('hero'))
        worn[0]='replacement'
        self.assertTrue(env['QuickGear_SlotsChanged']('hero'))

    def test_packaged_recovery_removes_failed_paths_and_keeps_gameplay(self):
        old=View(ROOT/'release/development/QuickUI51/FFERPG-QuickUI51-Forsaken.w3x')
        new=View(ROOT/'release/development/QuickUI53/FFERPG-QuickUI53-Forsaken.w3x')
        a,b=functions(old.runtime),functions(new.runtime)
        for name in ('QuickGear_Reseat','QuickGear_LoadRefresh','QuickGear_QueueLoaded','Wave_BagChildren','Wave_CacheBatch','Wave_RefreshControls'):
            self.assertNotIn(name,b)
        for name,body in b.items():
            if name.startswith('Wave_'):
                self.assertNotIn('BlzFrameGetChild',body,name)
                self.assertNotIn('BlzGetFrameByName',body,name)
        for name in ('Aqua_Pulse','DG_Impact','Cuts_Damage','Forsaken_TransferSharedInventory'):
            self.assertEqual(tokens(a[name]),tokens(b[name]),name)
        for ext in ('w3a','w3u','w3t','w3h'):
            for prefix in ('war3map.','war3mapSkin.'):
                self.assertEqual(old.archive.read(prefix+ext),new.archive.read(prefix+ext))
        for name in ('FFL_Commit','Trig_Cmd_Load_Code_LoadCodeV2','Trig_Cmd_Load_Code_LoadCodeV3'):
            self.assertIn('call QuickGear_Loaded(',b[name])
        self.assertIn('"-gearcheck"',b['QuickGear_InitDiagnostics'])
        self.assertNotIn('ORIGIN_FRAME_ITEM_BUTTON',b['Wave_Init'])
        self.assertNotIn('FRAMEEVENT_MOUSE_DOWN',b['Wave_Hook'])


if __name__=='__main__':unittest.main()
