"""On-demand cached parent diagnostics, without native frame lookup locally."""
from pathlib import Path
from collections import defaultdict
import sys,re,unittest
sys.path[:0]=[str(Path(__file__).resolve().parents[1]),str(Path(__file__).resolve().parent)]
from build_f1030_inventory_rollback import view
from jtok import functions
from test_shared_context import mocks
from test_armory_materia import execute
ROOT=Path(__file__).resolve().parents[2]
class GearViewTests(unittest.TestCase):
 @classmethod
 def setUpClass(cls):
  cls.source=view(str(ROOT/'release/development/H20261110UI01/FFERPG-0.9.7.5h-UI01.w3x')).modules['TEquip'];cls.fs=functions(cls.source)
 def test_shared_startup_cache_is_bounded_even_if_native_parent_chain_cycles(self):
  body=self.fs['QuickGear_Init'];start=body.index('    set displayParent=QuickGearRoot');end=body.index('    set displayParent=null',start)
  s='function Cache takes nothing returns nothing\n    local framehandle displayParent=null\n'+body[start:end]+'\nendfunction'
  e=mocks(s);lookups=[]
  e.update(QuickGearRoot='dock',GearView29Frame=defaultdict(lambda:None),GearView29Name=defaultdict(str),GearView29Count=0,
   BlzFrameGetName=lambda f:f,BlzFrameGetParent=lambda f:lookups.append(f) or ('parent' if f=='dock' else 'parent'))
  e=execute(s,['Cache'],e);e['Cache']()
  self.assertEqual(e['GearView29Count'],8);self.assertEqual(len(lookups),8)
  self.assertEqual(e['GearView29Frame'][0],'dock');self.assertEqual(e['GearView29Name'][1],'parent')
 def test_readout_reports_hidden_ancestor_without_lookups_or_mutations(self):
  body=self.fs['QuickGear_Diagnostic'];start=body.index('        call DisplayTimedTextToPlayer(owner,0.,0.,60.,"Gear UI:');end=body.index('        set slot=0',start)
  s='function Readout takes nothing returns nothing\n    local integer slot=0\n'+body[start:end]+'\nendfunction'
  out=[];e=mocks(s)
  e.update(owner=0,QuickGearShown=True,QuickGearRoot='dock',QuickGearAnchor='anchor',QuickGearActive={0:True,1:True},
   GearView29Count=2,GearView29Frame={0:'dock',1:'hidden parent'},GearView29Name={0:'dock',1:'hidden parent'},
   QuickGear_Bool=lambda v:'yes' if v else 'no',I2S=str,R2S=str,
   BlzFrameIsVisible=lambda f:f!='hidden parent',BlzFrameGetWidth=lambda f:.04,BlzFrameGetHeight=lambda f:.086,
   DisplayTimedTextToPlayer=lambda *args:out.append(args[-1]))
  e=execute(s,['Readout'],e);e['Readout']()
  self.assertEqual(len(out),3);self.assertIn('hidden parent visible=no',out[-1])
  self.assertNotRegex(s,r'\b(?:BlzGetFrame|BlzFrameGetParent|BlzFrameGetName|BlzCreate|CreateTimer|BlzSend|UnitUse|UnitAdd|BlzUnit)')
if __name__=='__main__':unittest.main()
