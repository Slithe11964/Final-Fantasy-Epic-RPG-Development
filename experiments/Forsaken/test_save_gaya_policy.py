"""Detached Gaya support policy and actual-source owned replacement planning."""
import itertools
import unittest

import migrate_save as migration
import save_hero_policy as policy
import save_vnext as codec
import test_save_hero_policy as job_tests
from test_save_jass import engine

SOURCE=job_tests.HERE / 'Forsaken-save-gaya-policy.j'
SUPPORT=('A0B4','A02K','A02L')
CHANT=('A058','S004','A07E')


def values(level=20, mastered=False, ranks=(0,0,0), chants=(False,False,False)):
    return dict(level=level,mastered=mastered,break_stun=ranks[0],mana_transfer=ranks[1],
                mega_heal=ranks[2],tarugaya=chants[0],sukugaya=chants[1],rakugaya=chants[2])


class GayaPolicyTests(unittest.TestCase):
    def test_all_support_ranks_and_chant_combinations(self):
        for ranks in itertools.product(range(4),repeat=3):
            for chants in itertools.product((False,True),repeat=3):
                p=policy.gaya(values(ranks=ranks,chants=chants))
                self.assertEqual(p.support_ranks,ranks)
                self.assertEqual(p.purchases,tuple(r>0 for r in ranks))
                self.assertEqual(p.chants,chants)
                self.assertEqual(p.research,tuple((raw,int(rank>0)) for raw,rank in zip(policy.GAYA_SUPPORT_RESEARCH,ranks)))
                self.assertEqual(p.spiritual_power_available,any(chants))
                self.assertEqual(p.spiritual_power,1+sum(w for w,c in zip((1,2,4),chants) if c))

    def test_levels_and_mastered_consistency(self):
        for level in (0,1,49,50,99,100):
            self.assertEqual(policy.gaya(values(level=level)).native_level,max(1,level))
        p=policy.gaya(values(99,True,(3,3,3),(True,True,True)))
        self.assertEqual((p.native_level,p.spiritual_power,p.purchases),(99,8,(True,True,True)))
        for bad in (values(50,True,(3,3,3),(True,True,True)),values(99,True,(2,3,3),(True,True,True)),values(99,True,(3,3,3),(True,False,True)),values(101),values(-1),values(ranks=(4,0,0))):
            with self.assertRaises(codec.Error): policy.gaya(bad)
        bad=values(); del bad['rakugaya']
        with self.assertRaises(codec.Error):policy.gaya(bad)

    def test_legacy_profile_retains_saved_ranks_and_envelope(self):
        for case in job_tests.CASES:
            env=migration.translate(case['code'])
            p=policy.plan(env,env.account_hash)
            before=codec.encode(env)
            self.assertIs(p.envelope,env)
            self.assertEqual(codec.encode(p.envelope),before)
            self.assertEqual(p.gaya,policy.gaya(migration.progression.snapshot(env)['gaya']))

    def test_bt_object_bindings_confirm_innate_support_and_research_requirements(self):
        from mpq import MPQ
        from objdata import read_objects, fields
        archive=MPQ(str(job_tests.HERE.parents[1] / 'release/Forsaken/FFERPG_0.9.7.3-r16-ForsakenBT.w3x'))
        def objects(ext):
            table=read_objects(archive.read('war3map.'+ext),ext)
            return {o['id'] or o['base']:fields(o) for bucket in ('original','custom') for o in table[bucket]}
        units=objects('w3u'); abilities=objects('w3a')
        innate=set(units['H01D']['uabi'].split(','))
        self.assertTrue(set(SUPPORT+('A10F',))<=innate)
        self.assertFalse(set(CHANT)&innate)
        self.assertEqual(tuple(abilities[raw]['areq'] for raw in SUPPORT),policy.GAYA_SUPPORT_RESEARCH)
        self.assertEqual(abilities['A10F']['alev'],8)


