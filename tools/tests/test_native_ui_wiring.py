"""Saved-game UI rebinding must not weaken the single-startup-registration guard."""
import unittest
import sys
from pathlib import Path
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from check_map import registration_calls

SOURCE='''function Startup takes nothing returns nothing
    call Register_Bazaar_FrameClick()
    call Register_Bazaar_FrameSync()
endfunction
function BazaarFrame_Rebuild takes nothing returns nothing
    call Register_Bazaar_FrameClick()
    call Register_Bazaar_FrameSync()
endfunction
'''


class WiringTests(unittest.TestCase):
    def test_one_startup_and_one_explicit_reload_binding(self):
        calls,errors=registration_calls(SOURCE)
        self.assertFalse(errors)
        self.assertEqual(calls['Register_Bazaar_FrameClick'],1)

    def test_extra_startup_call_and_duplicate_reload_remain_errors(self):
        extra=SOURCE.replace('function Startup takes nothing returns nothing',
                             'function Startup takes nothing returns nothing\n    call Register_Bazaar_FrameClick()')
        self.assertEqual(registration_calls(extra)[0]['Register_Bazaar_FrameClick'],2)
        extra=SOURCE.replace('function BazaarFrame_Rebuild takes nothing returns nothing',
                             'function BazaarFrame_Rebuild takes nothing returns nothing\n    call Register_Bazaar_FrameClick()')
        self.assertTrue(registration_calls(extra)[1])

    def test_classic_empty_stub_and_arbitrary_other_caller(self):
        source=SOURCE.replace('BazaarFrame_Rebuild','Unapproved_Rebuild')
        self.assertEqual(registration_calls(source)[0]['Register_Bazaar_FrameClick'],2)
        source=SOURCE[:SOURCE.index('function BazaarFrame_Rebuild')]+'''function BazaarFrame_Rebuild takes nothing returns nothing
endfunction
'''
        calls,errors=registration_calls(source)
        self.assertFalse(errors)
        self.assertEqual(calls['Register_Bazaar_FrameClick'],1)
