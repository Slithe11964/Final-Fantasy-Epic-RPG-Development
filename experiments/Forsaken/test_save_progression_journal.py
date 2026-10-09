"""Execute live progression JASS with faulting native mocks; no Warcraft claims."""
import json
import unittest

from test_save_jass import engine, SOURCE, ROOT
from test_save_life import LIFE
from test_save_native import NATIVE
from test_save_position import JOURNAL, EFFECTS, POSITION, SPACER, Handle
from test_save_equipment import EQUIPMENT, RING_FILLER
from test_save_recovery import RECOVERY, RecoveryWorld

PROGRESSION=SOURCE.with_name('Forsaken-save-progression.j')
SCALARS=['CodeDifficulty','NewGamePlusLevel','MiracleStage','MetaFragments',
         'SpeedrunLevel','ArmoryItemCount','TotalJobLevel','HighestJobLevel','ArmoryCodeSegment']
DECLARATIONS='''
globals
    integer array udg_JobUnitType
    integer udg_JobCount
    integer udg_SaveFlagCount
    integer udg_Difficulty
    integer udg_SpeedrunTitleBase
    boolean udg_SpeedrunMode
    boolean udg_HardcoreOff
    boolean udg_GameRunning
    boolean array udg_HasLoadedCode
    force array udg_TitleForce
    force array udg_SaveFlagForce
    force udg_LegendaryGuardianForce
    force udg_CheaterForce
    hashtable udg_JobLevelHash
    hashtable udg_JobHeroHash
'''+''.join('    integer array udg_'+name+'\n' for name in SCALARS)+'endglobals\n'


class ProgressionWorld(RecoveryWorld):
    def __init__(self):
        super().__init__()
        self.resources={(pid,k):pid*100+k for pid in (0,7) for k in range(3)}
        self.techs={}
        self.writes=[]
        self.reject=0
        self.write_callback=None

    def allow(self,kind,key):
        self.writes.append((kind,key))
        if self.write_callback: self.write_callback()
        return len(self.writes)!=self.reject

    def resource(self,pid,key,value):
        if self.allow('resource',(pid,key)): self.resources[pid,key]=value

    def research(self,pid,key,value):
        if self.allow('research',(pid,key)): self.techs[pid,key]=value

    def member(self,force,pid,add):
        if self.allow('force',(id(force),pid)):
            if add: force['members'].add(pid)
            else: force['members'].discard(pid)

    def integer(self,table,parent,key,value):
        if self.allow('integer',(parent,key)): table[parent,key]=value
        return True  # Readback must catch even a lying setter.

    def remove_integer(self,table,parent,key):
        if self.allow('remove_integer',(parent,key)): table.pop((parent,key),None)

    def natives(self):
        env=super().natives()
        env.update(PLAYER_STATE_RESOURCE_GOLD=0,PLAYER_STATE_RESOURCE_LUMBER=1,
            PLAYER_STATE_RESOURCE_FOOD_USED=2,
            GetPlayerState=lambda p,k:self.resources.get((p,k),0),SetPlayerState=self.resource,
            GetPlayerTechCount=lambda p,k,s:self.techs.get((p,k),0),SetPlayerTechResearched=self.research,
            IsPlayerInForce=lambda p,f:p in f['members'],
            ForceAddPlayer=lambda f,p:self.member(f,p,True),ForceRemovePlayer=lambda f,p:self.member(f,p,False),
            HaveSavedInteger=lambda t,p,k:(p,k) in t,LoadInteger=lambda t,p,k:t.get((p,k),0),
            SaveInteger=self.integer,RemoveSavedInteger=self.remove_integer,
            LoadUnitHandle=lambda t,p,k:t.get((p,k)),
            GetHeroXP=lambda u:u['xp'],GetHeroLevel=lambda u:u['level'],
            GetUnitAbilityLevel=lambda u,r:u['mastery'])
        return env