class GayaBridgeTests(unittest.TestCase):
    def setUp(self):
        job_tests.BridgeTests.setUp(self)
        base=self.e
        # Reuse the already compiled fixture and add the actual bridge functions.
        addition=engine(SOURCE.read_text(encoding='utf-8'),self.w.natives())
        # Functions resolve through addition's globals, so populate those with base.
        addition.update(base)
        self.e=addition

    prepare=job_tests.BridgeTests.prepare
    core=job_tests.BridgeTests.core
    cleanup=job_tests.BridgeTests.cleanup

    def fresh(self,pid=0):
        self.prepare(pid=pid)
        for raw in SUPPORT+('A10F',): self.w.add_ability(self.w.created[1],raw,1)

    def plan_gaya(self,level=20,mastered=False,ranks=(0,0,0),chants=(False,False,False),pid=0):
        return self.e['FGP_Plan'](pid,1,level,mastered,*ranks,*chants,(max(1,level)-1)*100+7,2,13,18,19)

    def test_zero_purchases_preserve_locked_native_menus_and_originals(self):
        self.fresh(); self.assertTrue(self.core(stage=0)); self.assertTrue(self.plan_gaya())
        self.assertEqual(self.w.unit_writes,[])
        self.assertTrue(self.e['FHP_Apply'](0)); self.assertTrue(self.e['FHP_Verify'](0))
        u=self.w.created[1]
        self.assertEqual(tuple(u['ranks'][r] for r in SUPPORT),(1,1,1))
        self.assertEqual(u['ranks']['A10F'],1)
        self.assertTrue(all(r not in u['ranks'] for r in CHANT))
        self.assertEqual([dict(u) for u in self.units],self.originals); self.cleanup()

    def test_all_chants_prepare_exact_spiritual_power(self):
        for mask in range(8):
            with self.subTest(mask=mask):
                self.setUp(); self.fresh(); self.assertTrue(self.core(stage=0))
                chants=tuple(bool(mask&w) for w in (1,2,4))
                self.assertTrue(self.plan_gaya(ranks=(1,2,3),chants=chants))
                self.assertTrue(self.e['FHP_Apply'](0)); self.assertTrue(self.e['FHP_Verify'](0))
                u=self.w.created[1]
                self.assertEqual(tuple(u['ranks'][r] for r in SUPPORT),(1,2,3))
                self.assertEqual(u['ranks']['A10F'],mask+1)
                self.assertEqual(tuple(r in u['ranks'] for r in CHANT),chants)
                self.cleanup()

    def test_mastered_player7_plan_and_exact_points(self):
        self.fresh(pid=7); self.assertTrue(self.core(stage=0,pid=7))
        self.assertTrue(self.plan_gaya(99,True,(3,3,3),(True,True,True),7))
        self.assertTrue(self.e['FHP_Apply'](7)); self.assertTrue(self.e['FHP_Verify'](7))
        u=self.w.created[1]
        self.assertEqual((u['level'],u['points'],u['ranks']['A10F']),(99,2,8))
        self.assertEqual(self.e['FHP_Abilities'][169],7); self.cleanup(pid=7)

    def test_invalid_role_fields_and_nonfresh_abilities_refuse_partial_plan(self):
        self.fresh()
        for args in ((50,True,(3,3,3),(True,True,True)),(99,True,(3,2,3),(True,True,True)),(101,False,(0,0,0),(False,False,False)),(20,False,(4,0,0),(False,False,False))):
            self.assertFalse(self.plan_gaya(*args))
            self.assertFalse(self.e['FHP_Planned'][1]); self.assertEqual(self.e['FHP_Abilities'][1],0)
        self.assertFalse(self.e['FGP_Plan'](0,0,20,False,0,0,0,False,False,False,1907,2,13,18,19))
        self.w.created[1]['ranks']['A10F']=2
        self.assertFalse(self.plan_gaya()); self.assertFalse(self.e['FHP_Planned'][1])
        self.w.created[1]['ranks']['A10F']=1; self.w.add_ability(self.w.created[1],'A058')
        self.assertFalse(self.plan_gaya()); self.assertFalse(self.e['FHP_Planned'][1])
        self.assertEqual(self.w.unit_writes,[]); self.cleanup()

    def test_failed_chant_addition_retains_then_retries_without_power_increment(self):
        self.fresh(); self.assertTrue(self.core(stage=0))
        self.assertTrue(self.plan_gaya(ranks=(3,2,1),chants=(True,True,True)))
        self.w.bad_ability='S004'
        self.assertFalse(self.e['FHP_Apply'](0)); self.assertTrue(self.e['FSJ_PreparedPending'][0])
        self.w.bad_ability=None
        self.assertTrue(self.e['FHP_Apply'](0)); self.assertTrue(self.e['FHP_Verify'](0))
        self.assertEqual(self.w.created[1]['ranks']['A10F'],8)
        self.assertEqual([dict(u) for u in self.units],self.originals); self.cleanup()

    def test_source_crlf_no_player_or_original_writes(self):
        raw=SOURCE.read_bytes(); self.assertNotIn(b'\n',raw.replace(b'\r\n',b''))
        for forbidden in ('SetPlayerTechResearched(', 'SetPlayerAbilityAvailable(', 'SetHeroXP(', 'UnitRemoveAbility(', 'RemoveUnit('):
            self.assertNotIn(forbidden,raw.decode('utf-8'))


if __name__=='__main__': unittest.main()
