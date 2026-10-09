"""Saved normal-job decisions and actual-JASS contained preparation bridge."""
import json
from pathlib import Path
import unittest

import migrate_save as migration
import save_hero_policy as policy
import save_vnext as codec
from test_save_jass import engine, SOURCE
import test_save_prepared_heroes as prepared_tests
from test_save_prepared_heroes import PREPARED, SKILL_GLOBALS
from test_save_units import MODULES
from test_save_references import REFERENCES
from test_save_body import BODY
from test_save_ownership import OWNERSHIP
from test_save_session import SESSION_GLOBALS
from test_save_progression_journal import DECLARATIONS
from test_save_heroes import EXTRA

HERE = Path(__file__).resolve().parent
BRIDGE = HERE / 'Forsaken-save-job-policy.j'
CASES = json.loads((HERE / 'legacy-fixtures.json').read_text(encoding='utf-8'))['cases']


def replaced(envelope, sid, payload):
    return codec.Envelope(envelope.account_hash, tuple(
        codec.Section(s.id, s.version, s.required, payload) if s.id == sid else s
        for s in envelope.sections))


class PolicyTests(unittest.TestCase):
    def test_every_legacy_version_maps_without_changing_evidence(self):
        for case in CASES:
            envelope = migration.translate(case['code'])
            before = codec.encode(envelope)
            resolved = policy.plan(envelope, envelope.account_hash)
            self.assertIs(resolved.envelope, envelope)
            self.assertEqual(codec.encode(resolved.envelope), before)
            self.assertEqual(len(resolved.jobs), 22)
            self.assertEqual(resolved.dormant_jobs, ())
            levels = dict(codec.read_pairs(next(s.payload for s in envelope.sections if s.id == 2)))
            self.assertEqual([(p.identity, p.saved_level) for p in resolved.jobs], sorted(levels.items()))

    def test_all_levels_and_identities_have_bounded_skill_policy(self):
        for identity in range(1, 23):
            for saved in range(101):
                p = policy.normal_job(identity, saved)
                self.assertEqual(p.native_level, max(1, min(saved, 99)))
                self.assertEqual(p.points, p.native_level if saved < 50 else p.native_level - 50)
                self.assertEqual(p.skill_ranks, (0,)*5 if saved < 50 else (11,11,11,11,6))
                self.assertEqual((p.mastery_rank,p.attribute_bonus),
                                 (4,100) if saved==100 else ((3,50) if saved==99 else ((2,20) if saved>=50 else (1,0))))

    def test_future_jobs_and_optional_sections_are_preserved_without_rewards(self):
        env = migration.translate(CASES[0]['code'])
        jobs = codec.read_pairs(next(s.payload for s in env.sections if s.id == 2))
        env = replaced(env, 2, codec.pairs(jobs + [(999,100),(23,49)]))
        env = codec.Envelope(env.account_hash, env.sections + (codec.Section(123,7,False,'ABCD'),))
        resolved = policy.plan(env, env.account_hash)
        self.assertEqual(resolved.dormant_jobs, ((23,49),(999,100)))
        self.assertEqual(len(resolved.jobs),22)
        self.assertEqual(codec.encode(resolved.envelope),codec.encode(env))

    def test_wrong_account_invalid_profile_and_cheat_refuse(self):
        env = migration.translate(CASES[0]['code'])
        for account in (True,-1,1048576,env.account_hash ^ 1):
            with self.assertRaises(codec.Error): policy.plan(env,account)
        fields=codec.read_pairs(next(s.payload for s in env.sections if s.id==4))
        with self.assertRaises(codec.Error):
            policy.plan(replaced(env,4,codec.pairs([(i,1 if i==11 else v) for i,v in fields])),env.account_hash)
        with self.assertRaises(codec.Error): policy.plan(replaced(env,2,codec.pairs([(1,50)])),env.account_hash)

    def test_invalid_levels_and_ids_do_not_infer_new_content(self):
        for identity,level in [(True,50),(0,50),(23,50),(1,True),(1,-1),(1,101),(1,150),(1,999),(1,3.5)]:
            with self.assertRaises(codec.Error): policy.normal_job(identity,level)


