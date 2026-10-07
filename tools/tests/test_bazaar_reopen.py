"""Exercise repeated purchases, frame Close/sync, reopening and stale sessions."""
import unittest

from test_bazaar_frames import frame_runtime, SOURCE
from test_armory_materia import execute


class ReopenTests(unittest.TestCase):
    def test_recipe_button_restock_and_close_allow_repeated_opening(self):
        e, _, pool, money, created, frames, packets = frame_runtime()
        shop = {'raw': 'n030', 'stock': 1}
        buyer = {'owner': 0}
        sold = {'raw': 'bRcp'}
        stock_calls = []
        def remove_stock(unit, raw):
            self.assertEqual((unit, raw), (shop, 'bRcp'))
            unit['stock'] = 0
            stock_calls.append('remove')
        def add_stock(unit, raw, current, maximum):
            self.assertEqual((unit, raw, current, maximum), (shop, 'bRcp', 1, 1))
            unit['stock'] = current
            stock_calls.append('add')
        e.update(BazaarUseFrames=True, GetBuyingUnit=lambda: buyer,
                 GetSellingUnit=lambda: shop, GetSoldUnit=lambda: sold,
                 RemoveUnit=lambda u: u.update(removed=True),
                 RemoveUnitFromStock=remove_stock, AddUnitToStock=add_stock)
        names = ['Trig_Bazaar_OpenRecipes_Conditions', 'Trig_Bazaar_OpenRecipes_Actions',
                 'Bazaar_CloseBrowser', 'Bazaar_ShowRecipe', 'BazaarFrame_Show',
                 'BazaarFrame_Hide', 'BazaarFrame_OnClick', 'BazaarFrame_OnSync']
        e = execute(SOURCE.read_text(), names, e)
        initial_pool, initial_money = dict(pool), dict(money)
        prior_session = None
        for _ in range(3):
            self.assertEqual(shop['stock'], 1)
            shop['stock'] -= 1  # Warcraft consumes the shop entry before the sell event.
            self.assertTrue(e['Trig_Bazaar_OpenRecipes_Conditions']())
            e['Trig_Bazaar_OpenRecipes_Actions']()
            self.assertTrue(e['BazaarBrowserOpen'][0])
            self.assertTrue(frames[e['BazaarFrameRoot']]['visible'])
            self.assertEqual(shop['stock'], 1)
            if prior_session is not None:
                e['BlzGetTriggerSyncData'] = lambda: str(prior_session * 1000)
                e['BazaarFrame_OnSync']()
                self.assertTrue(e['BazaarBrowserOpen'][0])
            prior_session = e['BazaarSession'][0]
            e['BlzGetTriggerFrame'] = lambda: e['BazaarFrameClose']
            e['BazaarFrame_OnClick']()
            self.assertFalse(frames[e['BazaarFrameRoot']]['visible'])
            e['BlzGetTriggerSyncData'] = lambda: packets[-1][1]
            e['BazaarFrame_OnSync']()
            self.assertFalse(e['BazaarBrowserOpen'][0])
            self.assertIsNone(e['BazaarBuyer'][0])
            self.assertIsNone(e['BazaarShop'][0])
        self.assertEqual(stock_calls, ['remove', 'add'] * 3)
        self.assertEqual({k: v for k, v in pool.items() if v},
                         {k: v for k, v in initial_pool.items() if v})
        self.assertEqual(dict(money), initial_money)
        self.assertFalse(created)


if __name__ == '__main__':
    unittest.main()
