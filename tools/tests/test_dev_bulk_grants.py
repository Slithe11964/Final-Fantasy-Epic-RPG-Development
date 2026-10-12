"""Developer bulk grants preserve item handles and do not award titles twice."""
from collections import defaultdict
from pathlib import Path
import unittest
from test_armory_materia import execute

SOURCE = (Path(__file__).resolve().parents[2]/'src/triggers/11 Developer tools/DevCommands.j').read_text()


class BulkGrantTests(unittest.TestCase):
    def test_item_catalog_skips_empty_and_duplicate_entries(self):
        items = []
        existing = {'raw': 99, 'owner': 2}
        def create(raw, x, y):
            item = dict(raw=raw, x=x, y=y)
            items.append(item)
            return item
        env = dict(udg_SaveFlagCount=5, udg_ItemIdTable=defaultdict(int, {1:10, 2:20, 3:10, 5:30}),
            GetUnitX=lambda h:1000., GetUnitY=lambda h:1000., InitHashtable=dict,
            LoadBoolean=lambda t,a,b:t.get((a,b),False), SaveBoolean=lambda t,a,b,v:t.__setitem__((a,b),v),
            FlushParentHashtable=lambda t:t.clear(), CreateItem=create,
            SetItemPlayer=lambda item,p,c:item.__setitem__('owner',p), I2R=float, I2S=str,
            ModuloInteger=lambda a,b:a%b, DevCommands_Say=lambda *args:None)
        engine = execute(SOURCE, ['DevCommands_AllItems'], env)
        engine['DevCommands_AllItems'](1, 'hero')
        self.assertEqual([item['raw'] for item in items], [10,20,30])
        self.assertTrue(all(item['owner']==1 for item in items))
        self.assertEqual(existing, {'raw':99, 'owner':2})

    def test_chronicles_include_time_trial_and_repeat_without_new_grants(self):
        forces = defaultdict(set, {1:{0}})
        names = defaultdict(str, {1:'Owned', 2:'Missing', 3:'Not a Chronicle', 61:'Trial 1', 62:'Trial 2'})
        categories = defaultdict(int, {1:1, 2:2, 61:11, 62:11})
        grants = []
        env = dict(LIBRARY_TTitle=True, udg_TempPlayer=7, udg_TempInteger=88,
            GetPlayerId=lambda p:p, udg_TitleName=names, udg_TitleChronicleIndex=categories,
            udg_TitleForce=forces, udg_SpeedrunTitleBase=60, udg_SpeedrunLevel=defaultdict(int),
            gg_trg_Title_Grant='grant', IsPlayerInForce=lambda p,f:p in f,
            DevCommands_Say=lambda *args:None, I2S=str)
        engine = execute(SOURCE, ['DevCommands_AllChronicles'], env)
        def grant(trigger):
            i=engine['udg_TempInteger'];p=engine['udg_TempPlayer']
            grants.append(i);forces[i].add(p)
        engine['TriggerExecute']=grant
        engine['DevCommands_AllChronicles'](0)
        self.assertEqual(grants, [2,61,62])
        self.assertEqual(engine['udg_SpeedrunLevel'][1],2)
        self.assertEqual((engine['udg_TempPlayer'],engine['udg_TempInteger']),(7,88))
        engine['DevCommands_AllChronicles'](0)
        self.assertEqual(grants, [2,61,62])


if __name__=='__main__':
    unittest.main()
