import unittest,sys
from pathlib import Path
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from build_drake80 import BASE,OUT,NEW
from editor_pair import View
from jtok import functions,tokens
from damage_tooltips import merged
from priest_master import fields
from test_shared_context import mocks
from test_armory_materia import execute
class Drake80Tests(unittest.TestCase):
 @classmethod
 def setUpClass(c):c.before=View(BASE);c.after=View(Path(__file__).resolve().parents[2]/"tools/tests/fixtures/historical-maps"/OUT.parent.name/OUT.name);c.fs=functions(c.after.runtime)
 def test_caster_spear_proficiency_scales_both_drake_attacks_once(self):
  s=self.fs['Dragoon80_ScaleDrake']
  for prof in [0,5,15]:
   damage={0:400,1:200};reads=[];e=mocks(s)
   e.update(Prof_GetLevel=lambda caster,raw:reads.append((caster,raw)) or prof,I2R=float,R2I=int,BlzGetUnitBaseDamage=lambda u,slot:damage[slot],BlzSetUnitBaseDamage=lambda u,value,slot:damage.__setitem__(slot,value))
   e=execute(s,['Dragoon80_ScaleDrake'],e);e['Dragoon80_ScaleDrake'](10,20)
   self.assertEqual(damage,{0:int(400*(1+.1*prof)),1:int(200*(1+.1*prof))});self.assertEqual(reads,[(10,'R009')])
  action=self.fs['Trig_Lancer_DragonAlly_Actions'];self.assertEqual(action.count('call Dragoon80_ScaleDrake'),1)
  self.assertLess(action.index('call ConditionalTriggerExecute'),action.index('call Dragoon80_ScaleDrake'))
 def test_tooltip_ranks_and_other_spell_terminology_match(self):
  a=merged(self.after.archive.read('war3map.w3a'),self.after.archive.read('war3mapSkin.w3a'),'w3a')
  tips=[v for (k,rank),v in fields(a['A14G']).items() if k=='aub1'];self.assertEqual(len(tips),11)
  self.assertTrue(all(NEW in s for s in tips))
  for raw in ['A11R','A03M','A1E6','A14D']:
   self.assertNotIn('Spear Technique',str(fields(a[raw])))
 def test_previous_balancing_input_and_other_summons_preserved(self):
  before=functions(self.before.runtime)
  for n,b in before.items():
   if n!='Trig_Lancer_DragonAlly_Actions':self.assertEqual(tokens(b.replace('Spear Technique','Spear Proficiency')),tokens(self.fs[n]),n)
  for name in ['war3map.w3u','war3mapSkin.w3u','war3map.w3t','war3mapSkin.w3t']:
   self.assertEqual(self.before.archive.read(name),self.after.archive.read(name))
if __name__=='__main__':unittest.main()
