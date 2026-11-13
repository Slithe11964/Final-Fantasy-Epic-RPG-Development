"""Cinematic suspension, staged autosave and actual native cast API paths."""
import sys,unittest,math
from pathlib import Path
from collections import defaultdict
sys.path[:0]=[str(Path(__file__).resolve().parents[1]),str(Path(__file__).resolve().parent)]
from cinematic_v20 import UI,PROFILE,refresh
from creatures_v20 import CAST,COPY
from creatures_v20 import refresh as creature_refresh
from build_f1030_inventory_rollback import view
from build_forest86 import ROOT,functions
from test_shared_context import mocks
from test_armory_materia import execute

class V20Tests(unittest.TestCase):
 def test_hide_covers_toolbar_wheels_talents_close_and_move(self):
  source=functions(UI)['C20_HideUI'];e=mocks(source);hidden=[];actions=[]
  e.update(QuickGearPending=1,QuickGearShown=True,QuickGearReady=True,QuickGearRoot='fg',QuickGearButton={0:'f',1:'g'},QuickGearWheelPanel={0:'fw',1:'gw'},
   ForsakenTalentRoot='talents',ForsakenTalentToggle='talentButton',ForsakenBackpackClose='x',ForsakenLinkedBagClose='bx',ForsakenInspectRoot='inspect',ForsakenInspectButton='inspectButton',CarryUIButton='move',CarryUIRoot='movePanel',
   BlzFrameSetVisible=lambda f,v:hidden.append((f,v)),Forsaken_CloseBackpack=lambda:actions.append('close'),QuickGear_ClearPreview=lambda:actions.append('preview'))
  e=execute(source,['C20_HideUI'],e);e['C20_HideUI']()
  self.assertEqual({f for f,v in hidden if not v},{'fg','f','g','fw','gw','talents','talentButton','x','bx','inspect','inspectButton','move','movePanel'})
  self.assertEqual(actions,['close','preview']);self.assertEqual(e['QuickGearPending'],-1)
 def test_ui_stops_timer_and_equipment_trigger_before_hide_then_resumes(self):
  names=['C20_UIPause','C20_UIResume'];source='\n'.join(functions(UI)[n] for n in names);e=mocks(source);events=[]
  e.update(C20UITimerActive=False,C20InventoryActive=False,C20EquipEventsActive=False,C20UIPaused=False,QuickGearUITimer='ui',ForsakenInventoryTimer='inv',gg_trg_Forsaken_Equipment='equip',C20DeferredCount=0,
   TimerGetRemaining=lambda t:1.,IsTriggerEnabled=lambda t:True,PauseTimer=lambda t:events.append(('pause',t)),ResumeTimer=lambda t:events.append(('resume',t)),DisableTrigger=lambda t:events.append(('disable',t)),EnableTrigger=lambda t:events.append(('enable',t)),C20_HideUI=lambda:events.append(('hide',None)))
  e=execute(source,names,e);e['C20_UIPause']();self.assertEqual(events,[('pause','ui'),('pause','inv'),('disable','equip'),('hide',None)])
  e['C20_UIResume']();self.assertEqual(events[-3:],[('enable','equip'),('resume','inv'),('resume','ui')])
 def test_shared_profile_pause_preserves_capture_watchdog_and_timeout_time(self):
  names=['C20_ProfilePause','C20_ProfileResume'];source='\n'.join(functions(PROFILE)[n] for n in names);events=[];clock=[10.];e=mocks(source)
  e.update(C20PauseStarted=0.,C20PollPaused=False,C20ProfilePaused=False,C20CapturePaused=defaultdict(bool),FST_Clock='clock',FFL_Poll='loadpoll',
   FRC_Phase=defaultdict(int,{1:1}),FRC_Timer={1:'capture'},FRC_Watchdog={1:'watchdog'},FFL_Phase=defaultdict(int,{1:3}),FFL_Started=defaultdict(float,{1:5.}),
   TimerGetElapsed=lambda t:clock[0],TimerGetRemaining=lambda t:1.,PauseTimer=lambda t:events.append(('pause',t)),ResumeTimer=lambda t:events.append(('resume',t)))
  e=execute(source,names,e);e['C20_ProfilePause']();clock[0]=40.;e['C20_ProfileResume']()
  self.assertEqual(e['FFL_Started'][1],35.);self.assertEqual({t for op,t in events if op=='pause'},{'loadpoll','capture','watchdog'})
  self.assertEqual({t for op,t in events if op=='resume'},{'loadpoll','capture','watchdog'})
 def test_autosave_starts_staged_capture_without_inline_pump(self):
  source=functions(PROFILE)['C20_BeginAutosave'];e=mocks(source);events=[]
  e.update(udg_InCinematicMode=False,InventoryCinematicActive=False,C20RetryAfter=defaultdict(float),FST_Clock='clock',TimerGetElapsed=lambda t:20.,FRC_Start=lambda p:events.append(('start',p)) or True,
   FRC_Timer={0:'capture'},FRC_Watchdog={0:'watchdog'},FRC_Tick=lambda:None,FRC_Timeout=lambda:None,TimerStart=lambda t,dt,rep,cb:events.append((t,dt,rep)),FFL_SaveFile=defaultdict(bool),FST_LegacySaveMessages=defaultdict(bool),FFL_Phase=defaultdict(int),C20SoftAutosave=defaultdict(bool))
  e=execute(source,['C20_BeginAutosave'],e);self.assertTrue(e['C20_BeginAutosave'](0));self.assertEqual(events,[('start',0),('capture',.1,True),('watchdog',60.,False)])
  self.assertNotIn('FRC_StartNow',source)
 def test_gear_receiver_reads_no_item_or_sync_payload_in_scene(self):
  v=view(str(ROOT/'release/development/V19/FFERPG-V19.w3x'));s=refresh('TEquip',v.modules['TEquip']);b=functions(s)['QuickGear_Receive'];e=mocks(b)
  def fail(*a):self.fail('receiver accessed item/sync payload while cinematic')
  e.update(udg_InCinematicMode=True,InventoryCinematicActive=True,GetTriggerPlayer=fail,BlzGetTriggerSyncData=fail,QuickGear_Item=fail)
  e=execute(b,['QuickGear_Receive'],e);e['QuickGear_Receive']()
 def test_dragon_casts_on_proxy_and_charges_real_caster_only_on_success(self):
  for accepted in [False,True]:
   e=mocks(CAST);orders=[];paid=[];removed=[]
   e.update(udg_InCinematicMode=False,Forest86_Enemy=lambda *a:True,UNIT_TYPE_HERO=1,UNIT_STATE_MANA=0,
    IsUnitType=lambda *a:True,IsUnitInRange=lambda *a:True,Forest86_Ready=lambda *a:True,
    CreateUnit=lambda *a:'proxy',GetOwningPlayer=lambda u:11,GetUnitX=lambda u:0.,GetUnitY=lambda u:0.,Atan2=math.atan2,bj_RADTODEG=180/math.pi,
    GetHandleId=lambda u:1,IssuePointOrder=lambda *a:orders.append(a) or accepted,GetUnitState=lambda *a:3000.,I2R=float,
    GetUnitFacing=lambda *a:0.,SetUnitState=lambda u,k,v:paid.append((u,v)),RemoveUnit=lambda u:removed.append(u))
   e=execute(CAST,['C20_DragonCast'],e);self.assertEqual(e['C20_DragonCast']('dragon','hero','kOB2',1000,30.,5000.,7,True),accepted)
   self.assertEqual(orders,[('proxy','breathoffire',0.,0.)]);self.assertEqual(paid,[('dragon',2000.)] if accepted else [])
   self.assertEqual(removed,[] if accepted else ['proxy'])
 def test_shadow_copy_uses_item_target_hero_not_self(self):
  e=mocks(COPY);orders=[]
  e.update(F99Data=1,Forest86_Enemy=lambda *a:True,IsUnitType=lambda *a:True,UNIT_TYPE_HERO=1,IsUnitIllusion=lambda u:False,
   CreateUnit=lambda *a:'dummy',GetOwningPlayer=lambda u:0,GetUnitX=lambda u:0.,GetUnitY=lambda u:0.,GetUnitFacing=lambda u:0.,
   GetHandleId=lambda u:1,CreateItem=lambda *a:'wand',UnitUseItemTarget=lambda *a:orders.append(a) or True,
   CreateTimer=lambda:'timer',F99_BindCopy=lambda:None)
  e=execute(COPY,['C20_ShadowCopy'],e);e['C20_ShadowCopy']('satyr','hero')
  self.assertEqual(orders,[('dummy','wand','hero')]);self.assertNotIn('852274',COPY)
 def test_summoned_copy_rejects_satyr_and_keeps_only_target_hero_type(self):
  v=view(str(ROOT/'release/development/V19/FFERPG-V19.w3x'));b=functions(creature_refresh('TMonsterData',v.modules['TMonsterData'],True))['F99_Summoned']
  for raw,accepted in [('H001',True),('nsts',False)]:
   e=mocks(b);removed=[];owners=[];attacks=[]
   e.update(F99Data=1,F99Active=1,GetSummoningUnit=lambda:'dummy',GetSummonedUnit=lambda:'copy',GetHandleId=lambda u:1,
    LoadUnitHandle=lambda h,i,k:'satyr' if k==41 else 'hero',GetUnitTypeId=lambda u:raw if u=='copy' else 'H001' if u=='hero' else 'h01B',
    IsUnitIllusion=lambda u:True,GetOwningPlayer=lambda u:11,SetUnitOwner=lambda *a:owners.append(a),RemoveUnit=lambda u:removed.append(u),IssueTargetOrder=lambda *a:attacks.append(a))
   e=execute(b,['F99_Summoned'],e);e['F99_Summoned']()
   self.assertEqual(removed,[] if accepted else ['copy'])
   self.assertEqual(attacks,[('copy','attack','hero')] if accepted else [])
   self.assertEqual(owners,[('copy',11,True)] if accepted else [])
 def test_entry_suspends_before_any_unit_pause_or_selection_change(self):
  v=view(str(ROOT/'release/development/V19/FFERPG-V19.w3x'));b=functions(refresh('TCine',v.modules['TCine']))['Cine_Enter']
  for name in ['C20_ProfilePause','C20_CooldownPause','C20_UIPause']:
   self.assertLess(b.index(name),b.index('call GroupEnumUnitsInRect'))
   self.assertLess(b.index(name),b.index('call ClearSelection'))
 def test_plain_orders_never_refresh_worn_inventory(self):
  v=view(str(ROOT/'release/development/V19/FFERPG-V19.w3x'));b=functions(refresh('TEquip',v.modules['TEquip']))['Forsaken_OnEquip']
  for event in [1,2,3]:
   e=mocks(b);calls=[]
   def fail(*a):self.fail('ordinary order rescanned inventory')
   e.update(udg_InCinematicMode=False,InventoryCinematicActive=False,ForsakenConvertingGear=False,
    GetTriggerUnit=lambda:'hero',GetUnitTypeId=lambda u:'H000',GetTriggerEventId=lambda:event,
    EVENT_PLAYER_UNIT_ISSUED_TARGET_ORDER=1,EVENT_PLAYER_UNIT_ISSUED_POINT_ORDER=2,EVENT_PLAYER_UNIT_ISSUED_ORDER=3,
    Forsaken_CarryOrder=lambda u:calls.append(u),Integrity_RefreshWorn=fail,GetUnitAbilityLevel=fail)
   e=execute(b,['Forsaken_OnEquip'],e);e['Forsaken_OnEquip']();self.assertEqual(calls,['hero'])
 def test_queued_rebind_stores_timer_without_inventory_reads_during_scene(self):
  v=view(str(ROOT/'release/development/V19/FFERPG-V19.w3x'));b=functions(refresh('TEquip',v.modules['TEquip']))['Forsaken_RebindBag'];e=mocks(b)
  def fail(*a):self.fail('rebind accessed inventory during cinematic')
  e.update(udg_InCinematicMode=True,InventoryCinematicActive=True,C20DeferredCount=0,C20DeferredBag={},GetExpiredTimer=lambda:'queued',GetHandleId=fail,LoadUnitHandle=fail)
  e=execute(b,['Forsaken_RebindBag'],e);e['Forsaken_RebindBag']();self.assertEqual(e['C20DeferredBag'],{0:'queued'});self.assertEqual(e['C20DeferredCount'],1)

if __name__=='__main__':unittest.main()
