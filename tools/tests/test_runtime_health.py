"""Run the maintained projectile, collection and panel paths with counted natives."""
from collections import defaultdict
from pathlib import Path
import sys,unittest
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
sys.path.insert(0,str(Path(__file__).resolve().parents[2]/'experiments/Forsaken'))
from test_save_jass import engine
from test_armory_materia import execute
from test_shared_context import mocks
from performance_runtime import refresh
from jtok import functions
ROOT=Path(__file__).resolve().parents[2]

class RuntimeHealthTests(unittest.TestCase):
    def test_observers_invalidate_only_changed_watched_membership(self):
        helper=(ROOT/'experiments/Forsaken/CollectionCache.j').read_text()
        e=engine(helper,dict(GetHandleId=id,GetPlayerId=lambda p:p,Player=lambda p:p,
            IsPlayerInForce=lambda p,f:p in f,ForceAddPlayer=lambda f,p:f.add(p),
            ForceRemovePlayer=lambda f,p:f.discard(p),ForceClear=lambda f:f.clear()))
        armory=set();titles=set();other=set()
        e['Collection_Watch'](armory,1);e['Collection_Watch'](titles,2)
        e['Collection_ForceAddPlayer'](other,0)
        self.assertEqual(e['CollectionArmoryRevision'][0],0)
        e['Collection_ForceAddPlayerSimple'](0,armory)
        e['Collection_ForceAddPlayerSimple'](0,armory)
        self.assertEqual(e['CollectionArmoryRevision'][0],1)
        e['Collection_ForceRemovePlayer'](armory,0)
        self.assertEqual(e['CollectionArmoryRevision'][0],2)
        e['Collection_ForceAddPlayer'](titles,1);e['Collection_ForceClear'](titles)
        self.assertEqual(e['CollectionTitleRevision'][1],2)
        self.assertEqual(e['CollectionArmoryRevision'][1],0)

    def test_idle_armory_uses_revision_without_rescanning_flags(self):
        s=(ROOT/'src/triggers/05 Items crafting and shops/Armory.j').read_text()
        calls=[]
        e=execute(s,['Armory_PollCounter'],dict(GetPlayerId=lambda p:p,GetLocalPlayer=lambda:0,
             CollectionArmoryRevision=defaultdict(int),ArmoryCounterRevision=-1,
             Armory_RefreshCounter=lambda:calls.append(1)))
        for i in range(100):e['Armory_PollCounter']()
        self.assertEqual(len(calls),1)
        e['CollectionArmoryRevision'][0]+=1;e['Armory_PollCounter']()
        self.assertEqual(len(calls),2)

    def test_idle_chronicles_skip_inventory_and_tooltip_scans(self):
        s=(ROOT/'experiments/Forsaken/ChronicleCache.j').read_text();calls=[]
        env=dict(Player=lambda p:p,GetLocalPlayer=lambda:0,Player_GetHero=lambda p:('h',p),
            udg_SpiritOfGaya=defaultdict(lambda:None),udg_SpeedrunLevel=defaultdict(int),
            Chronicles_CheckInventory=lambda p:calls.append(('inventory',p)),
            Chronicles_RestoreSecrets=lambda p:calls.append(('restore',p)),
            Chronicles_RefreshTooltips=lambda:calls.append(('tooltip',0)))
        for name in ('ChroniclesCachedInventory','ChroniclesCachedTitles','ChroniclesCachedSpeed',
                     'CollectionInventoryRevision','CollectionTitleRevision'):env[name]=defaultdict(int)
        for name in ('ChroniclesCachedHero','ChroniclesCachedSpirit'):env[name]=defaultdict(lambda:None)
        e=execute(s,['Chronicles_Tick'],env)
        e['Chronicles_Tick']();calls.clear()
        for i in range(100):e['Chronicles_Tick']()
        self.assertEqual(calls,[])
        e['CollectionInventoryRevision'][0]+=1;e['Chronicles_Tick']()
        self.assertEqual(calls,[('inventory',0),('restore',0),('tooltip',0)])

    def motion(self,name):
        s=(ROOT/'src/triggers/01 Shared helpers'/f'{name}.j').read_text();env=mocks(s)
        env.update(ATTACK_TYPE_NORMAL=0,MissileTag=defaultdict(int),MissileNoDamage=defaultdict(bool),CreateGroup=lambda:set(),DestroyGroup=lambda g:g.clear(),CreateUnit=lambda *a:object(),
                   TimerStart=lambda *a:None,GetUnitX=lambda u:0.,GetUnitY=lambda u:0.,
                   GetOwningPlayer=lambda u:0,Atan2=lambda *a:0.,AddSpecialEffectTarget=lambda *a:object())
        env['udg_'+name+'FreeHead']=0;env['udg_'+name+'Count']=0;env['udg_'+name+'ActiveCount']=0
        env['udg_'+name+'Next']=defaultdict(int)
        for key in list(env):
            if isinstance(env[key],defaultdict):env[key]=defaultdict(lambda:0)
        selected=[name+'_Allocate',name+'_Free',name+'_Register',name+'_Create']
        selected+=[('Missile_CreateWithEffects' if name=='Missile' else 'Knock_Launch')]
        return execute(s,selected,env)

    def test_projectile_group_survives_final_callback_and_is_freed_once(self):
        e=self.motion('Missile');destroyed=[];seen=[]
        e['DestroyGroup']=lambda g:destroyed.append(g)
        index=e['Missile_Allocate']();group=e['udg_MissileHitGroup'][index]
        def impact(trigger):
            seen.append(e['udg_MissileHitGroup'][index])
            e['Missile_Free'](index) # Reentrant damage hooks cannot free twice.
        e['TriggerEvaluate']=impact
        e['Missile_Free'](index);e['Missile_Free'](index)
        self.assertEqual(seen,[group]);self.assertEqual(destroyed,[group])
        self.assertIsNone(e['udg_MissileHitGroup'][index])
        self.assertEqual(e['Missile_Allocate'](),index)
        self.assertIsNot(e['udg_MissileHitGroup'][index],group)

    def test_exhausted_motion_pools_do_not_register_or_create_objects(self):
        for name in ('Missile','Knock'):
            e=self.motion(name);created=[];e['CreateUnit']=lambda *a:created.append(a)
            e['udg_'+name+'Count']=8190
            for repeat in range(10):self.assertEqual(e[name+'_Allocate'](),0)
            e[name+'_Register'](0)
            self.assertEqual(e['udg_'+name+'Count'],8190)
            self.assertEqual(e['udg_'+name+'ActiveCount'],0)
            if name=='Missile':self.assertEqual(e['Missile_CreateWithEffects']('hero','','',0.,0.),0)
            else:self.assertEqual(e['Knock_Launch']('hero','target',1.,'',False,0.),0)
            self.assertEqual(created,[])

    def native_source(self):
        current=(ROOT/'src/triggers/05 Items crafting and shops/Equip.j').read_text()
        if 'function Forsaken_FindFrame takes' in current:return refresh(current)
        reference=ROOT/'release/pairs/PAIR010/FFERPG-PAIR010-Forsaken.w3x'
        if not reference.exists():self.skipTest('Native panel checks run only in the native profile')
        from editor_pair import View
        return refresh(View(reference).modules['TEquip'])

    def test_native_frames_are_searched_once_then_served_from_cache(self):
        source=self.native_source();calls=[]
        def find(name,context):
            calls.append((name,context))
            return name if context==7 else None
        e=execute(source,['Forsaken_FindFrameUncached','Forsaken_FindFrame'],dict(
            ForsakenPanelClock=1,TimerGetElapsed=lambda t:0.,ForsakenPanelOpen=False,
            ForsakenFrameSearchRequested=True,ForsakenNextFrameRetry=0.,
            ForsakenCachedEquipment=None,ForsakenCachedBackdrop=None,
            BlzGetFrameByName=find,BlzFrameIsVisible=lambda f:False))
        self.assertEqual(e['Forsaken_FindFrame']('SimpleEquipmentPanel'),'SimpleEquipmentPanel')
        self.assertEqual(len(calls),512)
        for i in range(100):
            e['Forsaken_FindFrame']('SimpleEquipmentPanel');e['Forsaken_FindFrame']('EquipmentPanelBackdrop')
        self.assertEqual(len(calls),512)
        self.assertNotIn('Trig_MagicDefense_Calc_Actions',functions(source)['Forsaken_DrawPanels'])
        self.assertNotIn('set udg_',functions(source)['Forsaken_DrawPanels'])
        self.assertEqual(refresh(source),source)

    def test_stat_reads_are_cached_only_for_one_render_pass(self):
        source=self.native_source()
        calls=[];table={}
        env=dict(ForsakenStatReadActive=False,ForsakenStatReadCache=table,
                 HaveSavedInteger=lambda t,p,k:(p,k) in t,LoadInteger=lambda t,p,k:t.get((p,k),0),
                 SaveInteger=lambda t,p,k,v:t.__setitem__((p,k),v),FlushChildHashtable=lambda t,p:t.clear(),
                 Forsaken_StatAbilityLevelUncached=lambda h,r:calls.append((h,r)) or 2)
        e=execute(source,['Forsaken_StatAbilityLevel','Forsaken_RenderStats'],env)
        e['Forsaken_RenderStatsUncached']=lambda h:[e['Forsaken_StatAbilityLevel'](h,123) for _ in range(20)]
        e['Forsaken_RenderStats']('hero');self.assertEqual(calls,[('hero',123)])
        e['Forsaken_RenderStats']('other');self.assertEqual(calls,[('hero',123),('other',123)])
        self.assertFalse(e['ForsakenStatReadActive'])

    def test_maintenance_is_idempotent_for_shared_sources(self):
        for relative in ('01 Shared helpers/Missile.j','01 Shared helpers/Knock.j',
                         '01 Shared helpers/Force.j','05 Items crafting and shops/Armory.j',
                         '09 Player features/Titles.j','03 Jobs and progression/Talents.j'):
            s=(ROOT/'src/triggers'/relative).read_text()
            self.assertEqual(refresh(s),s,relative)

if __name__=='__main__':unittest.main()
