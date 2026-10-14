"""Execute Chronicle collection, counters, loot checks and existing title save bits."""
from collections import Counter, defaultdict
import copy
from pathlib import Path
import re
import sys
import unittest

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
from source_checks import ROOT
from objdata import fields, read_objects
from mpq import MPQ
from chronicles_catalog import prepare, NEW_IDS
from jtok import functions, tokens
from test_shared_context import mocks
from test_armory_materia import execute
import savecode

TITLES = ROOT / 'src/triggers/09 Player features/Titles.j'
TITLE = TITLES.with_name('Title.j')
LOOT = ROOT / 'src/triggers/05 Items crafting and shops/Loot.j'
BASE = ROOT / 'baseline/Reforged/FFERPG_0.9.7.3-r16.w3x'
ITEMS = ['I0EI', 'I0EF', 'I0EG', 'I0EJ', 'I0EH', 'I0EM', 'I0EK', 'I0EL', 'I0EO', 'I0EN']


def runtime():
    source = TITLES.read_text() + '\n' + TITLE.read_text() + '\n' + LOOT.read_text()
    e = mocks(source)
    e.update({name: defaultdict(str) for name in ['udg_TitleName', 'udg_BonusText',
              'ChroniclesTooltipBase', 'ChroniclesTooltipShown', 'ChroniclesNameBase']})
    e.update({name: defaultdict(int) for name in ['udg_TitleChronicleIndex', 'udg_TitleChroniclePoints',
              'udg_BonusValue', 'udg_SpeedrunLevel', 'ChroniclesMonographCount', 'ChroniclesLevels']})
    e.update({name: defaultdict(bool) for name in ['udg_TitlePrimaryStatOnly', 'ChroniclesMonographSeen']})
    e.update(udg_TitleForce=defaultdict(set), udg_BonusGroup=defaultdict(set),
             udg_PlayingPlayers={0, 1}, udg_TempPlayer='previous', udg_TempInteger=47,
             gg_trg_Title_Grant='grant', gg_trg_Title_UnlockEffects='unlock', gg_trg_Title_ApplyStats='stats',
             udg_SpiritOfGaya=defaultdict(lambda: None, {1: (0, 'gaya'), 2: (1, 'gaya')}),
             udg_MonographItem=dict(enumerate(ITEMS)), inventory=defaultdict(list),
             ability_levels=defaultdict(lambda: 1), available={}, messages=[], writes=[],
             viewer=0, picked_unit=(0, 'hero'), picked_item=ITEMS[0], killer=(0, 'hero'), zone=1,
             ChroniclesRootBase='', ChroniclesRootShown='', ChroniclesSecretsBase='', ChroniclesSecretsShown='',
             ChroniclesTooltipOffset=0)
    e.update(GetPlayerId=lambda p: p, GetConvertedPlayerId=lambda p: p + 1,
             bj_forLoopAIndex=0, bj_forLoopAIndexEnd=0,
             IsPlayerInForce=lambda p, f: p in f, Player_GetHero=lambda p: (p, 'hero'),
             GetOwningPlayer=lambda u: u[0], Player=lambda p: p, I2S=str, IMinBJ=min,
             ForceAddPlayerSimple=lambda p, f: f.add(p), Force_OfPlayer=lambda p: {p},
             GroupAddUnitSimple=lambda u, g: g.add(u), DestroyForce=lambda f: None,
             bj_QUESTMESSAGE_ITEMACQUIRED='acquired')
    names = ['Trig_Titles_Init_Actions', 'Trig_Titles_Init_Title_HasStatBonus',
             'Trig_Titles_Init_Title_BoostsPrimaryOnly', 'Chronicles_MonographIndex',
             'Chronicles_RecordMonograph', 'Chronicles_MonographPickup', 'Chronicles_CheckInventory',
             'Chronicles_Progress', 'Chronicles_RestoreSecrets', 'Chronicles_RefreshTooltips',
             'Trig_Title_Grant_Title_NotOwned', 'Trig_Title_Grant_Actions',
             'Trig_Loot_MonsterDrop_HasItemOfType', 'Loot_HasMonographBonus',
             'Trig_Loot_MonsterDrop_Cond_MonographBonus', 'Trig_Loot_EssenceDrop_HasMonograph',
             'Trig_Loot_EssenceDrop_Cond_DoubleEssenceCharges', 'Trig_Loot_MonsterDrop_PickDropItem']
    e.update(GetForLoopIndexA=lambda: live['bj_forLoopAIndex'],
             GetLocalPlayer=lambda: live['viewer'],
             GetTriggerUnit=lambda: live['picked_unit'], GetManipulatedItem=lambda: live['picked_item'],
             GetItemTypeId=lambda item: item or '',
             UnitHasItem=lambda u, item: item in live['inventory'][u],
             UnitItemInSlot=lambda u, i: (live['inventory'][u] + [None] * 6)[i],
             GetUnitAbilityLevel=lambda u, raw: live['ability_levels'][u, raw] if u else 0,
             GetUnitAbilityLevelSwapped=lambda raw, u: live['ability_levels'][u, raw],
             SetUnitAbilityLevel=lambda u, raw, value: live['ability_levels'].__setitem__((u, raw), value),
             SetUnitAbilityLevelSwapped=lambda raw, u, value: live['ability_levels'].__setitem__((u, raw), value),
             SetPlayerAbilityAvailable=lambda p, raw, value: live['available'].__setitem__((p, raw), value),
             SetPlayerAbilityAvailableBJ=lambda value, raw, p: live['available'].__setitem__((p, raw), value),
             ConditionalTriggerExecute=lambda trigger: live['Trig_Title_Grant_Actions']() if trigger == 'grant' else None,
             DisplayTimedTextToForce=lambda *args: live['messages'].append(args),
             BlzSetAbilityTooltip=lambda *args: live['writes'].append(('name', *args)),
             BlzSetAbilityExtendedTooltip=lambda *args: live['writes'].append(('body', *args)),
             GetKillingUnit=lambda: live['killer'], GetKillingUnitBJ=lambda: live['killer'],
             GetUnitUserData=lambda u: live['zone'], GetRandomInt=lambda *args: 1,
             # The backpack (TBackpack): no pages in these tests, so carrying means the unit's own slots.
             Gear_HasCarried=lambda u, raw: raw in live['inventory'][u],
             BACKPACK_PAGES=7, BACKPACK_SLOTS=6, BackpackHolder=defaultdict(lambda: None),
             ModuloInteger=lambda a, b: a % b,
             ForForce=lambda *args: None)
    live = execute(source, names, e)
    live['Trig_Titles_Init_Actions']()
    return live


