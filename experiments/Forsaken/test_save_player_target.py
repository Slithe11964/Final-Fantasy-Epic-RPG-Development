"""Reversible research and per-game skill choices using actual source."""
import unittest
import test_save_hero_policy as fixtures
from test_save_jass import engine

SOURCE=fixtures.HERE/'Forsaken-save-player-target.j'

class PlayerTargetTests(unittest.TestCase):
    def setUp(self):
        fixtures.BridgeTests.setUp(self)
        extra=self.w.natives();extra['IMaxBJ']=max
        addition=engine(SOURCE.read_text(encoding='utf-8'),extra)
        addition.update(self.e);self.e=addition

    prepare=fixtures.BridgeTests.prepare
    core=fixtures.BridgeTests.core
    cleanup=fixtures.BridgeTests.cleanup

    def ready(self,pid=0):
        self.prepare(pid)
        # All three target writes must change a value for fault injection.
        self.w.techs[pid,self.e['FPG_TechRaw'](17)]=0
        self.e['FPG_Tech'][pid*18+17]=0
        for raw,rank in zip(('A0B4','A02K','A02L'),(1,2,3)):
            self.w.add_ability(self.w.created[1],raw,rank)
        self.assertTrue(self.core(stage=0,pid=pid));self.assertTrue(self.core(stage=1,pid=pid))
        self.assertTrue(self.e['FHP_Apply'](pid));self.w.writes.clear()
        self.before_tech=[self.w.techs.get((pid,self.e['FPG_TechRaw'](15+i)),0) for i in range(3)]
        self.before_skill=[self.e['FPT_Skill'](pid,i) for i in range(6)]

    def begin(self,pid=0):self.assertTrue(self.e['FPT_Begin'](pid,0,2,3))

    def close(self,pid=0):
        self.assertTrue(self.e['FPT_Recover'](pid));self.assertTrue(self.e['FPT_Release'](pid))
        self.assertEqual([self.w.techs[pid,self.e['FPG_TechRaw'](15+i)] for i in range(3)],self.before_tech)
        self.assertEqual([self.e['FPT_Skill'](pid,i) for i in range(6)],self.before_skill)
        self.cleanup(pid)

    def test_readonly_capture_apply_and_original_recovery(self):
        self.ready();self.begin();self.assertEqual(self.w.writes,[])
        self.assertTrue(self.e['FPT_Apply'](0));self.assertTrue(self.e['FPT_Verify'](0))
        self.assertEqual([self.w.techs[0,self.e['FPG_TechRaw'](15+i)] for i in range(3)],[0,1,1])
        self.assertEqual([self.e['FPT_Skill'](0,i) for i in range(6)],[0]*6)
        self.assertFalse(self.e['FHP_Discard'](0));self.assertFalse(self.e['FSO_Neutralize'](0))
        self.assertFalse(self.e['FPT_Release'](0));self.close()
        self.assertEqual([dict(u) for u in self.units],self.originals)

    def test_each_research_apply_failure_retains_then_recovers(self):
        for fault in range(1,4):
            self.setUp();self.ready();self.begin();self.w.reject=fault
            self.assertFalse(self.e['FPT_Apply'](0));self.assertEqual(self.e['FPT_State'][0],3)
            self.assertTrue(self.e['FSJ_PlayerPending'][0]);self.w.reject=0;self.close()

    def test_each_research_recovery_failure_retains_and_retries(self):
        for fault in range(1,4):
            self.setUp();self.ready();self.begin();self.assertTrue(self.e['FPT_Apply'](0))
            self.w.writes.clear();self.w.reject=fault
            self.assertFalse(self.e['FPT_Recover'](0));self.assertFalse(self.e['FPT_Release'](0))
            self.w.reject=0;self.close()

    def test_reentrant_player_and_disposal_calls_are_blocked(self):
        self.ready();self.begin();results=[]
        def callback():
            results.extend((self.e['FPT_Apply'](0),self.e['FPT_Recover'](0),self.e['FPT_Release'](0),self.e['FHP_Discard'](0)))
        self.w.write_callback=callback
        self.assertTrue(self.e['FPT_Apply'](0));self.w.write_callback=None
        self.assertTrue(results);self.assertFalse(any(results));self.close()

    def test_each_skill_write_failure_is_detected_and_recoverable(self):
        for fault in range(6):
            self.setUp();self.ready();self.begin()
            original=self.e['FPT_SetSkill']
            self.e['FPT_SetSkill']=lambda pid,slot,value:None if slot==fault else original(pid,slot,value)
            expected=self.before_skill[fault]!=0
            self.assertEqual(self.e['FPT_Apply'](0),not expected)
            self.e['FPT_SetSkill']=original;self.close()

    def test_changed_skill_or_support_and_invalid_input_refuse_capture(self):
        self.ready()
        for pid,ranks in [(-1,(0,2,3)),(0,(-1,2,3)),(0,(0,4,3)),(0,(0,1,3))]:
            self.assertFalse(self.e['FPT_Begin'](pid,*ranks))
        self.e['udg_AbilitySlot1'][1]+=1
        self.assertFalse(self.e['FPT_Begin'](0,0,2,3));self.assertFalse(self.e['FSJ_PlayerPending'][0])
        self.e['udg_AbilitySlot1'][1]=self.before_skill[0];self.begin();self.close()

    def test_core_drift_still_allows_player_recovery_and_player7(self):
        self.ready(7);self.begin(7);self.assertTrue(self.e['FPT_Apply'](7))
        self.w.created[0]['strength']+=1
        self.assertTrue(self.e['FPT_Recover'](7));self.assertTrue(self.e['FPT_Release'](7))
        self.assertEqual([self.e['FPT_Skill'](7,i) for i in range(6)],self.before_skill)
        self.cleanup(7)

    def test_research_side_effect_blocks_apply_but_player_recovery_survives(self):
        self.ready();self.begin()
        def callback():self.w.created[0]['strength']+=1
        self.w.write_callback=callback
        self.assertFalse(self.e['FPT_Apply'](0));self.assertEqual(self.e['FPT_State'][0],3)
        self.assertTrue(self.e['FSJ_PlayerPending'][0]);self.w.write_callback=None;self.close()

    def test_activation_pending_and_foreign_owner_refuse_recovery(self):
        self.ready();self.begin();self.assertTrue(self.e['FPT_Apply'](0));self.w.writes.clear()
        self.e['FSJ_ActivationPending'][0]=True
        self.assertFalse(self.e['FPT_Recover'](0));self.assertEqual(self.w.writes,[])
        self.e['FSJ_ActivationPending'][0]=False;self.w.created[0]['owner']=2
        self.assertFalse(self.e['FPT_Recover'](0));self.assertEqual(self.w.writes,[])
        self.w.created[0]['owner']=0;self.close()

    def test_source_crlf_and_no_unverifiable_availability_or_hero_writes(self):
        raw=SOURCE.read_bytes();self.assertNotIn(b'\n',raw.replace(b'\r\n',b''))
        for text in ('SetPlayerAbilityAvailable(', 'SetHeroXP(', 'RemoveUnit(', 'CreateUnit('):self.assertNotIn(text,raw.decode('utf-8'))

if __name__=='__main__':unittest.main()
