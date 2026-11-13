"""Regression coverage for the Aqualung dummy-order correction."""
import sys
import unittest
from pathlib import Path

sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from aqualung_fix import refresh


class AqualungFixTests(unittest.TestCase):
    def test_older_runtime_orders_before_hiding_or_expiring_dummy(self):
        source='''function Trig_Aqualung_Cast_IsCasterHero takes nothing returns boolean
    return(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))!=null
endfunction
function Trig_Aqualung_Cast_Actions takes nothing returns nothing
    call UnitApplyTimedLifeBJ(6.,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    call UnitAddAbilityBJ('A0C5',GetLastCreatedUnit()) // 'A0C5': ability "Aqualung"
    call IssuePointOrderLocBJ(GetLastCreatedUnit(),"blizzard",udg_TempPoint)
endfunction
'''
        fixed=refresh(source)
        self.assertIn('return IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO)',fixed)
        self.assertNotIn('ShowUnitHide',fixed)
        self.assertLess(fixed.index('IssuePointOrderLocBJ'),fixed.index('UnitApplyTimedLifeBJ'))
        self.assertIn("UnitApplyTimedLifeBJ(12.",fixed)


if __name__=='__main__':
    unittest.main()
