"""Exercise job transactions with hostile scratch callbacks and checkpoint UI rebuilds."""
from pathlib import Path
from collections import defaultdict
import sys,unittest

sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from editor_pair import View
from jtok import functions,tokens
from test_shared_context import mocks
from test_armory_materia import execute
from objdata import read_objects
from priest_master import fields
from session_hotfix56 import job_patch,travel_patch

ROOT=Path(__file__).resolve().parents[2]
BASE=ROOT/'release/development/VersionEHotfix03/FFERPG-0.9.7.5e-Hotfix03-Forsaken.w3x'


class JobTransactionTests(unittest.TestCase):
    def runtime(self):
        source=job_patch(View(BASE).modules['TJob']);env=mocks(source)
        for name,value in list(env.items()):
            if isinstance(value,defaultdict):env[name]=defaultdict(int)
        owners={'old':0,'new':0,'sold':0,'gaya':0};raw={'old':'H000','new':'H001','sold':'H001','gaya':'H01D'}
        removed=[];hidden=[];transferred=[];created=[]
        env.update(udg_PlayerHero=defaultdict(lambda:None,{1:'old',2:'other'}),udg_SpiritOfGaya={1:'gaya'},
            JobSwitchBusy=defaultdict(bool),JobSwitchItems=defaultdict(lambda:None),
            udg_SummonUnit=defaultdict(lambda:None),udg_FreelancerHero=defaultdict(lambda:None),
            GetSoldUnit=lambda:'sold',GetBuyingUnit=lambda:'gaya',GetOwningPlayer=lambda unit:owners.get(unit,0),
            GetPlayerId=lambda p:p,GetConvertedPlayerId=lambda p:p+1,Player=lambda p:p,
            Player_GetHero=lambda p:live['udg_PlayerHero'][p+1],GetUnitTypeId=lambda u:raw.get(u,''),
            RemoveUnit=lambda u:removed.append(u),IsUnitHiddenBJ=lambda u:u in hidden,
            Job_GetSavedLevel=lambda *args:99,IsPlayerInForce=lambda *args:False,
            GetUnitAbilityLevel=lambda *args:0,GetUnitAbilityLevelSwapped=lambda *args:0,
            GetUnitLifePercent=lambda u:100.,GetUnitManaPercent=lambda u:100.,GetUnitFacing=lambda u:90.,
            GetUnitX=lambda u:1.,GetUnitY=lambda u:2.,GetUnitLoc=lambda u:'old-position',
            GetPlayerStartLocationLoc=lambda p:'start',UnitItemInSlotBJ=lambda *args:None,
            GetItemTypeId=lambda item:0,GetItemCharges=lambda item:0,ShowUnitHide=lambda u:hidden.append(u),
            GetHeroXP=lambda u:0,GetHandleIdBJ=lambda u:1,IsUnitType=lambda *args:False,
            Player_NEUTRAL_PASSIVE=15,PLAYER_NEUTRAL_PASSIVE=15,bj_UNIT_FACING=90.,bj_REMOVEBUFFS_ALL=0,
            bj_HEROSTAT_STR=0,bj_HEROSTAT_AGI=1,bj_HEROSTAT_INT=2,bj_MODIFYMETHOD_SET=0,bj_MODIFYMETHOD_SUB=0,
            UNIT_TYPE_SUMMONED='summoned',Group_UnitsOfPlayer=lambda *args:[],
            Forsaken_TransferSharedInventory=lambda a,b:transferred.append((a,b)),
            Gaya_RecreateSpirit=lambda *args:self.fail('job change replaced Gaya'))
        def interfere(*args):
            live.update(udg_TempPlayer=1,udg_TempInteger=8,udg_NewHero='gaya',udg_SelectedJobId='Hbad',
                bj_forLoopAIndex=99,bj_forLoopAIndexEnd=0,udg_HeroLoc='corrupted')
        def owner(unit,p,*args):owners[unit]=p;interfere()
        def gethero(*args):created.append(args);interfere();return 'new'
        env.update(SetUnitOwner=owner,Job_GetHero=gethero,ConditionalTriggerExecute=interfere,TriggerExecute=interfere)
        live=execute(source,['Trig_Job_Change_Actions','Trig_Job_Change_FilterSummoned'],env)
        return live,owners,removed,hidden,transferred,created

    def test_gaya_buyer_and_player_hero_survive_nested_scratch_mutations(self):
        env,owners,removed,hidden,transferred,created=self.runtime()
        env['Trig_Job_Change_Actions']()
        self.assertEqual(env['udg_PlayerHero'][1],'new')
        self.assertEqual(env['udg_PlayerHero'][2],'other')
        self.assertEqual(env['udg_SpiritOfGaya'][1],'gaya')
        self.assertEqual(removed,['sold'])
        self.assertIn('old',hidden);self.assertNotIn('gaya',hidden)
        self.assertEqual(owners['old'],15);self.assertEqual(owners['new'],0)
        self.assertEqual(transferred,[('old','new')]);self.assertEqual(len(created),1)
        self.assertFalse(env['JobSwitchBusy'][0])

    def test_reentrant_purchase_does_not_release_outer_lock_or_spawn_more_jobs(self):
        env,owners,removed,hidden,transferred,created=self.runtime()
        def gethero(*args):
            created.append(args)
            env['Trig_Job_Change_Actions']()
            self.assertTrue(env['JobSwitchBusy'][0])
            return 'new'
        env['Job_GetHero']=gethero
        env['Trig_Job_Change_Actions']()
        self.assertEqual(len(created),1);self.assertFalse(env['JobSwitchBusy'][0])
        self.assertEqual(env['udg_PlayerHero'][1],'new')

    def test_summon_cleanup_never_kills_gaya(self):
        env,*_=self.runtime()
        env['GetFilterUnit']=lambda:'gaya';env['IsUnitType']=lambda *args:True
        self.assertFalse(env['Trig_Job_Change_FilterSummoned']())
        env['GetFilterUnit']=lambda:'summon'
        self.assertTrue(env['Trig_Job_Change_FilterSummoned']())


