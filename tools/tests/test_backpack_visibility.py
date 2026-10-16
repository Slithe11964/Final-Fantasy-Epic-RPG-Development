"""Keep native inventory presentation through drops without changing shared state."""
from pathlib import Path
import sys,unittest
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from inventory_ui import refresh
from jtok import functions
from test_armory_materia import execute
from test_shared_context import mocks
ROOT=Path(__file__).resolve().parents[2]
HELPER=(ROOT/'experiments/Forsaken/BackpackVisibility.j').read_text()


class BackpackVisibilityTests(unittest.TestCase):
    def runtime(self):
        env=mocks(HELPER);now=[10.];shown=[];selected=[True];owner=[0]
        env.update(GetTriggerUnit=lambda:'hero',GetOwningPlayer=lambda u:owner[0],
            GetLocalPlayer=lambda:0,Player_GetHero=lambda p:'hero',IsUnitSelected=lambda *a:selected[0],
            ForsakenBackpackWasVisible=True,ForsakenBackpackRestoreUntil=0.,ForsakenPanelClock='clock',
            ForsakenFrameSearchRequested=False,TimerGetElapsed=lambda t:now[0],BlzFrameIsVisible=lambda f:False,
            BlzFrameSetVisible=lambda *a:shown.append(a))
        e=execute(HELPER,['Forsaken_BackpackActivity','Forsaken_BackpackVisible'],env)
        return e,now,shown,selected,owner

    def test_drop_or_use_recovers_open_backpack_after_native_refresh(self):
        e,now,shown,selected,owner=self.runtime()
        e['Forsaken_BackpackActivity']()
        self.assertEqual(e['ForsakenBackpackRestoreUntil'],10.5)
        now[0]=10.1;self.assertTrue(e['Forsaken_BackpackVisible']('backpack'))
        self.assertEqual(shown,[('backpack',True)])
        self.assertTrue(e['ForsakenFrameSearchRequested'])

    def test_closed_inventory_and_expired_restore_do_not_force_it_open(self):
        e,now,shown,selected,owner=self.runtime();e['ForsakenBackpackWasVisible']=False
        e['Forsaken_BackpackActivity']();self.assertFalse(e['Forsaken_BackpackVisible']('backpack'))
        e['ForsakenBackpackWasVisible']=True;e['Forsaken_BackpackActivity']();now[0]=11.
        self.assertFalse(e['Forsaken_BackpackVisible']('backpack'));self.assertEqual(shown,[])
        self.assertFalse(e['Forsaken_BackpackVisible'](None))

    def test_other_players_and_unselected_hero_do_not_change_local_intent(self):
        e,now,shown,selected,owner=self.runtime();owner[0]=1
        e['Forsaken_BackpackActivity']();self.assertEqual(e['ForsakenBackpackRestoreUntil'],0.)
        owner[0]=0;selected[0]=False;e['Forsaken_BackpackActivity']()
        self.assertEqual(e['ForsakenBackpackRestoreUntil'],0.);self.assertEqual(shown,[])

    def test_escape_and_backpack_hotkey_cancel_restore(self):
        s='library TEquip\nglobals\nendglobals\n'+(ROOT/'experiments/Forsaken/Forsaken-panels.j').read_text()+'\nendlibrary'
        s=refresh(s)
        for key in ['escape','backpack']:
            env=mocks(s);env.update(GetTriggerPlayer=lambda:0,GetLocalPlayer=lambda:0,Player_GetHero=lambda p:'hero',
                GetTriggerEventId=lambda:'key',GetTriggerUnit=lambda:None,BlzGetTriggerPlayerKey=lambda:key,
                EVENT_PLAYER_UNIT_SELECTED='selected',EVENT_PLAYER_UNIT_DESELECTED='deselected',
                OSKEY_ESCAPE='escape',OSKEY_B='backpack',ForsakenBackpackRestoreUntil=10.,
                ForsakenInspectRoot='inspect',ForsakenTalentRoot='talents',ForsakenPanelOpen=True,ForsakenPanelNeedsRefresh=False)
            e=execute(s,['Forsaken_PanelAccess'],env);e['Forsaken_PanelAccess']()
            self.assertEqual(e['ForsakenBackpackRestoreUntil'],0.)

    def test_native_only_integration_is_idempotent(self):
        s='library TEquip\nglobals\nendglobals\n'+(ROOT/'experiments/Forsaken/Forsaken-panels.j').read_text()+'\nendlibrary'
        result=refresh(s);self.assertEqual(refresh(result),result)
        fs=functions(result)
        self.assertIn('Forsaken_BackpackVisible(nativePanel)',fs['Forsaken_PollPanels'])
        self.assertIn('Forsaken_RegisterBackpackActivity()',fs['Register_Forsaken_PanelAccess'])
        self.assertEqual(refresh('library TBackpack\nendlibrary'),'library TBackpack\nendlibrary')


if __name__=='__main__':unittest.main()
