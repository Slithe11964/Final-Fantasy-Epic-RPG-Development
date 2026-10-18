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
        state=dict(frame='command4',now=10.,hero='freelancer',key='',player=0,preview='freelancer',allow=True,down=True,selected=True)
        visible={'gear':False,'bag':False,'command0':True,'command1':True,'command4':True}
        looked=[];clicked=[]
        def click(button):
            clicked.append(button)
            if state['allow'] and button=='command4':
                opening=not (visible['gear'] or visible['bag'])
                visible.update(gear=opening,bag=opening)
                if opening:state['preview']=state['hero']
            elif state['allow']:
                pane='gear' if button=='command1' else 'bag'
                visible[pane]=not visible[pane]
                if pane=='gear' and visible[pane]:state['preview']=state['hero']
        def lookup(name):
            looked.append(name)
            return {'SimpleEquipmentPanel':'gear','EquipmentPanelBackdrop':'backdrop','SimpleEquipmentInventoryPanel':'bag'}.get(name)
        env=mocks(HELPER);env.update(
            ForsakenInventoryBinding=False,ForsakenLastToggleTime=-1.,ForsakenLastToggleSource=0,
            ForsakenBackpackKeyHeld=False,ForsakenInventoryBindPhase=0,ForsakenInventoryBindHero=None,ForsakenInventoryBindUntil=0.,
            ForsakenBackpackCommand='command4',ForsakenGearCommand=None,
            GetUnitAbilityLevel=lambda *a:1,BlzGetTriggerFrame=lambda:state['frame'],
            ForsakenBackpackWanted=False,ForsakenBackpackWasVisible=False,ForsakenBackpackCloseUntil=0.,
            ForsakenTalentsWanted=True,ForsakenPanelOpen=False,ForsakenPanelClock='clock',ForsakenCachedEquipment='gear',ForsakenCachedBackdrop='backdrop',
            ForsakenLinkedBag='bag',ForsakenInventoryHero='freelancer',ForsakenNextBagSearch=0.,
            ForsakenBackpackClose='close',ForsakenLinkedBagClose='bagclose',ForsakenTalentRoot='talents',
            ForsakenSelectedTarget='freelancer',ForsakenFrameSearchRequested=False,ForsakenBackpackNativeClose=None,ForsakenBagNativeClose=None,
            ForsakenBackpackHookRoot=None,ForsakenBagHookRoot=None,ForsakenBackpackScanBudget=0,
            GetLocalPlayer=lambda:0,GetTriggerPlayer=lambda:state['player'],GetTriggerEventId=lambda:'key',
            Player_GetHero=lambda p:state['hero'],IsUnitSelected=lambda *a:state['selected'],GetTriggerUnit=lambda:state['hero'],GetOwningPlayer=lambda u:0,
            BlzGetTriggerPlayerIsKeyDown=lambda:state['down'],
            BlzGetTriggerPlayerKey=lambda:state['key'],OSKEY_B='B',OSKEY_ESCAPE='escape',
            EVENT_PLAYER_UNIT_SELECTED='selected',EVENT_PLAYER_UNIT_DESELECTED='deselected',
            TimerGetElapsed=lambda t:state['now'],BlzFrameIsVisible=lambda f:visible.get(f,False),
            BlzFrameSetVisible=lambda f,v:visible.__setitem__(f,v),Forsaken_FindFrameUncached=lookup,
            BlzGetAbilityPosX=lambda raw:0,BlzGetAbilityPosY=lambda raw:1 if raw=='ASpc' else 0,
            ORIGIN_FRAME_COMMAND_BUTTON='command',BlzGetOriginFrame=lambda k,i:'command'+str(i),
            BlzFrameGetEnable=lambda f:True,BlzFrameClick=click,
            StringCase=lambda s,b:s.lower(),StringLength=len,SubString=lambda s,a,b:s[a:b],
            BlzFrameGetChildrenCount=lambda f:0,BlzFrameGetName=lambda f:f,FRAMEPOINT_TOPRIGHT='topright')
        e=execute(HELPER,list(functions(HELPER)),env)
        return e,state,visible,looked,clicked

    def test_native_button_toggles_both_and_ignores_automatic_rebind_clicks(self):
        e,s,v,looked,clicks=self.runtime()
        e['Forsaken_BackpackToggleAction']();self.assertTrue(e['ForsakenBackpackWanted'])
        e['Forsaken_BackpackVisible']('gear');self.assertTrue(v['gear'] and v['bag'])
        s['now']+=1;e['Forsaken_BackpackToggleAction']()
        self.assertFalse(e['ForsakenBackpackWanted']);self.assertFalse(v['gear'] or v['bag'])
        e['ForsakenInventoryBinding']=True;e['Forsaken_BackpackToggleAction']()
        self.assertFalse(e['ForsakenBackpackWanted'])

    def test_keyboard_and_frame_duplicate_do_not_reverse_one_click(self):
        for order in [(1,2),(2,1)]:
            e,s,v,_,_=self.runtime()
            for origin in order:e['Forsaken_RequestBackpackToggle'](origin)
            self.assertTrue(e['ForsakenBackpackWanted'])
            s['now']+=1
            for origin in order:e['Forsaken_RequestBackpackToggle'](origin)
            self.assertFalse(e['ForsakenBackpackWanted'])

    def test_explicit_close_wins_over_late_native_reopen_and_duplicate_frames(self):
        e,state,v,_,_=self.runtime()
        e['ForsakenBackpackWanted']=True;e['Forsaken_CloseBackpack']()
        for now in [10.01,11.,60.,600.]:
            state['now']=now;v.update(gear=True,bag=True)
            self.assertFalse(e['Forsaken_BackpackVisible']('gear'))
            self.assertFalse(v['gear'] or v['bag']);self.assertFalse(e['ForsakenBackpackWanted'])
        e['Forsaken_RequestBackpackToggle'](2);e['Forsaken_RequestBackpackToggle'](2)
        self.assertTrue(e['ForsakenBackpackWanted'])

    def test_closed_stays_closed_and_no_idle_search(self):
        e,s,v,looked,clicks=self.runtime()
        self.assertFalse(e['Forsaken_BackpackVisible']('gear'));self.assertEqual(clicks,[]);self.assertEqual(looked,[])

    def test_first_unbound_closed_inventory_never_scans_contexts_or_clicks(self):
        e,s,v,looked,clicks=self.runtime();e['ForsakenInventoryHero']=None
        for _ in range(50):self.assertFalse(e['Forsaken_BackpackVisible']('gear'))
        self.assertEqual(looked,[]);self.assertEqual(clicks,[])

    def test_bag_only_open_binds_and_opens_both_engine_panels(self):
        e,s,v,looked,clicks=self.runtime();e['ForsakenBackpackWanted']=True;e['ForsakenInventoryHero']=None;v['bag']=True
        self.assertTrue(e['Forsaken_BackpackVisible']('gear'))
        self.assertTrue(v['gear']);self.assertTrue(v['bag']);self.assertIn('SimpleEquipmentInventoryPanel',looked)
        self.assertEqual(s['preview'],s['hero']);self.assertEqual(clicks,[])

    def test_gear_only_open_restores_bag(self):
        e,s,v,looked,clicks=self.runtime();e['ForsakenBackpackWanted']=True;v['gear']=True
        self.assertTrue(e['Forsaken_BackpackVisible']('gear'));self.assertTrue(v['bag'])

    def test_changed_job_refreshes_native_model_and_both_slot_panels(self):
        e,s,v,looked,clicks=self.runtime();e['ForsakenBackpackWanted']=True;v.update(gear=True,bag=True);s['hero']='time mage'
        self.assertFalse(e['Forsaken_BackpackVisible']('gear'))
        s['now']+=.2;self.assertFalse(e['Forsaken_BackpackVisible']('gear'))
        s['now']+=.2
        self.assertTrue(e['Forsaken_BackpackVisible']('gear'))
        self.assertEqual(s['preview'],'time mage');self.assertEqual(e['ForsakenInventoryHero'],'time mage')
        self.assertTrue(v['gear'] and v['bag']);self.assertEqual(clicks[:2],['command4','command4'])

    def test_failed_engine_binding_hides_both_instead_of_exposing_stale_hero(self):
        e,s,v,looked,clicks=self.runtime();e['ForsakenBackpackWanted']=True;v['bag']=True;s.update(hero='time mage',allow=False)
        self.assertFalse(e['Forsaken_BackpackVisible']('gear'));self.assertFalse(v['gear'] or v['bag'])
        self.assertNotEqual(e['ForsakenInventoryHero'],'time mage')

    def test_item_use_drop_idle_keep_pair_without_rebinding_or_canceling_targeting(self):
        e,s,v,looked,clicks=self.runtime();e['ForsakenBackpackWanted']=True;v['bag']=True;e['Forsaken_BackpackVisible']('gear')
        for time in (11.,30.,600.):
            s['now']=time;e['Forsaken_BackpackActivity']();v.update(gear=False,bag=False)
            self.assertTrue(e['Forsaken_BackpackVisible']('gear'));self.assertTrue(v['gear'] and v['bag'])
        self.assertEqual(clicks,[]);self.assertNotIn('ForceUICancel',HELPER)

    def test_explicit_close_and_key_race_hide_both_then_can_reopen(self):
        for key in ('B','escape'):
            e,s,v,looked,clicks=self.runtime();e['ForsakenBackpackWanted']=True;v.update(gear=True,bag=True);e['Forsaken_BackpackVisible']('gear')
            s['key']=key;e['Forsaken_BackpackAccess'](0,s['hero']);v['bag']=True
            self.assertFalse(e['Forsaken_BackpackVisible']('gear'));self.assertFalse(v['gear'] or v['bag'])
            s['now']=11.;self.assertFalse(e['Forsaken_BackpackVisible']('gear'))
            s['down']=False;e['Forsaken_BackpackAccess'](0,s['hero']);s['down']=True
            s['key']='B';e['Forsaken_BackpackAccess'](0,s['hero'])
            self.assertTrue(e['Forsaken_BackpackVisible']('gear'));self.assertTrue(v['gear'] and v['bag'])

    def test_other_player_close_is_ignored_and_new_x_is_in_gear_header(self):
        e,s,v,looked,clicks=self.runtime();e['ForsakenBackpackWanted']=True;s['player']=1
        e['Forsaken_BackpackCloseAction']();self.assertTrue(e['ForsakenBackpackWanted'])
        e['Forsaken_BackpackControls']('gear','backdrop',True)
        self.assertTrue(v['close']);self.assertFalse(v['bagclose'])
        e['Forsaken_CloseBackpack']();self.assertTrue(e['ForsakenTalentsWanted']);self.assertFalse(v['close'])

    def test_armory_refresh_rebinds_only_the_open_owning_inventory(self):
        e,s,v,looked,clicks=self.runtime()
        e['Forsaken_RequestInventoryRefresh']('freelancer');self.assertEqual(e['ForsakenInventoryHero'],'freelancer')
        e['ForsakenBackpackWanted']=True;e['Forsaken_RequestInventoryRefresh']('other');self.assertEqual(e['ForsakenInventoryHero'],'freelancer')
        e['Forsaken_RequestInventoryRefresh']('freelancer');self.assertIsNone(e['ForsakenInventoryHero'])
        self.assertTrue(e['ForsakenFrameSearchRequested']);self.assertFalse(e['Forsaken_BackpackVisible']('gear'))
        s['now']+=.2;self.assertTrue(e['Forsaken_BackpackVisible']('gear'))
        self.assertTrue(v['gear'] and v['bag'])

    def test_binding_is_presentation_only_and_native_commands_are_limited(self):
        body=functions(HELPER)['Forsaken_BindInventory']
        for forbidden in ['CreateUnit','CreateItem','IssueImmediateOrder','UnitAddAbility','SelectUnit','ForceUIKey']:
            self.assertNotIn(forbidden,HELPER)
        self.assertEqual(set(__import__('re').findall(r"Forsaken_NativeInventoryClick\('(.{4})'\)",body)),{'ASpc'})

    def test_gaya_selection_hides_both_and_hero_selection_restores_open_intent(self):
        e,s,v,looked,clicks=self.runtime();e['ForsakenBackpackWanted']=True;v.update(gear=True,bag=True);e['Forsaken_BackpackVisible']('gear')
        e['ForsakenSelectedTarget']='gaya'
        s['selected']=False
        self.assertFalse(e['Forsaken_InventoryContext']('freelancer',0));self.assertFalse(v['gear'] or v['bag'])
        self.assertTrue(e['ForsakenBackpackWanted'])
        e['ForsakenSelectedTarget']='freelancer'
        s['selected']=True
        self.assertTrue(e['Forsaken_InventoryContext']('freelancer',0))
        self.assertTrue(e['Forsaken_BackpackVisible']('gear'));self.assertTrue(v['gear'] and v['bag'])

    def test_transform_is_idempotent_and_poll_uses_rebound_cached_frames(self):
        source='library TEquip\nglobals\nendglobals\n'+(ROOT/'experiments/Forsaken/Forsaken-panels.j').read_text()+'\nendlibrary'
        result=refresh(source);self.assertEqual(refresh(result),result)
        body=functions(result)['Forsaken_PollPanels']
        self.assertIn('set nativePanel=ForsakenCachedEquipment',body)
        self.assertIn('set anchor=ForsakenCachedBackdrop',body)
        self.assertEqual(refresh('library TBackpack\nendlibrary'),'library TBackpack\nendlibrary')

    def test_held_b_is_one_toggle_until_release_including_focus_modifier_release(self):
        e,s,v,_,clicks=self.runtime();s['key']='B'
        for now in [10.,10.2,10.5,11.,20.]:
            s['now']=now;e['Forsaken_BackpackAccess'](0,s['hero'])
            self.assertTrue(e['ForsakenBackpackWanted'])
        s['down']=False;e['Forsaken_BackpackAccess'](0,s['hero'])
        s.update(now=21.,down=True);e['Forsaken_BackpackAccess'](0,s['hero'])
        self.assertFalse(e['ForsakenBackpackWanted']);self.assertEqual(clicks,[])
        source='library TEquip\nglobals\nendglobals\n'+(ROOT/'experiments/Forsaken/Forsaken-panels.j').read_text()+'\nendlibrary'
        register=functions(refresh(source))['Register_Forsaken_PanelAccess']
        for modifier in range(16):self.assertIn(f'OSKEY_B,{modifier},false)',register)

    def test_native_mouse_hook_does_not_receive_hotkeys_or_scripted_control_clicks(self):
        register=functions(HELPER)['Forsaken_RegisterBackpackActivity']
        line=next(x for x in register.splitlines() if 'BlzTriggerRegisterFrameEvent(ForsakenBackpackToggleEvents' in x)
        self.assertIn('FRAMEEVENT_MOUSE_UP',line)
        self.assertNotIn('FRAMEEVENT_CONTROL_CLICK',line)

    def test_real_user_open_is_adopted_without_clicking_it_closed(self):
        e,s,v,_,clicks=self.runtime();e['ForsakenInventoryHero']=None
        e['Forsaken_RequestBackpackToggle'](2);v.update(gear=True,bag=True)
        self.assertTrue(e['Forsaken_BackpackVisible']('gear'))
        self.assertEqual(clicks,[]);self.assertEqual(e['ForsakenInventoryHero'],s['hero'])

    def test_delayed_native_commands_rebind_once_and_do_not_form_a_polling_click_loop(self):
        e,s,v,_,clicks=self.runtime();pending=[];native={'open':True}
        def deferred(control):
            clicks.append(control);pending.append(s['now']+.08)
        def poll(now):
            s['now']=now
            while pending and pending[0]<=now:
                pending.pop(0);native['open']=not native['open']
                v.update(gear=native['open'],bag=native['open'])
                if native['open']:s['preview']=s['hero']
            return e['Forsaken_BackpackVisible']('gear')
        e['BlzFrameClick']=deferred;e['ForsakenBackpackWanted']=True
        v.update(gear=True,bag=True);s['hero']='time mage'
        self.assertFalse(poll(10.));self.assertEqual(len(clicks),1)
        self.assertFalse(poll(10.1));self.assertEqual(len(clicks),1)
        self.assertFalse(poll(10.2));self.assertEqual(len(clicks),2)
        poll(10.3);self.assertTrue(poll(10.4))
        for now in [11.,20.,100.,600.]:self.assertTrue(poll(now))
        self.assertEqual(len(clicks),2);self.assertEqual(s['preview'],'time mage')
        self.assertEqual(e['ForsakenInventoryHero'],'time mage')

    def test_unavailable_native_binding_stops_clicking_and_explicit_close_cancels_it(self):
        e,s,v,_,clicks=self.runtime();e['ForsakenBackpackWanted']=True;s.update(hero='time mage',allow=False)
        for now in [10.,10.2,10.4,11.3,20.,600.]:
            s['now']=now;self.assertFalse(e['Forsaken_BackpackVisible']('gear'))
        self.assertEqual(len(clicks),1);self.assertEqual(e['ForsakenInventoryBindPhase'],3)
        e['Forsaken_CloseBackpack']();v.update(gear=True,bag=True)
        self.assertFalse(e['Forsaken_BackpackVisible']('gear'));self.assertFalse(v['gear'] or v['bag'])
        self.assertEqual(e['ForsakenInventoryBindPhase'],0)

    def test_actual_selection_wins_over_stale_selection_event_cache(self):
        e,s,v,_,_=self.runtime();e['ForsakenSelectedTarget']='gaya'
        self.assertTrue(e['Forsaken_InventoryContext'](s['hero'],0))

if __name__=='__main__':unittest.main()
