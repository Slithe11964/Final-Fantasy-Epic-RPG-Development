"""Actual read-only capture against modeled BT handles; engine round trip still pending."""
import copy
import json
from pathlib import Path
import unittest

import save_progression as progression
import save_vnext as codec
import save_registry
from test_save_jass import JassArray, engine
from test_save_life import Real32

HERE = Path(__file__).resolve().parent


def raw(text):
    return text  # Existing source harness represents rawcode literals as strings.


class CaptureTests(unittest.TestCase):
    def setUp(self):
        self.hero = dict(raw=raw('H002'), level=51, abilities={raw('A02F'): 2}, quick={}, bag={}, equipment={})
        self.free = dict(raw=raw('H02L'), level=99, abilities={raw('A02F'): 4})
        self.gaya = dict(raw=raw('H03N'), level=51, abilities={raw('A0B4'): 2, raw('A02K'): 1, raw('A02L'): 1, raw('A058'): 1}, quick={})
        self.house = dict(raw=raw('n001'), quick={})
        self.registry, self.aliases = save_registry.check(json.loads((HERE.parents[1]/'release/Forsaken/gear-slots-BS.json').read_text()))
        self.players = JassArray(lambda: None)
        self.players[1] = self.hero
        self.gayas = JassArray(lambda: None); self.gayas[1] = self.gaya
        self.houses = JassArray(lambda: None); self.houses[1] = self.house
        self.frees = JassArray(lambda: None); self.frees[1] = self.free
        self.names = JassArray(lambda: 'Fixture#1234')
        self.jobs = JassArray(lambda: 0)
        for job in self.registry['jobs']: self.jobs[job['legacy_index']] = raw(job['rawcode'])
        self.job_table = {(raw('H002'), 0): self.hero}
        self.level_table = {(raw('H000'), 0): 66, (raw('H008'), 0): 100}
        self.title_forces = JassArray(lambda: set())
        self.title_forces[18] = {0}; self.title_forces[100] = {0}
        self.armory_forces = JassArray(lambda: set())
        self.armory_forces[1] = {0}; self.armory_forces[358] = {0}
        self.techs = {(0, raw('Resi')): 1, (0, raw('R000')): 10}
        self.elapsed = None
        self.destroyed = []
        self.mutations = []
        def timer(): return object()
        def remove(table, parent, key): table.pop((parent, key), None)
        natives = dict(I2S=str, I2R=Real32, R2I=lambda v: int(float(v)),
            StringHash=lambda s: ord(s.upper()) if len(s)==1 else (-2147483648 if s == 'MIN' else -123456789),
            Player=lambda p: p, LoadInteger=lambda t, a, b: t.get((a, b), 0),
            SaveInteger=lambda t, a, b, v: t.__setitem__((a, b), v),
            RemoveSavedInteger=remove, LoadUnitHandle=lambda t, a, b: t.get((a, b)),
            GetUnitTypeId=lambda u: u['raw'] if u else 0,
            GetHeroLevel=lambda u: u['level'] if u else 0,
            GetUnitAbilityLevel=lambda u, ability: u.get('abilities', {}).get(ability, 0) if u else 0,
            GetPlayerState=lambda p, state: 123456 if state == 1 else 42,
            GetPlayerTechCount=lambda p, tech, all: self.techs.get((p, tech), 0),
            IsPlayerInForce=lambda p, force: p in force,
            UnitItemInSlot=lambda u, slot: u.get('quick', {}).get(slot) if u else None,
            UnitItemInBagSlot=lambda u, slot: u['bag'].get(slot),
            UnitItemInEquipmentSlot=lambda u, slot: u['equipment'].get(slot),
            ConvertLoadoutSlot=lambda slot: slot, UnitExtendedInventorySize=lambda u: 30,
            GetItemTypeId=lambda i: i['raw'] if i else 0,
            GetItemCharges=lambda i: i['quantity'], GetItemUserData=lambda i: i['binding'],
            GetWidgetLife=lambda i: Real32(i['life']), IsItemInvulnerable=lambda i: bool(i['flags'] & 1),
            BlzGetItemBooleanField=lambda i, field: bool(i['flags'] & 2),
            IsItemPawnable=lambda i: bool(i['flags'] & 4),
            CreateTimer=timer, TimerStart=lambda *args: None, PauseTimer=lambda *args: None,
            DestroyTimer=self.destroyed.append, GetHandleId=id, GetExpiredTimer=lambda: self.elapsed,
            PLAYER_STATE_RESOURCE_GOLD=1, PLAYER_STATE_RESOURCE_LUMBER=2, ITEM_BF_CAN_BE_DROPPED=1,
            udg_PlayerHero=self.players, udg_SpiritOfGaya=self.gayas, udg_PlayerHouse=self.houses,
            udg_FreelancerHero=self.frees, udg_JobHeroHash=self.job_table, udg_JobLevelHash=self.level_table,
            udg_JobUnitType=self.jobs, udg_PlayerName=self.names,
            udg_CodeDifficulty=JassArray(lambda: 2), udg_NewGamePlusLevel=JassArray(lambda: 0),
            udg_MiracleStage=JassArray(lambda: 1), udg_MetaFragments=JassArray(lambda: 2),
            udg_SpeedrunLevel=JassArray(lambda: 3), udg_LegendaryGuardianForce={0}, udg_CheaterForce=set(),
            udg_TitleForce=self.title_forces, udg_SaveFlagForce=self.armory_forces,
            udg_SaveFlagCount=358, udg_SpeedrunMode=False, udg_ArmoryCodeSegment=JassArray(lambda: 0))
        source = (HERE/'Forsaken-save-life.j').read_text()+'\n'+(HERE/'Forsaken-save-capture.j').read_text()
        self.e = engine(source, natives)
        self.e['FRC_Init']()
        for alias, identity in self.aliases.items(): self.e['FRC_Map'][(0, raw(alias))] = identity
        def item(code, quantity, binding=1, life=145.25, flags=5):
            return dict(raw=raw(code), quantity=quantity, binding=binding, life=life, flags=flags)
        self.hero['quick'][0] = item('phea', 0)
        self.hero['bag'][29] = item('f003', 120)
        self.hero['equipment'][3] = item('f003', 0, life=1.)
        self.house['quick'][0] = item('pman', 127)
        self.house['quick'][3] = item('pman', 2, binding=0)
        self.gaya['quick'][5] = item('phea', 7)

    def start(self):
        self.assertTrue(self.e['FRC_Start'](0))
        self.elapsed = self.e['FRC_Timer'][0]

    def tick(self): self.e['FRC_Tick']()

    def finish(self):
        for _ in range(150):
            if self.e['FRC_Phase'][0] == 0: break
            self.tick()
        self.assertEqual(self.e['FRC_Phase'][0], 0)

    def test_full_capture_exact_slots_metadata_actual_jobs_and_flags_read_only(self):
        before = copy.deepcopy((self.hero, self.gaya, self.free, self.house, self.level_table, self.techs))
        self.start(); self.finish()
        self.assertTrue(self.e['FRC_Ready'][0], self.e['FRC_Error'][0])
        envelope = codec.decode(self.e['FRC_Result'][0])
        state = progression.snapshot(envelope)
        self.assertEqual(state['core']['current_job'], 11)
        self.assertEqual(state['job_levels'][11], 51)
        self.assertEqual(state['job_levels'][1], 66)
        self.assertEqual((state['job_levels'][15], state['job_mastery'][15]), (99, 3))
        self.assertEqual(state['core']['freelancer'], 99)
        self.assertEqual(state['core']['freelancer_mastery'], 3)
        self.assertEqual(state['titles'], [18, 100])
        self.assertEqual(state['armory'], [1, 358])
        self.assertEqual(state['core']['gold'], 123456)
        self.assertEqual(state['core']['shards'], 42)
        self.assertEqual(state['gaya']['break_stun'], 2)
        self.assertEqual(state['gaya']['mana_transfer'], 0)  # Research was never purchased.
        self.assertEqual([(r[2], r[3], r[4], r[5]) for r in state['inventory']],
            [(1, 0, 0, True), (2, 29, 120, True), (3, 3, 0, True), (4, 5, 7, True),
             (5, 0, 127, True), (5, 3, 2, False)])
        self.assertEqual(codec.read_life(state['inventory'][1][6][0][2]), 145.25)
        self.assertEqual(before, (self.hero, self.gaya, self.free, self.house, self.level_table, self.techs))
        self.assertEqual(len(self.destroyed), 2)
        self.assertEqual(self.e['FRC_Timers'], {})

    def test_change_during_capture_fails_and_retry_succeeds(self):
        self.start()
        for _ in range(66): self.tick()
        self.hero['quick'][0]['quantity'] = 1
        self.finish()
        self.assertFalse(self.e['FRC_Ready'][0])
        self.assertIn('inventory changed', self.e['FRC_Error'][0])
        self.start(); self.finish()
        self.assertTrue(self.e['FRC_Ready'][0])

    def test_unknown_item_and_foreign_binding_are_never_omitted(self):
        for update in ({'raw': raw('XXXX')}, {'binding': 2}, {'quantity': 128}):
            with self.subTest(update=update):
                self.setUp(); self.hero['quick'][0].update(update)
                self.start(); self.finish()
                self.assertFalse(self.e['FRC_Ready'][0])
                self.assertIsNone(self.e['FRC_Result'][0])
                self.assertTrue(self.e['FRC_Error'][0])

    def test_progression_change_and_reference_change_abort_read_only(self):
        self.start()
        for _ in range(66): self.tick()
        self.hero['level'] = 52
        self.finish()
        self.assertFalse(self.e['FRC_Ready'][0])
        self.assertIn('progression', self.e['FRC_Error'][0])
        self.start(); self.players[1] = dict(self.hero, replacement=True); self.tick()
        self.assertIn('character/storage/account', self.e['FRC_Error'][0])

    def test_missing_last_armory_field_would_not_pass(self):
        self.start(); self.finish()
        self.assertTrue(self.e['FRC_Ready'][0])
        envelope = codec.decode(self.e['FRC_Result'][0])
        self.assertEqual({s.id for s in envelope.sections}, {1, 2, 4, 5, 6, 7, 8})

    def test_timeout_and_unreviewed_variant_fail_without_gameplay_changes(self):
        self.start(); self.e['FRC_Timeout']()
        self.assertFalse(self.e['FRC_Ready'][0])
        self.assertEqual(self.players[1], self.hero)
        self.free['raw'] = raw('H02O')
        self.start(); self.finish()
        self.assertFalse(self.e['FRC_Ready'][0])
        self.assertIn('variant', self.e['FRC_Error'][0])

    def test_live_starting_hero_does_not_require_a_preexisting_job_cache(self):
        self.job_table.clear()
        self.start(); self.finish()
        self.assertTrue(self.e['FRC_Ready'][0], self.e['FRC_Error'][0])
        state = progression.snapshot(codec.decode(self.e['FRC_Result'][0]))
        self.assertEqual(state['job_levels'][11], 51)

    def test_capture_timeout_does_not_abort_an_unrelated_writer(self):
        self.start()
        self.assertTrue(self.e['FSC_Begin'](0, 42))
        self.e['FRC_Timeout']()
        self.assertTrue(self.e['FSC_Writing'][0])
        self.e['FSC_Abort'](0)

    def test_new_game_minus_and_invalid_scalars_are_rejected(self):
        self.e['udg_NewGamePlusLevel'][1] = -1
        self.start(); self.finish()
        self.assertFalse(self.e['FRC_Ready'][0])
        self.assertIn('New Game mode', self.e['FRC_Error'][0])
        self.e['udg_NewGamePlusLevel'][1] = 0
        self.e['GetPlayerState'] = lambda *a: -1
        self.start(); self.finish()
        self.assertFalse(self.e['FRC_Ready'][0])
        self.assertIsNone(self.e['FRC_Result'][0])

    def test_speedrun_context_is_explicit_in_the_code(self):
        self.e['udg_SpeedrunMode'] = True
        self.start(); self.finish()
        state = progression.snapshot(codec.decode(self.e['FRC_Result'][0]))
        self.assertEqual(state['core']['speedrun_mode'], 1)

    def test_meta_fragment_count_above_legacy_bit_limit_round_trips(self):
        for count in (7, 8, 127, 2147483646):
            with self.subTest(count=count):
                self.e['udg_MetaFragments'][1] = count
                self.start(); self.finish()
                self.assertTrue(self.e['FRC_Ready'][0], self.e['FRC_Error'][0])
                state = progression.snapshot(codec.decode(self.e['FRC_Result'][0]))
                self.assertEqual(state['core']['meta_fragments'], count+1)

    def test_validation_failure_identifies_field_without_changing_character(self):
        self.e['udg_SpeedrunLevel'][1] = 16
        self.start(); self.finish()
        self.assertFalse(self.e['FRC_Ready'][0])
        self.assertIn('section 4 field 8 value=16 maximum=15', self.e['FRC_Error'][0])
        self.assertIsNone(self.e['FRC_Result'][0])
        self.e['udg_SpeedrunLevel'][1] = 3
        self.start(); self.finish()
        self.assertTrue(self.e['FRC_Ready'][0], self.e['FRC_Error'][0])
        self.assertEqual(self.e['FSC_Error'][0], '')

    def test_account_hash_handles_minimum_signed_value(self):
        self.assertEqual(self.e['FRC_Account'](0), 123456789 % 1048576)
        self.names[1] = 'MIN'
        self.assertEqual(self.e['FRC_Account'](0), 0)


if __name__ == '__main__':
    unittest.main()
