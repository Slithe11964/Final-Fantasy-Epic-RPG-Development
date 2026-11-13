"""Native mastery recognition, real damage steps, and regional balance scope."""
import sys,re,unittest
from pathlib import Path
from collections import defaultdict
from unittest.mock import patch
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from build_f1030_inventory_rollback import view
from build_forest86 import ROOT,functions,tokens,all_objects
from creatures_v18 import CHOICES,refresh,mastery
from priest_master import fields
from test_armory_materia import execute
from test_shared_context import mocks

class Creature18Tests(unittest.TestCase):
 @classmethod
 def setUpClass(c):
  c.base=view(str(ROOT/'release/development/V17/FFERPG-V17.w3x'))
  c.modules={lib:refresh(lib,s,True) for lib,s in c.base.modules.items()}
  c.fs={n:b for s in c.modules.values() for n,b in functions(s).items()}
 def lookup(self,choice):
  src=self.fs['Forsaken_ElementAbilityLevel'];e=mocks(src);abilities={'A02F':choice,CHOICES.get(choice,''):1}
  e.update(GetUnitAbilityLevel=lambda u,r:abilities.get(r,0) if u=='hero' else 0,
   GetOwningPlayer=lambda u:0,Player_GetHero=lambda p:'hero',GetUnitTypeId=lambda u:'H000',
   LoadBoolean=lambda h,p,k:p==0 and k in CHOICES.values(),ForsakenElementSources=1,
   Forsaken_ActiveGear=lambda *a:None,BlzGetItemEquipmentType=lambda i:0,EQUIPMENT_TYPE_NONE=0,
   Forsaken_ActiveAbilityLevel=lambda *a:0)
  return execute(src,['Forsaken_ElementAbilityLevel'],e),abilities
 def test_all_five_choices_recognized_without_gear_and_old_choice_removed(self):
  for choice,raw in CHOICES.items():
   e,a=self.lookup(choice);self.assertEqual(e['Forsaken_ElementAbilityLevel']('hero',raw),1)
   a['A02F']=4;a.pop(raw);self.assertEqual(e['Forsaken_ElementAbilityLevel']('hero',raw),0)
 def damage(self,choice,step,ratio,physical=False,magical=False,target=False):
  name='Trig_Damage_Engine_Step'+step;source=self.fs[name];e=mocks(source)
  for k in list(e):
   if callable(e[k]):e[k]=lambda *a:0
   elif isinstance(e[k],defaultdict):e[k]=defaultdict(int)
  for n in set(re.findall(r'(DmgCtx_\w+)\[',source)):e[n]=defaultdict(int)
  for constant in set(re.findall(r'\b[A-Z][A-Z0-9_]+\b',source)):
   e.setdefault(constant,constant)
  e.update(DmgCtx_Amount={0:100.},DmgCtx_Source={0:'enemy' if target else 'hero'},DmgCtx_Target={0:'hero' if target else 'enemy'},
   DmgCtx_Physical={0:physical},DmgCtx_Magical={0:magical},DmgCtx_NoCrit={0:True},
   UNIT_STATE_LIFE=0,UNIT_STATE_MAX_LIFE=1,GetUnitState=lambda u,s:(ratio*100 if s==0 else 100),
   GetRandomReal=lambda *a:16.,GetRandomInt=lambda *a:100,
   Forsaken_ElementAbilityLevel=lambda u,r:1 if u=='hero' and r==CHOICES[choice] else 0)
  # The quest harness assumes integer division. These damage steps use real
  # HP ratios and spread, so preserve JASS real division in this test only.
  import test_quest_lifecycle as harness
  original=harness.expression
  with patch.object(harness,'expression',lambda s:original(s).replace('//','/')):
   e=execute(source,[name],e)
  e[name](0);return e['DmgCtx_Amount'][0]
 def test_real_damage_steps_apply_all_five_bonuses(self):
  self.assertAlmostEqual(self.damage(5,'15_RandomSpread',.3,physical=True,target=True),50.)
  self.assertAlmostEqual(self.damage(5,'15_RandomSpread',.31,physical=True,target=True),100.)
  for choice,step,ratio,expected,phys,magic in [(6,'16_PhysicalHit',1.,150.,True,False),(7,'16_PhysicalHit',.3,200.,True,False),(8,'17_Magic',1.,150.,False,True),(9,'17_Magic',.3,200.,False,True)]:
   self.assertAlmostEqual(self.damage(choice,step,ratio,phys,magic),expected,msg=str((choice,step)))
 def test_forest_removed_highroad_and_arena_retained(self):
  from build_removals91 import pool_blocks
  b=self.fs['Trig_Spawn_Pools_Init_Actions'];blocks=list(pool_blocks(b))
  self.assertTrue(all("'nspb'" not in m[0] for m,day,zone in blocks if zone==1))
  self.assertTrue(any("'nspb'" in m[0] for m,day,zone in blocks if zone==5))
  for lib in self.modules:
   if 'Arena' in lib:self.assertEqual(tokens(self.base.modules[lib]),tokens(self.modules[lib]))
 def test_balanced_damage_and_badge_feature_removed_only(self):
  self.assertIn('B88_Damage(caster,u,300.,true)',self.fs['H90_Whirl'])
  self.assertIn('set udg_LiquidSteelDmg[d]=120.',self.fs['Trig_Spell_LiquidSteel_Actions'])
  s='\n'.join(self.modules.values());self.assertNotIn('D7Badge',s);self.assertNotIn('D7_Badge',s)
  for n in ['I2_AddSlow','Forest86_OnAttack','D7_SpellFactor','F99_Binding']:
   if n in functions(self.base.runtime):self.assertEqual(tokens(self.fs[n]),tokens(functions(self.base.runtime)[n]),n)

if __name__=='__main__':unittest.main()