class ChronicleTests(unittest.TestCase):
    def test_sequential_hero_and_gaya_collection_unlocks_once_for_the_right_player(self):
        e = runtime()
        for i, raw in enumerate(ITEMS):
            u = (0, 'hero' if i % 2 else 'gaya')
            e['picked_unit'], e['picked_item'] = u, raw
            e['inventory'][u] = [raw]
            e['Chronicles_MonographPickup']()
            e['Chronicles_MonographPickup']()
            self.assertEqual(e['ChroniclesMonographCount'][1], i + 1)
        self.assertEqual(e['udg_TitleForce'][59], {0})
        self.assertEqual(e['ChroniclesMonographCount'][2], 0)
        self.assertEqual(len(e['messages']), 1)
        self.assertEqual((e['udg_TempPlayer'], e['udg_TempInteger']), ('previous', 47))
        self.assertEqual(e['ability_levels'][(0, 'gaya'), 'cKeg'], 2)
        e['Chronicles_RecordMonograph'](0, ITEMS[0])
        self.assertEqual(len(e['messages']), 1)

    def test_wrong_unit_rejected_items_and_unrelated_items_do_not_count(self):
        e = runtime()
        e['picked_unit'] = (0, 'house')
        e['inventory'][e['picked_unit']] = [ITEMS[0]]
        e['Chronicles_MonographPickup']()
        e['picked_unit'] = (0, 'hero')
        e['Chronicles_MonographPickup']()  # discarded by an earlier ownership check
        e['Chronicles_RecordMonograph'](0, 'I045')
        e['Chronicles_RecordMonograph'](2, ITEMS[0])  # not a playing player
        self.assertFalse(e['ChroniclesMonographCount'])
        e['inventory'][(1, 'gaya')] = ITEMS[:6]
        e['Chronicles_CheckInventory'](1)
        self.assertEqual(e['ChroniclesMonographCount'][2], 6)
        self.assertNotIn(1, e['udg_TitleForce'][59])

    def test_counters_count_titles_not_weighted_ability_levels(self):
        e = runtime()
        expected = [5, 5, 4, 6, 5, 5, 6, 8, 7, 6, 5, 1]
        for category, total in enumerate(expected, 1):
            self.assertEqual(e['Chronicles_Progress'](0, category), f'0 / {total}')
        e['udg_TitleForce'][1].add(0)
        e['udg_TitleForce'][44].add(0)  # contributes three internal ability points
        e['udg_TitleForce'][59].add(0)
        e['udg_SpeedrunLevel'][1] = 3
        self.assertEqual(e['Chronicles_Progress'](0, 1), '2 / 5')
        self.assertEqual(e['Chronicles_Progress'](1, 1), '0 / 5')
        self.assertEqual(e['Chronicles_Progress'](0, 11), '3 / 5')
        self.assertEqual(e['Chronicles_Progress'](0, 0), f'6 / {sum(expected)}')

    def test_local_tooltips_refresh_without_changing_player_progress(self):
        e = runtime()
        for category in range(1, 13):
            e['ChroniclesLevels'][category] = 32
            e['ChroniclesTooltipBase'][category * 64] = 'Original reward text'
            e['ChroniclesNameBase'][category * 64] = 'Chronicle'
        e['ChroniclesRootBase'], e['ChroniclesSecretsBase'] = 'Book', 'Secrets'
        e['udg_TitleForce'][44].add(0)
        prior = copy.deepcopy(e['udg_TitleForce'])
        e['Chronicles_RefreshTooltips']()
        self.assertIn(('body', 'A0ZK', 'Original reward text|n|n|cffffcc00Chronicles unlocked:|r 1 / 5', 0), e['writes'])
        size = len(e['writes'])
        e['Chronicles_RefreshTooltips']()
        self.assertEqual(len(e['writes']), size)
        e['viewer'] = 1
        e['Chronicles_RefreshTooltips']()
        self.assertIn(('name', 'A0ZK', 'Chronicle', 0), e['writes'])
        # 1.29.2 counts tooltip levels from 1: every write moves up one index.
        e['ChroniclesTooltipOffset'] = 1
        e['ChroniclesTooltipShown'].clear()
        e['ChroniclesRootShown'] = ''
        e['Chronicles_RefreshTooltips']()
        self.assertIn(('name', 'A0ZK', 'Chronicle', 1), e['writes'])
        self.assertTrue(any(w[:2] == ('body', 'A0AR') and w[3] == 1 for w in e['writes']))
        self.assertEqual({k: v for k, v in e['udg_TitleForce'].items() if v},
                         {k: v for k, v in prior.items() if v})

    def test_completed_title_restores_and_partial_progress_is_not_saved(self):
        e = runtime()
        e['udg_TitleForce'][59].add(0)
        e['Chronicles_RestoreSecrets'](0)
        self.assertEqual(e['ability_levels'][(0, 'gaya'), 'cKeg'], 2)
        self.assertTrue(e['available'][0, 'A0AR'])
        self.assertTrue(e['available'][0, 'cSec'])
        self.assertTrue(e['available'][0, 'cKeg'])
        self.assertEqual(e['ChroniclesMonographCount'][1], 0)
        fixture = __import__('json').loads((ROOT / 'tools/tests/fixtures/savecodes.json').read_text())
        # Existing G/H payloads already have the reserved title59 bit; no extra fields.
        cases = fixture['cases'] if isinstance(fixture, dict) and 'cases' in fixture else fixture
        case = next(c for c in cases if c['code'].startswith(('G', 'H')))
        table = savecode.load_items(str(ROOT / 'src/itemtable.txt'))
        charged = lambda i: table[i]['charged']
        original = savecode.decode(case['code'], charged)[0]
        for owned in (False, True):
            payload = copy.deepcopy(case['input'])
            payload['titles'] = [n for n in payload['titles'] if n != 59] + ([59] if owned else [])
            loaded = savecode.decode(savecode.encode(payload, charged), charged)[0]
            self.assertEqual(59 in loaded['titles'], owned)
            self.assertEqual({k: v for k, v in original.items() if k not in ('titles', 'code', 'trace', 'checksum')},
                             {k: v for k, v in loaded.items() if k not in ('titles', 'code', 'trace', 'checksum')})

    def test_secrets_category_and_locked_entries_stay_hidden_until_completion(self):
        e = runtime()
        e['Chronicles_RestoreSecrets'](0)
        self.assertFalse(e['available'][0, 'cSec'])
        self.assertFalse(e['available'][0, 'cKeg'])
        e['udg_TitleForce'][59].add(0)
        e['Chronicles_RestoreSecrets'](0)
        self.assertTrue(e['available'][0, 'cSec'])
        self.assertTrue(e['available'][0, 'cKeg'])
        e['ChroniclesSecretsBase'] = 'Secrets description'
        e['Chronicles_RefreshTooltips']()
        self.assertIn(('name', 'cSec', 'Secrets', 0), e['writes'])
        self.assertIn('Chronicles unlocked:|r 1 / 1', next(v[2] for v in e['writes'] if v[:2] == ('body', 'cSec')))