class RecoveryPackagingTests(unittest.TestCase):
    def test_all_native_builds_have_silence_immune_inventory_and_checkpoint_rebuild(self):
        for path in ['release/development/VersionEHotfix04/FFERPG-0.9.7.5e-Hotfix04-Forsaken.w3x',
                     'release/development/QuickUI56/FFERPG-QuickUI56-Forsaken.w3x']:
            v=View(ROOT/path);f=functions(v.runtime)
            self.assertIn('ExecuteFunc("TravelPanel_Rebuild")',f['ForsakenUI_Rebuild'])
            self.assertNotIn('DestroyTimer',f['TravelPanel_Init'])
            self.assertIn('DestroyTrigger(TravelPanelKeys)',f['TravelPanel_Init'])
            self.assertIn('TravelVisible[pid] and GetLocalPlayer()==Player(pid)',f['TravelPanel_Init'])
            self.assertIn('TravelPanel_Start',f['Register_Travel_Dialog_Click'])
            self.assertNotIn('Gaya_RecreateSpirit(',f['Job_GetHero'])
            self.assertNotIn('set udg_PlayerHero[udg_TempInteger]',f['Trig_Job_Change_Actions'])
            for name in ('war3map.w3a','war3mapSkin.w3a'):
                table=read_objects(v.archive.read(name),'w3a')
                obj=next(o for group in ('original','custom') for o in table[group] if (o['id'] or o['base'])=='ASpc')
                self.assertEqual(fields(obj)[('aite',0)],1)

    def test_ui56_preserves_confirmed_cast_and_icon_functions(self):
        a=functions(View(ROOT/'release/development/QuickUI55/FFERPG-QuickUI55-Forsaken.w3x').runtime)
        b=functions(View(ROOT/'release/development/QuickUI56/FFERPG-QuickUI56-Forsaken.w3x').runtime)
        targeted={'QuickGear_InitPreviews','QuickGear_ClearPreview','QuickGear_MovePreview','QuickGear_Request',
            'QuickGear_Reset','QuickGear_WheelTick','QuickGear_Receive','QuickGear_InitDiagnostics','QuickGear_Diagnostic'}
        for name,body in a.items():
            if name.startswith(('QuickGear_','Wave_','DG_','Cuts_','Aqua_')):
                if name not in targeted:self.assertEqual(tokens(body),tokens(b[name]),name)

    def test_release_line_does_not_include_new_jobs_or_cuts(self):
        v=View(ROOT/'release/development/VersionEHotfix04/FFERPG-0.9.7.5e-Hotfix04-Forsaken.w3x')
        f=functions(v.runtime)
        self.assertFalse(any(n.startswith(('DG_','Cuts_')) for n in f))
        self.assertIn('QuickGear_RepaintIcons',f)


class TravelCheckpointTests(unittest.TestCase):
    def test_load_replaces_listeners_recreates_frames_and_restores_open_page_once(self):
        source=travel_patch(View(BASE).modules['TTravel']);env=mocks(source)
        active={'old-click','old-keys','old-sync'};destroyed=[];rendered=[];serial=[0]
        def create():
            serial[0]+=1;value='trigger'+str(serial[0]);active.add(value);return value
        def destroy(value):active.remove(value);destroyed.append(value)
        env.update(TravelPanel='stale-frame',TravelPanelTitle='stale-title',TravelPanelButton=defaultdict(lambda:None),
            TravelPanelClicks='old-click',TravelPanelKeys='old-keys',TravelPanelSync='old-sync',
            TravelEscapeEpoch=defaultdict(int),TravelVisible=defaultdict(bool,{0:True}),TravelPage=defaultdict(int,{0:1}),
            CreateTrigger=create,DestroyTrigger=destroy,Player=lambda pid:pid,GetLocalPlayer=lambda:0,
            BlzCreateFrame=lambda name,*args:name+str(serial[0]),BlzGetOriginFrame=lambda *args:'game-ui',
            ORIGIN_FRAME_GAME_UI=0,FRAMEPOINT_CENTER=0,FRAMEPOINT_TOP=0,FRAMEEVENT_CONTROL_CLICK=1,OSKEY_ESCAPE=27,
            ConvertOsKeyType=lambda key:key,TravelPanel_Render=lambda owner:rendered.append(owner),
            DestroyTimer=lambda *args:self.fail('rebuild destroyed caller timer'),
            BlzDestroyFrame=lambda *args:self.fail('rebuild touched a stale saved frame'))
        env=execute(source,['TravelPanel_Init','TravelPanel_Rebuild'],env)
        env['TravelPanel_Rebuild']()
        self.assertEqual(destroyed,['old-click','old-keys','old-sync'])
        self.assertEqual(len(active),3);self.assertEqual(rendered,[0])
        self.assertEqual(env['TravelPage'][0],1);self.assertTrue(env['TravelVisible'][0])
        self.assertEqual(env['TravelEscapeEpoch'][0],1)
        env['TravelPanel_Rebuild']()
        self.assertEqual(len(active),3);self.assertEqual(len(destroyed),6)
        self.assertEqual(rendered,[0,0]);self.assertEqual(env['TravelEscapeEpoch'][0],2)


if __name__=='__main__':unittest.main()
