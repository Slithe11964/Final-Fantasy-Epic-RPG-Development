"""Synthetic engine diagnostic checks, distinct from human Warcraft acceptance."""
import unittest
from pathlib import Path
from test_save_jass import engine,SOURCE
from test_save_probe import DECL
from test_save_position import InventoryWorld,Handle
from test_save_life import Real32
from build_save_probe import house_probe_source,probe_source,modules

RUNTIME='trigger gg_trg_One=null\ntrigger gg_trg_Two=null\n'
GLOBALS='globals\n trigger gg_trg_One=null\n trigger gg_trg_Two=null\n integer bj_mapInitialPlayableArea=0\nendglobals\n'

class HouseProbeTests(unittest.TestCase):
    def setUp(self):
        self.w=InventoryWorld();self.created=[];self.messages=[];self.timers=[]
        self.fail_unit=False;self.forced=None;self.refuse_unit=False
        def create(owner,raw,x,y,face):
            if self.fail_unit:return None
            if self.forced is not None:return self.forced
            u=self.w.unit(owner);u.update(x=x,y=y,raw=raw,life=Real32(100),hidden=False,paused=False,invulnerable=False)
            self.created.append(u);return u
        env=self.w.natives()
        env.update(PLAYER_NEUTRAL_PASSIVE=15,UNIT_TYPE_HERO='hero',
            IsUnitType=lambda u,t:u.get('is_hero',False),UnitInventorySize=lambda u:6,
            CreateUnit=create,RemoveUnit=lambda u:u.update(raw=u['raw'] if self.refuse_unit else 0),
            ShowUnit=lambda u,v:u.update(hidden=not v),PauseUnit=lambda u,v:u.update(paused=v),
            SetUnitInvulnerable=lambda u,v:u.update(invulnerable=v),
            IsUnitHidden=lambda u:u['hidden'],IsUnitPaused=lambda u:u['paused'],BlzIsUnitInvulnerable=lambda u:u['invulnerable'],
            TriggerSleepAction=lambda seconds:None,
            I2S=str,GetHandleId=id,CreateTimer=lambda:Handle(),TimerStart=lambda t,d,r,c:t.update(callback=c),
            PauseTimer=lambda t:None,DestroyTimer=lambda t:self.timers.append(t),
            IsTriggerEnabled=lambda t:t['enabled'],DisableTrigger=lambda t:t.update(enabled=False),
            EnableTrigger=lambda t:t.update(enabled=True),DisplayTimedTextToPlayer=lambda p,x,y,d,s:self.messages.append(s),
            ClearTextMessages=lambda:None,
            GetUnitX=lambda u:u['x'],GetUnitY=lambda u:u['y'],
            GetRectMinX=lambda r:-1000.,GetRectMinY=lambda r:-1000.,
            GetRectMaxX=lambda r:1000.,GetRectMaxY=lambda r:1000.)
        pieces=[SOURCE.with_name('Forsaken-save-'+m+'.j').read_text(encoding='utf-8') for m in ('life','native','journal','effects','position')]
        self.e=engine(DECL+GLOBALS+'\n'.join(pieces)+probe_source({'fGap':1,'orig':2})+house_probe_source(RUNTIME),env)
        self.e['gg_trg_One']=Handle(enabled=True);self.e['gg_trg_Two']=Handle(enabled=False)
        self.hero=self.w.unit(0,30);self.gaya=self.w.unit(0);self.house=self.w.unit(9);self.house.update(x=300.,y=200.)
        self.e['udg_PlayerHero'][1]=self.hero;self.e['udg_SpiritOfGaya'][1]=self.gaya;self.e['udg_PlayerHouse'][1]=self.house
        self.original=self.w.create('orig',0,0);self.original.update(charges=3,binding=0,owner=0,owned=True,life=Real32(145.25))
        self.house['quick'][5]=self.original

    def guarded_originals(self):
        self.assertTrue(self.e['gg_trg_One']['enabled']);self.assertFalse(self.e['gg_trg_Two']['enabled'])
        self.assertIs(self.house['quick'][5],self.original);self.assertEqual(self.original['raw'],'orig')
        self.assertFalse(self.e['FHT_Busy'])

    def test_exact_failure_and_cleanup_components_are_reported(self):
        for stale,label in ((True,'droppable false toggle getter'),(False,'droppable true toggle getter')):
            self.setUp();self.w.stale_drop=stale;self.e['FHT_Run'](0)
            self.assertIn(label,self.messages[-1])
            self.assertIn('cleanup=yes; originals=yes; release=yes',self.messages[-1])
            self.guarded_originals()
        self.setUp();self.w.clamp_life=80.;self.e['FHT_Run'](0)
        self.assertIn('item life words',self.messages[-1]);self.guarded_originals()

    def test_deferred_house_removal_is_verified_without_manual_retry(self):
        pending=[]
        self.e['RemoveUnit']=lambda u:pending.append(u)
        def frame(seconds):
            for u in pending:u['raw']=0
            pending.clear()
        self.e['TriggerSleepAction']=frame
        self.e['FHT_Run'](0)
        self.assertIn('PASS:',self.messages[-1])
        self.assertTrue(any('deferred cleanup readback' in m for m in self.messages))
        self.assertIsNone(self.e['FHT_Unit'][0]);self.guarded_originals()

    def test_known_house_point_and_actual_bounds_gate(self):
        self.e['FHT_Run'](0)
        self.assertEqual((self.created[-1]['x'],self.created[-1]['y']),(300.,200.))
        self.assertTrue(any('STEP 3: NEXT temporary house allocation inside map' in m for m in self.messages))
        self.setUp();self.house['y']=-1128.
        self.e['FHT_Run'](0)
        self.assertEqual(self.created,[])
        self.assertIn('outside safe playable bounds',self.messages[-1]);self.guarded_originals()

    def test_trace_precedes_native_phases_and_preserves_busy_during_yield(self):
        sleeps=[]
        self.e['TriggerSleepAction']=lambda seconds:sleeps.append((seconds,self.e['FHT_Busy'],self.messages[-1]))
        self.e['FHT_Run'](0)
        self.assertTrue(sleeps)
        self.assertTrue(all(seconds==0.5 and busy for seconds,busy,_ in sleeps))
        trace=[message for _,_,message in sleeps]
        self.assertIn('original inventory journal',trace[0])
        self.assertTrue(any('house placement slot 5' in message for message in trace))
        self.assertIn('trigger restoration',trace[-1])
        self.assertIn('PASS:',self.messages[-1]);self.guarded_originals()

    def test_success_six_slots_and_repeated_cleanup(self):
        before=dict(self.original)
        self.e['FHT_Run'](0);self.assertIn('PASS: six exact house slots',self.messages[-1])
        self.assertEqual(dict(self.original),before);self.assertEqual(self.created[-1]['raw'],0)
        self.assertEqual(self.e['FSN_Count'][0],0);self.assertFalse(self.e['FSJ_Ready'][0]);self.guarded_originals()
        self.e['FHT_Run'](0);self.assertIn('PASS:',self.messages[-1]);self.guarded_originals()

    def test_failed_placement_restores_triggers_and_original_inventory(self):
        self.w.reject_drop=True;self.e['FHT_Run'](0)
        self.assertIn('FAIL at house placement slot 5',self.messages[-1]);self.assertIn('cleanup verified',self.messages[-1])
        self.assertEqual(self.created[-1]['raw'],0);self.guarded_originals()

    def test_failed_item_deletion_retains_retry(self):
        self.w.silent='charges';self.w.callback=lambda:self.w.refuse_delete.update(id(i) for i in self.w.items if i is not self.original)
        self.e['FHT_Run'](0);self.assertIn('cleanup or original readback',self.messages[-1]);self.guarded_originals()
        self.assertIsNotNone(self.e['FHT_Unit'][0]);self.assertTrue(self.e['FSJ_Ready'][0])
        self.w.silent=None;self.w.callback=None;self.w.refuse_delete.clear();self.e['FHT_Retry'](0)
        self.assertIn('PASS: temporary cleanup verified',self.messages[-1]);self.assertIsNone(self.e['FHT_Unit'][0]);self.guarded_originals()

    def test_failed_house_deletion_retains_retry(self):
        self.refuse_unit=True;self.e['FHT_Run'](0);self.assertIsNotNone(self.e['FHT_Unit'][0]);self.guarded_originals()
        self.refuse_unit=False;self.e['FHT_Retry'](0);self.assertIn('PASS: temporary cleanup',self.messages[-1]);self.guarded_originals()

    def test_null_or_original_house_allocation_grants_no_ownership(self):
        for original in (False,True):
            self.setUp();self.fail_unit=not original;self.forced=self.house if original else None
            self.e['FHT_Run'](0);self.assertIn('FAIL at house allocation',self.messages[-1]);self.guarded_originals()
            self.assertNotEqual(self.house['raw'],0);self.assertIsNone(self.e['FHT_Unit'][0])

    def test_watchdog_restores_guard_and_interrupted_scratch(self):
        self.assertTrue(self.e['FSJ_Capture'](0,self.hero,self.gaya,self.house,True))
        self.e['FHT_Busy']=True;self.e['FHT_Player']=0;self.e['FHT_Guard'](True)
        self.e['FSN_Busy'][0]=True;self.e['FSN_Executing'][0]=True;self.e['FSN_Operation'][0]=1
        self.e['TriggerSleepAction']=lambda seconds:self.fail('timer cleanup must not sleep')
        self.e['FHT_Timeout']();self.assertIn('watchdog / interrupted test',self.messages[-1])
        self.assertFalse(self.e['FSN_Busy'][0]);self.assertEqual(self.e['FSN_Operation'][0],0);self.guarded_originals()

    def test_borrowed_original_item_refuses_deletion(self):
        self.assertTrue(self.e['FSJ_Capture'](0,self.hero,self.gaya,self.house,True))
        self.e['FSN_Item'][0]=self.original;self.e['FSN_Count'][0]=1
        self.e['FHT_Guard'](True);self.e['FHT_Busy']=True
        self.e['FHT_Finish'](0,False,'borrowed item');self.assertIn('needs attention',self.messages[-1]);self.guarded_originals()

    def test_concurrent_capture_and_missing_context_refuse_before_allocation(self):
        self.e['FSX_Phase'][7]=1;self.e['FHT_Run'](0);self.assertEqual(self.created,[])
        self.e['FSX_Phase'][7]=0;self.e['udg_PlayerHero'][1]=None;self.e['FHT_Run'](0);self.assertEqual(self.created,[])
        self.guarded_originals()

    def test_guard_generation_is_bounded_deterministic_and_module_list_opt_in(self):
        self.assertEqual(house_probe_source(RUNTIME),house_probe_source(RUNTIME+RUNTIME))
        self.assertIn('FHT_OneGuard(gg_trg_One,0,block)',house_probe_source(RUNTIME))
        with self.assertRaises(ValueError):house_probe_source('')
        with self.assertRaises(ValueError):house_probe_source('\n'.join('trigger gg_trg_T%d=null'%i for i in range(4097)))
        self.assertEqual(len(modules()),3);self.assertEqual(len(modules(True)),8)

    def test_dynamic_trigger_guard_preserves_handles_span_and_disabled_states(self):
        runtime=RUNTIME+'trigger udg_CurseItemTrigger=null\ntrigger array QuestStepTrigger\ntrigger array QuestStepPickupTrigger\nconstant integer QUEST_MAX_STEPS=16\n'
        declarations='globals\n trigger gg_trg_One=null\n trigger gg_trg_Two=null\n trigger udg_CurseItemTrigger=null\n trigger array QuestStepTrigger\n trigger array QuestStepPickupTrigger\n integer QuestCount=1\n constant integer QUEST_MAX_STEPS=16\nendglobals\n'
        e=engine(declarations+house_probe_source(runtime),self.e)
        active=Handle(enabled=True);inactive=Handle(enabled=False);curse=Handle(enabled=True)
        e['gg_trg_One']=Handle(enabled=True);e['gg_trg_Two']=Handle(enabled=False)
        e['udg_CurseItemTrigger']=curse;e['QuestStepTrigger'][17]=active;e['QuestStepPickupTrigger'][17]=inactive
        self.assertTrue(e['FHT_Capacity']());e['FHT_Guard'](True)
        self.assertFalse(active['enabled']);self.assertFalse(curse['enabled']);self.assertEqual(e['FHT_Span'],32)
        e['QuestCount']=3;e['FHT_Guard'](False)
        self.assertTrue(active['enabled']);self.assertTrue(curse['enabled']);self.assertFalse(inactive['enabled'])
        self.assertEqual(e['FHT_Span'],0);e['QuestCount']=255;self.assertFalse(e['FHT_Capacity']())
        with self.assertRaises(ValueError):house_probe_source(runtime+'call TriggerRegisterAnyUnitEventBJ(unknown,EVENT_PLAYER_UNIT_PICKUP_ITEM)\n')
        with self.assertRaises(ValueError):house_probe_source(runtime.replace('QUEST_MAX_STEPS=16','QUEST_MAX_STEPS=17'))

if __name__=='__main__':unittest.main()
