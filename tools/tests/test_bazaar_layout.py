from pathlib import Path
import sys,unittest
from unittest.mock import patch
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from bazaar_layout import refresh
import test_bazaar_frames as fixtures

class BazaarLayoutTests(unittest.TestCase):
    def test_original_card_and_button_geometry_is_preserved(self):
        original=fixtures.SOURCE.read_text();updated=refresh(original,native=True)
        class Source:
            def read_text(self,**kwargs):return updated
        before=fixtures.frame_runtime()[5]
        with patch.object(fixtures,'SOURCE',Source()):
            e,_,_,_,_,frames,_=fixtures.frame_runtime()
        for slot in range(3):
            card=frames[e['BazaarFrameCard'][slot]];button=frames[e['BazaarFrameCraft'][slot]]
            self.assertEqual(card['size'],(.245,.425))
            self.assertEqual(button['size'],(.215,.033))
            self.assertEqual(button['point'][-1],.007)
            self.assertEqual(frames[e['BazaarFrameParts'][slot]]['size'],(.189,.235))
        self.assertNotIn('BlzGetFrameByName("ConsoleUIBackdrop",0)',updated)
        for slot in range(3):
            hit=frames[e['BazaarFrameCraftHit'][slot]]
            card=frames[e['BazaarFrameCard'][slot]]
            self.assertEqual(hit['size'],(.215,.033))
            self.assertAlmostEqual(hit['abs'][1],card['abs'][1]+.245/2)
            self.assertAlmostEqual(hit['abs'][2],card['abs'][2]-.425+.007)
        e['BazaarFrame_Show'](0)
        self.assertTrue(all(frames[e['BazaarFrameCraftHit'][s]]['visible'] for s in range(3)))
        e['BazaarFrame_Hide'](0)
        self.assertFalse(any(frames[e['BazaarFrameCraftHit'][s]]['visible'] for s in range(3)))
        self.assertNotIn('BlzFrameSetVisible(origin,false)',updated)
        self.assertEqual(refresh(updated,native=True),updated)
        self.assertEqual(refresh(original,native=False),original)

    def test_click_areas_send_existing_validated_recipe_packets_only(self):
        updated=refresh(fixtures.SOURCE.read_text(),native=True)
        class Source:
            def read_text(self,**kwargs):return updated
        with patch.object(fixtures,'SOURCE',Source()):
            e,data,pool,money,created,frames,packets=fixtures.frame_runtime()
        initial_pool,initial_money=dict(pool),dict(money)
        e['BazaarFrame_Show'](0)
        for slot in range(3):
            e['BlzGetTriggerFrame']=lambda slot=slot:e['BazaarFrameCraftHit'][slot]
            e['BazaarFrame_OnClick']()
        self.assertEqual(packets,[('FFERPGBZR','3001'),('FFERPGBZR','3002'),('FFERPGBZR','3003')])
        self.assertEqual({k:v for k,v in pool.items() if v},{k:v for k,v in initial_pool.items() if v});self.assertEqual(dict(money),initial_money)
        self.assertFalse(created)

    def test_original_mark_pages_cover_every_entry_exactly_once(self):
        original=fixtures.SOURCE.read_text();updated=refresh(original,native=True)
        class Source:
            def read_text(self,**kwargs):return updated
        with patch.object(fixtures,'SOURCE',Source()):
            e,data,pool,money,created,frames,packets=fixtures.frame_runtime()
        from test_armory_materia import execute
        e=execute(updated,['Bazaar_MarkPageText','Bazaar_IngredientPageText'],e)
        e['GetObjectName']=lambda raw:str(raw)
        seen=[]
        for page in range(20):
            text=e['Bazaar_MarkPageText'](page)
            if not text:break
            lines=e['Bazaar_PlainName'](text).split('|n')
            self.assertLessEqual(len(lines),18)
            seen.extend(lines[2::2])
        self.assertEqual(len(seen),16);self.assertEqual(len(set(seen)),16)

if __name__=='__main__':unittest.main()
