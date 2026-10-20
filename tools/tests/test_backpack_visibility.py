"""Owned inputs and confirmed native binding; engine state is separate from frames."""
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
        s=dict(frame='command4',now=10.,hero='freelancer',key='',player=0,preview='freelancer',
               allow=True,down=True,selected=True,engine=False,delay=.05)
        v={'gear':False,'bag':False,'command4':True};pending=[];clicks=[];looked=[];messages=[]
        def click(control):
            clicks.append((s['now'],control))
            if s['allow']:pending.append(s['now']+s['delay'])
        def lookup(name):
            looked.append(name)
            return {'SimpleEquipmentPanel':'gear','EquipmentPanelBackdrop':'backdrop','SimpleEquipmentInventoryPanel':'bag'}.get(name)
        env=mocks(HELPER);env.update(
            ForsakenBackpackCloses=0,ForsakenBackpackRequests=0,ForsakenBackpackMouseEvents=0,ForsakenBackpackKeyEvents=0,ForsakenBackpackNativeClicks=0,
            ForsakenInventoryBinding=False,ForsakenLastToggleTime=-1.,ForsakenLastToggleSource=0,
            ForsakenBackpackKeyHeld=False,ForsakenInventoryBindPhase=0,ForsakenInventoryBindHero=None,ForsakenInventoryBindUntil=0.,
            ForsakenBackpackCommand='command4',ForsakenBackpackInput='input',ForsakenGearCommand=None,
            GetUnitAbilityLevel=lambda *a:1,BlzGetTriggerFrame=lambda:s['frame'],
            ForsakenBackpackWanted=False,ForsakenBackpackWasVisible=False,ForsakenBackpackCloseUntil=0.,
            ForsakenTalentsWanted=True,ForsakenPanelOpen=False,ForsakenPanelClock='clock',ForsakenCachedEquipment='gear',ForsakenCachedBackdrop='backdrop',
            ForsakenLinkedBag='bag',ForsakenInventoryHero=None,ForsakenNextBagSearch=0.,ForsakenInspectTarget=None,
            ForsakenBackpackClose='close',ForsakenLinkedBagClose='bagclose',ForsakenTalentRoot='talents',
            ForsakenSelectedTarget='freelancer',ForsakenFrameSearchRequested=False,ForsakenBackpackNativeClose=None,ForsakenBagNativeClose=None,
            ForsakenBackpackHookRoot=None,ForsakenBagHookRoot=None,ForsakenBackpackScanBudget=0,
            GetLocalPlayer=lambda:0,GetTriggerPlayer=lambda:s['player'],GetTriggerEventId=lambda:'key',
            Player_GetHero=lambda p:s['hero'],IsUnitSelected=lambda *a:s['selected'],GetTriggerUnit=lambda:s['hero'],GetOwningPlayer=lambda u:0,
            BlzGetTriggerPlayerIsKeyDown=lambda:s['down'],BlzGetTriggerPlayerKey=lambda:s['key'],OSKEY_B='B',OSKEY_ESCAPE='escape',
            EVENT_PLAYER_UNIT_SELECTED='selected',EVENT_PLAYER_UNIT_DESELECTED='deselected',
            TimerGetElapsed=lambda t:s['now'],BlzFrameIsVisible=lambda f:v.get(f,False),
            BlzFrameSetVisible=lambda f,value:v.__setitem__(f,value),Forsaken_FindFrameUncached=lookup,
            BlzGetAbilityPosX=lambda raw:0,BlzGetAbilityPosY=lambda raw:1,ORIGIN_FRAME_COMMAND_BUTTON='command',
            BlzGetOriginFrame=lambda k,i:'command'+str(i),BlzFrameGetEnable=lambda f:True,BlzFrameClick=click,
            DisplayTimedTextToPlayer=lambda *a:messages.append(a[-1]),
            StringCase=lambda text,b:text.lower(),StringLength=len,SubString=lambda text,a,b:text[a:b],
            BlzFrameGetChildrenCount=lambda f:0,BlzFrameGetName=lambda f:f,FRAMEPOINT_TOPRIGHT='topright')
        e=execute(HELPER,list(functions(HELPER)),env)
        def poll(now):
            s['now']=round(now,4)
            while pending and pending[0]<=s['now']:
                pending.pop(0);s['engine']=not s['engine'];v.update(gear=s['engine'],bag=s['engine'])
                if s['engine']:s['preview']=s['hero']
            return e['Forsaken_BackpackVisible']('gear')
        def settle():
            start=s['now']
            for i in range(1,26):poll(start+i*.1)
            return v['gear'] and v['bag']
        return e,s,v,clicks,looked,messages,poll,settle

    def native_press(self,e,s,clicks):
        if e['ForsakenInventoryHero']==s['hero']:
            s['frame']='input';e['Forsaken_BackpackToggleAction']();s['frame']='command4'
        else:
            e['BlzFrameClick']('command4')
            e['Forsaken_BackpackToggleAction']()

    def test_native_mouse_and_b_open_without_a_synthetic_initial_click(self):
        for key in [False,True]:
            e,s,v,clicks,_,_,poll,settle=self.runtime()
            if key:s['key']='B';e['Forsaken_BackpackAccess'](0,s['hero'])
            self.native_press(e,s,clicks)
            self.assertTrue(settle());self.assertTrue(e['ForsakenBackpackWanted']);self.assertEqual(len(clicks),1)
            self.assertEqual(e['ForsakenInventoryHero'],s['hero'])

    def test_native_open_survives_missing_custom_mouse_or_key_event(self):
        e,s,v,clicks,_,_,poll,settle=self.runtime()
        e['BlzFrameClick']('command4')
        self.assertTrue(settle());self.assertTrue(e['ForsakenBackpackWanted'])
        self.assertEqual(len(clicks),1)

    def test_repeated_native_open_close_and_x_stay_closed(self):
        e,s,v,clicks,_,_,poll,settle=self.runtime()
        for attempt in range(4):
            s['now']+=2;self.native_press(e,s,clicks);self.assertTrue(settle())
            if attempt%2:self.native_press(e,s,clicks)
            else:e['Forsaken_CloseBackpack']()
            self.assertFalse(settle());self.assertFalse(e['ForsakenBackpackWanted'])
            self.assertTrue(e['ForsakenTalentsWanted'])
        self.assertEqual(len(clicks),1)

    def test_delayed_native_open_is_not_reclicked_in_flight(self):
        e,s,v,clicks,_,_,poll,settle=self.runtime();s['delay']=.8
        self.native_press(e,s,clicks)
        for i in range(1,8):self.assertFalse(poll(10.+i*.1))
        self.assertTrue(settle());self.assertEqual(len(clicks),1)

    def test_unavailable_binding_retries_once_then_waits_for_user(self):
        e,s,v,clicks,_,messages,poll,settle=self.runtime();s['allow']=False
        s['key']='B';e['Forsaken_BackpackAccess'](0,s['hero'])
        self.native_press(e,s,clicks);self.assertFalse(settle())
        self.assertEqual(len(clicks),2);self.assertEqual(len(messages),1)
        for now in [30.,60.,600.]:self.assertFalse(poll(now))
        self.assertEqual(len(clicks),2)
        s['allow']=True;self.native_press(e,s,clicks);self.assertTrue(settle())

    def test_close_cancels_an_in_flight_open(self):
        e,s,v,clicks,_,_,poll,settle=self.runtime();s['delay']=.3
        self.native_press(e,s,clicks);e['Forsaken_CloseBackpack']()
        for now in [10.1,10.4,11.,11.3]:self.assertFalse(poll(now))
        self.assertFalse(e['ForsakenBackpackWanted'])

    def test_idle_closed_has_no_frame_search_or_native_clicks(self):
        e,s,v,clicks,looked,_,poll,_=self.runtime();e['ForsakenInventoryHero']=None
        for now in [10.,20.,100.]:self.assertFalse(poll(now))
        self.assertEqual(clicks,[]);self.assertEqual(looked,[])

    def test_drop_use_and_native_partial_hide_restore_both_panels(self):
        e,s,v,clicks,_,_,poll,settle=self.runtime();self.native_press(e,s,clicks);settle()
        v['gear']=False;e['Forsaken_BackpackActivity']();self.assertTrue(poll(s['now']+.1))
        self.assertTrue(v['gear'] and v['bag']);self.assertEqual(len(clicks),1)
        e['Forsaken_CloseBackpack']();settle();e['Forsaken_BackpackActivity']()
        self.assertFalse(poll(s['now']+.1))

    def test_programmatic_and_other_players_notifications_cannot_toggle(self):
        e,s,v,_,_,_,_,_=self.runtime();e['ForsakenInventoryBinding']=True
        e['Forsaken_BackpackToggleAction']();self.assertFalse(e['ForsakenBackpackWanted'])
        e['ForsakenInventoryBinding']=False;s['player']=1
        e['Forsaken_BackpackToggleAction']();self.assertFalse(e['ForsakenBackpackWanted'])

    def test_key_latch_release_and_escape_close(self):
        e,s,v,clicks,_,_,poll,settle=self.runtime();s['key']='B'
        e['Forsaken_BackpackAccess'](0,s['hero']);self.native_press(e,s,clicks);settle()
        e['Forsaken_BackpackAccess'](0,s['hero']);self.assertTrue(e['ForsakenBackpackWanted'])
        s['down']=False;e['Forsaken_BackpackAccess'](0,s['hero']);self.assertFalse(e['ForsakenBackpackKeyHeld'])
        s['key']='escape';e['Forsaken_BackpackAccess'](0,s['hero']);self.assertFalse(settle())

    def test_owned_button_is_created_at_shared_startup(self):
        fs=functions(HELPER);register=fs['Forsaken_RegisterBackpackActivity']
        line=next(line for line in register.splitlines() if 'BlzTriggerRegisterFrameEvent(ForsakenBackpackToggleEvents' in line)
        self.assertIn('ForsakenBackpackInput,FRAMEEVENT_CONTROL_CLICK',line)
        self.assertIn('BlzCreateFrame("ScriptDialogButton"',register);self.assertNotIn('GetLocalPlayer',register)
        self.assertIn('BlzDestroyFrame(ForsakenBackpackInput)',fs['Forsaken_ResetBackpackControls'])
        for forbidden in ['CreateUnit','CreateItem','IssueImmediateOrder','UnitAddAbility','SelectUnit','ForceUIKey']:
            self.assertNotIn(forbidden,HELPER)

    def test_transform_is_idempotent_with_overlay_poll_and_modifier_releases(self):
        source='library TEquip\nglobals\nendglobals\n'+(ROOT/'experiments/Forsaken/Forsaken-panels.j').read_text()+'\nendlibrary'
        result=refresh(source);self.assertEqual(refresh(result),result)
        body=functions(result)['Forsaken_PollPanels'];self.assertIn('call Forsaken_BackpackInputControl(hero,viewer)',body)
        self.assertIn('set nativePanel=ForsakenCachedEquipment',body)
        for modifier in range(16):self.assertIn(f'OSKEY_B,{modifier},false)',functions(result)['Register_Forsaken_PanelAccess'])
        self.assertEqual(refresh('library TBackpack\nendlibrary'),'library TBackpack\nendlibrary')

    def test_native_only_object_hotkey_change_is_idempotent(self):
        from objdata import read_objects,write_objects
        from priest_master import fields
        table={'version':2,'original':[dict(base='ASpc',id=None,sets=[dict(flag=0,mods=[dict(field='ahky',type=3,level=0,data=0,value='B',end=0)])])],'custom':[]}
        data=write_objects(table,2,'w3a');self.assertEqual(objects(data),data)
        updated=objects(data,native=True);self.assertEqual(objects(updated,native=True),updated)
        obj=read_objects(updated,'w3a')['original'][0];self.assertEqual(fields(obj)['ahky',0],'B');self.assertEqual(obj['base'],'ASpc')

    def test_debug_is_read_only_and_private_to_requester(self):
        body=functions(HELPER)['Forsaken_BackpackDebug']
        self.assertIn('if GetLocalPlayer()==viewer then',body)
        self.assertIn('phase=',body);self.assertIn('bound=',body)
        for mutation in ['BlzFrameSet','UnitAdd','Issue','Create','SyncData']:
            self.assertNotIn(mutation,body)

if __name__=='__main__':unittest.main()
