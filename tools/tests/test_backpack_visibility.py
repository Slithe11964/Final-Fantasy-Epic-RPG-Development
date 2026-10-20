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
        s=dict(frame='input',now=10.,hero='freelancer',key='',player=0,preview='freelancer',
               allow=True,down=True,selected=True,engine=False,delay=.05)
        v={'gear':False,'bag':False,'command4':True};pending=[];clicks=[];looked=[];messages=[]
        def click(control):
            clicks.append((s['now'],control))
            if s['allow']:pending.append(s['now']+s['delay'])
        def lookup(name):
            looked.append(name)
            return {'SimpleEquipmentPanel':'gear','EquipmentPanelBackdrop':'backdrop','SimpleEquipmentInventoryPanel':'bag'}.get(name)
        env=mocks(HELPER);env.update(
            ForsakenInventoryBinding=False,ForsakenLastToggleTime=-1.,ForsakenLastToggleSource=0,
            ForsakenBackpackKeyHeld=False,ForsakenInventoryBindPhase=0,ForsakenInventoryBindHero=None,ForsakenInventoryBindUntil=0.,
            ForsakenBackpackCommand='command4',ForsakenBackpackInput='input',ForsakenGearCommand=None,
            GetUnitAbilityLevel=lambda *a:1,BlzGetTriggerFrame=lambda:s['frame'],
            ForsakenBackpackWanted=False,ForsakenBackpackWasVisible=False,ForsakenBackpackCloseUntil=0.,
            ForsakenTalentsWanted=True,ForsakenPanelOpen=False,ForsakenPanelClock='clock',ForsakenCachedEquipment='gear',ForsakenCachedBackdrop='backdrop',
            ForsakenLinkedBag='bag',ForsakenInventoryHero='freelancer',ForsakenNextBagSearch=0.,ForsakenInspectTarget=None,
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

    def test_mouse_and_b_share_confirmed_native_opening(self):
        for mouse in [True,False]:
            e,s,v,clicks,_,_,poll,settle=self.runtime()
            if mouse:e['Forsaken_BackpackToggleAction']()
            else:s['key']='B';e['Forsaken_BackpackAccess'](0,s['hero'])
            self.assertTrue(e['ForsakenBackpackWanted']);self.assertIsNone(e['ForsakenInventoryHero'])
            self.assertFalse(poll(10.));self.assertTrue(settle());self.assertEqual(len(clicks),1)

    def test_native_notifications_and_programmatic_clicks_cannot_toggle_owned_input(self):
        e,s,v,_,_,_,_,_=self.runtime();s['frame']='command4'
        e['Forsaken_BackpackToggleAction']();self.assertFalse(e['ForsakenBackpackWanted'])
        s['frame']='input';e['ForsakenInventoryBinding']=True
        e['Forsaken_BackpackToggleAction']();self.assertFalse(e['ForsakenBackpackWanted'])

    def test_script_hiding_keeps_engine_open_but_repeated_reopen_recovers(self):
        e,s,v,clicks,_,_,poll,settle=self.runtime()
        for attempt in range(4):
            s['now']+=1;e['Forsaken_RequestBackpackToggle'](2);poll(s['now'])
            self.assertTrue(settle(),attempt);self.assertEqual(e['ForsakenInventoryHero'],s['hero'])
            e['Forsaken_CloseBackpack']();self.assertTrue(s['engine'])
            self.assertFalse(v['gear'] or v['bag']);self.assertTrue(e['ForsakenTalentsWanted'])
        self.assertEqual(len(clicks),7)

    def test_cached_hidden_same_hero_does_not_skip_binding(self):
        e,s,v,clicks,_,_,poll,settle=self.runtime();s['engine']=True
        e['Forsaken_RequestBackpackToggle'](2);poll(10.)
        self.assertIsNone(e['ForsakenInventoryHero']);self.assertTrue(settle());self.assertEqual(len(clicks),2)

    def test_delayed_engine_command_is_not_reclicked_in_flight(self):
        e,s,v,clicks,_,_,poll,settle=self.runtime();s['delay']=.8
        e['Forsaken_RequestBackpackToggle'](2);poll(10.)
        for i in range(1,8):self.assertFalse(poll(10.+i*.1))
        self.assertEqual(len(clicks),1);self.assertTrue(settle());self.assertEqual(len(clicks),1)

    def test_unavailable_binding_is_bounded_and_next_press_retries(self):
        e,s,v,clicks,_,messages,poll,settle=self.runtime();s['allow']=False
        e['Forsaken_RequestBackpackToggle'](2);poll(10.);self.assertFalse(settle())
        self.assertEqual(len(clicks),2);self.assertFalse(e['ForsakenBackpackWanted']);self.assertEqual(len(messages),1)
        for now in [30.,60.,600.]:poll(now)
        self.assertEqual(len(clicks),2)
        s['allow']=True;e['Forsaken_RequestBackpackToggle'](2);poll(s['now']);self.assertTrue(settle())

    def test_close_cancels_in_flight_and_late_native_open(self):
        e,s,v,_,_,_,poll,_=self.runtime();s['delay']=.3
        e['Forsaken_RequestBackpackToggle'](2);poll(10.);e['Forsaken_CloseBackpack']()
        for now in [10.1,10.4,11.,60.]:
            self.assertFalse(poll(now));self.assertFalse(v['gear'] or v['bag'])

    def test_closed_unbound_inventory_has_no_idle_search_or_clicks(self):
        e,s,v,clicks,looked,_,poll,_=self.runtime();e['ForsakenInventoryHero']=None
        for now in [10.,20.,100.]:self.assertFalse(poll(now))
        self.assertEqual(clicks,[]);self.assertEqual(looked,[])

    def test_changed_hero_refreshes_engine_preview(self):
        e,s,v,_,_,_,poll,settle=self.runtime()
        e['Forsaken_RequestBackpackToggle'](2);poll(10.);self.assertTrue(settle())
        s['hero']='time mage';poll(s['now']+.1);self.assertTrue(settle())
        self.assertEqual(s['preview'],'time mage');self.assertEqual(e['ForsakenInventoryHero'],'time mage')

    def test_drop_use_idle_and_single_hidden_pane_restore_pair_without_rebinding(self):
        e,s,v,clicks,_,_,poll,settle=self.runtime()
        e['Forsaken_RequestBackpackToggle'](2);poll(10.);self.assertTrue(settle());count=len(clicks)
        for now in [20.,30.,600.]:
            s['now']=now;e['Forsaken_BackpackActivity']();v.update(gear=False,bag=False)
            self.assertTrue(poll(now));self.assertTrue(v['gear'] and v['bag'])
        for pane in ['gear','bag']:
            v[pane]=False;self.assertTrue(poll(s['now']+.1));self.assertTrue(v['gear'] and v['bag'])
        self.assertEqual(len(clicks),count)

    def test_selection_and_inspection_hide_overlay_and_pair_without_erasing_intent(self):
        e,s,v,_,_,_,poll,settle=self.runtime();e['Forsaken_RequestBackpackToggle'](2);poll(10.);settle()
        e['Forsaken_BackpackInputControl'](s['hero'],0);self.assertTrue(v['input'])
        s['selected']=False;self.assertFalse(e['Forsaken_InventoryContext'](s['hero'],0))
        self.assertFalse(v['gear'] or v['bag']);self.assertTrue(e['ForsakenBackpackWanted'])
        e['Forsaken_BackpackInputControl'](s['hero'],0);self.assertFalse(v['input'])
        s['selected']=True;e['ForsakenSelectedTarget']='gaya'
        self.assertTrue(e['Forsaken_InventoryContext'](s['hero'],0));self.assertTrue(poll(s['now']+.1))
        e['ForsakenInspectTarget']='npc';e['Forsaken_BackpackInputControl'](s['hero'],0);self.assertFalse(v['input'])

    def test_key_repeat_duplicate_notifications_escape_and_remote_close(self):
        e,s,v,_,_,_,_,_=self.runtime();s['key']='B'
        for now in [10.,10.2,10.5,20.]:
            s['now']=now;e['Forsaken_BackpackAccess'](0,s['hero']);self.assertTrue(e['ForsakenBackpackWanted'])
        s['down']=False;e['Forsaken_BackpackAccess'](0,s['hero'])
        s.update(now=21.,down=True);e['Forsaken_BackpackAccess'](0,s['hero']);self.assertFalse(e['ForsakenBackpackWanted'])
        s['now']=22.;e['Forsaken_RequestBackpackToggle'](2);e['Forsaken_RequestBackpackToggle'](1)
        self.assertTrue(e['ForsakenBackpackWanted']);s['player']=1;e['Forsaken_BackpackCloseAction']()
        self.assertTrue(e['ForsakenBackpackWanted']);s.update(player=0,key='escape')
        e['Forsaken_BackpackAccess'](0,s['hero']);self.assertFalse(e['ForsakenBackpackWanted']);self.assertTrue(e['ForsakenTalentsWanted'])

    def test_armory_refresh_only_rebinds_own_open_inventory(self):
        e,s,v,_,_,_,poll,settle=self.runtime();e['Forsaken_RequestInventoryRefresh'](s['hero'])
        self.assertEqual(e['ForsakenInventoryHero'],s['hero'])
        e['Forsaken_RequestBackpackToggle'](2);poll(10.);settle()
        e['Forsaken_RequestInventoryRefresh']('other');self.assertEqual(e['ForsakenInventoryHero'],s['hero'])
        e['Forsaken_RequestInventoryRefresh'](s['hero']);self.assertIsNone(e['ForsakenInventoryHero'])
        poll(s['now']);self.assertTrue(settle())

    def test_overlay_is_shared_startup_and_never_hooks_native_command_events(self):
        fs=functions(HELPER);register=fs['Forsaken_RegisterBackpackActivity']
        line=next(line for line in register.splitlines() if 'BlzTriggerRegisterFrameEvent(ForsakenBackpackToggleEvents' in line)
        self.assertIn('ForsakenBackpackInput,FRAMEEVENT_CONTROL_CLICK',line);self.assertNotIn('ForsakenBackpackCommand,',line)
        self.assertIn('BlzCreateFrameByType("BUTTON"',register);self.assertNotIn('GetLocalPlayer',register)
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
        obj=read_objects(updated,'w3a')['original'][0];self.assertEqual(fields(obj)['ahky',0],'');self.assertEqual(obj['base'],'ASpc')

    def test_debug_is_read_only_and_private_to_requester(self):
        body=functions(HELPER)['Forsaken_BackpackDebug']
        self.assertIn('if GetLocalPlayer()==viewer then',body)
        self.assertIn('phase=',body);self.assertIn('bound=',body)
        for mutation in ['BlzFrameSet','UnitAdd','Issue','Create','SyncData']:
            self.assertNotIn(mutation,body)

if __name__=='__main__':unittest.main()
