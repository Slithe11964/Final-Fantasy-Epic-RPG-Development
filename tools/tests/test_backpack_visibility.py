"""Engine panel pairing, native owner binding and persistent local UI intent."""
from pathlib import Path
import sys,unittest
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from inventory_ui import refresh
from jtok import functions
from test_armory_materia import execute
from test_shared_context import mocks
ROOT=Path(__file__).resolve().parents[2]
HELPER=(ROOT/'experiments/Forsaken/BackpackVisibility.j').read_text()

class BackpackVisibilityTests(unittest.TestCase):
    def runtime(self):
        state=dict(now=10.,hero='freelancer',key='',player=0,preview='freelancer',allow=True)
        visible={'gear':False,'bag':False,'command0':True,'command1':True}
        looked=[];clicked=[]
        def click(button):
            clicked.append(button)
            if state['allow']:
                pane='gear' if button=='command1' else 'bag'
                visible[pane]=not visible[pane]
                if pane=='gear' and visible[pane]:state['preview']=state['hero']
        def lookup(name):
            looked.append(name)
            return {'SimpleEquipmentPanel':'gear','EquipmentPanelBackdrop':'backdrop','SimpleEquipmentInventoryPanel':'bag'}.get(name)
        env=mocks(HELPER);env.update(
            ForsakenBackpackWanted=False,ForsakenBackpackWasVisible=False,ForsakenBackpackCloseUntil=0.,
            ForsakenPanelOpen=False,ForsakenPanelClock='clock',ForsakenCachedEquipment='gear',ForsakenCachedBackdrop='backdrop',
            ForsakenLinkedBag='bag',ForsakenInventoryHero='freelancer',ForsakenNextBagSearch=0.,
            ForsakenBackpackClose='close',ForsakenLinkedBagClose='bagclose',ForsakenTalentRoot='talents',
            ForsakenSelectedTarget='freelancer',ForsakenFrameSearchRequested=False,ForsakenBackpackNativeClose=None,ForsakenBagNativeClose=None,
            ForsakenBackpackHookRoot=None,ForsakenBagHookRoot=None,ForsakenBackpackScanBudget=0,
            GetLocalPlayer=lambda:0,GetTriggerPlayer=lambda:state['player'],GetTriggerEventId=lambda:'key',
            Player_GetHero=lambda p:state['hero'],IsUnitSelected=lambda *a:True,GetTriggerUnit=lambda:state['hero'],GetOwningPlayer=lambda u:0,
            BlzGetTriggerPlayerKey=lambda:state['key'],OSKEY_B='B',OSKEY_ESCAPE='escape',
            EVENT_PLAYER_UNIT_SELECTED='selected',EVENT_PLAYER_UNIT_DESELECTED='deselected',
            TimerGetElapsed=lambda t:state['now'],BlzFrameIsVisible=lambda f:visible.get(f,False),
            BlzFrameSetVisible=lambda f,v:visible.__setitem__(f,v),Forsaken_FindFrameUncached=lookup,
            BlzGetAbilityPosX=lambda raw:1 if raw=='fGer' else 0,BlzGetAbilityPosY=lambda raw:0,
            ORIGIN_FRAME_COMMAND_BUTTON='command',BlzGetOriginFrame=lambda k,i:'command'+str(i),
            BlzFrameGetEnable=lambda f:True,BlzFrameClick=click,
            StringCase=lambda s,b:s.lower(),StringLength=len,SubString=lambda s,a,b:s[a:b],
            BlzFrameGetChildrenCount=lambda f:0,BlzFrameGetName=lambda f:f)
        e=execute(HELPER,list(functions(HELPER)),env)
        return e,state,visible,looked,clicked

    def test_closed_stays_closed_and_no_idle_search(self):
        e,s,v,looked,clicks=self.runtime()
        self.assertFalse(e['Forsaken_BackpackVisible']('gear'));self.assertEqual(clicks,[]);self.assertEqual(looked,[])

    def test_first_unbound_closed_inventory_never_scans_contexts_or_clicks(self):
        e,s,v,looked,clicks=self.runtime();e['ForsakenInventoryHero']=None
        for _ in range(50):self.assertFalse(e['Forsaken_BackpackVisible']('gear'))
        self.assertEqual(looked,[]);self.assertEqual(clicks,[])

    def test_bag_only_open_binds_and_opens_both_engine_panels(self):
        e,s,v,looked,clicks=self.runtime();e['ForsakenInventoryHero']=None;v['bag']=True
        self.assertTrue(e['Forsaken_BackpackVisible']('gear'))
        self.assertTrue(v['gear']);self.assertTrue(v['bag']);self.assertIn('SimpleEquipmentInventoryPanel',looked)
        self.assertEqual(s['preview'],s['hero']);self.assertIn('command1',clicks)

    def test_gear_only_open_restores_bag(self):
        e,s,v,looked,clicks=self.runtime();v['gear']=True
        self.assertTrue(e['Forsaken_BackpackVisible']('gear'));self.assertTrue(v['bag'])

    def test_changed_job_refreshes_native_model_and_both_slot_panels(self):
        e,s,v,looked,clicks=self.runtime();v.update(gear=True,bag=True);s['hero']='time mage'
        self.assertTrue(e['Forsaken_BackpackVisible']('gear'))
        self.assertEqual(s['preview'],'time mage');self.assertEqual(e['ForsakenInventoryHero'],'time mage')
        self.assertTrue(v['gear'] and v['bag']);self.assertEqual(clicks[:2],['command1','command1'])

    def test_failed_engine_binding_hides_both_instead_of_exposing_stale_hero(self):
        e,s,v,looked,clicks=self.runtime();v['bag']=True;s.update(hero='time mage',allow=False)
        self.assertFalse(e['Forsaken_BackpackVisible']('gear'));self.assertFalse(v['gear'] or v['bag'])
        self.assertNotEqual(e['ForsakenInventoryHero'],'time mage')

    def test_item_use_drop_idle_keep_pair_without_rebinding_or_canceling_targeting(self):
        e,s,v,looked,clicks=self.runtime();v['bag']=True;e['Forsaken_BackpackVisible']('gear')
        for time in (11.,30.,600.):
            s['now']=time;e['Forsaken_BackpackActivity']();v.update(gear=False,bag=False)
            self.assertTrue(e['Forsaken_BackpackVisible']('gear'));self.assertTrue(v['gear'] and v['bag'])
        self.assertEqual(clicks,[]);self.assertNotIn('ForceUICancel',HELPER)

    def test_explicit_close_and_key_race_hide_both_then_can_reopen(self):
        for key in ('B','escape'):
            e,s,v,looked,clicks=self.runtime();v.update(gear=True,bag=True);e['Forsaken_BackpackVisible']('gear')
            s['key']=key;e['Forsaken_BackpackAccess'](0,s['hero']);v['bag']=True
            self.assertFalse(e['Forsaken_BackpackVisible']('gear'));self.assertFalse(v['gear'] or v['bag'])
            s['now']=11.;self.assertFalse(e['Forsaken_BackpackVisible']('gear'))
            s['key']='B';e['Forsaken_BackpackAccess'](0,s['hero'])
            self.assertTrue(e['Forsaken_BackpackVisible']('gear'));self.assertTrue(v['gear'] and v['bag'])

    def test_other_player_close_is_ignored_and_no_portrait_fallback_button(self):
        e,s,v,looked,clicks=self.runtime();e['ForsakenBackpackWanted']=True;s['player']=1
        e['Forsaken_BackpackCloseAction']();self.assertTrue(e['ForsakenBackpackWanted'])
        e['Forsaken_BackpackControls']('gear','portrait',True)
        self.assertFalse(v['close']);self.assertFalse(v['bagclose'])

    def test_binding_is_presentation_only_and_native_commands_are_limited(self):
        body=functions(HELPER)['Forsaken_BindInventory']
        for forbidden in ['CreateUnit','CreateItem','IssueImmediateOrder','UnitAddAbility','SelectUnit','ForceUIKey']:
            self.assertNotIn(forbidden,HELPER)
        self.assertEqual(set(__import__('re').findall(r"Forsaken_NativeInventoryClick\('(.{4})'\)",body)),{'fGer','fBag'})

    def test_gaya_selection_hides_both_and_hero_selection_restores_open_intent(self):
        e,s,v,looked,clicks=self.runtime();v.update(gear=True,bag=True);e['Forsaken_BackpackVisible']('gear')
        e['ForsakenSelectedTarget']='gaya'
        self.assertFalse(e['Forsaken_InventoryContext']('freelancer',0));self.assertFalse(v['gear'] or v['bag'])
        self.assertTrue(e['ForsakenBackpackWanted'])
        e['ForsakenSelectedTarget']='freelancer'
        self.assertTrue(e['Forsaken_InventoryContext']('freelancer',0))
        self.assertTrue(e['Forsaken_BackpackVisible']('gear'));self.assertTrue(v['gear'] and v['bag'])

    def test_transform_is_idempotent_and_poll_uses_rebound_cached_frames(self):
        source='library TEquip\nglobals\nendglobals\n'+(ROOT/'experiments/Forsaken/Forsaken-panels.j').read_text()+'\nendlibrary'
        result=refresh(source);self.assertEqual(refresh(result),result)
        body=functions(result)['Forsaken_PollPanels']
        self.assertIn('set nativePanel=ForsakenCachedEquipment',body)
        self.assertIn('set anchor=ForsakenCachedBackdrop',body)
        self.assertEqual(refresh('library TBackpack\nendlibrary'),'library TBackpack\nendlibrary')

if __name__=='__main__':unittest.main()
