import sys,unittest,struct
from pathlib import Path
from collections import defaultdict
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from creatures_v7 import *
from test_v2 import env
from test_armory_materia import execute

class CreaturesV7(unittest.TestCase):
 @classmethod
 def setUpClass(c):
  c.v=View(OUT);c.old=View(BASE);c.f=functions(c.v.runtime);c.a=all_objects(c.v,'w3a');c.u=all_objects(c.v,'w3u')
 def run_j(self,names,changes={}):
  s='\n'.join(self.f[n] for n in names);e=env(s);e.update(R2I=int,I2S=str,I2R=float);e.update(changes);return execute(s,names,e)
 def test_spell_difficulty_replaces_legacy_multiplier_once(self):
  names=['D7_SpellFactor','D7_RegionalSpell','Trig_Damage_Engine_Step14_Difficulty']
  e=self.run_j(names,{'DmgCtx_Amount':{1:1000.},'DmgCtx_Source':{1:'mob'},'DmgCtx_Target':{1:'hero'},'DmgCtx_Heal':{1:False},'DmgCtx_Pure':{1:False},'DmgCtx_Physical':{1:False},'DmgCtx_Magical':{1:True},'DmgCtx_ManaDamage':{1:False},'DmgCtx_SourcePlayer':{1:11},'DmgCtx_TargetPlayer':{1:0},'DmgCtx_DefenseScale':{1:1.},'udg_EternityMode':False,'udg_ActivePlayers':{0},'Player':lambda p:p,'IsPlayerInForce':lambda p,g:p in g,'GetUnitTypeId':lambda u:u,'Forest86_Actor':lambda r:r=='mob','F99_SummonType':lambda r:False,'BlzGetEventIsAttack':lambda:False})
  for diff,scale,factor in [(1,2.,.7),(2,1.5,.9),(3,1.,1.),(4,2./3.,1.1),(5,.5,1.2),(6,1./3.,1.4)]:
   e.update(udg_Difficulty=diff,udg_DifficultyScale=scale);e['DmgCtx_Amount'][1]=1000.;e['Trig_Damage_Engine_Step14_Difficulty'](1);self.assertAlmostEqual(e['DmgCtx_Amount'][1],1000.*factor)
  e.update(udg_Difficulty=4,udg_DifficultyScale=2./3.,BlzGetEventIsAttack=lambda:True);e['DmgCtx_Amount'][1]=1000.;e['Trig_Damage_Engine_Step14_Difficulty'](1);self.assertEqual(e['DmgCtx_Amount'][1],1500.)
  e['BlzGetEventIsAttack']=lambda:False;e['Forest86_Actor']=lambda r:False;e['DmgCtx_Amount'][1]=1000.;e['Trig_Damage_Engine_Step14_Difficulty'](1);self.assertEqual(e['DmgCtx_Amount'][1],1500.)
  e['Forest86_Actor']=lambda r:True
  for excluded in ['DmgCtx_Heal','DmgCtx_ManaDamage']:
   e[excluded][1]=True;e['DmgCtx_Amount'][1]=1000.;e['Trig_Damage_Engine_Step14_Difficulty'](1);self.assertEqual(e['DmgCtx_Amount'][1],1500.);e[excluded][1]=False
  e['DmgCtx_Pure'][1]=True;e['DmgCtx_Amount'][1]=1000.;e['Trig_Damage_Engine_Step14_Difficulty'](1);self.assertEqual(e['DmgCtx_Amount'][1],1000.)
 def test_queen_mana_and_native_frost_visual(self):
  f=fields(self.u['n02B']);self.assertEqual((f['umpm',None],f['umpi',None]),(1900,1900));self.assertIn('Base mana: 1900',f['utub',None])
  self.assertEqual(fields(self.a['jBF2'])['amat',0],r'Abilities\Spells\Other\BreathOfFrost\BreathOfFrostMissile.mdl')
  self.assertEqual(fields(self.a['jIB2'])['Ncl5',1],0);self.assertEqual(fields(self.a['jIB2'])['Ncl1',1],10.)
  for raw in ['jBF2','kOB2','kLB2']:
   old=fields(all_objects(self.old,'w3a')[raw]);new=fields(self.a[raw])
   for k in ['Ucs1','Ucs3','Ucs4','amcs','acdn']:self.assertEqual(old[k,1],new[k,1])
   self.assertIn('Nightmare x1.4',new['aub1',1])
 def test_swarm_only_removes_ribbon_emitters(self):
  def chunks(b):
   parts={};p=4
   while p<len(b):
    n=struct.unpack_from('<I',b,p+4)[0];parts[b[p:p+4]]=b[p+8:p+8+n];p+=8+n
   self.assertEqual(p,len(b));return parts
  a=chunks(self.old.archive.read(r'war3mapImported\DarkSwarmBreathV6.mdx'));b=chunks(self.v.archive.read(r'war3mapImported\DarkSwarmBreathV7.mdx'))
  self.assertIn(b'RIBB',a);self.assertNotIn(b'RIBB',b);self.assertEqual({k:v for k,v in a.items() if k!=b'RIBB'},b)
  oldf=functions(self.old.runtime)
  for n in ['D5_ForkBreath','D5_LightningEnd','D6_RootFootprint','D6_ClearFootprint','M2_Lifesteal']:self.assertEqual(tokens(oldf[n]),tokens(self.f[n]))
 def test_slow_creates_one_status_refresh_at_start_and_one_at_end(self):
  calls=[];e=self.run_j(['I2_AddSlow','I2_BeamEnd'],{'GetHandleId':lambda u:u,'M89_Dummy':lambda *a:calls.append(a),'SaveLightningHandle':lambda t,p,k,v:t.__setitem__((p,k),v),'LoadLightningHandle':lambda t,p,k:t.get((p,k))})
  for _ in range(10):e['I2_AddSlow'](1,2)
  self.assertEqual(e['I2Data'][2,72],10);self.assertEqual(len(calls),1)
  e['I2Data'].update({(1,20):2,(1,21):10.,(1,22):11.,(1,23):99});e['I2_BeamEnd'](1);e['I2_BeamEnd'](1);self.assertEqual(len(calls),2)
  for key in [20,21,22,23]:self.assertNotIn((1,key),e['I2Data'])
 def test_reentrant_beam_end_never_moves_destroyed_lightning(self):
  moved=[];data={(1,20):2,(1,21):10.,(1,22):1.,(1,23):99};e=self.run_j(['I2_BeamTick'],{'I2Data':data,'Forest86Now':1.,'IsUnitPaused':lambda u:False,'GetUnitAbilityLevel':lambda *a:0,'Forest86_Enemy':lambda *a:True,'IsUnitInRange':lambda *a:True,'GetUnitCurrentOrder':lambda u:'drain','I2_BeamEnd':lambda u:data.clear(),'I2_AddSlow':lambda *a:data.clear(),'MoveLightningEx':lambda *a:moved.append(a)})
  e['I2_BeamTick'](1);self.assertFalse(moved)
 def test_badge_counts_are_read_only_and_daggers_are_per_viewer(self):
  e=self.run_j(['D7_BadgeCount'],{'GetHandleId':lambda u:u,'GetLocalPlayer':lambda:0,'GetPlayerId':lambda p:p,'F99_Count':lambda u,k:{1:4,2:5,3:6}[k],'DG_Data':{(1,0):1,(1,1):15.},'LoadUnitHandle':lambda t,p,k:t.get((p,k)),'CutsTarget':{0:1,1:1},'CutsCount':{0:7,1:99},'I2Data':{(1,72):3},'D2Data':{(1,82):2,(1,90):8}})
  self.assertEqual([e['D7_BadgeCount'](1,k) for k in range(8)],[3,2,5,4,6,8,3,7]);e['GetLocalPlayer']=lambda:1;self.assertEqual(e['D7_BadgeCount'](1,7),99)
  for n in ['D7_BadgeCount','D7_BadgeArt','D7_BadgeDraw','D7_BadgeSelection']:
   for unsafe in ['CreateTrigger(','CreateTimer(','CreateGroup(','UnitDamageTarget(','UnitAddAbility(','SetUnitState(','SaveInteger(','BlzGetUnitAbility(','BlzGetItemAbility(']:self.assertNotIn(unsafe,self.f[n],n)
  self.assertNotIn('TimerStart',self.f['D7_BadgeInit']);self.assertEqual(self.f['Forest86_Tick'].count('call D7_BadgeDraw()'),1)
 def test_badges_switch_with_selection_and_clear_without_touching_native_bar(self):
  counts={0:3,2:4};visible={};texts={};e=self.run_j(['D7_BadgeDraw'],{'D7BadgeRoot':100,'D7BadgeBuffBar':101,'D7BadgeSelected':1,'D7BadgeShown':False,'D7BadgeIcon':{i:200+i for i in range(8)},'D7BadgeText':{i:300+i for i in range(8)},'D7BadgeLastKind':defaultdict(lambda:-1),'D7BadgeLastCount':defaultdict(lambda:-1),'D7_BadgeCount':lambda u,k:counts.get(k,0),'D7_BadgeArt':lambda k:'icon'+str(k),'GetLocalPlayer':lambda:0,'IsUnitSelected':lambda *a:True,'Inventory94Paused':False,'InventoryCinematicActive':False,'udg_InCinematicMode':False,'GetWidgetLife':lambda u:100.,'BlzFrameIsVisible':lambda f:True,'BlzFrameSetVisible':lambda f,v:visible.__setitem__(f,v),'BlzFrameSetText':lambda f,t:texts.__setitem__(f,t)})
  e['D7_BadgeDraw']();self.assertTrue(visible[100]);self.assertEqual((texts[300],texts[301]),('3','4'));self.assertNotIn(101,visible)
  counts.pop(0);e['D7_BadgeDraw']();self.assertEqual(texts[300],'4');self.assertFalse(visible[201]);e['D7BadgeSelected']=None;e['D7_BadgeDraw']();self.assertFalse(visible[100])
 def test_ui_and_save_gameplay_preserved(self):
  oldf=functions(self.old.runtime)
  for n,b in oldf.items():
   if n.startswith(('FFL_','FRC_','FSC_','FST_','Inventory94_','QuickGear_','Cuts_','DG_')):self.assertEqual(tokens(b),tokens(self.f[n]),n)
  for ext in ['w3t','w3q','w3b']:self.assertEqual(self.old.archive.read('war3map.'+ext),self.v.archive.read('war3map.'+ext))
  self.assertIn('SetUnitPathing(u,not D7ReviewNoCollision)',self.f['F99_RootEnd'])
if __name__=='__main__':unittest.main()
