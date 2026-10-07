"""Execute armory browsing with mocked stock natives; verify additive object data."""
from collections import defaultdict
import copy
import json
from unittest.mock import patch
import unittest

import test_quest_lifecycle as harness
from test_shared_context import mocks
from source_checks import ROOT, sources
from check_save_compat import assignments
from armory_catalog import catalog_objects, hint_id, ICON
from check_armory import check
from mpq import MPQ
from objdata import read_objects, fields

SOURCE = ROOT / 'src/triggers/05 Items crafting and shops/Armory.j'


def runtime():
    source = SOURCE.read_text(encoding='utf-8')
    env = mocks(source)
    for name in ['ArmoryMissingUnit', 'ArmoryCategory']:
        env[name] = defaultdict(int)
    env['ArmoryHint'] = defaultdict(str)
    shop = {'owner': 1}
    stock = []
    categories = {f'u{i}': 12 for i in range(1, 12)}
    flags = defaultdict(set)
    env.update(GetOwningPlayer=lambda u: u['owner'], GetConvertedPlayerId=lambda p: p,
               IsPlayerInForce=lambda p, force: p in force,
               GetUnitPointValueByType=lambda raw: categories.get(raw, 0),
               RemoveUnitFromStock=lambda u, raw: stock.remove(raw) if raw in stock else None,
               AddUnitToStock=lambda u, raw, a, b: stock.append(raw),
               SetUnitAbilityLevel=lambda u, ability, level: u.update(back=level),
               udg_SaveFlagUnitID=defaultdict(int, {i: f'u{i}' for i in range(1, 12)}),
               udg_SaveFlagForce=flags, udg_SaveFlagCount=351, udg_ArmoryStockMax=540)
    names = ['Armory_InitHints', 'Armory_InCategory', 'Armory_ClearStock', 'Armory_ShowCategory',
             'Trig_Armory_Select_Actions', 'Trig_Armory_Select_CanWithdraw', 'Trig_Armory_Back_Actions']
    with patch.object(harness, 'SELECTED', []):
        e = harness.load_engine(source, names, env)
    e['Armory_InitHints']()
    # Synthetic unit identities keep the stock assertions readable.
    e['ArmoryMissingUnit'] = defaultdict(int, {i: hint_id(i) for i in range(1, 12)})
    e['GetTriggerUnit'] = lambda: shop
    e['GetUnitTypeId'] = lambda u: u['raw']
    e['BlzGetUnitMaxMana'] = lambda u: u['index']
    e['Trig_Armory_Select_NotYourArmory'] = lambda: False
    return e, shop, stock, flags


