"""Execute Bazaar choice/transactions against all original recipes with mocked natives."""
from collections import defaultdict
import copy
import json
import re
import unittest
from unittest.mock import patch
import test_quest_lifecycle as harness
from test_shared_context import mocks
from check_bazaar import recipe_data, check
from check_save_compat import assignments
from source_checks import ROOT, sources
from armory_catalog import catalog_objects
from bazaar_catalog import prepare, prices
from mpq import MPQ
from objdata import fields, read_objects

SOURCE = ROOT / 'src/triggers/05 Items crafting and shops/Bazaar.j'


def runtime():
    source = SOURCE.read_text(encoding='utf-8')
    env = mocks(source)
    for name in re.findall(r'^    \w+ array (Bazaar\w+)', source, re.M):
        env[name] = defaultdict(int)
    _, texts = sources()
    for name in ['udg_DropItemIdTable', 'udg_BazaarGoodItem', 'udg_BazaarResultItem']:
        data, errors = assignments(texts, name)
        assert not errors
        env[name] = defaultdict(int, {int(k): v for k, v in data.items()})
    data = recipe_data(source)
    pool = defaultdict(int)
    money = defaultdict(lambda: 1000000)
    created, messages = [], []
    buttons = []
    def add_button(dialog, label, hotkey):
        buttons.append((dialog, label))
        return len(buttons)
    def create(raw, x, y):
        item = {'raw': raw}
        created.append(item)
        return item
    env.update(udg_BazaarRecipeHash=data, udg_MaterialOwnedCount=pool,
               udg_BazaarGoodCount=56, bj_MAX_PLAYERS=12,
               UNIT_TYPE_DEAD='dead', ITEM_TYPE_CHARGED='charged',
               PLAYER_STATE_RESOURCE_GOLD='gold', PLAYER_STATE_RESOURCE_LUMBER='shards',
               GetPlayerId=lambda p: p, Player=lambda p: p,
               LoadInteger=lambda table, parent, child: table.get((parent, child), 0),
               I2S=str, GetObjectName=lambda raw: 'Ingredient '+raw,
               GetOwningPlayer=lambda unit: unit['owner'],
               GetUnitTypeId=lambda unit: unit.get('raw', 'hero') if unit else 0,
               GetUnitX=lambda unit: unit.get('x', 0.), GetUnitY=lambda unit: unit.get('y', 0.),
               IsUnitType=lambda unit, kind: unit.get('dead', False),
               GetPlayerState=lambda p, state: money[p, state],
               SetPlayerState=lambda p, state, amount: money.__setitem__((p, state), amount),
               CreateItem=create, GetItemType=lambda item: 'charged',
               SetItemCharges=lambda item, count: item.update(charges=count),
               UnitAddItem=lambda buyer, item: True,
               DisplayTimedTextToPlayer=lambda *args: messages.append(args[-1]),
               DialogAddButton=add_button)
    names = ['Bazaar_InitBrowserData', 'Bazaar_MaterialsReady', 'Bazaar_RecipeText',
             'Bazaar_CraftRecipe', 'Bazaar_ShowRecipe', 'Bazaar_CloseBrowser',
             'Bazaar_RefreshBrowsers', 'Trig_Bazaar_BrowseRecipes_Actions',
             'Trig_Bazaar_UpdateStock_Actions']
    with patch.object(harness, 'SELECTED', []):
        e = harness.load_engine(source, names, env)
    e['Bazaar_InitBrowserData']()
    return e, data, pool, money, created


def ingredients(data, recipe):
    return [(data[recipe, slot+1], data[recipe, slot])
            for slot in range(3, 3+2*data[recipe, 1], 2)]


