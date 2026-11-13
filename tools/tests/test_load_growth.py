"""Loaded Holy Swordsman must match the ordinary job-switch growth path."""
from pathlib import Path
from collections import defaultdict
import sys,unittest
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from test_chronicles_secrets import runtime
from test_armory_materia import execute
from jtok import functions
ROOT=Path(__file__).resolve().parents[2]
class LoadGrowthTests(unittest.TestCase):
 def test_load_matches_job_switch_and_repeat_refresh_does_not_stack(self):
  for ng in [0,1,10]:
   with self.subTest(ng=ng):
    e=runtime();stats={h:[100,80,60] for h in ['loaded','switched']};abilities=defaultdict(int);damage=defaultdict(lambda:10);armor=defaultdict(float);current=['loaded']
    source=(ROOT/'src/triggers/09 Player features/Title.j').read_text()+'\n'+(ROOT/'src/triggers/03 Jobs and progression/Hero_EndlessGrowth.j').read_text()+'\n'+(ROOT/'src/triggers/12 Save system/ForsakenFreshLoad.j').read_text()
    source=source.replace("udg_TempInteger>'d'","udg_TempInteger>100")
    groups=defaultdict(set)
    e.update(udg_TitleStatsBlocked=defaultdict(bool),udg_BonusGroup=groups,udg_CheaterForce=set(),udg_NewGamePlusLevel={1:ng},udg_SpeedrunMode=False,udg_JobCount=0,udg_FreelancerHero=defaultdict(lambda:None),PLAYER_STATE_RESOURCE_FOOD_USED=0,gg_trg_JobLevels_Init='jobs',udg_JobLevelTimer=None,
      Player=lambda p:p,Player_GetHero=lambda p:current[0],GetHeroLevel=lambda u:99,GetConvertedPlayerId=lambda p:p+1,GetUnitTypeId=lambda u:'H00M',
      GetHeroStr=lambda u,b:stats[u][0],GetHeroAgi=lambda u,b:stats[u][1],GetHeroInt=lambda u,b:stats[u][2],SetHeroStr=lambda u,v,b:stats[u].__setitem__(0,v),SetHeroAgi=lambda u,v,b:stats[u].__setitem__(1,v),SetHeroInt=lambda u,v,b:stats[u].__setitem__(2,v),
      bj_HEROSTAT_STR=0,bj_HEROSTAT_AGI=1,bj_HEROSTAT_INT=2,bj_MODIFYMETHOD_ADD=0,bj_MODIFYMETHOD_SUB=1,
      ModifyHeroStat=lambda k,u,op,v:stats[u].__setitem__(k,stats[u][k]+(v if op==0 else -v)),I2R=float,R2I=int,
      GetUnitAbilityLevelSwapped=lambda raw,u:abilities[u,raw],UnitAddAbilityBJ=lambda raw,u:abilities.__setitem__((u,raw),1),SetUnitAbilityLevelSwapped=lambda raw,u,v:abilities.__setitem__((u,raw),v),
      IsUnitInGroup=lambda u,g:u in g,GroupAddUnitSimple=lambda u,g:g.add(u),BlzGetUnitBaseDamage=lambda u,i:damage[u,i],BlzSetUnitBaseDamage=lambda u,v,i:damage.__setitem__((u,i),v),BlzGetUnitArmor=lambda u:armor[u],BlzSetUnitArmor=lambda u,v:armor.__setitem__(u,v),
      SetPlayerState=lambda *a:None,EnableTrigger=lambda *a:None,StartTimerBJ=lambda *a:None,FFL_RestoreChronicles=lambda *a:None)
    for i in [1,4,21,36]:e['udg_TitleForce'][i].add(0)
    names=[n for n in functions(source) if n.startswith('Trig_Title_ApplyStats_') or n.startswith('Trig_Hero_EndlessGrowth_') or n=='FFL_RestoreUnlocks']
    e=execute(source,names,e)
    e['ConditionalTriggerExecute']=lambda t:e['Trig_Title_ApplyStats_Actions']() if t=='stats' and e['Trig_Title_ApplyStats_Conditions']() else None
    e['udg_TempPlayer']=7;e['udg_TempInteger']=47
    e['FFL_RestoreUnlocks'](0)
    self.assertEqual((e['udg_TempPlayer'],e['udg_TempInteger']),(7,47))
    after=tuple(stats['loaded']);other_damage=damage['loaded',0];other_armor=armor['loaded']
    current[0]='switched';e['udg_TempPlayer']=0;e['Trig_Hero_EndlessGrowth_Actions']()
    self.assertEqual(tuple(stats['switched']),after)
    self.assertEqual(damage['switched',0],other_damage);self.assertEqual(armor['switched'],other_armor)
    current[0]='loaded';e['Trig_Hero_EndlessGrowth_Actions']()
    self.assertEqual(tuple(stats['loaded']),after)
    self.assertEqual(damage['loaded',0],other_damage);self.assertEqual(armor['loaded'],other_armor)
    self.assertGreater(after[0],100)
if __name__=='__main__':unittest.main()
