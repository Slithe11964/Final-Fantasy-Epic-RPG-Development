"""Legendary constructors, active/cache swaps, and shrine bonus transitions."""
import sys,unittest
from pathlib import Path
from collections import defaultdict
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from editor_pair import View
from mpq import MPQ
from jtok import functions,tokens
from test_armory_materia import execute
from test_shared_context import mocks
import test_session_hotfix56 as fixture
ROOT=Path(__file__).resolve().parents[2]
CHOICES={5:'A0T9',6:'A0P9',7:'A0PA',8:'A0RF',9:'A0RG'}
MAPS=['release/0.9.7.5f/FFERPG-0.9.7.5f-Forsaken.w3x',
      'release/0.9.7.5f/FFERPG-0.9.7.5f-1.29.2.w3x',
      'release/development/QuickUI69/FFERPG-QuickUI69-Forsaken.w3x']
def script(path):return MPQ(str(ROOT/path)).read('war3map.j').decode().replace('\r\n','\n')

class LegendaryStatsTests(unittest.TestCase):
    def transaction(self,source,choice=4):
        env,owners,*_=fixture.JobTransactionTests().runtime()
        stats={'old':[500,400,300],'new':[110,110,110]};abilities=set()
        env.update(GetUnitAbilityLevelSwapped=lambda raw,u:choice if raw=='A02F' else 0,
            GetUnitAbilityLevel=lambda u,raw:choice if raw=='A02F' else 0,
            udg_MasteryBonusAbility=CHOICES,GetHeroLevel=lambda u:99,
            bj_MODIFYMETHOD_ADD=0,bj_MODIFYMETHOD_SUB=1,
            ModifyHeroStat=lambda k,u,op,n:stats[u].__setitem__(k,stats[u][k]+(n if op==0 else -n)),
            UnitAddAbilityBJ=lambda raw,u:abilities.add((u,raw)),
            UnitRemoveAbilityBJ=lambda raw,u:abilities.discard((u,raw)))
        e=execute(source,['Trig_Job_Change_Actions'],env)
        return e,stats,abilities,owners

    def test_previous_job_activation_double_applied_already_constructed_stats(self):
        old=script('release/development/VersionEHotfix16/FFERPG-0.9.7.5e-Hotfix16-Forsaken.w3x')
        e,stats,*_=self.transaction(old);e['Trig_Job_Change_Actions']()
        self.assertEqual(stats['old'],[490,390,290]);self.assertEqual(stats['new'],[120]*3)

    def test_all_profiles_keep_stat_choice_on_cached_hero_and_no_activation_stack(self):
        for path in MAPS:
            e,stats,abilities,owners=self.transaction(script(path));before={k:v[:] for k,v in stats.items()}
            e['Trig_Job_Change_Actions']();self.assertEqual(stats,before,path)
            e['Job_GetHero']=lambda *a:'old'
            raw={'old':'H000','new':'H001','sold':'H000','gaya':'H01D'}
            e['GetUnitTypeId']=lambda u:raw.get(u,'')
            e['Trig_Job_Change_Actions']();self.assertEqual(stats,before,path)
            self.assertEqual(e['udg_PlayerHero'][1],'old')

    def test_all_five_passive_choices_still_restore_on_entering_job(self):
        for choice,ability in CHOICES.items():
            for path in MAPS:
                e,stats,abilities,owners=self.transaction(script(path),choice)
                abilities.add(('old',ability));e['Trig_Job_Change_Actions']()
                self.assertNotIn(('old',ability),abilities);self.assertIn(('new',ability),abilities)
                self.assertEqual(stats['new'],[110]*3)

    def test_shrine_switches_all_choices_and_repeated_selection_cannot_stack_stats(self):
        for path in MAPS:
            fs=functions(script(path))
            source='\n'.join(b for n,b in fs.items() if n.startswith('Trig_Shrine_AbilitySwap_'))
            env=mocks(source)
            state=dict(choice=4,rank=4);stats=[110]*3;abilities=set()
            env.update(GetSoldUnit=lambda:'sold',GetTriggerUnit=lambda:'shop',
                GetUnitTypeId=lambda u:'n0KM' if u=='shop' else 'n0KN',
                GetUnitPointValue=lambda u:state['choice'],GetOwningPlayer=lambda u:0,
                Player_GetHero=lambda p:'hero',GetUnitName=lambda u:'hero' if u=='hero' else 'bonus',
                Force_OfPlayer=lambda p:'force',GetUnitAbilityLevelSwapped=lambda raw,u:state['rank'],
                SetUnitAbilityLevelSwapped=lambda raw,u,n:state.update(rank=n),
                udg_MasteryBonusAbility=CHOICES,bj_HEROSTAT_STR=0,bj_HEROSTAT_AGI=1,bj_HEROSTAT_INT=2,
                bj_MODIFYMETHOD_ADD=0,bj_MODIFYMETHOD_SUB=1,
                ModifyHeroStat=lambda k,u,op,n:stats.__setitem__(k,stats[k]+(n if op==0 else -n)),
                UnitAddAbilityBJ=lambda raw,u:abilities.add(raw),UnitRemoveAbilityBJ=lambda raw,u:abilities.discard(raw))
            e=execute(source,[n for n in fs if n.startswith('Trig_Shrine_AbilitySwap_')],env)
            for choice,ability in CHOICES.items():
                state['choice']=choice;e['Trig_Shrine_AbilitySwap_Actions']()
                self.assertEqual(stats,[100]*3);self.assertIn(ability,abilities)
                e['Trig_Shrine_AbilitySwap_Actions']();self.assertEqual(stats,[100]*3)
                state['choice']=4;e['Trig_Shrine_AbilitySwap_Actions']()
                self.assertEqual(stats,[110]*3);self.assertNotIn(ability,abilities)
                e['Trig_Shrine_AbilitySwap_Actions']();self.assertEqual(stats,[110]*3)

    def test_loaded_legendary_default_includes_exactly_100_mastery_stats(self):
        for path in MAPS:
            source=functions(script(path))['FFL_PrepareHero']
            env=mocks(source);stats=[10]*3;rank={};levels={}
            env.update(FFL_Val=lambda p,s,k:1 if (s,k)==(4,14) else 0,ModuloInteger=lambda a,b:a%b,
                UnitInventorySize=lambda h:6,BlzUnitExtendedInventorySize=lambda h:30,SaveSlots_BagSize=lambda h:30,
                UnitAddAbility=lambda h,r:rank.update({r:1}),UnitMakeAbilityPermanent=lambda *a:None,
                GetUnitAbilityLevel=lambda h,r:rank.get(r,0),SetUnitAbilityLevel=lambda h,r,n:rank.update({r:n}),
                FFL_SetHeroLevel=lambda h,n:levels.update({h:n}),GetHeroLevel=lambda h:levels.get(h,1),
                GetHeroStr=lambda h,b:stats[0],GetHeroAgi=lambda h,b:stats[1],GetHeroInt=lambda h,b:stats[2],
                SetHeroStr=lambda h,n,b:stats.__setitem__(0,n),SetHeroAgi=lambda h,n,b:stats.__setitem__(1,n),
                SetHeroInt=lambda h,n,b:stats.__setitem__(2,n),FFL_Learn=lambda *a:True,
                udg_JobSkill=defaultdict(lambda:'Ajob'))
            e=execute(source,['FFL_PrepareHero'],env)
            self.assertTrue(e['FFL_PrepareHero'](0,'hero',1,99,3),path)
            self.assertEqual(stats,[110]*3,path);self.assertEqual(rank['A02F'],4)

    def test_release_job_content_is_retained_and_save_codecs_unchanged(self):
        native=View(ROOT/MAPS[0]);before=View(ROOT/'release/development/VersionEHotfix16/FFERPG-0.9.7.5e-Hotfix16-Forsaken.w3x')
        self.assertFalse(any(n.startswith('DG_') or n.startswith('Cuts_') for n in functions(native.runtime)))
        for key in ['war3map.w3u','war3map.w3a','war3map.w3t']:
            self.assertEqual(before.archive.read(key),native.archive.read(key))
        current=functions(native.runtime)
        for n,b in functions(before.runtime).items():
            if n.startswith(('Save_','FFL_','FSC_','FSR_','FSS_')):
                self.assertEqual(tokens(b),tokens(current[n]),n)

if __name__=='__main__':unittest.main()
