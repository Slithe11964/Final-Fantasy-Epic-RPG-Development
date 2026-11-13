import sys,unittest,struct,math
from pathlib import Path
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from creatures_v5 import *
from test_v2 import env
from test_armory_materia import execute

class CreaturesV5(unittest.TestCase):
 @classmethod
 def setUpClass(c):
  c.v=View(OUT);c.old=View(BASE);c.f=functions(c.v.runtime);c.a=all_objects(c.v,'w3a');c.u=all_objects(c.v,'w3u')
 def run_j(self,names,changes={}):
  s='\n'.join(self.f[n] for n in names);e=env(s);e.update(bj_PI=math.pi,Atan2=math.atan2,Cos=math.cos,Sin=math.sin,UNIT_WEAPON_RF_ATTACK_RANGE=0);e.update(changes);return execute(s,names,e)
 def test_mobile_ancients_have_real_foot_movement_and_collision(self):
  for raw in ['n00P','n00N','n00O']:
   f=fields(self.u[raw]);self.assertEqual((f['ubdg',None],f['umvt',None],f['umvs',None],f['ucol',None],f['upat',None]),(0,'foot',270,96.,''))
 def test_root_unroot_restores_movement_and_structure_class_repeatedly(self):
  for raw in ['n00P','n00N','n00O']:
   state={'structure':False,'speed':270.,'disabled':False,'pathing':False};data={}
   e=self.run_j(['F99_Root','F99_RootEnd'],{'F99Data':data,'F99_Active':lambda u,k:(u,k) in data,'GetUnitTypeId':lambda u:raw,'GetUnitMoveSpeed':lambda u:state['speed'],'GetUnitDefaultMoveSpeed':lambda u:270.,'GetUnitAbilityLevel':lambda *a:1,'UnitAddType':lambda *a:state.update(structure=True),'UnitRemoveType':lambda *a:state.update(structure=False),'BlzSetUnitBooleanField':lambda u,k,v:state.update(structure=v),'SetUnitPathing':lambda u,v:state.update(pathing=v),'BlzUnitDisableAbility':lambda u,r,v,h:state.update(disabled=v),'SetUnitMoveSpeed':lambda u,v:state.update(speed=v),'BlzSetUnitIntegerField':lambda u,k,v:state.update(move=v),'GetHandleId':lambda u:u,'MOVE_TYPE_FOOT':1,'UNIT_TYPE_STRUCTURE':2,'UNIT_BF_IS_A_BUILDING':3,'UNIT_IF_MOVE_TYPE':4,'BlzGetUnitArmor':lambda u:100.,'BlzGetUnitBaseDamage':lambda *a:351,'BlzGetUnitDiceSides':lambda *a:12,'BlzGetUnitWeaponRealField':lambda *a:1000.,'D2_RootWeapons':lambda *a:None})
   for _ in range(3):
    e['F99_Root'](1);self.assertTrue(state['structure']);self.assertTrue(state['disabled']);self.assertTrue(state['pathing']);self.assertEqual(state['speed'],0.)
    e['F99_RootEnd'](1);self.assertFalse(state['structure']);self.assertFalse(state['disabled']);self.assertEqual(state['speed'],270.);self.assertEqual(state['move'],1);self.assertTrue(state['pathing'])
 def test_native_breath_uses_correct_length_width_and_ai_order(self):
  for r in ['jBF2','kOB2','kLB2','kWB2','kFB2']:
   f=fields(self.a[r]);self.assertEqual(self.a[r]['base'],'ACbf');self.assertEqual((f['Ucs3',1],f['Ucs4',1],f['aare',1]),(800.,300.,150.))
  self.assertNotIn('breathoffrost',self.f['I2_AI']+self.f['M2_AI']);self.assertIn('breathoffire',self.f['I2_AI']);self.assertIn('breathoffire',self.f['M2_AI'])
  old=all_objects(self.old,'w3a')
  for r in ['jBF2','kOB2','kLB2']:
   for k in ['Ucs1','Nbf5','amcs','acdn']:self.assertEqual(fields(self.a[r])[k,1],fields(old[r])[k,1])
 def test_beam_adds_ten_stacks_and_stops_on_interrupt(self):
  data={(1,20):2,(1,21):10.,(1,22):1.,(1,23):9};hits=[];destroyed=[];stun=[False]
  e=self.run_j(['I2_BeamTick','I2_BeamEnd'],{'I2Data':data,'Forest86_Enemy':lambda *a:True,'Forest86_Alive':lambda *a:True,'IsUnitPaused':lambda u:False,'GetUnitAbilityLevel':lambda *a:1 if stun[0] else 0,'IsUnitInRange':lambda *a:True,'GetUnitCurrentOrder':lambda u:'drain','I2_AddSlow':lambda *a:hits.append(a),'LoadLightningHandle':lambda t,p,k:t.get((p,k)),'DestroyLightning':lambda l:destroyed.append(l),'BlzGetUnitZ':lambda u:300.})
  for t in range(1,11):e['Forest86Now']=float(t);e['I2_BeamTick'](1)
  self.assertEqual(len(hits),10);self.assertEqual(destroyed,[9]);self.assertNotIn((1,20),data)
  data.update({(1,20):2,(1,21):30.,(1,22):11.,(1,23):10});stun[0]=True;e['Forest86Now']=11.;e['I2_BeamTick'](1);self.assertEqual(len(hits),10);self.assertEqual(destroyed,[9,10])
  events=[];e=self.run_j(['D5_BeamInterrupted'],{'GetSpellAbilityId':lambda:'jIB2','GetTriggerUnit':lambda:1,'I2_BeamEnd':lambda u:events.append(u)});e['D5_BeamInterrupted']();self.assertEqual(events,[1])
  self.assertIn('EVENT_PLAYER_UNIT_SPELL_ENDCAST',self.f['Forest86_Init']);self.assertIn('not Forest86_Alive(u)',self.f['I2_BeamTick']);self.assertIn('BlzGetUnitZ',self.f['I2_Spell']);self.assertIn('AddLightningEx("DRAM"',self.f['I2_Spell'])
 def test_slow_cooldown_and_all_tooltips(self):
  self.assertEqual(fields(self.a['zIM9'])['acdn',1],30.)
  self.assertIn('30-second cooldown',fields(self.a['zIM9'])['aub1',1]);self.assertNotIn('15-second cooldown',fields(self.a['zIM9'])['aub1',1])
  for rank in range(1,65):self.assertAlmostEqual(fields(self.a['jIS2'])['Isx1',rank],-.1*rank,places=5)
  for r in ['jIS2','jIB2','jIM2']:self.assertNotIn('20%',fields(self.a[r])['aub1',1])
  self.assertNotIn('20% attack-speed',fields(self.u['n02C'])['utub',None])
 def test_fork_visual_and_cleanup_are_bounded(self):
  lines=[];clocks=[];data={};e=self.run_j(['D5_ForkBreath','D5_LightningEnd'],{'F99Data':data,'GetUnitX':lambda u:0.,'GetUnitY':lambda u:0.,'GetSpellTargetX':lambda:100.,'GetSpellTargetY':lambda:0.,'BlzGetUnitZ':lambda u:200.,'CreateTimer':lambda:99,'AddLightningEx':lambda *a:lines.append(a) or len(lines),'SaveLightningHandle':lambda t,p,k,v:t.__setitem__((p,k),v),'LoadLightningHandle':lambda t,p,k:t.get((p,k)),'TimerStart':lambda *a:clocks.append(a),'GetExpiredTimer':lambda:99})
  e['D5_ForkBreath'](1);self.assertEqual(len(lines),3);self.assertEqual([x[6] for x in lines],[-300.,0.,300.]);self.assertEqual(clocks[0][1:3],(.4,False));e['D5_LightningEnd']();self.assertFalse(data)
 def test_development_and_release_safety(self):
  before=functions(self.old.runtime)
  for n,b in before.items():
   if n.startswith(('FFL_','FRC_','FSC_','FST_','QuickGear_','Inventory94_','DG_','Cuts')):self.assertEqual(tokens(b),tokens(self.f[n]),n)
  for lib in self.old.modules:
   if 'Arena' in lib or lib in ['TLancer','TThief','TJob','TSpawn']:self.assertEqual(self.old.modules[lib],self.v.modules[lib],lib)
  self.assertEqual(self.old.archive.read('war3map.w3t'),self.v.archive.read('war3map.w3t'))
  for r in ['kOB2','jBF2']:self.assertNotEqual(fields(self.a[r])['amat',0],fields(all_objects(self.old,'w3a')[r]).get(('amat',0)))
  self.assertEqual(self.v.archive.read('war3mapImported\\OmniBreathV5.mdx')[:4],b'MDLX')
  self.assertNotIn('GetLocalPlayer',FX);self.assertNotIn(',true,function',FX)
if __name__=='__main__':unittest.main()
