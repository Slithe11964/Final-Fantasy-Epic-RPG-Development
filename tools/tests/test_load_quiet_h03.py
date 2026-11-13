import sys,unittest
from pathlib import Path
from collections import defaultdict
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from jtok import functions,tokens
from editor_pair import View
from test_armory_materia import execute
from test_shared_context import mocks
from load_quiet_h03 import refresh
ROOT=Path(__file__).resolve().parents[2]
class QuietLoad(unittest.TestCase):
 @classmethod
 def setUpClass(c):
  c.base=View(ROOT/'release/development/V3/FFERPG-V3.w3x');c.f=functions(refresh(c.base.runtime))
 def env(self,local):
  names=['InventoryH03_LoadBusy','Inventory94_Blocked','Inventory71_Reconcile'];source='\n'.join(self.f[n] for n in names);e=mocks(source);e.update(FFP_Locked=defaultdict(bool),FFL_Phase=defaultdict(int),Inventory94Paused=False,InventoryCinematicActive=False,udg_InCinematicMode=False,Inventory94ResumeUntil=0.,NativeCDClock=1,Inventory94Until=defaultdict(float),GetLocalPlayer=lambda:local,GetPlayerId=lambda p:p,TimerGetElapsed=lambda t:100.,GetUnitTypeId=lambda u:123,Inventory71_Scan=lambda *a:True)
  return execute(source,names,e)
 def test_every_client_stops_reading_during_any_player_load_then_recovers(self):
  for phase in [2,3,5,6]:
   for viewer in range(8):
    e=self.env(viewer);e['FFL_Phase'][5]=phase
    self.assertTrue(e['Inventory94_Blocked']());e['FFL_Phase'][5]=0;self.assertFalse(e['Inventory94_Blocked']())
 def test_profile_lock_and_saving_are_distinct(self):
  e=self.env(0);e['FFP_Locked'][7]=True;self.assertTrue(e['InventoryH03_LoadBusy']());e['FFP_Locked'][7]=False;e['FFL_Phase'][7]=1;self.assertFalse(e['InventoryH03_LoadBusy']());self.assertFalse(e['Inventory94_Blocked']())
 def test_locked_inventory_is_not_scanned_or_rewritten_but_others_continue(self):
  e=self.env(0);calls=[];e.update(Inventory71_Scan=lambda *a:calls.append(('scan',a)) or True,Inventory94_Changed=lambda *a:calls.append(('changed',a)),Forsaken_EnableHero=lambda *a:calls.append(('enable',a)))
  e['FFP_Locked'][3]=True;e['Inventory71_Reconcile'](123,3);self.assertEqual(calls,[])
  e['Inventory71_Reconcile'](456,4);self.assertEqual([x[0] for x in calls],['scan','changed','enable','scan'])
  calls.clear();e['FFP_Locked'][3]=False;e['Inventory71_Reconcile'](123,3);self.assertEqual([x[0] for x in calls],['scan','changed','enable','scan'])
 def test_patch_scope_and_no_local_mutations(self):
  old=functions(self.base.runtime);new=self.f;changed=[n for n in old if tokens(old[n])!=tokens(new[n])];self.assertEqual(set(changed),{'Inventory94_Blocked','Inventory71_Reconcile'})
  self.assertEqual(set(new)-set(old),{'InventoryH03_LoadBusy'});self.assertNotIn('GetLocalPlayer',new['InventoryH03_LoadBusy']);self.assertNotIn('CreateTimer',new['InventoryH03_LoadBusy']);self.assertNotIn('set FFL_',new['InventoryH03_LoadBusy'])
  for relative in ['release/development/VersionHHotfix03/FFERPG-0.9.7.5h-Hotfix03.w3x','release/development/V4/FFERPG-V4.w3x']:
   v=View(ROOT/relative);f=functions(v.runtime)
   for n in ['InventoryH03_LoadBusy','Inventory94_Blocked','Inventory71_Reconcile']:self.assertEqual(tokens(f[n]),tokens(new[n]))
if __name__=='__main__':unittest.main()
