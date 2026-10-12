"""The 1.29.2 save conversion must remove every sync native and keep everything else."""
import unittest
from pathlib import Path
import sys
sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
from save_legacy import convert

ROOT = Path(__file__).resolve().parents[2]
TRANSPORT = ROOT / 'experiments/Forsaken/Forsaken-save-transport.j'
NATIVES = ('BlzSendSyncData', 'BlzGetTriggerSyncData', 'BlzTriggerRegisterPlayerSyncEvent')

SAMPLE = '''globals
    constant boolean FST_UseSyncNative=true
endglobals

function FSTSync_Send takes string packet returns nothing
    set FST_SyncSent=BlzSendSyncData("FSCU",packet)
endfunction

function FST_Keep takes nothing returns integer
    return 7
endfunction
'''


class SaveLegacyTests(unittest.TestCase):
    def test_the_switch_flips_and_the_wrappers_are_emptied(self):
        out = convert(SAMPLE.replace('FSTSync_Send', 'FSTSync_Send')
                      + '\nfunction FSTSync_OnSync takes nothing returns nothing\n'
                        '    call FST_Receive(0,BlzGetTriggerSyncData())\nendfunction\n'
                        'function FSTSync_Register takes trigger t,integer pid returns nothing\n'
                        '    call BlzTriggerRegisterPlayerSyncEvent(t,Player(pid),"FSCU",false)\n'
                        'endfunction\n')
        self.assertIn('constant boolean FST_UseSyncNative=false', out)
        for native in NATIVES:
            self.assertNotIn(native, out)
        self.assertIn('function FSTSync_Send takes string packet returns nothing', out)
        self.assertIn('return 7', out, 'unrelated functions must survive untouched')

    def test_a_file_without_the_switch_is_returned_unchanged(self):
        text = 'function Nothing takes nothing returns nothing\nendfunction\n'
        self.assertEqual(convert(text), text)

    def test_a_sync_native_outside_a_wrapper_is_refused(self):
        bad = SAMPLE.replace('function FST_Keep takes nothing returns integer\n    return 7',
                             'function FST_Keep takes nothing returns integer\n'
                             '    call BlzSendSyncData("FSCU","x")\n    return 7')
        bad += ('function FSTSync_OnSync takes nothing returns nothing\nendfunction\n'
                'function FSTSync_Register takes nothing returns nothing\nendfunction\n')
        with self.assertRaises(ValueError):
            convert(bad)

    def test_the_real_transport_converts_and_keeps_its_own_logic(self):
        if not TRANSPORT.exists():
            self.skipTest('private save line not present')
        out = convert(TRANSPORT.read_text())
        for native in NATIVES:
            self.assertNotIn(native, out)
        self.assertIn('constant boolean FST_UseSyncNative=false', out.replace('\r\n', '\n'))
        self.assertIn('FSG_Send', out, 'the cache path must remain wired up')
        self.assertIn('FST_TextChecksum', out, 'the transport logic is untouched')


if __name__ == '__main__':
    unittest.main()