class BazaarBrowserTests(unittest.TestCase):
    def test_prepared_objects_and_prices_agree(self):
        archive = MPQ(str(ROOT / 'baseline/Reforged/FFERPG_0.9.7.3-r16.w3x'))
        table = read_objects(archive.read('war3map.w3u'), 'w3u')
        items = read_objects(archive.read('war3map.w3t'), 'w3t')
        item_fields = {o['id'] or o['base']: fields(o) for g in ('original', 'custom') for o in items[g]}
        _, texts = sources()
        flags, errors = assignments(texts, 'udg_SaveFlagUnitID', repeated=True)
        self.assertFalse(errors)
        flags = {k: v[-1] for k, v in flags.items()}
        catalog = json.loads((ROOT / 'src/armory-hints.json').read_text(encoding='utf-8'))
        armory = catalog_objects(table, catalog, flags, item_fields)
        bazaar = prepare(armory)
        self.assertEqual(len(bazaar['custom']), len(armory['custom'])+1)
        button = fields(bazaar['custom'][-1])
        self.assertEqual((button['ubpx'], button['ubpy']), (3, 2))
        self.assertEqual((button['ugol'], button['ulum']), (0, 0))
        e, _, _, _, _ = runtime()
        goods, errors = assignments(texts, 'udg_BazaarGoodItem')
        self.assertFalse(errors)
        for key, (gold, shards) in prices(archive, goods).items():
            self.assertEqual(e['BazaarGoldCost'][int(key)], gold)
            self.assertEqual(e['BazaarShardCost'][int(key)], shards)

    def test_every_recipe_consumes_only_one_set_and_preserves_results_and_charges(self):
        e, data, pool, money, created = runtime()
        for recipe in range(1, 57):
            with self.subTest(recipe=recipe):
                pool.clear()
                money.clear()
                created.clear()
                for material, amount in ingredients(data, recipe):
                    pool[material] = amount*3
                pool[0] = 999
                before = copy.deepcopy(pool)
                self.assertTrue(e['Bazaar_CraftRecipe'](0, recipe, {'owner': 0}, {'raw': 'n030'}))
                for material, amount in ingredients(data, recipe):
                    before[material] -= amount
                self.assertEqual(pool, before)
                self.assertEqual(money[0, 'gold'], 1000000-e['BazaarGoldCost'][recipe])
                self.assertEqual(money[0, 'shards'], 1000000-e['BazaarShardCost'][recipe])
                start = 4+2*data[recipe, 1]
                expected = []
                for slot in range(start, start+2*data[recipe, 2], 2):
                    item = {'raw': e['udg_BazaarResultItem'][data[recipe, slot]]}
                    if data.get((recipe, slot+1), 0) >= 1:
                        item['charges'] = data[recipe, slot+1]
                    expected.append(item)
                self.assertEqual(created, expected)

    def test_browsing_colors_counts_hides_rewards_and_spends_nothing(self):
        e, data, pool, money, created = runtime()
        material, amount = ingredients(data, 7)[0]
        pool[material] = amount
        before = copy.deepcopy(pool)
        text = e['Bazaar_RecipeText'](7)
        self.assertIn('|cff00ff00Ingredient '+e['udg_DropItemIdTable'][material], text)
        self.assertIn('Reward: ???', text)
        self.assertNotIn(e['udg_BazaarResultItem'][data[7, 4+2*data[7, 1]]], text)
        e['Trig_Bazaar_UpdateStock_Actions']()
        self.assertEqual({k: v for k, v in pool.items() if v}, dict(before))
        self.assertEqual(created, [])

    def test_competing_players_cannot_spend_the_same_parts_twice(self):
        e, data, pool, money, created = runtime()
        for material, amount in ingredients(data, 7):
            pool[material] = amount
        shop = {'raw': 'n030'}
        self.assertTrue(e['Bazaar_CraftRecipe'](0, 7, {'owner': 0}, shop))
        before = copy.deepcopy(money)
        result_count = len(created)
        self.assertFalse(e['Bazaar_CraftRecipe'](1, 7, {'owner': 1}, shop))
        self.assertEqual(money, before)
        self.assertEqual(len(created), result_count)
        self.assertTrue(all(amount >= 0 for amount in pool.values()))

    def test_failed_payment_and_invalid_buyer_preserve_parts(self):
        e, data, pool, money, created = runtime()
        for failure in ['parts', 'gold', 'shards', 'owner', 'distance', 'dead']:
            with self.subTest(failure=failure):
                pool.clear()
                money.clear()
                created.clear()
                money[0, 'gold'] = 1000000
                money[0, 'shards'] = 1000000
                for material, amount in ingredients(data, 4):
                    pool[material] = amount
                buyer = {'owner': 0}
                if failure == 'parts':
                    pool[ingredients(data, 4)[0][0]] = 0
                elif failure in ['gold', 'shards']:
                    money[0, failure] = 0
                elif failure == 'owner':
                    buyer['owner'] = 1
                elif failure == 'distance':
                    buyer['x'] = 1000.
                else:
                    buyer['dead'] = True
                before = copy.deepcopy(pool)
                cash = copy.deepcopy(money)
                self.assertFalse(e['Bazaar_CraftRecipe'](0, 4, buyer, {'raw': 'n030'}))
                self.assertEqual(pool, before)
                self.assertEqual(dict(money), dict(cash))
                self.assertEqual(created, [])

    def test_navigation_wraps_and_is_separate_for_each_player(self):
        e, data, pool, money, created = runtime()
        e['BazaarSelectedRecipe'][0] = 1
        e['BazaarSelectedRecipe'][1] = 20
        e['BazaarBrowserOpen'][0] = True
        e['BazaarBrowserOpen'][1] = True
        e['Bazaar_ShowRecipe'](0)
        e['GetTriggerPlayer'] = lambda: 0
        e['GetClickedButton'] = lambda: e['BazaarPrevious'][0]
        e['Trig_Bazaar_BrowseRecipes_Actions']()
        self.assertEqual(e['BazaarSelectedRecipe'][0], 56)
        e['GetClickedButton'] = lambda: e['BazaarNext'][0]
        e['Trig_Bazaar_BrowseRecipes_Actions']()
        self.assertEqual(e['BazaarSelectedRecipe'][0], 1)
        self.assertEqual(e['BazaarSelectedRecipe'][1], 20)
        e['GetClickedButton'] = lambda: -1
        e['Trig_Bazaar_BrowseRecipes_Actions']()
        self.assertFalse(e['BazaarBrowserOpen'][0])
        self.assertTrue(e['BazaarBrowserOpen'][1])
        self.assertEqual(created, [])


if __name__ == '__main__':
    unittest.main()
