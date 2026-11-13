"""Dragon hero targeting, nearby-combat summons and native Mastery visibility."""
import sys,unittest
from pathlib import Path
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from build_f1030_inventory_rollback import view
from build_forest86 import ROOT,functions,all_objects
from creatures_v19 import refresh,objects,HERO,DRAGONS
from priest_master import fields
from test_armory_materia import execute
from test_shared_context import mocks

class Creature19Tests(unittest.TestCase):
 @classmethod
 def setUpClass(c):
  c.v=view(str(ROOT/'release/development/V18/FFERPG-V18.w3x'))
  c.source=refresh('TMonsterData',c.v.modules['TMonsterData'],True);c.fs=functions(c.source)
 def dragon(self,raw,ready,accepted=True):
  orders=[];search=[];e=mocks(DRAGONS)
  e.update(GetUnitTypeId=lambda u:raw,IsUnitIllusion=lambda u:False,
   A19_FindHero=lambda u,r:search.append(r) or 'hero',Forest86_Ready=lambda u,a,c:a in ready,
   GetUnitX=lambda u:750.,GetUnitY=lambda u:0.,M2_Food=lambda u:'food',
   IssuePointOrder=lambda *a:orders.append(a) or accepted,
   IssueTargetOrder=lambda *a:orders.append(a) or True,IssueImmediateOrder=lambda *a:orders.append(a) or True)
  e=execute(DRAGONS,['M2_AI'],e);e['M2_AI']('dragon','pet');return orders,search
 def test_all_four_dragon_breaths_choose_hero_at_native_800_range(self):
  for raw,spell in [('n03H','kOB2'),('n03G','kLB2'),('n03E','kWB2'),('n03F','kFB2')]:
   orders,search=self.dragon(raw,{spell});self.assertEqual(search,[800.]);self.assertEqual(orders,[('dragon','breathoffire',750.,0.)])
 def test_black_dragon_offense_precedes_buff_and_rejected_breath_falls_back(self):
  orders,_=self.dragon('n03H',{'kOB2','kOF2','kDV2','kES2'});self.assertEqual(len(orders),1);self.assertEqual(orders[0][1],'breathoffire')
  orders,_=self.dragon('n03H',{'kOB2','kOF2'},False);self.assertEqual(orders[-1],('dragon','thunderbolt','hero'))
 def forest(self,raw,enemy,ready=()):
  source=self.fs['F99_AI'];e=mocks(source);orders=[]
  e.update(GetUnitTypeId=lambda u:raw,D2_FindEnemy=lambda u,r:enemy,A19_FindHero=lambda u,r:'hero',
   IsUnitIllusion=lambda u:False,F99_Active=lambda *a:False,GetHandleId=lambda u:1,
   LoadInteger=lambda *a:0,F99Data=1,Forest86_Ready=lambda u,a,c:a in ready,
   UNIT_TYPE_HERO=1,IsUnitType=lambda u,t:u=='hero',
   IssueTargetOrder=lambda *a:orders.append(a) or True,IssuePointOrder=lambda *a:orders.append(a) or True,
   IssueImmediateOrder=lambda *a:orders.append(a) or True)
  e=execute(source,['F99_AI'],e);e['F99_AI']('unit','pet');return orders
 def test_shadowdancer_finds_hero_even_if_shared_target_was_pet(self):
  self.assertEqual(self.forest('nsts','enemy',{'zCL9'}),[('unit','shadowstrike','hero')])
 def test_all_ancient_summoner_ai_stops_without_enemy_inside_2000(self):
  for raw in ['n00P','nenc','n010','nsth','qS99','qI99','n00N']:
   self.assertFalse(self.forest(raw,None,{'zDY9','zSY9','zEN9','zEG9','zIF9','zCV9'}),raw)
 def test_hero_search_ignores_closer_pet_and_illusion(self):
  e=mocks(HERO);units=['pet','illusion','hero'];released=[]
  e.update(CreateGroup=lambda:units[:],GetUnitX=lambda u:{'caster':0.,'pet':100.,'illusion':200.,'hero':750.}[u],
   GetUnitY=lambda u:0.,GroupEnumUnitsInRange=lambda *a:None,FirstOfGroup=lambda g:g[0] if g else None,
   GroupRemoveUnit=lambda g,u:g.remove(u),Forest86_Enemy=lambda *a:True,UNIT_TYPE_HERO=1,
   IsUnitType=lambda u,t:u!='pet',IsUnitIllusion=lambda u:u=='illusion',IsUnitHidden=lambda u:False,
   DestroyGroup=lambda g:released.append(True))
  e=execute(HERO,['A19_FindHero'],e);self.assertEqual(e['A19_FindHero']('caster',800.),'hero');self.assertEqual(released,[True])
 def test_rooted_summons_require_near_enemy_and_do_not_catch_up_in_bursts(self):
  source=self.fs['F99_TickUnit']
  for distance,expected in [(2000.,1),(2001.,0)]:
   e=mocks(source);children=[];schedule=[]
   e.update(GetEnumUnit=lambda:'tree',GetHandleId=lambda u:1,GetUnitTypeId=lambda u:'n00P',Forest86_Alive=lambda u:True,
    F99Data=1,LoadInteger=lambda *a:0,LoadBoolean=lambda *a:False,LoadReal=lambda h,i,k:5. if k==11 else 0.,
    HaveSavedReal=lambda h,i,k:k==10,Forest86Now=10.,F99_Active=lambda u,k:k==10,F99_ExpireStacks=lambda *a:None,
    D2_FindEnemy=lambda u,r:'enemy' if distance<=r else None,F99_Summon=lambda *a:children.append(a) or 'child',
    GetUnitX=lambda u:0.,GetUnitY=lambda u:0.,SaveReal=lambda h,i,k,n:schedule.append((k,n)))
   e=execute(source,['F99_TickUnit'],e);e['F99_TickUnit']();self.assertEqual(len(children),expected)
   self.assertIn((11,15.),schedule)
 def test_native_mastery_hide_field_uses_data_d_for_all_legendary_choices(self):
  for p in ['release/development/V18/FFERPG-V18.w3x','release/development/GRecovery07/FFERPG-0.9.7.5g-Recovery07.w3x','release/development/GRecovery07/FFERPG-0.9.7.5g-1.29.2-Recovery07.w3x']:
   v=view(str(ROOT/p));u,a=objects(v,p.startswith('release/development/V'))
   f=fields(a['A02F']);self.assertEqual(f['Ihid',1],1)
   for rank in range(5,10):
    m=next(m for st in a['A02F']['sets'] for m in st['mods'] if m['field']=='Ihid' and m['level']==rank)
    self.assertEqual((m['value'],m['data']),(0,4))

if __name__=='__main__':unittest.main()