class ArmoryTests(unittest.TestCase):
    def test_original_baseline_without_hint_objects_is_rejected(self):
        errors = check(ROOT / 'baseline/Reforged/FFERPG_0.9.7.3-r16.w3x')
        self.assertTrue(any('missing/wrong hint object field' in error for error in errors))

    def test_single_panel_shows_all_eleven_entries(self):
        e, shop, stock, flags = runtime()
        e['Armory_ShowCategory'](shop, 12)
        self.assertEqual(stock, [hint_id(i) for i in range(1, 12)])
        self.assertNotIn('zNXT', stock)
        self.assertNotIn('zPRV', stock)

    def test_collection_and_category_are_independent_for_each_player(self):
        e, shop, stock, flags = runtime()
        flags[5].add(1)
        e['Armory_ShowCategory'](shop, 12)
        self.assertIn('u5', stock)
        second = {'owner': 2}
        e['Armory_ShowCategory'](second, 12)
        self.assertIn('z005', stock)
        self.assertNotIn('u5', stock)
        e['Armory_ShowCategory'](second, 0)
        self.assertEqual(e['ArmoryCategory'][1], 12)
        self.assertEqual(e['ArmoryCategory'][2], 0)

    def test_hint_click_does_not_withdraw_or_change_saved_flags(self):
        e, shop, stock, flags = runtime()
        messages = []
        e['Armory_ShowCategory'](shop, 12)
        before = copy.deepcopy(flags)
        e['GetSoldUnit'] = lambda: {'raw': 'z005', 'index': 5}
        e['DisplayTimedTextToPlayer'] = lambda *args: messages.append(args[-1])
        e['CreateItemLoc'] = lambda *args: self.fail('hint granted an item')
        e['Trig_Armory_Select_Actions']()
        self.assertEqual(flags, before)
        self.assertEqual(len(messages), 1)
        self.assertIn('z001', stock)

    def test_back_uses_the_current_players_category(self):
        e, shop, stock, flags = runtime()
        e['Armory_ShowCategory'](shop, 12)
        e['udg_ArmoryParentCategory'][12] = 1
        e['Trig_Armory_Back_IsTopLevel'] = lambda: False
        e['Trig_Armory_Back_Actions']()
        self.assertEqual(e['ArmoryCategory'][1], 1)

    def test_withdrawal_replaces_stored_icon_with_hint_and_removes_one_flag(self):
        e, shop, stock, flags = runtime()
        flags[5].add(1)
        e['udg_TitleForce'][35] = {1}
        e['udg_ArmoryItemCount'][1] = 1
        e['Armory_ShowCategory'](shop, 12)
        e['GetSoldUnit'] = lambda: {'raw': 'u5', 'index': 5}
        e['Trig_Armory_Select_HasStockId'] = lambda: True
        e['Trig_Armory_Select_IsCategoryNode'] = lambda: False
        e['udg_ItemIdTable'][5] = 'I00D'
        created = []
        e['CreateItemLoc'] = lambda raw, loc: created.append(raw)
        e['GetLastCreatedItem'] = lambda: 'withdrawn item'
        e['GetItemName'] = lambda item: 'Champion belt'
        e['ForceRemovePlayerSimple'] = lambda p, force: force.remove(p)
        e['Trig_Armory_Select_Actions']()
        self.assertEqual(created, ['I00D'])
        self.assertEqual(e['udg_ArmoryItemCount'][1], 0)
        self.assertNotIn(1, flags[5])
        self.assertIn('z005', stock)
        self.assertNotIn('u5', stock)

    def test_catalog_covers_all_collectibles_and_preserves_original_objects(self):
        _, texts = sources()
        flags, errors = assignments(texts, 'udg_SaveFlagUnitID', repeated=True)
        self.assertFalse(errors)
        flags = {k: v[-1] for k, v in flags.items()}
        catalog = json.loads((ROOT / 'src/armory-hints.json').read_text())
        archive = MPQ(str(ROOT / 'baseline/Reforged/FFERPG_0.9.7.3-r16.w3x'))
        table = read_objects(archive.read('war3map.w3u'), 'w3u')
        items = read_objects(archive.read('war3map.w3t'), 'w3t')
        item_fields = {o['id'] or o['base']: fields(o) for g in ('original', 'custom') for o in items[g]}
        changed = catalog_objects(table, catalog, flags, item_fields)
        self.assertEqual(changed['original'], table['original'])
        for before, after in zip(table['custom'], changed['custom']):
            for obj in (before, after):
                for group in obj['sets']:
                    group['mods'][:] = [m for m in group['mods'] if m['field'] not in ('ubpx', 'ubpy')]
            self.assertEqual(before, after)
        self.assertEqual(len(changed['custom']) - len(table['custom']), 276)
        for obj in changed['custom'][len(table['custom']):]:
            f = fields(obj)
            self.assertEqual(f['ugol'], 0)
            self.assertEqual(f['ulum'], 0)
            self.assertEqual(f['uico'], ICON)
            self.assertEqual(f['ulev'], 0)
            self.assertIn('Hint:', f['utub'])
        e, _, _, _ = runtime()
        for index, entry in catalog.items():
            self.assertEqual(e['ArmoryHint'][int(index)], entry['hint'])


if __name__ == '__main__':
    unittest.main()
