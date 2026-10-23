"""Only manual input closes an inventory trio that has actually been bound."""
from pathlib import Path
import sys,unittest
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from inventory_ui import refresh,objects
from jtok import functions
from test_armory_materia import execute
from test_shared_context import mocks
ROOT=Path(__file__).resolve().parents[2]
HELPER=(ROOT/'experiments/Forsaken/BackpackVisibility.j').read_text()

class BackpackVisibilityTests(unittest.TestCase):
    def runtime(self):
        s=dict(now=10.,hero='hero',player=0,key='B',down=True,selected=True)
        v={'gear':False,'bag':False,'backdrop':False};clicks=[];looked=[];messages=[]
        env=mocks(HELPER);env.update(
            ForsakenNativeFrame={0:'gear',256:'backdrop',512:'bag'},ForsakenNativeFrameCount={0:1,1:1,2:1},
            ForsakenBackpackCloses=0,ForsakenBackpackRequests=0,ForsakenBackpackMouseEvents=0,ForsakenBackpackKeyEvents=0,
            ForsakenBackpackNativeClicks=0,ForsakenInventoryBinding=False,ForsakenLastToggleTime=-1.,ForsakenLastToggleSource=0,
            ForsakenBackpackKeyHeld=False,ForsakenInventoryBindPhase=0,ForsakenInventoryBindHero=None,ForsakenInventoryBindUntil=0.,
            ForsakenBackpackChatOpen=False,ForsakenBackpackWanted=False,ForsakenBackpackExplicitlyClosed=False,ForsakenBackpackWasVisible=False,
            ForsakenBackpackCloseUntil=0.,ForsakenPanelOpen=False,ForsakenPanelClock='clock',ForsakenTalentsWanted=True,
            ForsakenCachedEquipment=None,ForsakenCachedBackdrop=None,ForsakenLinkedBag=None,ForsakenInventoryHero=None,
            ForsakenTalentToggle='toggle',ForsakenBackpackClose='close',ForsakenLinkedBagClose='bagclose',ForsakenTalentRoot='talents',
            ForsakenInspectTarget=None,ForsakenBackpackCommand='command4',ForsakenBackpackInput=None,ForsakenNextBagSearch=0.,
            InventoryCinematicActive=False,udg_InCinematicMode=False,bj_cineModeAlreadyIn=False,EVENT_GAME_CUSTOM_UI_FRAME='frame',
            BlzGetTriggerFrame=lambda:'command4',
            GetLocalPlayer=lambda:0,GetTriggerPlayer=lambda:s['player'],GetTriggerEventId=lambda:s.get('event','key'),
            GetTriggerUnit=lambda:s['hero'],GetOwningPlayer=lambda u:0,GetSpellAbilityId=lambda:'ASpc',
            Player_GetHero=lambda p:s['hero'],IsUnitSelected=lambda *a:s['selected'],GetUnitAbilityLevel=lambda *a:1,
            BlzGetTriggerPlayerIsKeyDown=lambda:s['down'],BlzGetTriggerPlayerKey=lambda:s['key'],OSKEY_RETURN='enter',OSKEY_B='B',OSKEY_ESCAPE='escape',
            EVENT_PLAYER_UNIT_SELECTED='selected',EVENT_PLAYER_UNIT_DESELECTED='deselected',
            TimerGetElapsed=lambda t:s['now'],BlzFrameIsVisible=lambda f:v.get(f,False),
            BlzFrameSetVisible=lambda f,value:v.__setitem__(f,value),FRAMEPOINT_TOPRIGHT='topright')
        e=execute(HELPER,list(functions(HELPER)),env)
        def poll(now):
            s['now']=now
            return e['Forsaken_BackpackVisible'](None)
        def settle():return poll(s['now']+1.)
        return e,s,v,clicks,looked,messages,poll,settle

    def test_holding_b_toggles_once_until_release_even_after_debounce(self):
        e,s,*_=self.runtime()
        e['Forsaken_BackpackAccess'](0,s['hero'])
        self.assertEqual(e['ForsakenBackpackRequests'],1)
        for now in [10.3,11.,12.]:
            s['now']=now;e['Forsaken_BackpackAccess'](0,s['hero'])
        self.assertEqual(e['ForsakenBackpackRequests'],1)
        self.assertTrue(e['ForsakenBackpackWanted'])
        s['down']=False;e['Forsaken_BackpackAccess'](0,s['hero'])
        s['down']=True;e['Forsaken_BackpackAccess'](0,s['hero'])
        self.assertEqual(e['ForsakenBackpackRequests'],2)
        self.assertFalse(e['ForsakenBackpackWanted'])

    def test_input_does_not_manufacture_open_before_native_activation(self):
        e,s,v,_,_,_,poll,_=self.runtime()
        e['Forsaken_BackpackAccess'](0,s['hero'])
        for now in [10.1,10.2,10.6]:self.assertFalse(poll(now))
        self.assertFalse(v['gear'] or v['bag'] or v['backdrop'])
        v.update(gear=True,bag=True,backdrop=True)
        self.assertTrue(poll(10.7));self.assertTrue(e['ForsakenBackpackWanted'])

    def test_native_cast_tracks_mouse_close_without_replacing_command_handler(self):
        e,s,v,_,_,_,poll,_=self.runtime()
        for now,opened in [(10.,True),(11.,False),(12.,True),(13.,False)]:
            s['now']=now;e['Forsaken_BackpackToggleAction']()
            v.update(gear=opened,bag=opened,backdrop=opened)
            self.assertEqual(poll(now+.3),opened)
        self.assertEqual(e['ForsakenBackpackRequests'],4)

    def test_native_close_never_restores_static_cached_frames(self):
        e,s,v,_,_,_,poll,_=self.runtime()
        v.update(gear=True,bag=True,backdrop=True);self.assertTrue(poll(10.))
        for now in [11.,12.,60.]:
            v.update(gear=False,bag=False,backdrop=False)
            e['Forsaken_BackpackActivity']()
            self.assertFalse(poll(now))
            self.assertFalse(v['gear'] or v['bag'] or v['backdrop'])
        s['now']=61.;e['Forsaken_RequestBackpackToggle'](1)
        v.update(gear=False,bag=False,backdrop=False)
        self.assertFalse(poll(61.3))

    def test_real_native_view_is_selected_instead_of_hidden_cached_copy(self):
        e,s,v,_,_,_,poll,_=self.runtime()
        e['ForsakenNativeFrame'].update({1:'livegear',257:'livebackdrop',513:'livebag'})
        e['ForsakenNativeFrameCount'].update({0:2,1:2,2:2})
        e['ForsakenCachedEquipment']='gear';e['ForsakenCachedBackdrop']='backdrop';e['ForsakenLinkedBag']='bag'
        v.update(livegear=True,livebackdrop=True,livebag=True)
        self.assertTrue(poll(10.1))
        self.assertEqual(e['ForsakenCachedEquipment'],'livegear')
        self.assertEqual(e['ForsakenLinkedBag'],'livebag')
        self.assertFalse(v['gear'] or v['bag'] or v['backdrop'])

    def test_missing_parent_or_pane_never_exposes_custom_controls(self):
        for missing in ['gear','bag','backdrop']:
            e,s,v,_,_,_,poll,_=self.runtime();v.update(gear=True,bag=True,backdrop=True);v[missing]=False
            visible=poll(10.1);self.assertFalse(visible)
            e['Forsaken_BackpackControls'](None,None,visible)
            self.assertFalse(v['close'])

    def test_slot_updates_do_not_touch_native_drag_or_cooldown_visibility(self):
        e,s,v,_,_,_,poll,_=self.runtime();v.update(gear=True,bag=True,backdrop=True)
        writes=[];e['BlzFrameSetVisible']=lambda *a:writes.append(a)
        for now in [10.1,10.2,10.3,11.]:
            e['Forsaken_BackpackActivity']();self.assertTrue(poll(now))
        self.assertEqual(writes,[])

    def test_close_stays_closed_without_timer_or_item_event_reopening(self):
        e,s,v,_,_,_,poll,_=self.runtime();v.update(gear=True,bag=True,backdrop=True);poll(10.1)
        v['toggle']=True;e['Forsaken_CloseBackpack']()
        self.assertFalse(v['toggle'])
        for now in [10.2,11.,60.]:
            e['Forsaken_BackpackActivity']();self.assertFalse(poll(now))
        self.assertTrue(e['ForsakenTalentsWanted'])
        s['now']=60.5;e['Forsaken_RequestBackpackToggle'](2)
        v.update(gear=True,bag=True,backdrop=True) # subsequent real native opening
        self.assertTrue(poll(61.))

    def test_key_and_mouse_notifications_do_not_double_toggle_engine(self):
        e,s,v,_,_,_,poll,_=self.runtime()
        e['Forsaken_BackpackAccess'](0,s['hero'])
        s['now']=10.12;s['down']=False;e['Forsaken_BackpackAccess'](0,s['hero'])
        e['Forsaken_BackpackToggleAction']()
        self.assertEqual(e['ForsakenBackpackRequests'],1)
        self.assertFalse(poll(10.2))
        v.update(gear=True,bag=True,backdrop=True);self.assertTrue(poll(10.3))

    def test_x_closes_native_controller_once_without_latching_or_double_toggle(self):
        e,s,v,clicks,_,_,poll,_=self.runtime()
        v.update(gear=True,bag=True,backdrop=True,command4=True);poll(10.)
        e['BlzFrameGetEnable']=lambda f:True
        engine={'open':True}
        def native_key(key):
            self.assertEqual(key,'B');clicks.append(key)
            self.assertTrue(v['gear']) # Native controller receives input before hiding panes.
            e['Forsaken_BackpackAccess'](0,s['hero'])
            e['Forsaken_BackpackToggleAction']()
            engine['open']=not engine['open']
            v.update(gear=engine['open'],bag=engine['open'],backdrop=engine['open'])
        e['ForceUIKey']=native_key
        e['Forsaken_BackpackCloseAction']()
        self.assertEqual(clicks,['B']);self.assertFalse(engine['open'])
        self.assertFalse(e['ForsakenBackpackKeyHeld']);self.assertFalse(e['ForsakenBackpackWanted'])
        self.assertEqual(e['ForsakenBackpackRequests'],0)
        for now in [10.1,11.,60.]:
            if engine['open']:v.update(gear=True,bag=True,backdrop=True)
            self.assertFalse(poll(now))
        s['now']=61.;e['Forsaken_BackpackAccess'](0,s['hero'])
        self.assertTrue(e['ForsakenBackpackWanted'])

    def test_x_never_forwards_hotkey_for_another_player_or_changed_selection(self):
        for case in ['other','selection','chat','disabled','hidden']:
            e,s,v,clicks,_,_,poll,_=self.runtime()
            v.update(gear=True,bag=True,backdrop=True,command4=True);poll(10.)
            e['ForceUIKey']=lambda key:clicks.append(key)
            e['BlzFrameGetEnable']=lambda f:case!='disabled'
            if case=='other':s['player']=1
            if case=='selection':s['selected']=False
            if case=='chat':e['ForsakenBackpackChatOpen']=True
            if case=='hidden':v['command4']=False
            e['Forsaken_BackpackCloseAction']();self.assertEqual(clicks,[],case)
            if case=='other':self.assertTrue(e['ForsakenBackpackWanted'])

    def test_x_delayed_native_key_echo_never_latches_or_reopens(self):
        e,s,v,clicks,_,_,poll,_=self.runtime()
        v.update(gear=True,bag=True,backdrop=True,command4=True);poll(10.)
        e['BlzFrameGetEnable']=lambda f:True
        e['ForceUIKey']=lambda key:clicks.append(key)
        e['Forsaken_BackpackCloseAction']();self.assertEqual(clicks,['B'])
        s['now']+=.05;e['Forsaken_BackpackAccess'](0,s['hero'])
        e['Forsaken_BackpackToggleAction']()
        self.assertFalse(e['ForsakenBackpackKeyHeld']);self.assertFalse(e['ForsakenBackpackWanted'])
        self.assertEqual(e['ForsakenBackpackRequests'],0)
        s['now']+=1.;e['Forsaken_BackpackAccess'](0,s['hero'])
        self.assertTrue(e['ForsakenBackpackWanted'])

    def test_chat_letters_and_chat_cancel_do_not_close_the_bag(self):
        e,s,v,_,_,_,poll,_=self.runtime();v.update(gear=True,bag=True,backdrop=True);poll(10.)
        s['key']='enter';e['Forsaken_BackpackAccess'](0,s['hero'])
        s['key']='B';e['Forsaken_BackpackAccess'](0,s['hero'])
        self.assertEqual(e['ForsakenBackpackRequests'],0);self.assertTrue(e['ForsakenBackpackWanted'])
        s['key']='escape';e['Forsaken_BackpackAccess'](0,s['hero'])
        self.assertTrue(e['ForsakenBackpackWanted']);self.assertTrue(poll(11.))
        e['Forsaken_BackpackAccess'](0,s['hero']);self.assertFalse(poll(12.))

    def test_first_open_after_a_new_hero_does_not_toggle_stale_intent_off(self):
        e,s,v,_,_,_,poll,_=self.runtime();v.update(gear=True,bag=True,backdrop=True);poll(10.)
        s['hero']='newhero';v.update(gear=False,bag=False,backdrop=False)
        self.assertFalse(poll(11.));self.assertFalse(e['ForsakenBackpackWanted'])
        e['Forsaken_RequestBackpackToggle'](1);self.assertTrue(e['ForsakenBackpackWanted'])
        v.update(gear=True,bag=True,backdrop=True);self.assertTrue(poll(12.))

    def test_rapid_key_and_mouse_toggles_only_follow_the_live_native_view(self):
        for method in ['B','mouse']:
            e,s,v,_,_,_,poll,_=self.runtime()
            for i in range(20):
                s['now']=10.+i*.1
                if method=='B':
                    s['down']=True;e['Forsaken_BackpackAccess'](0,s['hero'])
                    s['down']=False;e['Forsaken_BackpackAccess'](0,s['hero'])
                else:
                    s['event']='frame';e['Forsaken_BackpackToggleAction']()
                opened=i%2==0
                v.update(gear=opened,bag=opened,backdrop=opened)
                self.assertEqual(poll(s['now']+.01),opened,(method,i))
                self.assertEqual(v['gear'],opened);self.assertEqual(v['bag'],opened)
            self.assertFalse(poll(60.))

    def test_one_escape_hides_all_contexts_including_incomplete_old_views(self):
        e,s,v,_,_,_,poll,_=self.runtime();v.update(gear=True,bag=True,backdrop=True);poll(10.)
        e['ForsakenNativeFrame'].update({1:'oldgear',257:'oldbackdrop',513:'oldbag'})
        e['ForsakenNativeFrameCount'].update({0:2,1:2,2:2})
        v.update(oldgear=True,oldbackdrop=True,oldbag=False)
        s['key']='escape';e['Forsaken_BackpackAccess'](0,s['hero'])
        self.assertFalse(any(v.get(f,False) for f in ['gear','bag','backdrop','oldgear','oldbag','oldbackdrop']))
        self.assertFalse(poll(60.))

    def test_cutscene_hides_inventory_and_never_restores_cached_frames(self):
        e,s,v,_,_,_,poll,_=self.runtime();v.update(gear=True,bag=True,backdrop=True);poll(10.)
        for flag in ['InventoryCinematicActive']:
            e[flag]=True;self.assertFalse(poll(11.))
            e['Forsaken_RequestBackpackToggle'](1);self.assertFalse(v['gear'] or v['bag'])
            e[flag]=False;self.assertFalse(poll(12.))
        body=functions(HELPER)['Forsaken_BackpackVisible']
        self.assertNotIn('BlzFrameSetVisible',body)
        self.assertNotIn('ForceUIKey',body)

    def test_transform_is_idempotent_and_polls_before_cached_panel_guard(self):
        source='library TEquip\nglobals\nendglobals\n'+(ROOT/'experiments/Forsaken/Forsaken-panels.j').read_text()+'\nendlibrary'
        source=source.replace('visible or ForsakenInspectTarget!=null)','visible or ForsakenInspectTarget!=null or (nativePanel==null and hero!=null and IsUnitSelected(hero,viewer)))')
        result=refresh(source);self.assertEqual(refresh(result),result)
        body=functions(result)['Forsaken_PollPanels']
        self.assertEqual(body.count('Forsaken_BackpackVisible(nativePanel)'),1)
        self.assertNotIn('nativePanel==null and hero!=null',body)
        self.assertLess(body.index('Forsaken_BackpackVisible(nativePanel)'),body.index('if nativePanel!=null'))
        for modifier in range(16):self.assertIn(f'OSKEY_B,{modifier},false)',functions(result)['Register_Forsaken_PanelAccess'])

if __name__=='__main__':unittest.main()
