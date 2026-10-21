"""Native inventory is authoritative; custom controls cannot create another view."""
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
            ForsakenBackpackWanted=False,ForsakenBackpackExplicitlyClosed=False,ForsakenBackpackWasVisible=False,
            ForsakenBackpackCloseUntil=0.,ForsakenPanelOpen=False,ForsakenPanelClock='clock',ForsakenTalentsWanted=True,
            ForsakenCachedEquipment=None,ForsakenCachedBackdrop=None,ForsakenLinkedBag=None,ForsakenInventoryHero=None,
            ForsakenTalentToggle='toggle',ForsakenBackpackClose='close',ForsakenLinkedBagClose='bagclose',ForsakenTalentRoot='talents',
            ForsakenInspectTarget=None,ForsakenBackpackCommand='command4',ForsakenBackpackInput=None,ForsakenNextBagSearch=0.,
            GetLocalPlayer=lambda:0,GetTriggerPlayer=lambda:s['player'],GetTriggerEventId=lambda:'key',
            Player_GetHero=lambda p:s['hero'],IsUnitSelected=lambda *a:s['selected'],GetUnitAbilityLevel=lambda *a:1,
            BlzGetTriggerPlayerIsKeyDown=lambda:s['down'],BlzGetTriggerPlayerKey=lambda:s['key'],OSKEY_B='B',OSKEY_ESCAPE='escape',
            EVENT_PLAYER_UNIT_SELECTED='selected',EVENT_PLAYER_UNIT_DESELECTED='deselected',
            TimerGetElapsed=lambda t:s['now'],BlzFrameIsVisible=lambda f:v.get(f,False),
            BlzFrameSetVisible=lambda f,value:v.__setitem__(f,value),FRAMEPOINT_TOPRIGHT='topright')
        e=execute(HELPER,list(functions(HELPER)),env)
        def poll(now):
            s['now']=now
            return e['Forsaken_BackpackVisible'](None)
        def settle():return poll(s['now']+1.)
        return e,s,v,clicks,looked,messages,poll,settle

    def test_input_does_not_manufacture_open_before_native_activation(self):
        e,s,v,_,_,_,poll,_=self.runtime()
        e['Forsaken_BackpackAccess'](0,s['hero'])
        for now in [10.1,10.2,10.6]:self.assertFalse(poll(now))
        self.assertFalse(v['gear'] or v['bag'] or v['backdrop'])
        v.update(gear=True,bag=True,backdrop=True)
        self.assertTrue(poll(10.7));self.assertTrue(e['ForsakenBackpackWanted'])

    def test_mouse_works_even_when_native_button_does_not_forward_click_event(self):
        e,s,v,_,_,_,poll,_=self.runtime()
        # Actual client reports mouse=0. Native visibility must still be followed.
        for opened in [True,False,True,False]:
            v.update(gear=opened,bag=opened,backdrop=opened)
            self.assertEqual(poll(s['now']+.1),opened)
        self.assertEqual(e['ForsakenBackpackRequests'],0)

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
