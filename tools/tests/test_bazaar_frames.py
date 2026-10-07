"""Exercise local frame navigation, synchronized spending and the classic fallback."""
import copy
from collections import defaultdict
import unittest
from unittest.mock import patch
import test_quest_lifecycle as harness
from test_bazaar_browser import SOURCE, runtime, ingredients
from bazaar_legacy import convert
from jtok import functions, tokens


def frame_runtime():
    e, data, pool, money, created = runtime()
    frames, packets = {}, []
    def create(kind, *args):
        handle = len(frames)+1
        frames[handle] = {'kind': kind}
        return handle
    def prop(handle, key, value):
        frames[handle][key] = value
    e.update(BazaarUseFrames=True, BazaarFrameRoot=None, BazaarFrameHeading=None,
             BazaarFrameNext=None, BazaarFramePrevious=None, BazaarFrameClose=None,
             GetLocalPlayer=lambda: 0, GetTriggerPlayer=lambda: 0,
             S2I=int, I2R=float, ModuloInteger=lambda a, b: a % b,
             BlzGetOriginFrame=lambda *args: 0,
             BlzCreateFrame=create, BlzCreateFrameByType=create,
             BlzFrameSetVisible=lambda h, v: prop(h, 'visible', v),
             BlzFrameSetText=lambda h, v: prop(h, 'text', v),
             BlzFrameSetSize=lambda h, x, y: prop(h, 'size', (x, y)),
             BlzFrameSetAbsPoint=lambda h, p, x, y: prop(h, 'abs', (p, x, y)),
             BlzFrameSetPoint=lambda h, *args: prop(h, 'point', args),
             BlzSendSyncData=lambda prefix, packet: packets.append((prefix, packet)))
    for constant in ['ORIGIN_FRAME_GAME_UI', 'FRAMEPOINT_CENTER', 'FRAMEPOINT_TOP',
                     'FRAMEPOINT_TOPLEFT', 'FRAMEPOINT_TOPRIGHT', 'FRAMEPOINT_BOTTOM',
                     'FRAMEPOINT_BOTTOMLEFT', 'FRAMEEVENT_CONTROL_CLICK',
                     'TEXT_JUSTIFY_MIDDLE', 'TEXT_JUSTIFY_CENTER', 'TEXT_JUSTIFY_TOP', 'TEXT_JUSTIFY_LEFT']:
        e[constant] = constant
    names = ['Bazaar_AllIngredients', 'Bazaar_IngredientPageText', 'BazaarFrame_Show', 'BazaarFrame_Hide',
             'BazaarFrame_OnClick', 'BazaarFrame_OnSync', 'BazaarFrame_Init']
    with patch.object(harness, 'SELECTED', []):
        e = harness.load_engine(SOURCE.read_text(encoding='utf-8'), names, e)
    e['BazaarFrame_Init']()
    e['BazaarBrowserOpen'][0] = True
    e['BazaarSession'][0] = 3
    e['BazaarBuyer'][0] = {'owner': 0}
    e['BazaarShop'][0] = {'raw': 'n030'}
    # The earlier loaded functions have their own namespace; redirect these callbacks.
    e['Bazaar_CloseBrowser'] = lambda p: e['BazaarBrowserOpen'].__setitem__(p, False)
    e['Bazaar_RefreshBrowsers'] = lambda: None
    return e, data, pool, money, created, frames, packets


