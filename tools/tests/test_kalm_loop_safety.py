"""Nested events must not change Kalm wave loop iteration state."""
from collections import defaultdict
import sys,unittest
from pathlib import Path
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from build_barrel_siege_fix import patch
from test_armory_materia import execute
class KalmLoopTests(unittest.TestCase):
 def test_nested_trigger_clobbering_gui_loop_state_cannot_skip_wave_units(self):
  source='''function Trig_KalmSiege1_Begin_IsShieldSlot takes nothing returns boolean
    return ModuloInteger(GetForLoopIndexA(),2)==0
endfunction
function Trig_KalmSiege1_Begin_Actions takes nothing returns nothing
    set bj_forLoopAIndex=1
    set bj_forLoopAIndexEnd=4
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        call Observe(GetForLoopIndexA(),Trig_KalmSiege1_Begin_IsShieldSlot())
        call NestedTrigger()
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
endfunction'''
  seen=[];env=dict(ModuloInteger=lambda a,b:a%b,Observe=lambda i,shield:seen.append((i,shield)),bj_forLoopAIndex=0,bj_forLoopAIndexEnd=0)
  env['NestedTrigger']=lambda:env.update(bj_forLoopAIndex=100,bj_forLoopAIndexEnd=0)
  e=execute(patch(source),['Trig_KalmSiege1_Begin_IsShieldSlot','Trig_KalmSiege1_Begin_Actions'],env)
  e['NestedTrigger']=lambda:e.update(bj_forLoopAIndex=100,bj_forLoopAIndexEnd=0)
  e['Trig_KalmSiege1_Begin_Actions']()
  self.assertEqual(seen,[(1,False),(2,True),(3,False),(4,True)])
if __name__=='__main__':unittest.main()
