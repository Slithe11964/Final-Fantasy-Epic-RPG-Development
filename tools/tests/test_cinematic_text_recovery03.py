import sys,unittest
from pathlib import Path
from collections import defaultdict
from unittest.mock import patch
import test_quest_lifecycle as harness
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from mpq import MPQ
from jtok import functions,tokens
from test_armory_materia import execute
from test_shared_context import mocks
ROOT=Path(__file__).resolve().parents[2]
class CinematicText(unittest.TestCase):
 @classmethod
 def setUpClass(c):
  paths=['release/development/GRecovery03/FFERPG-0.9.7.5g-Recovery03.w3x','release/development/GRecovery03/FFERPG-0.9.7.5g-1.29.2-Recovery03.w3x','release/development/V14/FFERPG-V14.w3x']
  bases=['release/development/GRecovery02/FFERPG-0.9.7.5g-Recovery02.w3x','release/development/GRecovery01/FFERPG-0.9.7.5g-1.29.2-Recovery01.w3x','release/development/V13/FFERPG-V13.w3x']
  c.pairs=[]
  for a,b in zip(bases,paths):
   old,new=MPQ(str(ROOT/a)),MPQ(str(ROOT/b));c.pairs.append((old,new,functions(old.read('war3map.j').decode()),functions(new.read('war3map.j').decode())))
 def env(self):
  f=self.pairs[0][3];names=['Text_Transmission','Text_Say','Text_Caption','Cine_OnSkip','Inventory94_CineEnter'];s='\n'.join(f[n] for n in names);e=mocks(s);portraits=[];text=[];waits=[];ended=[];cleanup=[]
  e.update(udg_TextSpeed=300.,udg_TextSpeedFast=300.,udg_CinematicSkipped=False,bj_cineModeAlreadyIn=False,udg_InCinematicMode=False,bj_lastTransmissionDuration=0.,bj_TRANSMISSION_PORT_HANGTIME=1.5,bj_cineSceneLastSound=None,udg_PlayerName=defaultdict(lambda:'Player'),StringLength=len,GetUnitTypeId=lambda u:123,GetPlayerColor=lambda p:p,GetOwningPlayer=lambda u:9,GetPlayerId=lambda p:p,GetPlayerController=lambda p:'computer',MAP_CONTROL_USER='user',IsUnitType=lambda *a:True,UNIT_TYPE_HERO=1,IsUnitHidden=lambda u:True,GetHeroProperName=lambda u:'Cid',GetUnitName=lambda u:'Cid',GetUnitX=lambda u:0.,GetUnitY=lambda u:0.,bj_TRANSMISSION_PING_TIME=1.,RMaxBJ=max,I2R=float,GetSoundDuration=lambda s:4000,SetCinematicScene=lambda *a:portraits.append(a),GetPlayersAll=lambda:'all',DisplayTimedTextToForce=lambda *a:text.append(a),TriggerSleepAction=waits.append,EndCinematicScene=lambda:ended.append(True),Inventory94_ClearLocal=lambda:cleanup.append(True),ForceUICancel=lambda:self.fail('Scene entry synthesized a UI cancel'))
  # This harness defaults to integer division for quest indices; these helpers use real division.
  expression=harness.expression
  with patch.object(harness,"expression",lambda x:expression(x).replace("//","/")):
   e=execute(s,names,e)
  return e,portraits,text,waits,ended,cleanup
 def test_normal_speed_retains_portrait_full_text_and_duration(self):
  e,p,t,w,*_=self.env();e['Inventory94_CineEnter']();e['bj_cineModeAlreadyIn']=True;e['udg_InCinematicMode']=True;e['Text_Say'](1,'Bring the Beastslayer to Jessie.',False)
  self.assertEqual(len(p),1);self.assertEqual(p[0][2:4],('Cid','Bring the Beastslayer to Jessie.'));self.assertGreater(sum(w),1.);self.assertFalse(e['udg_CinematicSkipped']);self.assertEqual(t,[])
 def test_escape_outside_scene_does_not_poison_next_line(self):
  for mode,active in [(False,False),(False,True),(True,False)]:
   e,p,t,w,end,_=self.env();e['bj_cineModeAlreadyIn']=mode;e['udg_InCinematicMode']=active;e['Cine_OnSkip']();self.assertFalse(e['udg_CinematicSkipped']);self.assertFalse(end);e['Text_Say'](1,'Real dialogue',False);self.assertEqual(len(p),1)
 def test_genuine_in_scene_skip_and_forced_lines_still_work(self):
  e,p,t,w,end,_=self.env();e['bj_cineModeAlreadyIn']=True;e['udg_InCinematicMode']=True;e['Cine_OnSkip']();self.assertTrue(e['udg_CinematicSkipped']);self.assertEqual(end,[True]);e['Text_Say'](1,'Skip this',False);self.assertFalse(p);e['Text_Transmission'](1,'Cid','Forced line',None,None,1.,True);self.assertEqual(len(p),1);self.assertEqual(w,[1.])
 def test_instant_mode_and_portrait_free_caption_timing_unchanged(self):
  e,p,t,w,*_=self.env();e['udg_TextSpeed']=0.;e['Text_Say'](1,'Instant',False);self.assertFalse(p);self.assertFalse(w)
  e['udg_TextSpeed']=300.;e['Text_Caption'](None,'Narrator','Story line',None,None,2.,False);self.assertEqual(len(t),1);self.assertIn('Story line',t[0][-1]);self.assertEqual(w,[2.])
 def test_scene_entry_cleans_aim_without_native_cancel(self):
  e,*rest=self.env();e['Inventory94_CineEnter']();self.assertEqual(rest[-1],[True])
 def test_notifications_dialogue_quest_inventory_and_assets_exact(self):
  for old,new,a,b in self.pairs:
   expected={'Cine_OnSkip'}|({'Inventory94_CineEnter'} if 'Inventory94_CineEnter' in a else set());self.assertEqual(a.keys(),b.keys());self.assertEqual({n for n in a if tokens(a[n])!=tokens(b[n])},expected)
   for name in old.read('(listfile)').decode().splitlines():
    if name.lower() not in ['war3map.j','war3map.wct','(listfile)','(attributes)','(signature)']:self.assertEqual(old.read(name),new.read(name),name)
   self.assertIn('message==null or message=="" or message==" " or message=="(null)"',b['QuestText_Message'])
if __name__=='__main__':unittest.main()
