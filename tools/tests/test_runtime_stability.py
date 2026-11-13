"""Execute completion, visitor isolation, cooldown starts and failed-load recovery."""
from pathlib import Path
from collections import defaultdict
import sys,unittest
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from runtime_stability import refresh
from job_runtime import refresh as job_refresh
from types import SimpleNamespace
from jtok import functions
from test_shared_context import mocks
from test_armory_materia import execute
ROOT=Path(__file__).resolve().parents[2]

class StabilityTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        names=['Armory','Title','Cooldown','OmegaWeapon','Quest_OmegaWeapon','Spell_TerraBreak','ForsakenFreshLoad','ForsakenSaveFreshObjects']
        modules={}
        import re
        for name in names:
            source=next((ROOT/'src/triggers').rglob(name+'.j')).read_text()
            modules[re.match(r'library (\w+)',source)[1]]=source
        cls.view=SimpleNamespace(modules=modules)
    def test_idempotent_all_affected_modules(self):
        for native in [False,True]:
            for lib,source in self.view.modules.items():
                updated=refresh(source,native=native)
                self.assertEqual(updated,refresh(updated,native=native),lib)
    def armory(self):
        s=refresh(self.view.modules['TArmory'],native=True);env=mocks(s)
        flags=defaultdict(set);titles=defaultdict(set,{35:{0,1}});awards=[]
        env.update(ArmoryMissingUnit=defaultdict(int,{i:i for i in range(1,281)}),
            udg_SaveFlagCount=358,udg_SaveFlagForce=flags,udg_TitleForce=titles,udg_TempPlayer=7,udg_TempInteger=99,
            IsPlayerInForce=lambda p,f:p in f,gg_trg_Title_Grant='grant')
        e=execute(s,['Armory_CheckCompletion'],env)
        def award(t):
            owner=e['udg_TempPlayer'];title=e['udg_TempInteger'];awards.append((owner,title));titles[title].add(owner)
        e['ConditionalTriggerExecute']=award
        return s,e,flags,titles,awards
    def test_only_catalog_items_count_and_completion_remains_after_withdrawal(self):
        s,e,flags,titles,awards=self.armory()
        for i in range(1,280):flags[i].add(0)
        for i in range(281,359):flags[i].add(0)
        e['Armory_CheckCompletion'](0);self.assertFalse(awards)
        flags[280].add(0);e['Armory_CheckCompletion'](0)
        self.assertEqual(awards,[(0,56)]);self.assertEqual((e['udg_TempPlayer'],e['udg_TempInteger']),(7,99))
        flags[10].remove(0);e['Armory_CheckCompletion'](0)
        self.assertIn(0,titles[56]);self.assertEqual(len(awards),1)
        e['Armory_CheckCompletion'](1);self.assertNotIn(1,titles[56])
    def test_visitors_use_their_own_shop_and_cannot_withdraw(self):
        s,e,flags,titles,awards=self.armory();state=dict(viewer=0,selected='house1');shops={};shown=[];selections=[];created=[];positions=[]
        e.update(Player=lambda p:p,GetPlayerId=lambda p:p,GetTriggerPlayer=lambda:state['viewer'],
            GetTriggerUnit=lambda:state['selected'],GetOwningPlayer=lambda u:1 if u=='house1' else 2,
            udg_PlayerHouse={2:'house1',3:'locked'},Player_GetHero=lambda p:'hero'+str(p),
            udg_ArmoryUnit=defaultdict(lambda:None),ArmoryViewOwner=defaultdict(int),
            GetUnitX=lambda u:500. if u=='house1' else -1000.,GetUnitY=lambda u:700. if u=='house1' else -900.,SetUnitPosition=lambda u,x,y:positions.append((u,x,y)),SetUnitVertexColor=lambda *a:None,Collection_ForceAddPlayerSimple=lambda p,f:f.add(p),
            ForceAddPlayerSimple=lambda p,f:f.add(p),ShowUnit=lambda *a:None,Armory_ShowCategory=lambda *a:shown.append(a),
            SelectUnitForPlayerSingle=lambda *a:selections.append(a),GetPlayerName=lambda p:str(p),DisplayTimedTextToPlayer=lambda *a:None)
        def create(p,raw,x,y,facing):
            created.append((p,x,y));return shops.setdefault(p,'shop'+str(p))
        e['CreateUnit']=create
        e=execute(s,['Armory_VisitHouse'],e);e['Armory_VisitHouse']()
        self.assertEqual(e['ArmoryViewOwner'][1],2);self.assertEqual(selections,[('shop0',0)])
        state['viewer']=2;e['Armory_VisitHouse']()
        self.assertEqual(e['ArmoryViewOwner'][3],2);self.assertEqual(e['udg_ArmoryUnit'][1],'shop0')
        self.assertEqual(created,[(0,500.,700.),(2,500.,700.)])
        self.assertEqual(positions,[('shop0',500.,700.),('shop2',500.,700.)])
        e['Armory_VisitHouse']()
        self.assertEqual(len(created),2,'repeat browsing reuses the existing interface at the house')
        before={k:set(v) for k,v in flags.items()};stock=[]
        e.update(GetConvertedPlayerId=lambda p:p+1,GetOwningPlayer=lambda u:0,
            GetTriggerUnit=lambda:'shop0',GetSoldUnit=lambda:'stock',BlzGetUnitMaxMana=lambda u:12,
            ArmoryCategory={1:12},udg_ItemIdTable={12:'gear'},ArmoryHint={12:'hint'},
            ShowUnitHide=lambda *a:None,UnitApplyTimedLifeBJ=lambda *a:None,
            GetObjectName=lambda r:r,CreateItemLoc=lambda *a:self.fail('visitor withdrew item'),
            Armory_ShowCategory=lambda *a:stock.append(a))
        e=execute(s,['Trig_Armory_Select_Actions'],e);e['Trig_Armory_Select_Actions']()
        self.assertEqual(stock,[('shop0',12)]);self.assertEqual(before,dict(flags))
    def test_first_and_subsequent_cooldowns_update_the_running_timer(self):
        s=refresh(self.view.modules['TCooldown'],native=True);duration={};running={};e=mocks(s)
        e.update(BlzSetUnitAbilityCooldown=lambda u,r,l,d:duration.__setitem__((u,r,l),d),
            BlzStartUnitAbilityCooldown=lambda u,r,d:running.__setitem__((u,r),d),RMaxBJ=max,IMaxBJ=max,GetSpellAbility=lambda:None,GetTriggerEventId=lambda:'effect',EVENT_PLAYER_UNIT_SPELL_EFFECT='effect',SharedItemCD_IsItem=lambda raw:False,NativeCD_Queue=lambda u,r,d,c:running.__setitem__((u,r),d))
        e=execute(s,['Cooldown_ApplyCurrent'],e)
        for rank in [0,3,10]:
            for raw,base in [('spell',60.),('item',30.)]:
                for scale in [.5,.75,1.]:
                    running['hero',raw]=base
                    e['Cooldown_ApplyCurrent']('hero',raw,rank,base*scale)
                    self.assertEqual(running['hero',raw],base*scale)
                    self.assertEqual(duration['hero',raw,rank],base*scale)
    def test_classic_prepares_at_cast_before_engine_starts_cooldown(self):
        s=refresh(self.view.modules['TCooldown'],native=False)
        fs=functions(s)
        self.assertNotIn('BlzStartUnitAbilityCooldown',fs['Cooldown_ApplyCurrent'])
        self.assertIn('EVENT_PLAYER_UNIT_SPELL_CAST',fs['Register_Cooldown_Scaling'])
        self.assertIn('EVENT_PLAYER_UNIT_SPELL_EFFECT',fs['Register_Cooldown_Scaling'])

    def test_omega_proxy_remains_visible_and_rotation_stops_before_more_orders(self):
        src=job_refresh(self.view.modules['TSpellTerraBreak'],native=True);e=mocks(src);orders=[];hidden=[]
        e.update(GetSpellTargetUnit=lambda:None,GetSpellTargetLoc=lambda:'point',
            CreateNUnitsAtLocFacingLocBJ=lambda *a:None,GetLastCreatedUnit=lambda:'proxy',
            GetHandleIdBJ=lambda u:7,GetTriggerUnit=lambda:'omega',GetOwningPlayer=lambda u:11,
            ShowUnitHide=lambda u:hidden.append(u),IssuePointOrderLocBJ=lambda *a:orders.append(a),
            UNIT_STATE_MANA=1,UNIT_STATE_MAX_MANA=2,GetUnitState=lambda *a:100.,SetUnitState=lambda *a:None)
        e=execute(src,['Trig_Spell_TerraBreak_Actions','Trig_Spell_TerraBreak_Cond_NoTargetUnit'],e)
        e['Trig_Spell_TerraBreak_Actions']();self.assertFalse(hidden);self.assertEqual(orders,[('proxy','blizzard','point')])
        src=refresh(self.view.modules['TOmegaWeapon']);life=[1000.];orders=[]
        e=mocks(src);e.update(gg_unit_N022_0125='omega',GetWidgetLife=lambda u:life[0],
            GetUnitLoc=lambda u:'point',Group_UnitsInRangeOfLoc=lambda *a:'group',
            Trig_OmegaWeapon_SpellRotation_Cond_CanCastLightning=lambda:True,
            IssueTargetOrderBJ=lambda *a:orders.append(a),GroupPickRandomUnit=lambda g:'hero',
            Wait_Polled=lambda t:life.__setitem__(0,0.))
        e=execute(src,['Trig_OmegaWeapon_SpellRotation_Actions'],e);e['Trig_OmegaWeapon_SpellRotation_Actions']()
        self.assertEqual(len(orders),1)
    def test_cleanup_command_recovers_incomplete_phases_but_never_live_committed_hero(self):
        src=refresh(self.view.modules['TForsakenFreshLoad']);body=functions(src)['FFL_Chat']
        # Execute the real command with unrelated routing predicates disabled.
        phase=defaultdict(int);snap=defaultdict(bool);allocated=defaultdict(int);capture=defaultdict(int);calls=[]
        e=mocks(src);e.update(GetTriggerPlayer=lambda:0,GetPlayerId=lambda p:p,
            GetEventPlayerChatString=lambda:'-newcleanup',FSC_PlayerValid=lambda p:True,
            FSS_Equals=lambda a,b:a==b,FSS_SubString=lambda s,a,b:s[a:b],FSS_Length=len,
            FSS_Lower=lambda s:s.lower(),StringCase=lambda s,b:s.lower(),
            FFL_Phase=phase,FFN_State=allocated,FFL_SnapshotTaken=snap,FRC_Phase=capture,
            FFL_Message=lambda *a:calls.append('message'),FFL_Fail=lambda *a:calls.append('restore'),
            FRC_Stop=lambda *a:calls.append('stop'),FFL_RoutesFile=lambda s:False)
        e=execute(src,['FFL_Chat'],e)
        for value in [4,5,6]:
            phase[0]=value;allocated[0]=1;snap[0]=True;capture[0]=1;calls.clear();e['FFL_Chat']()
            self.assertEqual(calls,['stop','restore'])
        phase[0]=0;allocated[0]=0;snap[0]=False;capture[0]=0;calls.clear();e['FFL_Chat']()
        self.assertEqual(calls,['message'])