class MonographLootTests(unittest.TestCase):
    def test_all_ten_work_in_either_inventory_or_from_keg_hunter_without_stacking(self):
        e = runtime()
        for zone, raw in enumerate(ITEMS):
            e['zone'] = zone
            for holder in ((0, 'hero'), (0, 'gaya')):
                e['inventory'].clear()
                e['inventory'][holder] = [raw]
                self.assertTrue(e['Trig_Loot_MonsterDrop_Cond_MonographBonus']())
                if zone <= 8:
                    self.assertTrue(e['Trig_Loot_EssenceDrop_Cond_DoubleEssenceCharges']())
            e['inventory'].clear()
            self.assertFalse(e['Loot_HasMonographBonus'](0, zone))
            e['udg_TitleForce'][59].add(0)
            self.assertTrue(e['Loot_HasMonographBonus'](0, zone))
            self.assertFalse(e['Loot_HasMonographBonus'](1, zone))
            e['inventory'][(0, 'gaya')] = [raw]
            self.assertIs(e['Loot_HasMonographBonus'](0, zone), True)
            e['udg_TitleForce'][59].clear()
        for zone in (-1, 10):
            self.assertFalse(e['Loot_HasMonographBonus'](0, zone))
        e['zone'], e['killer'] = 1, (0, 'summon')
        e['udg_TitleForce'][59].add(0)
        self.assertFalse(e['Trig_Loot_MonsterDrop_Cond_MonographBonus']())
        e['zone'], e['killer'] = 9, (0, 'hero')
        self.assertFalse(e['Trig_Loot_EssenceDrop_Cond_DoubleEssenceCharges']())

    def test_loot_roll_distribution_and_common_charge_bonus_remain_exact(self):
        e = runtime()
        e.update(TimerGetElapsed=lambda *args: 0., R2I=int, ModuloInteger=lambda a, b: a % b,
                 GetUnitAbilityLevel=lambda *args: 0, GetUnitTypeId=lambda *args: 'monster',
                 LoadInteger=lambda table, unit, slot: slot, Item_IdFromIndex=lambda slot: slot)
        for has_bonus, expected in [(False, {2: 13, 3: 5, 4: 2}), (True, {2: 9, 3: 7, 4: 4})]:
            e['udg_TitleForce'][59] = {0} if has_bonus else set()
            counts, charged_rolls = Counter(), 0
            for roll in range(1, 21):
                e['udg_DropTempInt'], e['udg_DropRollSeed'] = 20, 0
                values = iter([0, (roll - 8) % 20])
                e['GetRandomInt'] = lambda *args: next(values)
                e['Trig_Loot_MonsterDrop_PickDropItem']()
                counts[e['udg_LootItemID']] += 1
                charged_rolls += e['udg_MonographBonusDrop']
            self.assertEqual(counts, expected)
            self.assertEqual(charged_rolls, 9 if has_bonus else 0)


