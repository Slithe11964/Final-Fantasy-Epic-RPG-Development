"""Native UI reload must restore access without clearing saved progression."""
import sys
import unittest
from pathlib import Path
HERE=Path(__file__).resolve().parent
ROOT=HERE.parents[1]
sys.path[:0]=[str(ROOT/'tools'),str(ROOT/'tools/tests')]
from mpq import MPQ
from wct import read_wct
from test_armory_materia import execute
from test_shared_context import mocks
import ui_recovery


def module(name):
    archive=MPQ(str(ROOT/'release/Forsaken/FFERPG_0.9.7.3-r16-ForsakenDW.w3x'))
    return next(e.decode().replace('\r','').rstrip('\0') for e in read_wct(archive.read('war3map.wct'))['entries']
                if e.startswith(('library T'+name).encode()))


class RecoveryTests(unittest.TestCase):
    def test_missing_native_panel_name_keeps_talents_access_and_scoreboard(self):
        source=ui_recovery.panel_source(module('Equip'))
        hero={}
        visible={}
        boards=[]
        env=mocks(source)
        env.update(GetLocalPlayer=lambda:0,Player_GetHero=lambda p:hero,
                   Forsaken_FindFrame=lambda name:None,IsUnitSelected=lambda u,p:u is hero,
                   ForsakenInspectTarget=None,ForsakenSelectedTarget=None,ForsakenTalentAnchor=None,ForsakenPanelOpen=False,
                   ForsakenPanelNeedsRefresh=False,ForsakenBoardCovered=False,ForsakenTalentToggle='toggle',
                   ForsakenTalentRoot='tree',ForsakenInspectButton='inspect',udg_ScoreBoard='score',
                   Forsaken_CanInspect=lambda u,p:False,BlzFrameSetText=lambda *a:None,
                   BlzFrameSetVisible=lambda h,v:visible.__setitem__(h,v),
                   MultiboardDisplay=lambda h,v:boards.append(v))
        env=execute(source,['Forsaken_PollPanels'],env)
        env['Forsaken_PollPanels']()
        self.assertTrue(visible['toggle'])
        self.assertFalse(env['ForsakenBoardCovered'])
        self.assertEqual(boards,[True])

    def test_startup_allowance_rejects_any_extra_registration_change(self):
        original=module('Equip')
        updated=ui_recovery.panel_source(original)
        ui_recovery.startup_baseline(original,updated)
        changed=updated.replace('function RegisterTriggers_Equip takes nothing returns nothing',
                                'function RegisterTriggers_Equip takes nothing returns nothing\n    call KillUnit(null)')
        with self.assertRaisesRegex(ValueError,'unapproved UI registration'):
            ui_recovery.startup_baseline(original,changed)

    def test_rebuild_rebinds_panel_access_and_retains_saved_talent_choices(self):
        source=ui_recovery.panel_source(module('Equip'))
        state=mocks(source)
        saved={(111,0):True,(111,20):1}
        calls=[]
        state.update(ForsakenTalentState=saved,ForsakenUITimer='poll',ForsakenPanelClock='clock',
                     gg_trg_Forsaken_PanelAccess='access',gg_trg_Forsaken_TalentClick='click',
                     gg_trg_Forsaken_TalentSync='sync',ForsakenTalentAnchor='stale',
                     PauseTimer=lambda t:calls.append(('pause',t)),
                     DestroyTimer=lambda t:calls.append(('timer',t)),
                     DestroyTrigger=lambda t:calls.append(('trigger',t)),
                     CreateTrigger=lambda:{},TriggerAddAction=lambda *a:None,
                     InitHashtable=lambda:self.fail('saved talent table must not be reallocated'),
                     Register_Forsaken_TalentSync=lambda:calls.append('sync'),
                     Register_Forsaken_PanelAccess=lambda:calls.append('panels'))
        env=execute(source,['Register_Forsaken_TalentClick','Forsaken_RebuildPanels'],state)
        env['Forsaken_RebuildPanels']()
        self.assertIs(env['ForsakenTalentState'],saved)
        self.assertEqual(saved,{(111,0):True,(111,20):1})
        self.assertEqual(calls[-2:],['sync','panels'])
        self.assertIsNone(env['ForsakenTalentAnchor'])

    def test_secrets_uses_exact_requested_earned_text_and_counter(self):
        from test_chronicles_secrets import runtime
        env=runtime()
        env['udg_TitleForce'][59].add(0)
        env['ChroniclesSecretsBase']=ui_recovery.SECRETS
        source=ui_recovery.secrets_source(module('Titles'))
        env=execute(source,['Forsaken_SecretsProgress','Chronicles_RefreshTooltips'],env)
        env['Chronicles_RefreshTooltips']()
        self.assertIn(('name','cSec','Secrets',0),env['writes'])
        self.assertIn(('body','cSec',ui_recovery.SECRETS+'|n|nChronicles Unlocked: 1/1',0),env['writes'])


if __name__=='__main__':unittest.main()