class ProgressionTests(unittest.TestCase):
    def setUp(self):
        self.w=ProgressionWorld()
        self.e=engine(DECLARATIONS+'\n'.join(p.read_text() for p in
            [LIFE,NATIVE,JOURNAL,EFFECTS,POSITION,EQUIPMENT,RECOVERY,PROGRESSION]),self.w.natives())
        self.e.update(udg_JobCount=22,udg_SaveFlagCount=358,udg_Difficulty=6,udg_SpeedrunTitleBase=60,
                      udg_HardcoreOff=True,udg_GameRunning=True,
                      udg_JobLevelHash=Handle(),udg_JobHeroHash=Handle())
        for i in range(22): self.e['udg_JobUnitType'][i]=self.e['FPG_JobRaw'](i)
        for pid in (0,7):
            for i,name in enumerate(SCALARS):
                self.e['udg_'+name][pid if name=='ArmoryCodeSegment' else pid+1]=i*3+pid
            for i in range(18): self.w.techs[pid,self.e['FPG_TechRaw'](i)]=i%4
            for i in range(22):
                if i%3: self.e['udg_JobLevelHash'][self.e['FPG_JobRaw'](i),pid]=i
        self.e['udg_MiracleStage'][0]=-1
        for i in (0,14,52,59,65): self.e['udg_TitleForce'][i]=Handle(members={7,9} if i%2 else {0,9})
        for i in (0,358,507,540): self.e['udg_SaveFlagForce'][i]=Handle(members={0,9})
        self.e['udg_LegendaryGuardianForce']=Handle(members={0,9})
        self.e['udg_CheaterForce']=Handle(members={7,9})
        self.hero,self.gaya,self.house=self.w.unit(bag=30),self.w.unit(),self.w.unit(9)
        self.table={}

    def capture(self,pid=0):
        self.hero['owner']=pid
        self.gaya['owner']=pid
        self.assertTrue(self.e['FSJ_Capture'](pid,self.hero,self.gaya,self.house,True))
        self.assertTrue(self.e['FQR_Begin'](pid,self.table))
        return self.e['FPG_Begin'](pid)

    def mutate(self,pid=0):
        for name in SCALARS: self.e['udg_'+name][pid if name=='ArmoryCodeSegment' else pid+1]=777
        self.e['udg_HasLoadedCode'][pid]=True
        for k in range(3): self.w.resources[pid,k]=999
        for i in range(18): self.w.techs[pid,self.e['FPG_TechRaw'](i)]=9
        for i in range(644):
            force=self.e['FPG_LiveForce'](i)
            if force is not None:
                if pid in force['members']: force['members'].discard(pid)
                else: force['members'].add(pid)
        for i in range(22): self.e['udg_JobLevelHash'][self.e['FPG_JobRaw'](i),pid]=777

    def item_recover(self,pid=0):
        return self.e['FQR_Recover'](pid,SPACER,RING_FILLER,30)

    def test_read_only_capture_and_exact_recovery(self):
        self.assertTrue(self.capture())
        self.assertEqual(self.w.writes,[])
        other=dict(self.e['udg_JobLevelHash'])
        other={k:v for k,v in other.items() if k[1]==7}
        self.mutate()
        self.assertFalse(self.e['FPG_Verify'](0))
        self.assertTrue(self.e['FPG_Recover'](0))
        self.assertTrue(self.e['FPG_Verify'](0))
        self.assertEqual({k:v for k,v in self.e['udg_JobLevelHash'].items() if k[1]==7},other)
        self.assertTrue(all(9 in self.e['FPG_LiveForce'](i)['members'] for i in range(644)
                            if self.e['FPG_LiveForce'](i) is not None))

    def test_every_native_write_failure_blocks_and_retries(self):
        self.assertTrue(self.capture())
        self.mutate()
        self.assertTrue(self.e['FPG_Recover'](0))
        count=len(self.w.writes)
        self.assertEqual(count,54)  # 3 resources,18 research,11 groups,22 job keys.
        for fault in range(1,count+1):
            with self.subTest(fault=fault):
                self.mutate()
                self.w.writes=[]
                self.w.reject=fault
                self.assertFalse(self.e['FPG_Recover'](0))
                self.assertEqual(self.e['FPG_State'][0],3)
                self.assertTrue(self.e['FSN_ProgressionBlocked'][0])
                self.assertFalse(self.e['FSN_Begin'](0))
                self.assertFalse(self.e['FSJ_Release'](0))
                self.w.reject=0
                self.assertTrue(self.e['FPG_Recover'](0))

    def test_missing_zero_job_key_is_not_created(self):
        self.e['udg_JobLevelHash'][self.e['FPG_JobRaw'](0),0]=0
        self.assertTrue(self.capture())
        self.mutate()
        self.assertTrue(self.e['FPG_Recover'](0))
        self.assertIn((self.e['FPG_JobRaw'](0),0),self.e['udg_JobLevelHash'])
        self.assertNotIn((self.e['FPG_JobRaw'](3),0),self.e['udg_JobLevelHash'])

    def test_player7_bounds_and_release_order(self):
        self.assertTrue(self.capture(7))
        self.assertEqual(max(self.e['FPG_Force']),5151)
        self.mutate(7)
        self.assertTrue(self.e['FPG_Recover'](7))
        self.assertFalse(self.e['FPG_Release'](7))
        self.assertTrue(self.item_recover(7))
        self.assertTrue(self.e['FQR_Release'](7))
        self.assertFalse(self.e['FSN_Begin'](7))
        self.assertFalse(self.e['FSJ_Release'](7))
        self.assertTrue(self.e['FPG_Release'](7))
        self.assertTrue(self.e['FSJ_Release'](7))
        self.assertTrue(self.e['FSN_Begin'](7))
        self.assertIsNone(self.e['FPG_LevelTable'][7])
        self.assertTrue(all(f is None for f in self.e['FPG_Force'].values()))

    def test_progression_release_does_not_clear_item_block(self):
        self.assertTrue(self.capture())
        self.mutate()
        self.assertTrue(self.e['FPG_Recover'](0))
        self.assertTrue(self.item_recover())
        self.assertTrue(self.e['FPG_Release'](0))
        self.assertFalse(self.e['FSN_Begin'](0))
        self.assertFalse(self.e['FSJ_Release'](0))
        self.assertTrue(self.e['FQR_Release'](0))
        self.assertTrue(self.e['FSJ_Release'](0))

    def test_shared_context_changes_refuse_before_writes(self):
        self.assertTrue(self.capture())
        for name in ('udg_Difficulty','udg_JobCount','udg_SaveFlagCount','udg_SpeedrunMode','udg_HardcoreOff','udg_GameRunning','udg_SpeedrunTitleBase'):
            with self.subTest(name=name):
                old=self.e[name]
                self.e[name]=not old if isinstance(old,bool) else old+1
                self.w.writes=[]
                self.assertFalse(self.e['FPG_Recover'](0))
                self.assertEqual(self.w.writes,[])
                self.e[name]=old
        self.e['udg_MiracleStage'][0]=3
        self.assertFalse(self.e['FPG_Recover'](0))
        self.assertEqual(self.e['udg_MiracleStage'][0],3)

    def test_replaced_tables_or_force_refuse_without_overwrite(self):
        self.assertTrue(self.capture())
        for name in ('udg_JobLevelHash','udg_JobHeroHash','udg_CheaterForce'):
            old=self.e[name]
            self.e[name]=Handle(members=set()) if name.endswith('Force') else Handle()
            self.w.writes=[]
            self.assertFalse(self.e['FPG_Recover'](0))
            self.assertEqual(self.w.writes,[])
            self.e[name]=old

    def test_changed_hero_level_mastery_or_owner_is_boundary(self):
        unit=self.w.unit()
        unit.update(raw=self.e['FPG_JobRaw'](0),xp=1234,level=18,mastery=3)
        self.e['udg_JobHeroHash'][unit['raw'],0]=unit
        self.assertTrue(self.capture())
        for key in ('raw','owner','xp','level','mastery'):
            old=unit[key]
            unit[key]=old+'X' if isinstance(old,str) else old+1
            self.w.writes=[]
            self.assertFalse(self.e['FPG_Recover'](0))
            self.assertEqual(self.w.writes,[])
            unit[key]=old
        self.assertTrue(self.e['FPG_Recover'](0))

    def test_replaced_hero_refuses(self):
        self.assertTrue(self.capture())
        self.e['udg_JobHeroHash'][self.e['FPG_JobRaw'](0),0]=self.w.unit()
        self.assertFalse(self.e['FPG_Recover'](0))
        self.assertEqual(self.w.writes,[])

    def test_invalid_player_roster_and_bounds(self):
        for pid in (-1,8,8192):
            for method in ('FPG_Begin','FPG_Recover','FPG_Verify','FPG_Release'):
                self.assertFalse(self.e[method](pid))
        self.e['udg_JobCount']=23
        self.assertFalse(self.capture())
        self.e['udg_JobCount']=22
        self.e['udg_SaveFlagCount']=541
        self.assertFalse(self.e['FPG_Begin'](0))
        self.e['udg_SaveFlagCount']=358
        self.e['udg_JobUnitType'][0]=123
        self.assertFalse(self.e['FPG_Begin'](0))
        self.assertEqual(self.w.writes,[])

    def test_null_tables_and_recapture_rejected(self):
        table=self.e['udg_JobLevelHash']
        self.e['udg_JobLevelHash']=None
        self.assertFalse(self.capture())
        self.e['udg_JobLevelHash']=table
        self.assertTrue(self.e['FPG_Begin'](0))
        self.assertFalse(self.e['FPG_Begin'](0))

    def test_reentrant_operations_cannot_mutate_journal(self):
        self.assertTrue(self.capture())
        self.mutate()
        def callback():
            for name in ('FPG_Recover','FPG_Begin','FPG_Release','FPG_Verify','FSN_Begin','FSJ_Release'):
                self.assertFalse(self.e[name](0))
            self.assertFalse(self.item_recover())
        self.w.write_callback=callback
        self.assertTrue(self.e['FPG_Recover'](0))

    def test_aliased_groups_preserve_other_players(self):
        shared=self.e['udg_TitleForce'][0]
        self.e['udg_SaveFlagForce'][540]=shared
        self.assertTrue(self.capture())
        shared['members'].discard(0)
        self.assertTrue(self.e['FPG_Recover'](0))
        self.assertEqual(shared['members'],{0,9})

    def test_all644_force_positions_and_null_identity(self):
        for i in range(101): self.e['udg_TitleForce'][i]=Handle(members={i%2,9})
        for i in range(541): self.e['udg_SaveFlagForce'][i]=Handle(members={i%2,9})
        self.assertTrue(self.capture())
        before=[set(self.e['FPG_LiveForce'](i)['members']) for i in range(644)]
        self.mutate()
        self.assertTrue(self.e['FPG_Recover'](0))
        self.assertEqual([set(self.e['FPG_LiveForce'](i)['members']) for i in range(644)],before)
        self.e['udg_TitleForce'][1]=None
        self.w.writes=[]
        self.assertFalse(self.e['FPG_Recover'](0))
        self.assertEqual(self.w.writes,[])

    def test_original_item_failure_keeps_both_journals(self):
        item=self.w.create(1100,0.,0.)
        item['owned']=True
        self.hero['quick'][0]=item
        self.assertTrue(self.capture())
        self.assertTrue(self.e['FQR_Quarantine'](0))
        self.mutate()
        self.assertTrue(self.e['FPG_Recover'](0))
        self.w.reject_add=1
        self.assertFalse(self.item_recover())
        self.assertFalse(self.e['FPG_Release'](0))
        self.assertTrue(self.e['FSJ_ProgressionPending'][0])
        self.assertTrue(self.e['FSJ_RecoveryPending'][0])
        self.w.reject_add=0
        self.assertTrue(self.item_recover())
        self.assertIs(self.hero['quick'][0],item)
        self.assertTrue(self.e['FPG_Release'](0))
        self.assertTrue(self.e['FQR_Release'](0))

    def test_busy_stage_prevents_progression_capture(self):
        self.assertTrue(self.e['FSJ_Capture'](0,self.hero,self.gaya,self.house,True))
        self.assertTrue(self.e['FQR_Begin'](0,self.table))
        self.e['FSN_Busy'][0]=True
        self.assertFalse(self.e['FPG_Begin'](0))
        self.assertFalse(self.e['FSJ_ProgressionPending'][0])
        self.assertEqual(self.e['FPG_State'][0],0)

    def test_fault_after_success_prevents_release(self):
        self.assertTrue(self.capture())
        self.assertTrue(self.e['FPG_Recover'](0))
        self.assertTrue(self.item_recover())
        self.w.resources[0,0]+=1
        self.assertFalse(self.e['FPG_Release'](0))
        self.assertTrue(self.e['FSJ_ProgressionPending'][0])
        self.assertTrue(self.e['FPG_Recover'](0))
        self.assertTrue(self.e['FPG_Release'](0))

    def test_actual_frozen_job_and_research_mapping(self):
        registry=json.loads(SOURCE.with_name('save-identities.json').read_text())
        # The existing source harness represents four-character literals as strings.
        raw=lambda code:code
        self.assertEqual([self.e['FPG_JobRaw'](i) for i in range(22)],
                         [raw(j['rawcode']) for j in registry['jobs']])
        layout=json.loads(SOURCE.with_name('legacy-layouts.json').read_text())
        self.assertEqual([self.e['FPG_TechRaw'](i) for i in range(15)],
                         [raw(r) for r in layout['upgrades'].values()])
        variables=json.loads((ROOT/'src/variables.json').read_text())
        types={v['name']:v['type'] for v in variables}
        for name in SCALARS: self.assertEqual(types['udg_'+name],'integer array')
        self.assertEqual(types['udg_HasLoadedCode'],'boolean array')

    def test_source_crlf_and_no_world_or_unit_reconstruction(self):
        data=PROGRESSION.read_bytes()
        self.assertNotIn(b'\n',data.replace(b'\r\n',b''))
        text=data.decode()
        self.assertNotIn('initializer',text)
        for name in ('CreateUnit','RemoveUnit','SetHeroLevel','SetHeroXP','UnitAddAbility','UnitRemoveAbility','DestroyForce','FlushChildHashtable','ResetCooldown'):
            self.assertNotIn('call '+name,text)
        self.assertNotIn('set udg_Difficulty',text)
        self.assertNotIn('set udg_MiracleStage[0]',text)


if __name__=='__main__': unittest.main()
