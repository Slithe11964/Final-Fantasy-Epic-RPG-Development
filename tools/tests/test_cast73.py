"""Cross-client spell notices defer visual work and cannot clear a newer aim."""
import sys,unittest
from pathlib import Path
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from editor_pair import View
from jtok import functions,tokens
from cast73 import refresh
from test_armory_materia import execute
from test_shared_context import mocks
ROOT=Path(__file__).resolve().parents[2]

class Cast73Tests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.before=View(ROOT/'release/development/QuickUI72/FFERPG-QuickUI72.w3x').modules['TEquip']
        cls.source=refresh(cls.before);cls.fs=functions(cls.source)

    def runtime(self,viewer=0):
        source=self.fs['QuickGear_RecordSpell']+'\n'+self.fs['UI72_Tick'];env=mocks(source);clears=[]
        env.update(GetTriggerUnit=lambda:'hero',GetOwningPlayer=lambda h:0,GetPlayerId=lambda p:p,
            Player_GetHero=lambda p:'hero',GetLocalPlayer=lambda:viewer,GetTriggerEventId=lambda:2,
            EVENT_PLAYER_UNIT_SPELL_EFFECT=2,GetSpellAbilityId=lambda:123,
            QuickGearActualSpell={0:0},GearWaveMode=1,GearWaveCast67=123,
            UI73ClearRequested=False,UI73AimRevision=7,UI73ClearRevision=0,
            Preview_LogClear68=lambda s:None,QuickGear_ClearPreview=lambda:clears.append('clear'),
            ExecuteFunc=lambda n:self.fail('owner-only nested execution from spell observer'))
        e=execute(source,['QuickGear_RecordSpell','UI72_Tick'],env)
        return e,clears

    def test_shared_event_records_same_spell_but_only_owner_queues_cleanup(self):
        for viewer in [0,1]:
            e,clears=self.runtime(viewer);e['QuickGear_RecordSpell']()
            self.assertEqual(e['QuickGearActualSpell'][0],123);self.assertEqual(clears,[])
            self.assertEqual(e['UI73ClearRequested'],viewer==0)

    def test_cleanup_runs_once_on_existing_heartbeat(self):
        e,clears=self.runtime();e['QuickGear_RecordSpell']()
        e['ExecuteFunc']=lambda n:None;e['UI72_Tick']();e['UI72_Tick']()
        self.assertEqual(clears,['clear'])

    def test_old_cast_does_not_clear_new_preview(self):
        e,clears=self.runtime();e['QuickGear_RecordSpell']();e['UI73AimRevision']+=1
        e['ExecuteFunc']=lambda n:None;e['UI72_Tick']();self.assertEqual(clears,[])

    def test_unrelated_cast_leaves_native_wave_aim_intact(self):
        e,clears=self.runtime();e['GearWaveCast67']=999;e['QuickGear_RecordSpell']()
        self.assertFalse(e['UI73ClearRequested']);self.assertEqual(clears,[])

    def test_only_four_functions_change_and_no_timers_added(self):
        a,b=functions(self.before),self.fs
        self.assertEqual({n for n in a if tokens(a[n])!=tokens(b[n])},
            {'QuickGear_RecordSpell','UI72_Tick','QuickGear_Request','GearWave_Arm'})
        for n in ['QuickGear_RecordSpell','UI72_Tick']:
            self.assertNotIn('CreateTimer(',b[n]);self.assertNotIn('CreateGroup(',b[n])

if __name__=='__main__':unittest.main()
