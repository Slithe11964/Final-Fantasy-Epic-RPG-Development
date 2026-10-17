"""Persistent native inventory intent and explicit close controls; no gameplay writes."""
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
        env=mocks(HELPER);now=[10.];shown=[];selected=[True];owner=[0]
        control=dict(visible=False,key='',event='key',player=0)
        def show(frame,visible):
            shown.append((frame,visible))
            if frame=='backpack':control['visible']=visible
        env.update(GetTriggerUnit=lambda:'hero',GetOwningPlayer=lambda u:owner[0],
            GetLocalPlayer=lambda:0,GetTriggerPlayer=lambda:control['player'],Player_GetHero=lambda p:'hero',
            IsUnitSelected=lambda *a:selected[0],GetTriggerEventId=lambda:control['event'],
            BlzGetTriggerPlayerKey=lambda:control['key'],OSKEY_ESCAPE='escape',OSKEY_B='backpack',
            EVENT_PLAYER_UNIT_SELECTED='selected',EVENT_PLAYER_UNIT_DESELECTED='deselected',
            ForsakenBackpackWasVisible=False,ForsakenBackpackWanted=False,ForsakenBackpackCloseUntil=0.,
            ForsakenPanelClock='clock',ForsakenCachedEquipment='backpack',ForsakenBackpackClose='close',
            ForsakenTalentRoot='talents',ForsakenPanelOpen=False,ForsakenFrameSearchRequested=False,
            ForsakenBackpackEvents=None,ForsakenBackpackCloseEvents=None,
            ForsakenBackpackHookRoot=None,ForsakenBackpackNativeClose=None,ForsakenBackpackScanBudget=0,
            ForsakenLinkedBag=None,ForsakenLinkedBagClose=None,ForsakenBagNativeClose=None,
            ForsakenBagHookRoot=None,ForsakenBagSearchBudget=0,ForsakenNextBagSearch=0.,
            BlzGetOriginFrame=lambda *a:None,
            TimerGetElapsed=lambda t:now[0],BlzFrameIsVisible=lambda f:control['visible'],
            BlzFrameSetVisible=show,StringLength=lambda s:len(s or ''),StringCase=lambda s,b:(s or '').upper() if b else (s or '').lower(),
            SubString=lambda s,a,b:s[a:b],BlzFrameGetChildrenCount=lambda f:0,BlzFrameGetName=lambda f:f)
        for constant in ('EVENT_PLAYER_UNIT_DROP_ITEM','EVENT_PLAYER_UNIT_USE_ITEM','EVENT_PLAYER_UNIT_UNEQUIP_ITEM',
                         'FRAMEEVENT_CONTROL_CLICK','ORIGIN_FRAME_GAME_UI','FRAMEPOINT_TOPRIGHT'):
            env[constant]=constant
        e=execute(HELPER,list(functions(HELPER)),env)
        return e,now,shown,selected,owner,control

    def test_fresh_closed_backpack_stays_closed(self):
        e,now,shown,selected,owner,c=self.runtime()
        self.assertFalse(e['Forsaken_BackpackVisible']('backpack'))
        e['Forsaken_BackpackActivity']()
        self.assertFalse(e['ForsakenBackpackWanted']);self.assertEqual(shown,[])
        self.assertFalse(e['Forsaken_BackpackVisible'](None))

    def test_mouse_open_survives_idle_refresh_well_beyond_one_second(self):
        e,now,shown,selected,owner,c=self.runtime();c['visible']=True
        self.assertTrue(e['Forsaken_BackpackVisible']('backpack'))
        for time in (10.1,11.,20.,120.,600.):
            now[0]=time;c['visible']=False
            self.assertTrue(e['Forsaken_BackpackVisible']('backpack'))
        self.assertEqual(shown,[('backpack',True)]*5)

    def test_drop_use_and_unequip_do_not_expire_open_intent(self):
        e,now,shown,selected,owner,c=self.runtime();c['visible']=True
        e['Forsaken_BackpackVisible']('backpack')
        for time in (10.,20.,100.):
            now[0]=time;e['Forsaken_BackpackActivity']();c['visible']=False
            self.assertTrue(e['Forsaken_BackpackVisible']('backpack'))
        self.assertTrue(e['ForsakenFrameSearchRequested'])

    def test_explicit_close_suppresses_native_key_toggle_race_and_stays_closed(self):
        for key in ('escape','backpack'):
            e,now,shown,selected,owner,c=self.runtime();c['visible']=True
            e['Forsaken_BackpackVisible']('backpack');c['key']=key
            e['Forsaken_BackpackAccess'](0,'hero')
            self.assertFalse(e['ForsakenBackpackWanted'])
            c['visible']=True;now[0]=10.1
            self.assertFalse(e['Forsaken_BackpackVisible']('backpack'))
            now[0]=20.
            self.assertFalse(e['Forsaken_BackpackVisible']('backpack'))
            e['Forsaken_BackpackActivity']()
            self.assertFalse(e['ForsakenBackpackWanted'])

    def test_hotkey_opens_before_native_panel_appears_and_can_reopen_immediately(self):
        e,now,shown,selected,owner,c=self.runtime();c['key']='backpack'
        e['Forsaken_BackpackAccess'](0,'hero')
        self.assertTrue(e['Forsaken_BackpackVisible']('backpack'))
        e['Forsaken_BackpackAccess'](0,'hero');e['Forsaken_BackpackAccess'](0,'hero')
        self.assertTrue(e['Forsaken_BackpackVisible']('backpack'))

    def test_hotkey_open_is_safe_if_native_toggle_runs_before_script_event(self):
        e,now,shown,selected,owner,c=self.runtime();c['key']='backpack';c['visible']=True
        e['Forsaken_BackpackAccess'](0,'hero')
        self.assertTrue(e['ForsakenBackpackWanted'])
        self.assertTrue(e['Forsaken_BackpackVisible']('backpack'))

    def test_selection_does_not_erase_open_intent_and_other_player_events_are_ignored(self):
        e,now,shown,selected,owner,c=self.runtime();c['visible']=True
        e['Forsaken_BackpackVisible']('backpack')
        for event in ('deselected','selected'):
            c['event']=event;c['key']='escape'
            e['Forsaken_BackpackAccess'](0,'hero')
            self.assertTrue(e['ForsakenBackpackWanted'])
        owner[0]=1;e['ForsakenFrameSearchRequested']=False;e['Forsaken_BackpackActivity']()
        self.assertFalse(e['ForsakenFrameSearchRequested'])
        c['player']=1;e['Forsaken_BackpackCloseAction']()
        self.assertTrue(e['ForsakenBackpackWanted'])
        c['player']=0;e['Forsaken_BackpackCloseAction']()
        self.assertFalse(e['ForsakenBackpackWanted'])

    def test_native_close_search_is_bounded_cached_and_creates_no_events(self):
        e,now,shown,selected,owner,c=self.runtime();visits=[];events=[];points=[]
        tree={'backpack':['backdrop','EquipmentPanelCloseButton'],'backdrop':['item']}
        e.update(BlzFrameGetChildrenCount=lambda f:len(tree.get(f,[])),
                 BlzFrameGetChild=lambda f,i:tree[f][i],BlzFrameGetName=lambda f:visits.append(f) or f,
                 BlzTriggerRegisterFrameEvent=lambda *a:events.append(a),
                 BlzFrameSetAllPoints=lambda *a:points.append(a))
        e['Forsaken_BackpackControls']('backpack','anchor',True)
        self.assertEqual(e['ForsakenBackpackNativeClose'],'EquipmentPanelCloseButton')
        self.assertEqual(points,[('close','EquipmentPanelCloseButton')]);self.assertEqual(events,[])
        first=list(visits);e['Forsaken_BackpackControls']('backpack','anchor',True)
        self.assertEqual(visits,first)
        e['ForsakenBackpackNativeClose']=None;e['ForsakenBackpackScanBudget']=3
        e['BlzFrameGetChildrenCount']=lambda f:1
        e['BlzFrameGetChild']=lambda f,i:'branch'
        e['Forsaken_HookBackpackClose']('root',0)
        self.assertEqual(e['ForsakenBackpackScanBudget'],0)

    def test_registration_does_not_duplicate_item_triggers_after_ui_rebuild(self):
        e,now,shown,selected,owner,c=self.runtime();created=[];destroyed=[]
        def trigger():
            created.append('trigger'+str(len(created)));return created[-1]
        e.update(CreateTrigger=trigger,BlzCreateFrame=lambda *a:'close',DestroyTrigger=destroyed.append,
                 ForsakenBackpackEvents=None,ForsakenBackpackCloseEvents=None)
        e['Forsaken_RegisterBackpackActivity']();e['Forsaken_RegisterBackpackActivity']()
        self.assertEqual(len(created),2)
        e['Forsaken_ResetBackpackControls']();e['Forsaken_RegisterBackpackActivity']()
        self.assertEqual(len(created),3);self.assertEqual(destroyed,['trigger1'])

    def test_both_panes_open_and_close_together_without_portrait_close(self):
        e,now,shown,selected,owner,c=self.runtime()
        visible={'backpack':False,'bag':True}
        e.update(ForsakenLinkedBag='bag',BlzFrameIsVisible=lambda f:visible.get(f,False),
            BlzFrameSetVisible=lambda f,v:visible.__setitem__(f,v))
        self.assertTrue(e['Forsaken_BackpackVisible']('backpack'))
        self.assertTrue(visible['backpack']);self.assertTrue(visible['bag'])
        e['Forsaken_CloseBackpack']()
        self.assertFalse(visible['backpack']);self.assertFalse(visible['bag'])
        now[0]+=1.;c['key']='backpack';e['Forsaken_BackpackAccess'](0,'hero')
        self.assertTrue(e['Forsaken_BackpackVisible']('backpack'))
        self.assertTrue(visible['backpack']);self.assertTrue(visible['bag'])
        e['Forsaken_BackpackControls']('backpack','portrait',True)
        self.assertFalse(visible['close'])
        e['Forsaken_CloseBackpack']();now[0]+=1.
        self.assertFalse(e['Forsaken_BackpackVisible']('backpack'))

    def test_native_only_integration_is_idempotent_and_orders_helpers_before_callers(self):
        s='library TEquip\nglobals\nendglobals\n'+(ROOT/'experiments/Forsaken/Forsaken-panels.j').read_text()+'\nendlibrary'
        result=refresh(s);self.assertEqual(refresh(result),result)
        fs=functions(result)
        self.assertIn('Forsaken_BackpackVisible(nativePanel)',fs['Forsaken_PollPanels'])
        self.assertIn('Forsaken_BackpackAccess(viewer,hero)',fs['Forsaken_PanelAccess'])
        self.assertIn('Forsaken_RegisterBackpackActivity()',fs['Register_Forsaken_PanelAccess'])
        self.assertLess(result.index('function Forsaken_BackpackAccess takes'),result.index('function Forsaken_PanelAccess takes'))
        self.assertEqual(refresh('library TBackpack\nendlibrary'),'library TBackpack\nendlibrary')


if __name__=='__main__':unittest.main()