class ChronicleObjectTests(unittest.TestCase):
    def test_page_capacity_nested_books_and_additive_objects(self):
        old = read_objects(MPQ(str(BASE)).read('war3map.w3a'), 'w3a')
        new = prepare(old)
        before = {o['id'] or o['base']: fields(o) for group in ('original', 'custom') for o in old[group]}
        after = {o['id'] or o['base']: fields(o) for group in ('original', 'custom') for o in new[group]}
        self.assertEqual(after.keys() - before.keys(), NEW_IDS)
        for raw in before:
            permitted = {('spb1', 1)} if raw == 'A0AR' else {'abpx', 'abpy'} if raw == 'A10C' else set()
            self.assertEqual({k: v for k, v in before[raw].items() if k not in permitted},
                             {k: v for k, v in after[raw].items() if k not in permitted})
        self.assertEqual(after['A0AR']['spb1', 1].split(',')[-1], 'cPg2')
        self.assertNotIn('A10C', after['A0AR']['spb1', 1])
        self.assertEqual(after['cPg2']['spb1', 1], 'A10C,cSec')
        self.assertEqual(after['cSec']['spb1', 1], 'cKeg')
        self.assertEqual(after['cKeg']['alev'], 2)
        self.assertNotEqual(after['cPg2']['spb5', 1], after['cSec']['spb5', 1])
        for raw in ('A0AR', 'cPg2', 'cSec'):
            self.assertLessEqual(len(after[raw]['spb1', 1].split(',')), 11)
        self.assertEqual(prepare(new), new)
        broken = copy.deepcopy(new)
        broken['custom'] = [o for o in broken['custom'] if o['id'] != 'cKeg']
        with self.assertRaises(ValueError):
            prepare(broken)


if __name__ == '__main__':
    unittest.main()
