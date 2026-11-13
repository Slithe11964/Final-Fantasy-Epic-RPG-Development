import sys,re,unittest,collections
from pathlib import Path
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from editor_pair import View
from inventory_crash94 import catalog,presentations,refresh
from jtok import functions,tokens
from test_armory_materia import execute
from test_shared_context import mocks
ROOT=Path(__file__).resolve().parents[2]
BASES=[ROOT/'release/0.9.7.5f/history/2026-11-04-before-inventory94/FFERPG-0.9.7.5f.w3x',ROOT/'release/development/QuickUI93/FFERPG-QuickUI93.w3x']
OUTS=[ROOT/'release/development/VersionFHotfix10/FFERPG-0.9.7.5f-Hotfix10.w3x',ROOT/'release/development/QuickUI94/FFERPG-QuickUI94.w3x']

class Inventory94Tests(unittest.TestCase):
 @classmethod
 def setUpClass(c):
  c.pairs=[(View(b),View(o)) for b,o in zip(BASES,OUTS)]
  c.fs=functions(c.pairs[1][1].runtime)
 def test_only_audited_modules_and_no_gameplay_object_changes(self):
  for old,new in self.pairs:
   for lib,s in old.modules.items():
    if lib not in {'TUnit','TEquip','TCine','TItemCooldown','TForsakenFreshLoad','TProf','TTitles','TPassive','TStatus','TTalents','TTitle'}:self.assertEqual(s,new.modules[lib],lib)
   for name in old.archive.read('(listfile)').decode().splitlines():
    if name.lower() not in {'war3map.j','war3map.wct','war3map.wts','(listfile)','(attributes)','(signature)'}:self.assertEqual(old.archive.read(name),new.archive.read(name),name)
 def test_catalogue_has_all_items_and_no_live_index_icon_tooltip_queries(self):
  for old,new in self.pairs:
   items=catalog(old);self.assertGreater(len(items),2000)
   self.assertTrue(all(len(v)<=32 for v in items.values()))
   for name in ['BlzGetItemAbilityByIndex','BlzGetItemIconPath','BlzGetItemExtendedTooltip']:self.assertNotIn(name+'(',new.runtime)
   self.assertEqual(new.runtime.count('BlzGetItemEquipmentType('),1)
 def test_static_inherited_icons_cover_every_shortcut(self):
  for old,new in self.pairs:
   icons,tips=presentations(old);fs=functions(new.runtime)
   required=set(re.findall(r"SaveInteger\(QuickGearData,0,'(.{4})'",new.runtime))
   cached=set(re.findall(r"SaveStr\(QuickGearIconPaths,0,'(.{4})'",new.runtime))
   self.assertTrue(required<=cached,required-cached)
   for raw in ['I08N','f096','g096','I0DS','f032','I0HW','f131','g131']:self.assertTrue(icons[raw],raw)
   self.assertEqual(icons['I08N'],icons['axas']);self.assertTrue(tips['I08N'])
 def test_equipment_type_does_not_query_null_or_retired_items(self):
  s=self.fs['Inventory94_EquipmentType'];calls=[];e=mocks(s)
  e.update(EQUIPMENT_TYPE_NONE=0,GetItemTypeId=lambda item:0 if item in [None,'retired'] else 123,BlzGetItemEquipmentType=lambda item:(calls.append(item) or 7))
  e=execute(s,['Inventory94_EquipmentType'],e)
  for item in [None,'retired']:self.assertEqual(e['Inventory94_EquipmentType'](item),0)
  self.assertFalse(calls);self.assertEqual(e['Inventory94_EquipmentType']('live'),7);self.assertEqual(calls,['live'])
 def test_holder_accessors_do_not_query_null_or_removed_units(self):
  for name in ['Forsaken_ActiveGear','QuickGear_Item','Idle76_Item']:
   s=self.fs[name];e=mocks(s);calls=[]
   e.update(GetUnitTypeId=lambda u:0,UnitItemInSlot=lambda *a:calls.append(a),BlzUnitItemInEquipmentSlot=lambda *a:calls.append(a))
   e=execute(s,[name],e)
   for u in [None,'removed']:self.assertIsNone(e[name](u,0))
   self.assertFalse(calls,name)
 def test_cinematic_shutdown_precedes_pause_and_selection(self):
  for old,new in self.pairs:
   fs=functions(new.runtime);b=fs['Cine_Enter'];gate=b.index('set Inventory94Paused=true');clear=b.index('ExecuteFunc("Inventory94_CineEnter")')
   self.assertLess(gate,clear)
   for marker in ['ClearSelection()','ShowInterface(false','ForGroup(']:self.assertLess(clear,b.index(marker))
   end=fs['Cine_Exit'];self.assertLess(end.index('SelectUnit(l_hero,true)'),end.index('set Inventory94Paused=false'))
   self.assertIn('ForceUICancel()',fs['Inventory94_CineEnter'])
   before=functions(old.modules['TCine'])
   for name,s in before.items():
    if name not in ['Cine_Enter','Cine_Exit']:self.assertEqual(tokens(s),tokens(fs[name]),name)
 def test_paused_tick_and_sync_packet_do_no_work(self):
  for name in ['UI72_Tick','QuickGear_Receive','Forsaken_PrepareInventories']:
   s=self.fs[name];calls=[];e=mocks(s)
   for n in list(e):
    if callable(e[n]):e[n]=lambda *a,n=n:(calls.append(n) or 0)
   e.update(Inventory94Paused=True,InventoryCinematicActive=True,udg_InCinematicMode=True,Inventory94_Blocked=lambda:True)
   e=execute(s,[name],e);e[name]()
   self.assertNotIn('QuickGear_Item',calls);self.assertNotIn('UnitAddItem',calls);self.assertNotIn('BlzUnitItemInEquipmentSlot',calls)
   if name=='UI72_Tick':self.assertFalse(calls)
 def test_owner_quiet_window_does_not_block_other_players(self):
  s=self.fs['Inventory94_Blocked'];e=mocks(s)
  e.update(Inventory94Paused=False,InventoryCinematicActive=False,udg_InCinematicMode=False,Inventory94ResumeUntil=0.,Inventory94Until=collections.defaultdict(float,{0:1.2}),NativeCDClock=1,TimerGetElapsed=lambda t:1.,GetPlayerId=lambda p:p,GetLocalPlayer=lambda:0)
  e=execute(s,['Inventory94_Blocked'],e);self.assertTrue(e['Inventory94_Blocked']());e['GetLocalPlayer']=lambda:1;self.assertFalse(e['Inventory94_Blocked']())
 def test_local_cleanup_has_no_shared_gameplay_mutations(self):
  b=self.fs['Inventory94_ClearLocal']+self.fs['Inventory94_CineEnter']+self.fs['Inventory94_CineExit']
  for name in ['RemoveItem','UnitRemoveItem','UnitAddItem','CreateItem','CreateUnit','RemoveUnit','UnitRemoveAbility','BlzItemRemoveAbility','DestroyTimer','DestroyTrigger','BlzSendSyncData','InitHashtable','SaveInteger','SaveReal']:self.assertNotRegex(b,r'\b'+name+r'\(')
  self.assertNotIn('set Inventory94Until[',self.fs['Inventory94_CineExit'])
  self.assertLess(self.fs['Inventory94_Changed'].index('set Inventory94Until[pid]'),self.fs['Inventory94_Changed'].index('if GetLocalPlayer()'))
 def test_inventory_rebind_detaches_before_stripping(self):
  b=self.fs['Forsaken_RebindBag'];self.assertLess(b.index('UnitRemoveItem(holder,carried)'),b.index('Forsaken_SuspendStoredItem(carried)'));self.assertIn('Inventory94Paused',b)
  for name in ['Forsaken_PrepareQuickGear','Forsaken_PrepareWeaponHand','Forsaken_CarryReplacement']:
   b=self.fs[name]
   for m in re.finditer(r'call UnitAddItem\(holder,replacement\)',b):self.assertRegex(b[:m.start()],r'Forsaken_SuspendStoredItem\(replacement\)\s*$')
 def test_restore_checks_snapshot_item_type_before_mutation(self):
  b=self.fs['Forsaken_RestoreStoredItem'];self.assertLess(b.index('LoadInteger(ForsakenBagAbilities,key,-2)!=GetItemTypeId(carried)'),b.index('loop'))
  self.assertIn('SaveInteger(ForsakenBagAbilities,key,-2,GetItemTypeId(carried))',self.fs['Forsaken_SuspendStoredItem'])
 def test_no_new_polling_timers_and_save_serializers_unchanged(self):
  for old,new in self.pairs:
   for name in ['TimerStart(','CreateTimer(','TriggerRegisterTimerEvent']:self.assertEqual(old.runtime.count(name),new.runtime.count(name),name)
   oldfs=functions(old.runtime);newfs=functions(new.runtime)
   for name,s in oldfs.items():
    if name.startswith(('Save_','Load_','Trig_Cmd_Load_Code_')):self.assertEqual(tokens(s),tokens(newfs[name]),name)
 def test_all_background_stat_inventory_jobs_pause_and_resume(self):
  for old,new in self.pairs:
   fs=functions(new.runtime)
   for name in ['Forsaken_UpdatePanels','Forsaken_PrepareInventories','Inventory71_Reconcile','Idle76_Capture','Chronicles_Tick','Trig_Passive_Bonus_Sync_Actions','Trig_Status_AutoCleanse_Actions','Talent_ShieldDisplayTick','FFL_Tick']:
    if name in fs:
     b=fs[name];self.assertIn('if Inventory94Paused',b,name);self.assertNotIn('Inventory94_Blocked()',b,name)
   end=fs['Cine_Exit']
   for hook in ['Forsaken_PrepareInventories','Chronicles_Tick','FFL94_CineExit']:self.assertIn('ExecuteFunc("'+hook+'")',end)
   for timer in ['udg_StatsRefreshTimer','udg_HeroRefreshTimer']:self.assertIn('StartTimerBJ('+timer+',false,.01)',end)
 def test_save_load_deadlines_do_not_include_cinematic_time(self):
  s=self.fs['FFL94_CineExit'];e=mocks(s);started=collections.defaultdict(float,{0:10.,1:20.})
  e.update(FFL94PausedAt=30.,FST_Clock=1,TimerGetElapsed=lambda t:80.,FFL_Phase=collections.defaultdict(int,{0:3}),FFL_Started=started)
  e=execute(s,['FFL94_CineExit'],e);e['FFL94_CineExit']();self.assertEqual(started[0],60.);self.assertEqual(started[1],20.);self.assertEqual(e['FFL94PausedAt'],-1.)
 def test_newgameplus_uses_original_reset_writer_while_minus_stays_blocked(self):
  for old,new in self.pairs:
   fs=functions(new.runtime);b=fs['Forsaken_PrepareInventories']
   self.assertNotIn('TriggerClearActions(udg_NewGamePlusTrig)',b)
   self.assertIn('TriggerAddAction(udg_NewGameMinusTrig,function Forsaken_SaveUnavailable)',b)
   self.assertIn('TriggerAddAction(udg_NewGamePlusTrig,function Save_OnNewGamePlus)',fs['Save_InitCommands'])
   self.assertIn('Save_WriteNewGameCode(GetTriggerPlayer(),false)',fs['Save_OnNewGamePlus'])
   self.assertEqual(tokens(fs['Save_WriteNewGameCode']),tokens(functions(old.runtime)['Save_WriteNewGameCode']))
   self.assertIn('EnableTrigger(udg_NewGamePlusTrig)',fs['FFL_NotifyNewGamePlus'])
 def test_demi_fiend_minus_unlock_announcement_is_removed(self):
  for old,new in self.pairs:
   fs=functions(new.runtime)
   self.assertNotIn('New Game Minus',fs['Trig_Title_UnlockEffects_Actions'])
   self.assertNotIn('EnableTrigger(udg_NewGameMinusTrig)',new.runtime)
   self.assertNotIn('New Game Minus',fs['Trig_Titles_Init_Actions'])
   self.assertNotIn(b'Unlocked New Game Minus.',new.archive.read('war3map.wts'))
   self.assertIn('All your base stats increase by 10!',fs['Trig_Titles_Init_Actions'])

if __name__=='__main__':unittest.main()