class BridgeTests(unittest.TestCase):
    def setUp(self):
        prepared_tests.PreparedTests.setUp(self)
        source = DECLARATIONS+EXTRA+SESSION_GLOBALS+SKILL_GLOBALS+'\n'.join(
            SOURCE.with_name('Forsaken-save-'+m+'.j').read_text(encoding='utf-8') for m in MODULES)
        source += REFERENCES.read_text(encoding='utf-8')+BODY.read_text(encoding='utf-8')+OWNERSHIP.read_text(encoding='utf-8')+PREPARED.read_text(encoding='utf-8')+BRIDGE.read_text(encoding='utf-8')
        previous=self.e
        self.e=engine(source,self.w.natives())
        self.e.update({k:v for k,v in previous.items() if not callable(v)})

    prepare=prepared_tests.PreparedTests.prepare
    core=prepared_tests.PreparedTests.core
    cleanup=prepared_tests.PreparedTests.cleanup

    def test_saved_profile_to_contained_native_preparation(self):
        for saved in (0,1,49,50,98,99,100):
            with self.subTest(saved=saved):
                self.setUp(); self.prepare()
                env=migration.translate(CASES[0]['code'])
                pairs=codec.read_pairs(next(s.payload for s in env.sections if s.id==2))
                env=replaced(env,2,codec.pairs([(i,saved if i==1 else v) for i,v in pairs]))
                p=policy.plan(env,env.account_hash).jobs[0]
                self.assertTrue(self.e['FJP_PlanNormal'](0,0,p.identity,p.saved_level,(p.native_level-1)*100+7,13,18,19))
                self.assertTrue(self.core(stage=1))
                self.assertEqual(self.w.unit_writes,[])
                self.assertTrue(self.e['FHP_Apply'](0)); self.assertTrue(self.e['FHP_Verify'](0))
                u=self.w.created[0]
                self.assertEqual((u['level'],u['points'],u['strength'],u['agility'],u['intelligence']),
                                 (p.native_level,p.points,13+p.attribute_bonus,18+p.attribute_bonus,19+p.attribute_bonus))
                self.assertEqual(u['ranks']['A02F'],p.mastery_rank)
                self.assertEqual(tuple(u['ranks'].get(self.e['udg_JobSkill'][i],0) for i in range(1,6)),p.skill_ranks)
                self.assertEqual([dict(u) for u in self.units],self.originals)
                self.cleanup()

    def test_invalid_inputs_refuse_before_partial_core(self):
        self.prepare()
        args=(0,0,1,50,4907,13,18,19)
        for index,value in [(0,-1),(1,-1),(1,2),(2,0),(2,2),(2,23),(3,-1),(3,101),(4,-1),(5,-1),(5,2147483647),(6,2147483647),(7,2147483647)]:
            bad=list(args); bad[index]=value
            self.assertFalse(self.e['FJP_PlanNormal'](*bad))
            self.assertFalse(self.e['FHP_Planned'][0]); self.assertEqual(self.e['FHP_Abilities'][0],0)
        self.assertFalse(self.e['FJP_PlanNormal'](0,1,1,50,4907,13,18,19)) # Gaya
        self.assertEqual(self.w.unit_writes,[]); self.cleanup()

    def test_duplicate_and_conflicting_skill_marker_refuse(self):
        self.prepare()
        self.e['FHP_Skill'][0]='A02F'; self.e['udg_JobSkill'][1]='A02F'
        self.assertFalse(self.e['FJP_PlanNormal'](0,0,1,50,4907,13,18,19))
        self.assertFalse(self.e['FHP_Planned'][0])
        self.e['FHP_Skill'][0]='J000'; self.e['udg_JobSkill'][1]='J000'
        self.assertTrue(self.e['FJP_PlanNormal'](0,0,1,50,4907,13,18,19))
        self.assertFalse(self.e['FJP_PlanNormal'](0,0,1,50,4907,13,18,19))
        self.assertEqual(self.e['FHP_Abilities'][0],1); self.cleanup()

    def test_xp_mismatch_remains_blocked_and_disposable(self):
        self.prepare()
        self.assertTrue(self.e['FJP_PlanNormal'](0,0,1,100,7,13,18,19))
        self.assertTrue(self.core(stage=1))
        self.assertFalse(self.e['FHP_Apply'](0)); self.assertEqual(self.e['FHP_State'][0],3)
        self.assertTrue(self.e['FSJ_PreparedPending'][0]); self.cleanup()

    def test_player7_identity_and_integer_addition_boundary(self):
        self.prepare(pid=7)
        maximum=codec.MAX_INT
        self.assertTrue(self.e['FJP_PlanNormal'](7,0,1,100,9807,maximum-100,0,0))
        self.assertEqual(self.e['FHP_Str'][168],maximum)
        self.assertEqual(self.e['FHP_Level'][168],99)
        self.cleanup(pid=7)

    def test_rejected_mastery_ability_retains_and_retries_same_plan(self):
        self.prepare()
        self.w.created[0]['ranks'].pop('A02F')
        self.w.created[0]['ability_handles'].pop('A02F')
        self.assertTrue(self.e['FJP_PlanNormal'](0,0,1,100,9807,13,18,19))
        self.assertTrue(self.core(stage=1)); self.w.bad_ability='A02F'
        self.assertFalse(self.e['FHP_Apply'](0))
        self.assertTrue(self.e['FSJ_PreparedPending'][0])
        self.w.bad_ability=None
        self.assertTrue(self.e['FHP_Apply'](0)); self.assertTrue(self.e['FHP_Verify'](0))
        self.assertEqual(self.w.created[0]['strength'],113)
        self.assertEqual(self.w.created[0]['ranks']['A02F'],4)
        self.assertEqual([dict(u) for u in self.units],self.originals)
        self.cleanup()

    def test_source_crlf_and_no_native_mutation_or_growth_guess(self):
        raw=BRIDGE.read_bytes(); self.assertNotIn(b'\n',raw.replace(b'\r\n',b''))
        source=raw.decode('utf-8')
        for forbidden in ('SetHeroLevel(', 'SetHeroXP(', 'SetHeroStr(', 'SetUnitAbilityLevel(', 'RemoveUnit(', 'CreateUnit('):
            self.assertNotIn(forbidden,source)


if __name__=='__main__': unittest.main()
