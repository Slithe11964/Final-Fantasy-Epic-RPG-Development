import sys,unittest
from pathlib import Path
from collections import defaultdict
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from jtok import functions,tokens
from editor_pair import View
from test_armory_materia import execute
from test_shared_context import mocks
from sync_load_h04 import OBSERVERS
ROOT=Path(__file__).resolve().parents[2]
class SharedLoad(unittest.TestCase):
 @classmethod
 def setUpClass(c):
  c.maps=[View(ROOT/p) for p in ['release/development/VersionHHotfix04/FFERPG-0.9.7.5h-Hotfix04.w3x','release/development/V8/FFERPG-V8.w3x']]
  c.f=functions(c.maps[0].runtime)
 def env(self,names):
  src='\n'.join(self.f[n] for n in names);e=mocks(src);e.update(FFP_Locked=defaultdict(bool),FFL_Phase=defaultdict(int),FST_Clock=1,Load04ResumeUntil=0.,TimerGetElapsed=lambda t:100.)
  return execute(src,names,e)
 def test_shared_gate_lock_phases_and_resume(self):
  for player in range(8):
   for phase in [2,3,5,6]:
    e=self.env(['Load04_Busy','Load04_Resume']);e['FFL_Phase'][player]=phase;self.assertTrue(e['Load04_Busy']());e['FFL_Phase'][player]=0;self.assertFalse(e['Load04_Busy']());e['Load04_Resume']();self.assertTrue(e['Load04_Busy']());e['TimerGetElapsed']=lambda t:100.5;self.assertFalse(e['Load04_Busy']())
  e=self.env(['Load04_Busy']);e['FFL_Phase'][7]=1;self.assertFalse(e['Load04_Busy']());e['FFP_Locked'][7]=True;self.assertTrue(e['Load04_Busy']())
 def test_observers_are_gated_before_native_reads(self):
  for view in self.maps:
   f=functions(view.runtime)
   for n in OBSERVERS & f.keys():
    b=f[n];self.assertIn('if Load04_Busy() then',b,n)
    before=b.split('if Load04_Busy() then')[0]
    self.assertNotIn('call ',before,n)
   for n in ['FFL_Commit','FFL_Restore']:self.assertIn('call Load04_Resume()',f[n])
 def test_passive_one_shot_retries(self):
  e=self.env(['Load04_Busy','Trig_Passive_Bonus_Sync_Actions']);calls=[];e.update(udg_StatsRefreshTimer=1,StartTimerBJ=lambda *a:calls.append(a));e['FFP_Locked'][4]=True;e['Trig_Passive_Bonus_Sync_Actions']();self.assertEqual(calls,[(1,False,1.)])
 def test_private_callbacks_cannot_initialize_shared_codec(self):
  b=self.f['Load04_ReadDigit'];self.assertNotIn('FSC_Value(',b);self.assertNotIn('InitHashtable(',b);self.assertNotIn('FSC_InitCharacters(',b)
  self.assertNotIn('FSC_Value(',self.f['FST_LocalLegacyHash']);self.assertNotIn('FSS_Concat(',self.f['FST_Pump'])
  b=self.f['FST_Write'].split('if (GetLocalPlayer() == Player(pid)) then',1)[1];self.assertNotIn('FSS_Concat(',b)
 def test_scope_and_retained_autosave_casts(self):
  bases=['release/development/VersionHHotfix03/FFERPG-0.9.7.5h-Hotfix03.w3x','release/development/V7/FFERPG-V7.w3x']
  for view,path in zip(self.maps,bases):
   old=functions(View(ROOT/path).runtime);new=functions(view.runtime)
   for n in old:
    if n.startswith('FFL_Auto') or n in ['QuickGear_Mouse','QuickGear_Receive','FST_Init']:
     self.assertEqual(tokens(old[n]),tokens(new[n]),n)
   for n in ['Load04_Busy','Load04_Resume']:
    self.assertNotIn('GetLocalPlayer',new[n]);self.assertNotIn('CreateTimer',new[n])
   self.assertNotIn('BlzGetMouseFocusUnit',new['Wave65_Draw'])
   self.assertNotIn('set bj_forLoopAIndex',new['Load_TypeCodeWithUIKeys'])
if __name__=='__main__':unittest.main()
