import sys,unittest,struct,io
from pathlib import Path
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from creatures_v6 import *
from test_v2 import env
from test_armory_materia import execute
from PIL import Image

class CreaturesV6(unittest.TestCase):
 @classmethod
 def setUpClass(c):
  c.v=View(OUT);c.old=View(BASE);c.f=functions(c.v.runtime);c.a=all_objects(c.v,'w3a');c.b=all_objects(c.v,'w3h');c.u=all_objects(c.v,'w3u')
 def run_j(self,names,changes={}):
  s='\n'.join(self.f[n] for n in names);e=env(s);e.update(changes);return execute(s,names,e)
 def test_root_footprint_created_once_and_removed_idempotently(self):
  data={};created=[];removed=[];invul=[]
  e=self.run_j(['D6_ClearFootprint','D6_RootFootprint'],{'F99Data':data,'GetUnitX':lambda u:500.,'GetUnitY':lambda u:700.,'CreateDestructable':lambda *args:created.append(args) or len(created),'SaveDestructableHandle':lambda t,p,k,v:t.__setitem__((p,k),v),'LoadDestructableHandle':lambda t,p,k:t.get((p,k)),'RemoveDestructable':lambda d:removed.append(d),'SetDestructableInvulnerable':lambda *args:invul.append(args),'ModuloInteger':lambda a,b:a%b})
  e['D6_RootFootprint'](1);self.assertEqual(len(created),4);self.assertEqual(set((a[1],a[2]) for a in created),{(468.,668.),(532.,668.),(468.,732.),(532.,732.)});self.assertEqual([a[0] for a in created],['YTpc']*4);self.assertEqual(invul,[(i,True) for i in range(1,5)])
  self.assertEqual(set(data),{(1,k) for k in range(600,604)})
  e['D6_RootFootprint'](1);self.assertEqual(removed,[1,2,3,4]);self.assertEqual(len(created),8)
  e['D6_ClearFootprint'](1);e['D6_ClearFootprint'](1);self.assertEqual(removed,list(range(1,9)));self.assertFalse(data)
 def test_footprint_cleanup_precedes_early_exit_and_table_flush(self):
  f=self.f
  self.assertLess(f['F99_RootEnd'].index('D6_ClearFootprint'),f['F99_RootEnd'].index('if not HaveSavedReal'))
  self.assertLess(f['D2_Cleanup'].index('D6_ClearFootprint'),f['D2_Cleanup'].index('if D2Data==null'))
  self.assertIn('D2_Cleanup(u)',f['F99_Cleanup']);self.assertIn('F99_Cleanup(u)',f['F99_TickUnit'])
  self.assertIn('D6_RootFootprint(u)',f['F99_Root']);self.assertIn('GetUnitX(u)+160.',f['F99_TickUnit'])
 def test_lifesteal_3physical_5magic_preserves_damage_cap(self):
  hp={1:1000.,2:100.};e=self.run_j(['M2_Lifesteal'],{'Forest86_Enemy':lambda *a:True,'I2_Active':lambda *a:False,'GetWidgetLife':lambda u:hp[u],'BlzGetUnitMaxHP':lambda u:2000,'SetWidgetLife':lambda u,v:hp.__setitem__(u,v)})
  e['M2_Lifesteal'](1,2,1000.,True,False,False,False,False);self.assertEqual(hp[1],1003.)
  e['M2_Lifesteal'](1,2,1000.,False,True,False,False,False);self.assertEqual(hp[1],1008.)
  for heal,mana,pure in [(True,False,False),(False,True,False),(False,False,True)]:e['M2_Lifesteal'](1,2,1000.,True,False,heal,mana,pure)
  self.assertEqual(hp[1],1008.)
  self.assertIn('Physical damage restores 3%',fields(self.a['kVA2'])['aub1',1]);self.assertIn('Spell lifesteal: 5%',fields(self.b['bVA2'])['fube',None]);self.assertIn('Physical lifesteal: 3%',fields(self.b['bVA2'])['fube',None]);self.assertNotIn('Physical damage restores 1%',fields(self.u['n03H'])['utub',None])
 def test_breath_mechanics_and_dusk_visual_unchanged(self):
  olda=all_objects(self.old,'w3a');oldf=functions(self.old.runtime)
  for raw in ['jBF2','kOB2']:
   for key in ['Ucs1','Ucs2','Ucs3','Ucs4','aare','acdn','amcs','Nbf5']:self.assertEqual(fields(self.a[raw])[key,1],fields(olda[raw])[key,1])
  self.assertEqual(self.a['kLB2'],olda['kLB2'])
  for n in ['D5_ForkBreath','D5_LightningEnd','M2_Spell','I2_Spell','I2_BeamTick','I2_AI','M2_AI']:self.assertEqual(tokens(oldf[n]),tokens(self.f[n]),n)
 def test_native_breath_shape_and_assets_are_preserved(self):
  def chunks(b):
   out={};p=4;self.assertEqual(b[:4],b'MDLX')
   while p<len(b):
    n=struct.unpack_from('<I',b,p+4)[0];out[b[p:p+4]]=b[p+8:p+8+n];p+=8+n
   self.assertEqual(p,len(b));return out
  for source,name in [('BreathOfFireMissile','IcyFireBreathV6'),('CarrionSwarmMissile','DarkSwarmBreathV6')]:
   original=chunks((ROOT/('tools/build-inputs/v6-'+source+'.mdx')).read_bytes());new=chunks(self.v.archive.read('war3mapImported\\'+name+'.mdx'))
   for tag in [b'GEOS',b'BONE',b'HELP',b'PIVT',b'SEQS']:self.assertEqual(new[tag],original[tag],(name,tag))
   self.assertNotIn(b'LITE',new)
   for p in range(0,len(new[b'TEXS']),268):
    file=new[b'TEXS'][p+4:p+264].split(b'\0')[0].decode();im=Image.open(io.BytesIO(self.v.archive.read(file))).convert('RGBA');self.assertGreater(im.getextrema()[3][1],100)
   self.assertEqual(fields(self.a['jBF2' if name.startswith('Icy') else 'kOB2'])['amat',0],'war3mapImported\\'+name+'.mdx')
 def test_scope_preserves_jobs_saves_ui_and_other_creatures(self):
  oldf=functions(self.old.runtime);changed={n for n in oldf if tokens(oldf[n])!=tokens(self.f[n])}
  self.assertEqual(changed,{'F99_Root','F99_RootEnd','D2_Cleanup','M2_Lifesteal','F99_TickUnit'})
  self.assertEqual(set(self.f)-set(oldf),{'D6_ClearFootprint','D6_RootFootprint'})
  for lib in self.old.modules:
   if 'Arena' in lib or lib in ['TLancer','TThief','TJob','TSpawn']:self.assertEqual(self.old.modules[lib],self.v.modules[lib],lib)
  for ext in ['w3t','w3q','w3b']:self.assertEqual(self.old.archive.read('war3map.'+ext),self.v.archive.read('war3map.'+ext))
  self.assertNotIn('GetLocalPlayer',FX);self.assertNotIn('TimerStart',FX)
if __name__=='__main__':unittest.main()
