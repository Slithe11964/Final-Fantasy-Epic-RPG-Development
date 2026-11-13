import sys,unittest
from pathlib import Path
from collections import defaultdict
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from build_forest86 import *
from build_h_final20 import DIR
from build_v3 import OUT as DEV
from test_armory_materia import execute
from test_shared_context import mocks
class H20V3Tests(unittest.TestCase):
 @classmethod
 def setUpClass(c):
  c.paths=[DIR/'FFERPG-0.9.7.5h.w3x',DIR/'FFERPG-0.9.7.5h-1.29.2.w3x',DEV]
  c.maps=[MPQ(str(p)) for p in c.paths];c.fs=[functions(m.read('war3map.j').decode()) for m in c.maps]
 def test_timer_dispatches_at_20_30_40_minutes_and_manual_request_does_not_reset_it(self):
  for f in self.fs:
   names=['FFL_AutoStart','FFL_AutoSchedule','FFL_Autosave','Save_Autosave'];s='\n'.join(f[n] for n in names);now=[0.];state={};queued=[];starts=[];e=mocks(s)
   def timer_start(timer,delay,repeating,callback):state.update(next=now[0]+delay,delay=delay,repeat=repeating);starts.append((delay,repeating))
   e.update(FFL_AutoTimer=1,FFL_AutoStarted=False,FFL_AutoRepeating=False,udg_GameRunning=True,Save_AutosavePid=0,TimerStart=timer_start,FFL_QueueAutosave=lambda pid:queued.append((now[0],pid)))
   e=execute(s,names,e);e['ExecuteFunc']=lambda name:e[name]()
   e['FFL_AutoStart']();self.assertEqual(state['next'],1200.);self.assertEqual(starts,[(1200.,False)])
   now[0]=100.;e['FFL_Autosave']();self.assertEqual(state['next'],1200.);self.assertFalse(e['FFL_AutoRepeating']);queued.clear()
   now[0]=1199.;e['FFL_AutoStart']();self.assertEqual(state['next'],1200.);self.assertFalse(queued)
   for due in [1200.,1800.,2400.]:
    self.assertEqual(state['next'],due);now[0]=due;state['next']=due+state['delay'] if state['repeat'] else None;e['Save_Autosave']()
   self.assertEqual(starts,[(1200.,False),(600.,True)])
   for pid in range(8):self.assertEqual([t for t,p in queued if p==pid],[1200.,1800.,2400.])
 def test_production_changes_only_schedule_status_and_title(self):
  for i,suffix in enumerate(['','-1.29.2']):
   p=ROOT/'release/development/VersionHHotfix02'/('FFERPG-0.9.7.5h'+suffix+'-Hotfix02.w3x');old=MPQ(str(p));a=functions(old.read('war3map.j').decode());b=self.fs[i]
   self.assertEqual(a.keys(),b.keys());self.assertEqual({n for n in a if tokens(a[n])!=tokens(b[n])},{'FFL_AutoStart','FFL_AutoSchedule','Trig_Autosave_Command_Actions'})
   self.assertIn('First save at minute 20, then every 10 minutes.',b['Trig_Autosave_Command_Actions'])
   for file in old.read('(listfile)').decode().splitlines():
    if file.lower() not in ['war3map.j','war3map.wct','(listfile)','(attributes)','(signature)']:self.assertEqual(old.read(file),self.maps[i].read(file),file)
 def test_development_jobs_creatures_items_arenas_and_imports_preserved(self):
  old=View(ROOT/'release/development/V2/FFERPG-V2.w3x');new=View(DEV)
  for lib,s in old.modules.items():
   if 'Arena' in lib or lib in ['TMonsterData','TLancer','TThief','TJob']:self.assertEqual(s,new.modules[lib],lib)
  for ext in ['w3u','w3t','w3q','w3h','w3b','w3d']:self.assertEqual(old.archive.read('war3map.'+ext),new.archive.read('war3map.'+ext),ext)
  a=all_objects(old,'w3a');b=all_objects(new,'w3a');self.assertEqual(a.keys(),b.keys());self.assertEqual([r for r in a if a[r]!=b[r]],['aMEy'])
  self.assertEqual((fields(b['aMEy'])['abpx',0],fields(b['aMEy'])['abpy',0]),(0,-11))
  for name in old.archive.read('(listfile)').decode().splitlines():
   if name.lower().endswith(('.mdx','.mdl','.blp','.tga','.fdf','.toc')):self.assertEqual(old.archive.read(name),new.archive.read(name),name)
 def test_production_fixes_forwarded_and_dev_preview_state_preserved(self):
  prod,dev=self.fs[0],self.fs[2]
  for n in ['FFL_AutoStart','FFL_AutoSchedule','FFL_QueueAutosave','FFL_BeginAutosave','FFL_TryAutosave','FFL_Autosave','Trig_Autosave_Command_Actions','TravelPanel_Render','TravelPanel_Init','Forsaken_BackpackVisible','Forsaken_BackpackAccess','Forsaken_RequestBackpackToggle','Inventory94_Changed']:
   self.assertEqual(tokens(prod[n]),tokens(dev[n]),n)
  self.assertIn('set Preview75Caster=null',dev['Inventory94_ClearAim'])
  old=functions(View(ROOT/'release/development/V2/FFERPG-V2.w3x').runtime)
  for n in old:
   if n.startswith(('FRC_','FSC_','FST_','Load_','Trig_Cmd_Load_Code_')):self.assertEqual(tokens(old[n]),tokens(dev[n]),n)
if __name__=='__main__':unittest.main()