class BazaarFrameTests(unittest.TestCase):
    def test_three_panels_cover_all_recipes_in_eighteen_next_clicks(self):
        e, data, pool, money, created, frames, packets = frame_runtime()
        e['GetObjectName'] = lambda raw: 'A very long ingredient name '+raw
        before = copy.deepcopy(money)
        seen = []
        for page in range(19):
            e['BazaarFrame_Show'](0)
            for slot in range(3):
                if frames[e['BazaarFrameCard'][slot]]['visible']:
                    recipe = page*3+slot+1
                    seen.append(recipe)
                    body = frames[e['BazaarFrameParts'][slot]]['text']
                    self.assertIn('Sold parts (shared):', body)
                    self.assertLessEqual(len(e['Bazaar_PlainName'](body).split('|n')), 10)
                    self.assertIn('Reward: ???', frames[e['BazaarFrameTitle'][slot]]['text'])
            e['BlzGetTriggerFrame'] = lambda: e['BazaarFrameNext']
            e['BazaarFrame_OnClick']()
        self.assertEqual(seen, list(range(1, 57)))
        self.assertEqual(e['BazaarFramePage'][0], 0)
        e['BlzGetTriggerFrame'] = lambda: e['BazaarFramePrevious']
        e['BazaarFrame_OnClick']()
        self.assertEqual(e['BazaarFramePage'][0], 18)
        self.assertEqual(e['BazaarFramePage'][1], 0)
        self.assertEqual(money, before)
        self.assertFalse(created or packets)

    def test_cards_fit_viewport_and_ingredients_use_working_text_frame_type(self):
        e, _, _, _, _, frames, _ = frame_runtime()
        rectangles = []
        for slot in range(3):
            card = frames[e['BazaarFrameCard'][slot]]
            _, x, y = card['abs']
            width, height = card['size']
            self.assertTrue(0 <= x < x+width <= .8)
            self.assertTrue(0 <= y-height < y <= .6)
            rectangles.append((x, y-height, x+width, y))
            parts = frames[e['BazaarFrameParts'][slot]]
            self.assertEqual(parts['kind'], 'TEXT')
            self.assertLess(parts['size'][0]+parts['point'][-2], width)
            self.assertLess(parts['size'][1]-parts['point'][-1], height-.061)
        for i, a in enumerate(rectangles):
            for b in rectangles[i+1:]:
                self.assertTrue(a[2] <= b[0] or b[2] <= a[0] or a[3] <= b[1] or b[3] <= a[1])

    def test_click_sends_explicit_recipe_and_sync_ignores_local_page_and_duplicate(self):
        e, data, pool, money, created, _, packets = frame_runtime()
        recipe = 7
        for material, amount in ingredients(data, recipe):
            pool[material] = amount*2
        before = copy.deepcopy(pool)
        e['BazaarFramePage'][0] = 2
        e['BlzGetTriggerFrame'] = lambda: e['BazaarFrameCraft'][0]
        e['BazaarFrame_OnClick']()
        self.assertEqual(packets, [('FFERPGBZR', '3007')])
        self.assertEqual(pool, before)
        self.assertFalse(created)
        e['BazaarFramePage'][0] = 9
        e['BlzGetTriggerSyncData'] = lambda: '2007'
        e['BazaarFrame_OnSync']()
        self.assertEqual(pool, before)
        e['BlzGetTriggerSyncData'] = lambda: packets[0][1]
        e['BazaarFrame_OnSync']()
        self.assertEqual(e['BazaarSelectedRecipe'][0], recipe)
        for material, amount in ingredients(data, recipe):
            before[material] -= amount
        self.assertEqual(pool, before)
        cash, items = copy.deepcopy(money), copy.deepcopy(created)
        e['BazaarFrame_OnSync']()
        self.assertEqual(pool, before)
        self.assertEqual(money, cash)
        self.assertEqual(created, items)

    def test_long_recipe_pages_preserve_every_line_and_green_color_without_spending(self):
        e, data, pool, money, created, frames, packets = frame_runtime()
        e['GetObjectName'] = lambda raw: '|cffff0000A very long ingredient name '+raw+'|r'
        for recipe in range(1, 57):
            for material, amount in ingredients(data, recipe):
                pool[material] = amount
            complete = e['Bazaar_PlainName'](e['Bazaar_AllIngredients'](recipe)).split('|n')[1:]
            seen, page = [], 0
            while True:
                text = e['Bazaar_IngredientPageText'](recipe, page)
                if not text:
                    break
                lines = text.split('|n')[1:]
                self.assertLessEqual(len(lines), 9)
                self.assertTrue(all('|cff00ff00' in line for line in lines))
                seen.extend(e['Bazaar_PlainName'](line) for line in lines)
                page += 1
            self.assertEqual(seen, complete)
        before = copy.deepcopy(pool)
        e['BlzGetTriggerFrame'] = lambda: e['BazaarFrameMore'][0]
        e['BazaarFrame_Show'](0)
        e['BazaarFrame_OnClick']()
        self.assertEqual(e['BazaarFramePartPage'][0], 1)
        e['BlzGetTriggerFrame'] = lambda: e['BazaarFrameNext']
        e['BazaarFrame_OnClick']()
        self.assertEqual(e['BazaarFramePartPage'][0], 0)
        self.assertEqual(pool, before)
        self.assertFalse(created or packets)

    def test_classic_conversion_preserves_transactions_and_removes_frame_apis(self):
        source = SOURCE.read_bytes().decode('utf-8')
        classic = convert(source)
        self.assertEqual(convert(classic), classic)
        self.assertNotIn('framehandle', classic)
        self.assertNotIn('call Blz', classic)
        before, after = functions(source), functions(classic)
        for name in before:
            if not name.startswith('BazaarFrame_') and name != 'Bazaar_ShowRecipe':
                self.assertEqual(tokens(before[name]), tokens(after[name]), name)
        self.assertEqual(after['Bazaar_ShowRecipe'].count('DialogAddButton'), 4)
        self.assertIn('BazaarUseFrames=false', classic)
        self.assertNotIn('\n', classic.replace('\r\n', ''))


if __name__ == '__main__':
    unittest.main()
