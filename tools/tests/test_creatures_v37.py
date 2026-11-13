"""Checks for independent venom, cone damage, and complete arena placement."""
import json
import math
from pathlib import Path
import re
import sys
import unittest

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
from arena_roster37 import data_for
from build_forest86 import all_objects
from creature_objects37 import STATS
from editor_pair import View
from jtok import functions, tokens
from priest_master import fields
from test_armory_materia import execute
from test_v2 import env

ROOT = Path(__file__).resolve().parents[2]
DEVELOPMENT = ROOT/'release/development'

class CreatureV37Tests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.map = View(DEVELOPMENT/'V37/FFERPG-V37.w3x')
        cls.functions = functions(cls.map.runtime)

    def run_jass(self, names, **overrides):
        script='\n'.join(self.functions[name] for name in names)
        state=env(script)
        state.update(overrides)
        return execute(script,names,state)

    def test_breaths_apply_correct_damage_and_element_only_inside_cone(self):
        locations={1:(0,0),2:(800,300),3:(800,301),4:(-100,0),5:(801,0)}
        hits=[]
        state=self.run_jass(['V37_Breath'],GetUnitX=lambda unit:locations[unit][0],
                            GetUnitY=lambda unit:locations[unit][1],
                            GroupEnumUnitsInRange=lambda group,*args:group.update(locations),
                            Forest86_Enemy=lambda source,target:source!=target,
                            V37_LightningBreath=lambda *args:None,V37_Fx=lambda *args:None,
                            Atan2=math.atan2,Cos=math.cos,Sin=math.sin,RAbsBJ=abs,bj_RADTODEG=180/math.pi,
                            M89_Damage=lambda *args:hits.append(args))
        for raw,damage,element in [('kOB2',5000,7),('kLB2',4000,3),('kWB2',4000,6),('kFB2',4000,1)]:
            hits.clear()
            state['V37_Breath'](1,800,0,raw)
            self.assertEqual(hits,[(1,2,damage,element)])

    def test_hydras_keep_independent_venom_and_expire_on_tenth_tick(self):
        hits=[]
        state=self.run_jass(['V37_Dot','V37_DotTick'],V37Data={},V37Dots={},V37Serial=0,
                            V37Poison=set(),GetEnumUnit=lambda:3,GetUnitTypeId=lambda unit:unit,
                            ATTACK_TYPE_NORMAL=0,DAMAGE_TYPE_MAGIC=0,
                            UnitDamageTarget=lambda source,victim,amount,*args:hits.append((source,amount)))
        state['V37_Dot'](1,3,350.,10,1)
        state['V37_Dot'](2,3,230.,10,1)
        for second in range(1,12):
            state['Forest86Now']=float(second)
            state['V37_DotTick']()
        self.assertEqual(hits.count((1,350.)),10)
        self.assertEqual(hits.count((2,230.)),10)
        self.assertEqual(len(hits),20)
        self.assertFalse(state['V37Dots'])
        self.assertFalse(state['V37Poison'])

    def test_binding_poison_releases_at_twenty_and_does_not_spawn_per_hit_dummy(self):
        released=[]
        state=self.run_jass(['F99_AddStack','F99_ClearStack'],GetUnitTypeId=lambda unit:unit,
                            V37_Dot=lambda *args:released.append(args),
                            F99_Dummy=lambda *args:self.fail('Per-hit slow dummy'))
        for _ in range(19):
            state['F99_AddStack'](1,2,2,60.)
        self.assertEqual(state['F99Data'][2,108],19)
        self.assertEqual(released,[])
        state['F99_AddStack'](1,2,2,60.)
        self.assertEqual(released,[(1,2,0.,5,2)])
        self.assertNotIn((2,108),state['F99Data'])
        self.assertFalse(state['F99Stacks'])

    def test_published_unit_stats_match_in_each_map_and_arena_has_every_team(self):
        old=View(DEVELOPMENT.parent/'build-inputs/FFERPG-V36.w3x')
        old_functions=functions(old.runtime)
        for name in old_functions:
            if name.startswith(('Trig_Arena_','FFL_','FRC_','FSC_','FST_')):
                self.assertEqual(tokens(old_functions[name]),tokens(self.functions[name]),name)
        for path in ['V37/FFERPG-V37.w3x','CreatureReview03t/FFERPG-Creature-Review-03t.w3x','ArenaCreatureTest01/FFERPG-Arena-Creature-Test-01.w3x']:
            candidate=View(DEVELOPMENT/path)
            units=all_objects(candidate,'w3u')
            for raw,(hp,armor) in STATS.items():
                values=fields(units[raw])
                if hp is not None:
                    self.assertEqual(values['uhpm',None],hp,(path,raw))
                if armor is not None:
                    self.assertEqual(values['udef',None],armor,(path,raw))
        arena_dir=DEVELOPMENT/'ArenaCreatureTest01'
        roster=json.loads((arena_dir/'Arena-Roster.json').read_text())
        self.assertEqual(roster['teams'],data_for(self.map.runtime))
        self.assertEqual(len(roster['teams']),188)
        script=(arena_dir/'FFERPG-Arena-Creature-Test-01.j').read_text()
        placed=re.findall(r"call Review_Add\('(.{4})',.*,(\d+),(\d+)\)",script)
        self.assertEqual(len(placed),463)
        expected={(member['raw'],str(team['id']),str(slot)) for team in roster['teams']
                  for slot,member in enumerate(team['members'],1)}
        self.assertEqual(set(placed),expected)

if __name__=='__main__':
    unittest.main()