class ImportRecoveryTests(unittest.TestCase):
    def fixture(self):
        sys.path.insert(0,str(ROOT/'experiments/Forsaken'))
        import test_fresh_load as fresh
        from unittest.mock import patch
        original=fresh.engine
        def adapted(source,env):
            env=dict(env,Armory_CheckCompletion=lambda p:None)
            return original(refresh(source,native=True),env)
        fixture=fresh.FreshLoadTests()
        with patch.object(fresh,'engine',adapted):fixture.setUp()
        return fixture
    def test_existing_cleanup_and_readback_paths(self):
        for name in ['test_stopped_validation_times_out_without_changing_character',
                     'test_stopped_creation_times_out_and_restores_starter',
                     'test_starter_is_hidden_during_load_and_shown_again_on_failure',
                     'test_leftover_player_heroes_are_retired_on_commit']:
            f=self.fixture();getattr(f,name)()
    def test_stopped_apply_and_readback_restore_original_without_visible_duplicate(self):
        for phase in [6,3]:
            f=self.fixture();e=f.e;starter=e['udg_PlayerHero'][1];gaya=e['udg_SpiritOfGaya'][1]
            self.assertTrue(f.apply(),f.messages)
            e['FFL_Phase'][0]=phase;e['FFL_Started'][0]=0
            e['TimerGetElapsed']=lambda timer:61.
            e['FFL_Tick']()
            self.assertIs(e['udg_PlayerHero'][1],starter);self.assertIs(e['udg_SpiritOfGaya'][1],gaya)
            self.assertEqual(e['FFL_Phase'][0],0)
            self.assertTrue(all(u['raw']==0 or not u.get('visible',True) for u in f.f.units))
    def test_partial_armory_load_preserves_saved_completion_title(self):
        import save_vnext as codec
        f=self.fixture();envelope=codec.decode(f.f.base.encoded);sections=[]
        for section in envelope.sections:
            if section.id==7:
                flags=dict(codec.read_pairs(section.payload));flags[35]=1;flags[56]=1
                section=codec.Section(section.id,section.version,section.required,codec.pairs(sorted(flags.items())))
            sections.append(section)
        f.f.base.encoded=codec.encode(codec.Envelope(envelope.account_hash,tuple(sections)))
        self.assertTrue(f.apply(),f.messages);f.finish();f.e['FFL_Tick']()
        self.assertTrue(f.e['udg_HasLoadedCode'][0],f.messages)
        self.assertIn(0,f.e['udg_TitleForce'][56])
        saved=codec.decode(f.e['FRC_Result'][0]);titles=next(s for s in saved.sections if s.id==7)
        self.assertEqual(dict(codec.read_pairs(titles.payload))[56],1)

if __name__=='__main__':unittest.main()
