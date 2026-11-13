"""Regression behavior for the focused Version D/UI30 hotfix."""
from pathlib import Path
from collections import defaultdict
import sys,unittest
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from test_armory_materia import execute
from test_shared_context import mocks
from objdata import write_objects,read_objects
from priest_master import fields
from job_objects import refresh
ROOT=Path(__file__).resolve().parents[2]
class HotfixTests(unittest.TestCase):
 def test_load_refresh_preserves_shared_context(self):
  source=(ROOT/'src/triggers/12 Save system/ForsakenFreshLoad.j').read_text();e=mocks(source);seen=[]
  e.update(udg_TempPlayer=7,udg_TempInteger=47,udg_JobCount=0,udg_FreelancerHero=defaultdict(lambda:None),PLAYER_STATE_RESOURCE_FOOD_USED=0,Player=lambda p:p,SetPlayerState=lambda *a:None,IsPlayerInForce=lambda *a:False,EnableTrigger=lambda *a:None,StartTimerBJ=lambda *a:None,FFL_RestoreChronicles=lambda *a:None)
  e=execute(source,['FFL_RestoreUnlocks'],e)
  e['Trig_Hero_EndlessGrowth_Actions']=lambda:seen.append(e['udg_TempPlayer'])
  e['FFL_RestoreUnlocks'](0)
  self.assertEqual(seen,[0]);self.assertEqual((e['udg_TempPlayer'],e['udg_TempInteger']),(7,47))
 def test_escape_hides_only_triggering_players_dialog_without_warp(self):
  s=(ROOT/'src/triggers/08 World and travel/Travel.j').read_text();env=mocks(s);hidden=[]
  env.update(GetClickedButton=lambda:None,GetTriggerPlayer=lambda:3,GetPlayerId=lambda p:p,Player_GetHero=lambda p:'hero',GetTriggerEventId=lambda:99,EVENT_PLAYER_END_CINEMATIC=99,Travel_Hide=lambda p:hidden.append(p))
  e=execute(s,['Trig_Travel_Dialog_Click_Actions'],env);e['Trig_Travel_Dialog_Click_Actions']();self.assertEqual(hidden,[3])
 def test_divine_shield_has_no_native_miss_or_slow_at_any_rank(self):
  obj=dict(base='ANdh',id='A0RY',sets=[dict(flag=0,mods=[dict(field='Nsi2',type=2,level=11,data=2,value=.80,end=0)])])
  data=write_objects(dict(original=[],custom=[obj]),2,'w3a');fixed=refresh(data);f=fields(read_objects(fixed,'w3a')['custom'][0])
  for rank in range(1,12):
   self.assertEqual(f['Nsi1',rank],0)
   for field in ['Nsi2','Nsi3','Nsi4']:self.assertEqual(f[field,rank],0.)
  self.assertEqual(refresh(fixed),fixed)
if __name__=='__main__':unittest.main()
