"""Exercise post-cinematic placement restoration without inventory access."""
from pathlib import Path
from collections import defaultdict
import sys,re,unittest
sys.path[:0]=[str(Path(__file__).resolve().parents[1]),str(Path(__file__).resolve().parent)]
from build_f1030_inventory_rollback import view
from gear_visibility27 import refresh
from jtok import functions
from test_shared_context import mocks
from test_armory_materia import execute

class VisibilityTests(unittest.TestCase):
 @classmethod
 def setUpClass(cls):
  p=Path(__file__).resolve().parents[2]/'release/development/GRecovery15/FFERPG-0.9.7.5g-Recovery15.w3x'
  cls.source=refresh(view(str(p)).modules['TEquip']);cls.fs=functions(cls.source)

 def env(self):
  source=self.fs['QuickGear_Layout']+'\n'+self.fs['C20_UIResume'];e=mocks(source);events=[]
  for n in set(re.findall(r'\b(?:C20|QuickGear|Forsaken)\w+',source)):
   if n not in functions(source):e.setdefault(n,False)
  e.update(C20UIPaused=True,C20EquipEventsActive=False,C20InventoryActive=False,C20UITimerActive=True,
   C20DeferredCount=0,QuickGearRoot='dock',QuickGearUITimer='existing UI clock',FRAMEPOINT_TOPLEFT=0,
   BlzFrameClearAllPoints=lambda f:events.append(('clear',f)),
   BlzFrameSetAbsPoint=lambda f,p,x,y:events.append(('position',f,x,y)),
   ResumeTimer=lambda t:events.append(('resume',t)),C23_ResumeControls=lambda:None)
  return execute(source,['QuickGear_Layout','C20_UIResume'],e),events

 def test_resume_repositions_existing_dock_before_existing_ui_timer_resumes(self):
  e,events=self.env();e['C20_UIResume']()
  placed=[v for v in events if v[0]=='position'];self.assertEqual(len(placed),1)
  _,dock,x,y=placed[0];self.assertEqual(dock,'dock')
  self.assertGreaterEqual(x,0.);self.assertLessEqual(x+.040,.8)
  self.assertGreater(y-.086,.176);self.assertLessEqual(y,.6)
  self.assertLess(events.index(placed[0]),events.index(('resume','existing UI clock')))
  self.assertFalse(e['QuickGearReady']);self.assertFalse(e['C20UIPaused'])

 def test_inactive_resume_and_missing_dock_are_safe_without_frame_creation(self):
  e,events=self.env();e['C20UIPaused']=False;e['C20_UIResume']();self.assertEqual(events,[])
  e['C20UIPaused']=True;e['QuickGearRoot']=None;e['C20_UIResume']()
  self.assertFalse(any(v[0]=='position' for v in events))
  for n in ['C20_UIResume','QuickGear_Layout']:
   self.assertNotRegex(self.fs[n],r'\b(?:BlzCreate|BlzGetFrameByName|BlzUnitItem|BlzGetItem|UnitUseItem|BlzSendSyncData)')

if __name__=='__main__':unittest.main()
