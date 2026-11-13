import sys,unittest,re
from pathlib import Path
from collections import defaultdict
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from mpq import MPQ
from jtok import functions,tokens
from test_shared_context import mocks
from test_armory_materia import execute
from talent_flash_recovery02 import FRAMES
ROOT=Path(__file__).resolve().parents[2]
class TalentVisibility(unittest.TestCase):
 @classmethod
 def setUpClass(c):
  pairs=[('release/development/GRecovery01/FFERPG-0.9.7.5g-Recovery01.w3x','release/development/GRecovery02/FFERPG-0.9.7.5g-Recovery02.w3x'),('release/development/V11/FFERPG-V11.w3x','release/development/V12/FFERPG-V12.w3x')]
  c.pairs=[]
  for a,b in pairs:
   old,new=MPQ(str(ROOT/a)),MPQ(str(ROOT/b));c.pairs.append((old,new,functions(old.read('war3map.j').decode()),functions(new.read('war3map.j').decode())))
 def env(self,f,viewer=0,opened=True,flags=()):
  names=['Inventory94_ClearLocal','Inventory94_Changed'];source='\n'.join(f[n] for n in names);e=mocks(source);vis={};calls=[]
  e.update(Inventory94Paused=False,InventoryCinematicActive=False,udg_InCinematicMode=False,UI73AimRevision=10,QuickGearHeld=defaultdict(bool),GearCursorErrorUntil60=10.,GearCursorError60=80,QuickGearRoot=81,ForsakenInspectRoot=82,ForsakenInspectButton=83,CarryUIRoot=84,ForsakenHolyBoltsAttached=True,ForsakenAttackCommand=85,ForsakenPanelOpen=opened,Inventory94Until=defaultdict(float),NativeCDClock=1,TimerGetElapsed=lambda t:100.,GetUnitTypeId=lambda u:1 if u else 0,GetOwningPlayer=lambda u:0,GetLocalPlayer=lambda:viewer,GetPlayerId=lambda p:p,QuickGear_ClearPreview=lambda:calls.append('preview'),Wave65_Clear=lambda:calls.append('wave'),CarryUI_Close=lambda:calls.append('carry'),BlzFrameSetVisible=lambda frame,value:vis.__setitem__(frame,value),BlzFrameSetTooltip=lambda *a:calls.append('tooltip'))
  for name in re.findall(r'\bset\s+(\w+)',source):
   if name not in e and name not in ['pid','slot']:e[name]=None
  for i,n in enumerate(FRAMES):e[n]=100+i;vis[100+i]=opened
  for flag in flags:e[flag]=True
  return execute(source,names,e),vis,calls
 def test_item_cleanup_preserves_only_requested_controls_and_cancels_stale_aim(self):
  for _,_,old,new in self.pairs:
   a,va,ca=self.env(old);b,vb,cb=self.env(new);a['Inventory94_Changed'](10);b['Inventory94_Changed'](10)
   for n in FRAMES:self.assertFalse(va[a[n]]);self.assertTrue(vb[b[n]])
   self.assertFalse(a['ForsakenPanelOpen']);self.assertTrue(b['ForsakenPanelOpen']);self.assertEqual(ca,cb)
   for n in ['QuickGearPending','QuickGearPendingHero','QuickGearPendingItem','QuickGearPendingMark','GearInputTarget','BagMoving64','BagLeft64','BagRight64','BagSourceSlot66','UI73AimRevision','ForsakenInspectTarget','QuickGearShown','QuickGearReady']:self.assertEqual(a[n],b[n],n)
   self.assertEqual(b['Inventory94Until'][0],100.2)
 def test_closed_controls_are_never_opened(self):
  e,v,_=self.env(self.pairs[0][3],opened=False);e['Inventory94_Changed'](10);self.assertFalse(e['ForsakenPanelOpen']);self.assertFalse(any(v[e[n]] for n in FRAMES))
 def test_every_cinematic_flag_retains_full_teardown(self):
  for flag in ['Inventory94Paused','InventoryCinematicActive','udg_InCinematicMode']:
   a,va,ca=self.env(self.pairs[0][2],flags=[flag]);b,vb,cb=self.env(self.pairs[0][3],flags=[flag]);a['Inventory94_ClearLocal']();b['Inventory94_ClearLocal']();self.assertEqual(va,vb);self.assertEqual(ca,cb);self.assertFalse(b['ForsakenPanelOpen'])
 def test_other_players_item_events_do_not_touch_viewers_frames(self):
  for viewer in range(1,8):
   e,v,c=self.env(self.pairs[0][3],viewer=viewer);e['Inventory94_Changed'](10);self.assertTrue(all(v[e[n]] for n in FRAMES));self.assertTrue(e['ForsakenPanelOpen']);self.assertFalse(c)
 def test_one_function_scope_and_all_accepted_fixes_preserved(self):
  for old,new,a,b in self.pairs:
   self.assertEqual(a.keys(),b.keys());self.assertEqual({n for n in a if tokens(a[n])!=tokens(b[n])},{'Inventory94_ClearLocal'})
   for name in old.read('(listfile)').decode().splitlines():
    if name.lower() not in ['war3map.j','war3map.wct','(listfile)','(attributes)','(signature)']:self.assertEqual(old.read(name),new.read(name),name)
   self.assertLess(b['Cine_Enter'].index('set InventoryCinematicActive=true'),b['Cine_Enter'].index('ExecuteFunc("Inventory94_CineEnter")'));self.assertIn('call Inventory94_ClearLocal()',b['Inventory94_CineEnter'])
if __name__=='__main__':unittest.main()
